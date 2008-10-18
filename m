From: akpm@linux-foundation.org
Subject: - proc-move-sysrq-trigger-out-of-fs-proc.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:19:09 -0700
Message-ID: <200810182319.m9INJ9uF029431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751014AbYJRXTL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:19:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     proc: move sysrq-trigger out of fs/proc/
has been removed from the -mm tree.  Its filename was
     proc-move-sysrq-trigger-out-of-fs-proc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: move sysrq-trigger out of fs/proc/
From: Alexey Dobriyan <adobriyan@gmail.com>

Move it into sysrq.c, along with the rest of the sysrq implementation.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/sysrq.c |   30 ++++++++++++++++++++++++++++++
 fs/proc/proc_misc.c  |   26 --------------------------
 2 files changed, 30 insertions(+), 26 deletions(-)

diff -puN drivers/char/sysrq.c~proc-move-sysrq-trigger-out-of-fs-proc drivers/char/sysrq.c
--- a/drivers/char/sysrq.c~proc-move-sysrq-trigger-out-of-fs-proc
+++ a/drivers/char/sysrq.c
@@ -23,6 +23,7 @@
 #include <linux/reboot.h>
 #include <linux/sysrq.h>
 #include <linux/kbd_kern.h>
+#include <linux/proc_fs.h>
 #include <linux/quotaops.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -534,3 +535,32 @@ int unregister_sysrq_key(int key, struct
 	return __sysrq_swap_key_ops(key, NULL, op_p);
 }
 EXPORT_SYMBOL(unregister_sysrq_key);
+
+#ifdef CONFIG_PROC_FS
+/*
+ * writing 'C' to /proc/sysrq-trigger is like sysrq-C
+ */
+static ssize_t write_sysrq_trigger(struct file *file, const char __user *buf,
+				   size_t count, loff_t *ppos)
+{
+	if (count) {
+		char c;
+
+		if (get_user(c, buf))
+			return -EFAULT;
+		__handle_sysrq(c, NULL, 0);
+	}
+	return count;
+}
+
+static const struct file_operations proc_sysrq_trigger_operations = {
+	.write		= write_sysrq_trigger,
+};
+
+static int __init sysrq_init(void)
+{
+	proc_create("sysrq-trigger", S_IWUSR, NULL, &proc_sysrq_trigger_operations);
+	return 0;
+}
+module_init(sysrq_init);
+#endif
diff -puN fs/proc/proc_misc.c~proc-move-sysrq-trigger-out-of-fs-proc fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~proc-move-sysrq-trigger-out-of-fs-proc
+++ a/fs/proc/proc_misc.c
@@ -45,7 +45,6 @@
 #include <linux/blkdev.h>
 #include <linux/hugetlb.h>
 #include <linux/jiffies.h>
-#include <linux/sysrq.h>
 #include <linux/vmalloc.h>
 #include <linux/crash_dump.h>
 #include <linux/pid_namespace.h>
@@ -704,28 +703,6 @@ static int execdomains_read_proc(char *p
 	return proc_calc_metrics(page, start, off, count, eof, len);
 }
 
-#ifdef CONFIG_MAGIC_SYSRQ
-/*
- * writing 'C' to /proc/sysrq-trigger is like sysrq-C
- */
-static ssize_t write_sysrq_trigger(struct file *file, const char __user *buf,
-				   size_t count, loff_t *ppos)
-{
-	if (count) {
-		char c;
-
-		if (get_user(c, buf))
-			return -EFAULT;
-		__handle_sysrq(c, NULL, 0);
-	}
-	return count;
-}
-
-static const struct file_operations proc_sysrq_trigger_operations = {
-	.write		= write_sysrq_trigger,
-};
-#endif
