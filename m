From: akpm@linux-foundation.org
Subject: [merged]
 init-mainc-remove-unnecessary-repair_env_string-in-do_initcall_level.patch
 removed from -mm tree
Date: Fri, 31 Jan 2020 15:21:00 -0800
Message-ID: <20200131232100.2XhW7ClXV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgAaXVB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:21:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cmetcalf@tilera.com, krzysiek@podlesie.net, mm-commits@vger.kernel.org, nivedita@alum.mit.edu


The patch titled
     Subject: init/main.c: remove unnecessary repair_env_string in do_initcall_level
has been removed from the -mm tree.  Its filename was
     init-mainc-remove-unnecessary-repair_env_string-in-do_initcall_level.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arvind Sankar <nivedita@alum.mit.edu>
Subject: init/main.c: remove unnecessary repair_env_string in do_initcall_level

Since commit 08746a65c296 ("init: fix in-place parameter modification
regression"), parse_args in do_initcall_level is called on a copy of
saved_command_line.  It is unnecessary to call repair_env_string during
this parsing, as this copy is not used for anything later.

Remove the now unnecessary arguments from repair_env_string as well.

Link: http://lkml.kernel.org/r/20191212180023.24339-3-nivedita@alum.mit.edu
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Krzysztof Mazur <krzysiek@podlesie.net>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/init/main.c~init-mainc-remove-unnecessary-repair_env_string-in-do_initcall_level
+++ a/init/main.c
@@ -246,8 +246,7 @@ static int __init loglevel(char *str)
 early_param("loglevel", loglevel);
 
 /* Change NUL term back to "=", to make "param" the whole string. */
-static int __init repair_env_string(char *param, char *val,
-				    const char *unused, void *arg)
+static void __init repair_env_string(char *param, char *val)
 {
 	if (val) {
 		/* param=val or param="val"? */
@@ -260,7 +259,6 @@ static int __init repair_env_string(char
 		} else
 			BUG();
 	}
-	return 0;
 }
 
 /* Anything after -- gets handed straight to init. */
@@ -272,7 +270,7 @@ static int __init set_init_arg(char *par
 	if (panic_later)
 		return 0;
 
-	repair_env_string(param, val, unused, NULL);
+	repair_env_string(param, val);
 
 	for (i = 0; argv_init[i]; i++) {
 		if (i == MAX_INIT_ARGS) {
@@ -292,7 +290,7 @@ static int __init set_init_arg(char *par
 static int __init unknown_bootoption(char *param, char *val,
 				     const char *unused, void *arg)
 {
-	repair_env_string(param, val, unused, NULL);
+	repair_env_string(param, val);
 
 	/* Handle obsolete-style parameters */
 	if (obsolete_checksetup(param))
@@ -991,6 +989,12 @@ static const char *initcall_level_names[
 	"late",
 };
 
+static int __init ignore_unknown_bootoption(char *param, char *val,
+			       const char *unused, void *arg)
+{
+	return 0;
+}
+
 static void __init do_initcall_level(int level)
 {
 	initcall_entry_t *fn;
@@ -1000,7 +1004,7 @@ static void __init do_initcall_level(int
 		   initcall_command_line, __start___param,
 		   __stop___param - __start___param,
 		   level, level,
-		   NULL, &repair_env_string);
+		   NULL, ignore_unknown_bootoption);
 
 	trace_initcall_level(initcall_level_names[level]);
 	for (fn = initcall_levels[level]; fn < initcall_levels[level+1]; fn++)
_

Patches currently in -mm which might be from nivedita@alum.mit.edu are
