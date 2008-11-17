From: akpm@linux-foundation.org
Subject: - add-pr_prefix-to-pr_xyz-macros.patch removed from -mm tree
Date: Mon, 17 Nov 2008 13:27:41 -0800
Message-ID: <200811172127.mAHLRfeD024396@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40568 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752568AbYKQVgN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Nov 2008 16:36:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: schwidefsky@de.ibm.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Add PR_PREFIX to pr_xyz() macros
has been removed from the -mm tree.  Its filename was
     add-pr_prefix-to-pr_xyz-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add PR_PREFIX to pr_xyz() macros
From: Martin Schwidefsky <schwidefsky@de.ibm.com>

A common reason for device drivers to implement their own printk macros is
the lack of a printk prefix with the standard pr_xyz macros.  Introduce a
pr_fmt macro that is applied for every pr_xyz macro to the format string. 
The most common use of the pr_fmt macro would be to add the name of the
device driver to all pr_xyz messages in a source file.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   42 +++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff -puN include/linux/kernel.h~add-pr_prefix-to-pr_xyz-macros include/linux/kernel.h
--- a/include/linux/kernel.h~add-pr_prefix-to-pr_xyz-macros
+++ a/include/linux/kernel.h
@@ -335,32 +335,36 @@ static inline char *pack_hex_byte(char *
 	return buf;
 }
 
-#define pr_emerg(fmt, arg...) \
-	printk(KERN_EMERG fmt, ##arg)
-#define pr_alert(fmt, arg...) \
-	printk(KERN_ALERT fmt, ##arg)
-#define pr_crit(fmt, arg...) \
-	printk(KERN_CRIT fmt, ##arg)
-#define pr_err(fmt, arg...) \
-	printk(KERN_ERR fmt, ##arg)
-#define pr_warning(fmt, arg...) \
-	printk(KERN_WARNING fmt, ##arg)
-#define pr_notice(fmt, arg...) \
-	printk(KERN_NOTICE fmt, ##arg)
-#define pr_info(fmt, arg...) \
-	printk(KERN_INFO fmt, ##arg)
+#ifndef pr_fmt
+#define pr_fmt(fmt) fmt
+#endif
+
+#define pr_emerg(fmt, ...) \
+        printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_alert(fmt, ...) \
+        printk(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_crit(fmt, ...) \
+        printk(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_err(fmt, ...) \
+        printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_warning(fmt, ...) \
+        printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_notice(fmt, ...) \
+        printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
+#define pr_info(fmt, ...) \
+        printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
 
 /* If you are writing a driver, please use dev_dbg instead */
 #if defined(CONFIG_DYNAMIC_PRINTK_DEBUG)
 #define pr_debug(fmt, ...) do { \
-	dynamic_pr_debug(fmt, ##__VA_ARGS__); \
+	dynamic_pr_debug(pr_fmt(fmt), ##__VA_ARGS__); \
 	} while (0)
 #elif defined(DEBUG)
-#define pr_debug(fmt, arg...) \
-	printk(KERN_DEBUG fmt, ##arg)
+#define pr_debug(fmt, ...) \
+	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #else
-#define pr_debug(fmt, arg...) \
-	({ if (0) printk(KERN_DEBUG fmt, ##arg); 0; })
+#define pr_debug(fmt, ...) \
+	({ if (0) printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__); 0; })
 #endif
 
 /*
_

Patches currently in -mm which might be from schwidefsky@de.ibm.com are

linux-next.patch
s390-use-the-new-byteorder-headers.patch
add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch
kprobes-add-kprobe_insn_mutex-and-cleanup-arch_remove_kprobe.patch
documentation-update-s390-header-file-paths.patch

