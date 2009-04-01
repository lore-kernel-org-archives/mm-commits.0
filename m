From: akpm@linux-foundation.org
Subject: [merged] uml-dont-use-a-too-long-string-literal.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:39:25 -0700
Message-ID: <200904011839.n31IdPnt008668@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933676AbZDASsC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:48:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     uml: don't use a too long string literal
has been removed from the -mm tree.  Its filename was
     uml-dont-use-a-too-long-string-literal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: don't use a too long string literal
From: WANG Cong <xiyou.wangcong@gmail.com>

uml uses a concatenated string literal to store the contents of .config,
but .config file content is varaible, it can be very long.

Use an array of string literals instead.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/Makefile    |    6 +++---
 arch/um/kernel/config.c.in |    8 ++++++--
 2 files changed, 9 insertions(+), 5 deletions(-)

diff -puN arch/um/kernel/Makefile~uml-dont-use-a-too-long-string-literal arch/um/kernel/Makefile
--- a/arch/um/kernel/Makefile~uml-dont-use-a-too-long-string-literal
+++ a/arch/um/kernel/Makefile
@@ -28,7 +28,7 @@ $(obj)/config.tmp: $(objtree)/.config FO
 	$(call if_changed,quote1)
 
 quiet_cmd_quote1 = QUOTE   $@
-      cmd_quote1 = sed -e 's/"/\\"/g' -e 's/^/"/' -e 's/$$/\\n"/' \
+      cmd_quote1 = sed -e 's/"/\\"/g' -e 's/^/"/' -e 's/$$/\\n",/' \
 		   $< > $@
 
 $(obj)/config.c: $(src)/config.c.in $(obj)/config.tmp FORCE
@@ -36,9 +36,9 @@ $(obj)/config.c: $(src)/config.c.in $(ob
 
 quiet_cmd_quote2 = QUOTE   $@
       cmd_quote2 = sed -e '/CONFIG/{'          \
-		  -e 's/"CONFIG"\;/""/'        \
+		  -e 's/"CONFIG"//'            \
 		  -e 'r $(obj)/config.tmp'     \
 		  -e 'a \'                     \
-		  -e '""\;'                    \
+		  -e '""'                      \
 		  -e '}'                       \
 		  $< > $@
diff -puN arch/um/kernel/config.c.in~uml-dont-use-a-too-long-string-literal arch/um/kernel/config.c.in
--- a/arch/um/kernel/config.c.in~uml-dont-use-a-too-long-string-literal
+++ a/arch/um/kernel/config.c.in
@@ -7,11 +7,15 @@
 #include <stdlib.h>
 #include "init.h"
 
-static __initdata char *config = "CONFIG";
+static __initdata const char *config[] = {
+"CONFIG"
+};
 
 static int __init print_config(char *line, int *add)
 {
-	printf("%s", config);
+	int i;
+	for (i = 0; i < sizeof(config)/sizeof(config[0]); i++)
+		printf("%s", config[i]);
 	exit(0);
 }
 
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
linux-next.patch

