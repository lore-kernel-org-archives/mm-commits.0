From: akpm@linux-foundation.org
Subject: [to-be-updated] arm-convert-proc-cpu-aligment-to-seq_file.patch removed from -mm tree
Date: Wed, 28 Apr 2010 07:35:10 -0400
Message-ID: <201004281436.o3SEaihS001003@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752159Ab0D1OhX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Apr 2010 10:37:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     arm: convert /proc/cpu/aligment to seq_file
has been removed from the -mm tree.  Its filename was
     arm-convert-proc-cpu-aligment-to-seq_file.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arm: convert /proc/cpu/aligment to seq_file
From: Alexey Dobriyan <adobriyan@gmail.com>

Convert code away from ->read_proc/->write_proc interfaces.  Switch to
proc_create()/proc_create_data() which make addition of proc entries
reliable wrt NULL ->proc_fops, NULL ->data and so on.

Problem with ->read_proc et al is described here commit
786d7e1612f0b0adb6046f19b906609e4fe8b1ba "Fix rmmod/read/write races in
/proc entries"

This patch is part of an effort to remove the old simple procfs PAGE_SIZE
buffer interface.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/alignment.c |   53 ++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

diff -puN arch/arm/mm/alignment.c~arm-convert-proc-cpu-aligment-to-seq_file arch/arm/mm/alignment.c
--- a/arch/arm/mm/alignment.c~arm-convert-proc-cpu-aligment-to-seq_file
+++ a/arch/arm/mm/alignment.c
@@ -17,6 +17,7 @@
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/uaccess.h>
@@ -94,36 +95,29 @@ static const char *usermode_action[] = {
 	"signal+warn"
 };
 
-static int
-proc_alignment_read(char *page, char **start, off_t off, int count, int *eof,
-		    void *data)
+static int alignment_proc_show(struct seq_file *m, void *v)
 {
-	char *p = page;
-	int len;
-
-	p += sprintf(p, "User:\t\t%lu\n", ai_user);
-	p += sprintf(p, "System:\t\t%lu\n", ai_sys);
-	p += sprintf(p, "Skipped:\t%lu\n", ai_skipped);
-	p += sprintf(p, "Half:\t\t%lu\n", ai_half);
-	p += sprintf(p, "Word:\t\t%lu\n", ai_word);
+	seq_printf(m, "User:\t\t%lu\n", ai_user);
+	seq_printf(m, "System:\t\t%lu\n", ai_sys);
+	seq_printf(m, "Skipped:\t%lu\n", ai_skipped);
+	seq_printf(m, "Half:\t\t%lu\n", ai_half);
+	seq_printf(m, "Word:\t\t%lu\n", ai_word);
 	if (cpu_architecture() >= CPU_ARCH_ARMv5TE)
-		p += sprintf(p, "DWord:\t\t%lu\n", ai_dword);
-	p += sprintf(p, "Multi:\t\t%lu\n", ai_multi);
-	p += sprintf(p, "User faults:\t%i (%s)\n", ai_usermode,
+		seq_printf(m, "DWord:\t\t%lu\n", ai_dword);
+	seq_printf(m, "Multi:\t\t%lu\n", ai_multi);
+	seq_printf(m, "User faults:\t%i (%s)\n", ai_usermode,
 			usermode_action[ai_usermode]);
 
-	len = (p - page) - off;
-	if (len < 0)
-		len = 0;
-
-	*eof = (len <= count) ? 1 : 0;
-	*start = page + off;
+	return 0;
+}
 
-	return len;
+static int alignment_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, alignment_proc_show, NULL);
 }
 
-static int proc_alignment_write(struct file *file, const char __user *buffer,
-				unsigned long count, void *data)
+static ssize_t alignment_proc_write(struct file *file, const char __user *buffer,
+				    size_t count, loff_t *pos)
 {
 	char mode;
 
@@ -136,6 +130,13 @@ static int proc_alignment_write(struct f
 	return count;
 }
 
+static const struct file_operations alignment_proc_fops = {
+	.open		= alignment_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= alignment_proc_write,
+};
 #endif /* CONFIG_PROC_FS */
 
 union offset_union {
@@ -901,12 +902,10 @@ static int __init alignment_init(void)
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry *res;
 
-	res = create_proc_entry("cpu/alignment", S_IWUSR | S_IRUGO, NULL);
+	res = proc_create("cpu/alignment", S_IWUSR | S_IRUGO, res,
+			  &alignment_proc_fops);
 	if (!res)
 		return -ENOMEM;
