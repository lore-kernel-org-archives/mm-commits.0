From: akpm@linux-foundation.org
Subject: [merged] printk-add-kern_levelsh-to-make-kern_level-available-for-asm-use.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:49:25 -0700
Message-ID: <20120731184925.C6EAF10007D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:33060 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab2GaSt0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:49:26 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4676512obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:49:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: add kern_levels.h to make KERN_<LEVEL> available for asm use
has been removed from the -mm tree.  Its filename was
     printk-add-kern_levelsh-to-make-kern_level-available-for-asm-use.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: printk: add kern_levels.h to make KERN_<LEVEL> available for asm use

Separate the printk.h file into 2 pieces so the definitions can be used in
asm files.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kern_levels.h |   22 ++++++++++++++++++++++
 include/linux/printk.h      |   19 +------------------
 2 files changed, 23 insertions(+), 18 deletions(-)

diff -puN /dev/null include/linux/kern_levels.h
--- /dev/null
+++ a/include/linux/kern_levels.h
@@ -0,0 +1,22 @@
+#ifndef __KERN_LEVELS_H__
+#define __KERN_LEVELS_H__
+
+#define KERN_EMERG	"<0>"	/* system is unusable			*/
+#define KERN_ALERT	"<1>"	/* action must be taken immediately	*/
+#define KERN_CRIT	"<2>"	/* critical conditions			*/
+#define KERN_ERR	"<3>"	/* error conditions			*/
+#define KERN_WARNING	"<4>"	/* warning conditions			*/
+#define KERN_NOTICE	"<5>"	/* normal but significant condition	*/
+#define KERN_INFO	"<6>"	/* informational			*/
+#define KERN_DEBUG	"<7>"	/* debug-level messages			*/
+
+/* Use the default kernel loglevel */
+#define KERN_DEFAULT	"<d>"
+/*
+ * Annotation for a "continued" line of log printout (only done after a
+ * line that had no enclosing \n). Only to be used by core/arch code
+ * during early bootup (a continued line is not SMP-safe otherwise).
+ */
+#define KERN_CONT	"<c>"
+
+#endif
diff -puN include/linux/printk.h~printk-add-kern_levelsh-to-make-kern_level-available-for-asm-use include/linux/printk.h
--- a/include/linux/printk.h~printk-add-kern_levelsh-to-make-kern_level-available-for-asm-use
+++ a/include/linux/printk.h
@@ -2,28 +2,11 @@
 #define __KERNEL_PRINTK__
 
 #include <linux/init.h>
+#include <linux/kern_levels.h>
 
 extern const char linux_banner[];
 extern const char linux_proc_banner[];
 
-#define KERN_EMERG	"<0>"	/* system is unusable			*/
-#define KERN_ALERT	"<1>"	/* action must be taken immediately	*/
-#define KERN_CRIT	"<2>"	/* critical conditions			*/
-#define KERN_ERR	"<3>"	/* error conditions			*/
-#define KERN_WARNING	"<4>"	/* warning conditions			*/
-#define KERN_NOTICE	"<5>"	/* normal but significant condition	*/
-#define KERN_INFO	"<6>"	/* informational			*/
-#define KERN_DEBUG	"<7>"	/* debug-level messages			*/
-
-/* Use the default kernel loglevel */
-#define KERN_DEFAULT	"<d>"
-/*
- * Annotation for a "continued" line of log printout (only done after a
- * line that had no enclosing \n). Only to be used by core/arch code
- * during early bootup (a continued line is not SMP-safe otherwise).
- */
-#define KERN_CONT	"<c>"
