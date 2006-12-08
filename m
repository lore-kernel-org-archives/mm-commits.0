From: akpm@osdl.org
Subject: - fault-injection-process-filtering-for-fault-injection-capabilities.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:11:22 -0800
Message-ID: <200612082011.kB8KBM0b002899@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59048 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946562AbWLHUL0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:11:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fault injection: process filtering for fault-injection capabilities
has been removed from the -mm tree.  Its filename was
     fault-injection-process-filtering-for-fault-injection-capabilities.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fault injection: process filtering for fault-injection capabilities
From: Akinobu Mita <akinobu.mita@gmail.com>

This patch provides process filtering feature.
The process filter allows failing only permitted processes
by /proc/<pid>/make-it-fail

Please see the example that demostrates how to inject slab allocation
failures into module init/cleanup code
in Documentation/fault-injection/fault-injection.txt

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/proc/base.c               |   65 +++++++++++++++++++++++++++++++++
 include/linux/fault-inject.h |    2 +
 include/linux/sched.h        |    3 +
 lib/fault-inject.c           |   17 ++++++++
 4 files changed, 86 insertions(+), 1 deletion(-)

diff -puN fs/proc/base.c~fault-injection-process-filtering-for-fault-injection-capabilities fs/proc/base.c
--- a/fs/proc/base.c~fault-injection-process-filtering-for-fault-injection-capabilities
+++ a/fs/proc/base.c
@@ -853,6 +853,65 @@ static struct file_operations proc_secco
 };
 #endif /* CONFIG_SECCOMP */
 
+#ifdef CONFIG_FAULT_INJECTION
+static ssize_t proc_fault_inject_read(struct file * file, char __user * buf,
+				      size_t count, loff_t *ppos)
+{
+	struct task_struct *task = get_proc_task(file->f_dentry->d_inode);
+	char buffer[PROC_NUMBUF];
+	size_t len;
+	int make_it_fail;
+	loff_t __ppos = *ppos;
+
+	if (!task)
+		return -ESRCH;
+	make_it_fail = task->make_it_fail;
+	put_task_struct(task);
+
+	len = snprintf(buffer, sizeof(buffer), "%i\n", make_it_fail);
+	if (__ppos >= len)
+		return 0;
+	if (count > len-__ppos)
+		count = len-__ppos;
+	if (copy_to_user(buf, buffer + __ppos, count))
+		return -EFAULT;
+	*ppos = __ppos + count;
+	return count;
+}
+
+static ssize_t proc_fault_inject_write(struct file * file,
+			const char __user * buf, size_t count, loff_t *ppos)
+{
+	struct task_struct *task;
+	char buffer[PROC_NUMBUF], *end;
+	int make_it_fail;
+
+	if (!capable(CAP_SYS_RESOURCE))
+		return -EPERM;
+	memset(buffer, 0, sizeof(buffer));
+	if (count > sizeof(buffer) - 1)
+		count = sizeof(buffer) - 1;
+	if (copy_from_user(buffer, buf, count))
+		return -EFAULT;
+	make_it_fail = simple_strtol(buffer, &end, 0);
+	if (*end == '\n')
+		end++;
+	task = get_proc_task(file->f_dentry->d_inode);
+	if (!task)
+		return -ESRCH;
+	task->make_it_fail = make_it_fail;
+	put_task_struct(task);
+	if (end - buffer == 0)
+		return -EIO;
+	return end - buffer;
+}
+
+static struct file_operations proc_fault_inject_operations = {
+	.read		= proc_fault_inject_read,
+	.write		= proc_fault_inject_write,
+};
+#endif
+
 static void *proc_pid_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
 	struct inode *inode = dentry->d_inode;
@@ -1793,6 +1852,9 @@ static struct pid_entry tgid_base_stuff[
 #ifdef CONFIG_AUDITSYSCALL
 	REG("loginuid",   S_IWUSR|S_IRUGO, loginuid),
 #endif
+#ifdef CONFIG_FAULT_INJECTION
+	REG("make-it-fail", S_IRUGO|S_IWUSR, fault_inject),
+#endif
 };
 
 static int proc_tgid_base_readdir(struct file * filp,
@@ -2068,6 +2130,9 @@ static struct pid_entry tid_base_stuff[]
 #ifdef CONFIG_AUDITSYSCALL
 	REG("loginuid",  S_IWUSR|S_IRUGO, loginuid),
 #endif
+#ifdef CONFIG_FAULT_INJECTION
+	REG("make-it-fail", S_IRUGO|S_IWUSR, fault_inject),
+#endif
 };
 
 static int proc_tid_base_readdir(struct file * filp,
diff -puN include/linux/fault-inject.h~fault-injection-process-filtering-for-fault-injection-capabilities include/linux/fault-inject.h
--- a/include/linux/fault-inject.h~fault-injection-process-filtering-for-fault-injection-capabilities
+++ a/include/linux/fault-inject.h
@@ -17,6 +17,7 @@ struct fault_attr {
 	atomic_t times;
 	atomic_t space;
 	unsigned long verbose;
+	u32 task_filter;
 
 	unsigned long count;
 
@@ -30,6 +31,7 @@ struct fault_attr {
 		struct dentry *times_file;
 		struct dentry *space_file;
 		struct dentry *verbose_file;
+		struct dentry *task_filter_file;
 	} dentries;
 
 #endif
diff -puN include/linux/sched.h~fault-injection-process-filtering-for-fault-injection-capabilities include/linux/sched.h
--- a/include/linux/sched.h~fault-injection-process-filtering-for-fault-injection-capabilities
+++ a/include/linux/sched.h
@@ -1045,6 +1045,9 @@ struct task_struct {
 #ifdef	CONFIG_TASK_DELAY_ACCT
 	struct task_delay_info *delays;
 #endif
+#ifdef CONFIG_FAULT_INJECTION
+	int make_it_fail;
+#endif
 };
 
 static inline pid_t process_group(struct task_struct *tsk)
diff -puN lib/fault-inject.c~fault-injection-process-filtering-for-fault-injection-capabilities lib/fault-inject.c
--- a/lib/fault-inject.c~fault-injection-process-filtering-for-fault-injection-capabilities
+++ a/lib/fault-inject.c
@@ -5,6 +5,7 @@
 #include <linux/types.h>
 #include <linux/fs.h>
 #include <linux/module.h>
+#include <linux/interrupt.h>
 #include <linux/fault-inject.h>
 
 /*
@@ -44,6 +45,11 @@ static void fail_dump(struct fault_attr 
 
 #define atomic_dec_not_zero(v)		atomic_add_unless((v), -1, 0)
 
+static int fail_task(struct fault_attr *attr, struct task_struct *task)
+{
+	return !in_interrupt() && task->make_it_fail;
+}
+
 /*
  * This code is stolen from failmalloc-1.0
  * http://www.nongnu.org/failmalloc/
@@ -51,6 +57,9 @@ static void fail_dump(struct fault_attr 
 
 int should_fail(struct fault_attr *attr, ssize_t size)
 {
+	if (attr->task_filter && !fail_task(attr, current))
+		return 0;
+
 	if (atomic_read(&attr->times) == 0)
 		return 0;
 
@@ -135,6 +144,9 @@ void cleanup_fault_attr_dentries(struct 
 	debugfs_remove(attr->dentries.verbose_file);
 	attr->dentries.verbose_file = NULL;
 
+	debugfs_remove(attr->dentries.task_filter_file);
+	attr->dentries.task_filter_file = NULL;
+
 	if (attr->dentries.dir)
 		WARN_ON(!simple_empty(attr->dentries.dir));
 
@@ -169,9 +181,12 @@ int init_fault_attr_dentries(struct faul
 	attr->dentries.verbose_file =
 		debugfs_create_ul("verbose", mode, dir, &attr->verbose);
 
+	attr->dentries.task_filter_file = debugfs_create_bool("task-filter",
+						mode, dir, &attr->task_filter);
+
 	if (!attr->dentries.probability_file || !attr->dentries.interval_file
 	    || !attr->dentries.times_file || !attr->dentries.space_file
-	    || !attr->dentries.verbose_file)
+	    || !attr->dentries.verbose_file || !attr->dentries.task_filter_file)
 		goto fail;
 
 	return 0;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
fault-injection-process-filtering-for-fault-injection-capabilities.patch
fault-injection-stacktrace-filtering.patch
fault-injection-Kconfig-cleanup.patch
fault-injection-stacktrace-filtering-kconfig-fix.patch
fault-injection-correct-disambiguate-and.patch
fault-injection-use-bool-true-false-throughout.patch
fault-injection-clamp-debugfs-stacktrace-depth-to.patch
fault-injection-optimize-and-simplify.patch
fault-injection-defaults-likely-to-please-a-new.patch
acpi-fix-single-linked-list-manipulation.patch
acpi-processor-prevent-loading-module-on-failures.patch
git-alsa.patch
audit-fix-kstrdup-error-check.patch
drm-fix-return-value-check.patch
ata-fix-platform_device_register_simple-error-check.patch
git-mtd.patch
net-use-bitrev8.patch
gss_spkm3-fix-error-handling-in-module-init.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
iscsi-fix-crypto_alloc_hash-error-check.patch

