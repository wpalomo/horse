unit Horse.Core;

interface

uses System.SysUtils, Web.HTTPApp, Horse.Router;

type
  THorseCore = class
  private
    FRoutes: THorseRouterTree;
    procedure Initialize;
    procedure RegisterRoute(AHTTPType: TMethodType; APath: string; ACallback: THorseCallback);
    class var FInstance: THorseCore;
  public
    destructor Destroy; override;
    constructor Create; overload;
    property Routes: THorseRouterTree read FRoutes write FRoutes;

    procedure Use(APath: string; ACallback: THorseCallback); overload;
    procedure Use(ACallback: THorseCallback); overload;
    procedure Use(APath: string; ACallbacks: array of THorseCallback); overload;
    procedure Use(ACallbacks: array of THorseCallback); overload;

    procedure Get(APath: string; ACallback: THorseCallback); overload;
    procedure Get(APath: string; AMiddleware, ACallback: THorseCallback); overload;
    procedure Get(APath: string; ACallbacks: array of THorseCallback); overload;
    procedure Get(APath: string; ACallbacks: array of THorseCallback; ACallback: THorseCallback); overload;

    procedure Put(APath: string; ACallback: THorseCallback); overload;
    procedure Put(APath: string; AMiddleware, ACallback: THorseCallback); overload;
    procedure Put(APath: string; ACallbacks: array of THorseCallback); overload;
    procedure Put(APath: string; ACallbacks: array of THorseCallback; ACallback: THorseCallback); overload;

    procedure Post(APath: string; ACallback: THorseCallback); overload;
    procedure Post(APath: string; AMiddleware, ACallback: THorseCallback); overload;
    procedure Post(APath: string; ACallbacks: array of THorseCallback); overload;
    procedure Post(APath: string; ACallbacks: array of THorseCallback; ACallback: THorseCallback); overload;

    procedure Delete(APath: string; ACallback: THorseCallback); overload;
    procedure Delete(APath: string; AMiddleware, ACallback: THorseCallback); overload;
    procedure Delete(APath: string; ACallbacks: array of THorseCallback); overload;
    procedure Delete(APath: string; ACallbacks: array of THorseCallback; ACallback: THorseCallback); overload;

    procedure Start; virtual; abstract;
    class function GetInstance: THorseCore;
  end;

implementation

{ THorseCore }

constructor THorseCore.Create;
begin
  Initialize;
end;

procedure THorseCore.Delete(APath: string; ACallbacks: array of THorseCallback; ACallback: THorseCallback);
var
  LCallback: THorseCallback;
begin
  for LCallback in ACallbacks do
    Delete(APath, LCallback);
  Delete(APath, ACallback);
end;

destructor THorseCore.Destroy;
begin
  FRoutes.free;
  inherited;
end;

procedure THorseCore.Delete(APath: string; AMiddleware, ACallback: THorseCallback);
begin
  Delete(APath, [AMiddleware, ACallback]);
end;

procedure THorseCore.Delete(APath: string; ACallbacks: array of THorseCallback);
var
  LCallback: THorseCallback;
begin
  for LCallback in ACallbacks do
  begin
    Delete(APath, LCallback);
  end;
end;

procedure THorseCore.Delete(APath: string; ACallback: THorseCallback);
begin
  RegisterRoute(mtDelete, APath, ACallback);
end;

procedure THorseCore.Initialize;
begin
  FInstance := Self;
  FRoutes := THorseRouterTree.Create;
end;

procedure THorseCore.Get(APath: string; ACallback: THorseCallback);
begin
  RegisterRoute(mtGet, APath, ACallback);
end;

procedure THorseCore.Get(APath: string; ACallbacks: array of THorseCallback);
var
  LCallback: THorseCallback;
begin
  for LCallback in ACallbacks do
  begin
    Get(APath, LCallback);
  end;
end;

procedure THorseCore.Get(APath: string; AMiddleware, ACallback: THorseCallback);
begin
  Get(APath, [AMiddleware, ACallback]);
end;

class function THorseCore.GetInstance: THorseCore;
begin
  Result := FInstance;
end;

procedure THorseCore.Post(APath: string; ACallback: THorseCallback);
begin
  RegisterRoute(mtPost, APath, ACallback);
end;

procedure THorseCore.Put(APath: string; ACallback: THorseCallback);
begin
  RegisterRoute(mtPut, APath, ACallback);
end;

procedure THorseCore.RegisterRoute(AHTTPType: TMethodType; APath: string; ACallback: THorseCallback);
begin
  if APath.EndsWith('/') then
    APath := APath.Remove(High(APath) - 1, 1);
  if not APath.StartsWith('/') then
    APath := '/' + APath;
  FRoutes.RegisterRoute(AHTTPType, APath, ACallback);
end;

procedure THorseCore.Use(ACallbacks: array of THorseCallback);
var
  LCallback: THorseCallback;
begin
  for LCallback in ACallbacks do
    Use(LCallback);
end;

procedure THorseCore.Use(APath: string; ACallbacks: array of THorseCallback);
var
  LCallback: THorseCallback;
begin
  for LCallback in ACallbacks do
    Use(APath, LCallback);
end;

procedure THorseCore.Use(ACallback: THorseCallback);
begin
  FRoutes.RegisterMiddleware('/', ACallback);
end;

procedure THorseCore.Use(APath: string; ACallback: THorseCallback);
begin
  FRoutes.RegisterMiddleware(APath, ACallback);
end;

procedure THorseCore.Post(APath: string; ACallbacks: array of THorseCallback);
var
  LCallback: THorseCallback;
begin
  for LCallback in ACallbacks do
    Post(APath, LCallback);
end;

procedure THorseCore.Post(APath: string; AMiddleware, ACallback: THorseCallback);
begin
  Post(APath, [AMiddleware, ACallback]);
end;

procedure THorseCore.Put(APath: string; AMiddleware, ACallback: THorseCallback);
begin
  Put(APath, [AMiddleware, ACallback]);
end;

procedure THorseCore.Put(APath: string; ACallbacks: array of THorseCallback);
var
  LCallback: THorseCallback;
begin
  for LCallback in ACallbacks do
    Put(APath, LCallback);
end;

procedure THorseCore.Get(APath: string; ACallbacks: array of THorseCallback; ACallback: THorseCallback);
var
  LCallback: THorseCallback;
begin
  for LCallback in ACallbacks do
    Get(APath, LCallback);
  Get(APath, ACallback);
end;

procedure THorseCore.Post(APath: string; ACallbacks: array of THorseCallback; ACallback: THorseCallback);
var
  LCallback: THorseCallback;
begin
  for LCallback in ACallbacks do
    Post(APath, LCallback);
  Post(APath, ACallback);
end;

procedure THorseCore.Put(APath: string; ACallbacks: array of THorseCallback; ACallback: THorseCallback);
var
  LCallback: THorseCallback;
begin
  for LCallback in ACallbacks do
    Put(APath, LCallback);
  Put(APath, ACallback);
end;

end.
