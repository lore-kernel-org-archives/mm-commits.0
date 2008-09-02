From: akpm@linux-foundation.org
Subject: + proc-move-sysrq-trigger-out-of-fs-proc.patch added to -mm tree
Date: Tue, 02 Sep 2008 16:22:09 -0700
Message-ID: <200809022322.m82NM9IT018109@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753046AbYIBXWm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 19:22:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     proc: move sysrq-trigger out of fs/proc/
has been added to the -mm tree.  Its filename is
     proc-move-sysrq-trigger-out-of-fs-proc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -533,3 +534,32 @@ int unregister_sysrq_key(int key, struct
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
@@ -46,7 +46,6 @@
 #include <linux/blkdev.h>
 #include <linux/hugetlb.h>
 #include <linux/jiffies.h>
-#include <linux/sysrq.h>
 #include <linux/vmalloc.h>
 #include <linux/crash_dump.h>
 #include <linux/pid_namespace.h>
@@ -756,28 +755,6 @@ static int execdomains_read_proc(char *p
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
-
 #ifdef CONFIG_PROC_PAGE_MONITOR
 #define KPMSIZE sizeof(u64)
 #define KPMMASK (KPMSIZE - 1)
@@ -986,7 +963,4 @@ void __init proc_misc_init(void)
 #ifdef CONFIG_PROC_VMCORE
 	proc_vmcore = proc_create("vmcore", S_IRUSR, NULL, &proc_vmcore_operations);
 #endif
-#ifdef CONFIG_MAGIC_SYSRQ
-	proc_create("sysrq-trigger", S_IWUSR, NULL, &proc_sysrq_trigger_operations);
-#endif
 }
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
less-softirq-vectors.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
cpuset-use-seq_cpumask-seq_nodemask.patch
proc-move-sysrq-trigger-out-of-fs-proc.patch
sysctl-simplify-strategy.patch
fs-kconfig-move-ext2-ext3-ext4-jbd-jbd2-out.patch
fs-kconfig-move-autofs-autofs4-out.patch
fs-kconfig-move-cifs-out.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

