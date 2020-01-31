From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 113/118] init/main.c: fix quoted value handling in
 unknown_bootoption
Date: Thu, 30 Jan 2020 22:17:19 -0800
Message-ID: <20200131061719.aCBYofV-k%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725832AbgAaGRV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:17:21 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cmetcalf@tilera.com, krzysiek@podlesie.net, linux-mm@kvack.org, mm-commits@vger.kernel.org, nivedita@alum.mit.edu, torvalds@linux-foundation.org

From: Arvind Sankar <nivedita@alum.mit.edu>
Subject: init/main.c: fix quoted value handling in unknown_bootoption

Patch series "init/main.c: minor cleanup/bugfix of envvar handling", v2.

unknown_bootoption passes unrecognized command line arguments to init as
either environment variables or arguments.  Some of the logic in the
function is broken for quoted command line arguments.

When an argument of the form param="value" is processed by parse_args and
passed to unknown_bootoption, the command line has
  param\0"value\0
with val pointing to the beginning of value.  The helper function
repair_env_string is then used to restore the '=' character that was
removed by parse_args, and strip the quotes off fully.  This results in
  param=value\0\0
and val ends up pointing to the 'a' instead of the 'v' in value.  This bug
was introduced when repair_env_string was refactored into a separate
function, and the decrement of val in repair_env_string became dead code.

This causes two problems in unknown_bootoption in the two places where the
val pointer is used as a substitute for the length of param:

1. An argument of the form param=".value" is misinterpreted as a
   potential module parameter, with the result that it will not be placed
   in init's environment.

2. An argument of the form param="value" is checked to see if param is
   an existing environment variable that should be overwritten, but the
   comparison is off-by-one and compares 'param=v' instead of 'param='
   against the existing environment.  So passing, for example,
   TERM="vt100" on the command line results in init being passed both
   TERM=linux and TERM=vt100 in its environment.

Patch 1 adds logging for the arguments and environment passed to init and
is independent of the rest: it can be dropped if this is unnecessarily
verbose.

Patch 2 removes repair_env_string from initcall parameter parsing in
do_initcall_level, as that uses a separate copy of the command line now
and the repairing is no longer necessary.

Patch 3 fixes the bug in unknown_bootoption by recording the length of
param explicitly instead of implying it from val-param.


This patch (of 3):

Commit a99cd1125189 ("init: fix bug where environment vars can't be passed
via boot args") introduced two minor bugs in unknown_bootoption by
factoring out the quoted value handling into a separate function.

When value is quoted, repair_env_string will move the value up 1 byte to
strip the quotes, so val in unknown_bootoption no longer points to the
actual location of the value.

The result is that an argument of the form param=".value" is mistakenly
treated as a potential module parameter and is not placed in init's
environment, and an argument of the form param="value" can result in a
duplicate environment variable: eg TERM="vt100" on the command line will
result in both TERM=linux and TERM=vt100 being placed into init's
environment.

Fix this by recording the length of the param before calling
repair_env_string instead of relying on val.

Link: http://lkml.kernel.org/r/20191212180023.24339-4-nivedita@alum.mit.edu
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Krzysztof Mazur <krzysiek@podlesie.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/init/main.c~init-mainc-fix-quoted-value-handling-in-unknown_bootoption
+++ a/init/main.c
@@ -255,7 +255,6 @@ static void __init repair_env_string(cha
 		else if (val == param+strlen(param)+2) {
 			val[-2] = '=';
 			memmove(val-1, val, strlen(val)+1);
-			val--;
 		} else
 			BUG();
 	}
@@ -290,6 +289,8 @@ static int __init set_init_arg(char *par
 static int __init unknown_bootoption(char *param, char *val,
 				     const char *unused, void *arg)
 {
+	size_t len = strlen(param);
+
 	repair_env_string(param, val);
 
 	/* Handle obsolete-style parameters */
@@ -297,7 +298,7 @@ static int __init unknown_bootoption(cha
 		return 0;
 
 	/* Unused module parameter. */
-	if (strchr(param, '.') && (!val || strchr(param, '.') < val))
+	if (strnchr(param, len, '.'))
 		return 0;
 
 	if (panic_later)
@@ -311,7 +312,7 @@ static int __init unknown_bootoption(cha
 				panic_later = "env";
 				panic_param = param;
 			}
-			if (!strncmp(param, envp_init[i], val - param))
+			if (!strncmp(param, envp_init[i], len+1))
 				break;
 		}
 		envp_init[i] = param;
_
