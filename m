From: akpm@linux-foundation.org
Subject: + uml-dont-use-a-too-long-string-literal.patch added to -mm tree
Date: Fri, 06 Mar 2009 15:16:26 -0800
Message-ID: <200903062316.n26NGQ3F010697@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750967AbZCFXQc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Mar 2009 18:16:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, jdike@addtoit.com


The patch titled
     uml: don't use a too long string literal
has been added to the -mm tree.  Its filename is
     uml-dont-use-a-too-long-string-literal.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
memdup_user-introduce.patch
uml-dont-use-a-too-long-string-literal.patch

