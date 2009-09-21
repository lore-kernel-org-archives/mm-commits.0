From: akpm@linux-foundation.org
Subject: [merged] kernel-profilec-switch-proc-irq-prof_cpu_mask-to-seq_file.patch removed from -mm tree
Date: Mon, 21 Sep 2009 12:24:42 -0700
Message-ID: <200909211924.n8LJOgCx001095@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56603 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753152AbZIUTZW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Sep 2009 15:25:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     kernel/profile.c: switch /proc/irq/prof_cpu_mask to seq_file
has been removed from the -mm tree.  Its filename was
     kernel-profilec-switch-proc-irq-prof_cpu_mask-to-seq_file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/profile.c: switch /proc/irq/prof_cpu_mask to seq_file
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/profile.c |   45 ++++++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff -puN kernel/profile.c~kernel-profilec-switch-proc-irq-prof_cpu_mask-to-seq_file kernel/profile.c
--- a/kernel/profile.c~kernel-profilec-switch-proc-irq-prof_cpu_mask-to-seq_file
+++ a/kernel/profile.c
@@ -442,48 +442,51 @@ void profile_tick(int type)
 
 #ifdef CONFIG_PROC_FS
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <asm/uaccess.h>
 
-static int prof_cpu_mask_read_proc(char *page, char **start, off_t off,
-			int count, int *eof, void *data)
+static int prof_cpu_mask_proc_show(struct seq_file *m, void *v)
 {
-	int len = cpumask_scnprintf(page, count, data);
-	if (count - len < 2)
-		return -EINVAL;
-	len += sprintf(page + len, "\n");
-	return len;
+	seq_cpumask(m, prof_cpu_mask);
+	seq_putc(m, '\n');
+	return 0;
 }
 
-static int prof_cpu_mask_write_proc(struct file *file,
-	const char __user *buffer,  unsigned long count, void *data)
+static int prof_cpu_mask_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, prof_cpu_mask_proc_show, NULL);
+}
+
+static ssize_t prof_cpu_mask_proc_write(struct file *file,
+	const char __user *buffer, size_t count, loff_t *pos)
 {
-	struct cpumask *mask = data;
-	unsigned long full_count = count, err;
 	cpumask_var_t new_value;
+	int err;
 
 	if (!alloc_cpumask_var(&new_value, GFP_KERNEL))
 		return -ENOMEM;
 
 	err = cpumask_parse_user(buffer, count, new_value);
 	if (!err) {
-		cpumask_copy(mask, new_value);
-		err = full_count;
+		cpumask_copy(prof_cpu_mask, new_value);
+		err = count;
 	}
 	free_cpumask_var(new_value);
 	return err;
 }
 
+static const struct file_operations prof_cpu_mask_proc_fops = {
+	.open		= prof_cpu_mask_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= prof_cpu_mask_proc_write,
+};
+
 void create_prof_cpu_mask(struct proc_dir_entry *root_irq_dir)
 {
-	struct proc_dir_entry *entry;
-
 	/* create /proc/irq/prof_cpu_mask */
-	entry = create_proc_entry("prof_cpu_mask", 0600, root_irq_dir);
-	if (!entry)
-		return;
-	entry->data = prof_cpu_mask;
-	entry->read_proc = prof_cpu_mask_read_proc;
-	entry->write_proc = prof_cpu_mask_write_proc;
+	proc_create("prof_cpu_mask", 0600, root_irq_dir, &prof_cpu_mask_proc_fops);
 }
 
 /*
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
acpi-switch-proc-acpi-debug_layerdebug_level-to-seq_file.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
cpqarray-switch-to-seq_file.patch
dac960-switch-to-seq_file.patch
const-make-struct-super_block-dq_op-const.patch
const-make-struct-super_block-s_qcop-const.patch
const-mark-remaining-super_operations-const.patch
const-mark-remaining-export_operations-const.patch
const-mark-remaining-address_space_operations-const.patch
const-mark-remaining-inode_operations-as-const.patch
const-make-file_lock_operations-const.patch
const-make-lock_manager_operations-const.patch
const-make-block_device_operations-const.patch
oom-move-oom_killer_enable-oom_killer_disable-to-where-they-belong.patch
pcmcia-switch-proc-bus-pccard-drivers-to-seq_file.patch
scripts-get_maintainerpl-add-remove-duplicates.patch
proc_flush_task-flush-proc-tid-task-pid-when-a-sub-thread-exits.patch
procfs-provide-stack-information-for-threads-v08.patch
procfs-provide-stack-information-for-threads-v011.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
viafb-switch-to-seq_file.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch
sysctl-remove-struct-file-argument-of-proc_handler.patch
aio-ifdef-fields-in-mm_struct.patch
gru-use-proc_create.patch

