From: akpm@linux-foundation.org
Subject: + arm-convert-proc-cpu-aligment-to-seq_file.patch added to -mm tree
Date: Tue, 01 Dec 2009 13:56:39 -0800
Message-ID: <200912012156.nB1LudI2003171@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57641 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752667AbZLAV4o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2009 16:56:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, rmk@arm.linux.org.uk


The patch titled
     arm: convert /proc/cpu/aligment to seq_file
has been added to the -mm tree.  Its filename is
     arm-convert-proc-cpu-aligment-to-seq_file.patch

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
Subject: arm: convert /proc/cpu/aligment to seq_file
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/alignment.c |   54 +++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff -puN arch/arm/mm/alignment.c~arm-convert-proc-cpu-aligment-to-seq_file arch/arm/mm/alignment.c
--- a/arch/arm/mm/alignment.c~arm-convert-proc-cpu-aligment-to-seq_file
+++ a/arch/arm/mm/alignment.c
@@ -16,6 +16,7 @@
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/uaccess.h>
@@ -91,36 +92,29 @@ static const char *usermode_action[] = {
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
 
@@ -133,6 +127,14 @@ static int proc_alignment_write(struct f
 	return count;
 }
 
+static const struct file_operations alignment_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= alignment_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= alignment_proc_write,
+};
 #endif /* CONFIG_PROC_FS */
 
 union offset_union {
@@ -902,12 +904,10 @@ static int __init alignment_init(void)
 	if (!res)
 		return -ENOMEM;
 
-	res = create_proc_entry("alignment", S_IWUSR | S_IRUGO, res);
+	res = proc_create("alignment", S_IWUSR | S_IRUGO, res,
+			  &alignment_proc_fops);
 	if (!res)
 		return -ENOMEM;
-
-	res->read_proc = proc_alignment_read;
-	res->write_proc = proc_alignment_write;
 #endif
 
 	/*
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
thinkpad_acpi-convert-to-seq_file.patch
asus_acpi-convert-to-seq_file.patch
toshiba_acpi-convert-to-seq_file.patch
arm-convert-proc-cpu-aligment-to-seq_file.patch
proc_fops-convert-av7110.patch
proc_fops-convert-cpia.patch
proc_fops-convert-drivers-isdn-to-seq_file.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix.patch
mpt-fusion-convert-to-seq_file.patch
const-constify-remaining-dev_pm_ops.patch
uml-irq-register-race-condition.patch
make-debug_bugverbose-default-to-y.patch
proc-rename-de_get-to-pde_get-and-inline-it.patch
pnpbios-convert-to-seq_file.patch
const-constify-remaining-pipe_buf_operations.patch
ufs-pass-qstr-instead-of-dentry-where-necessary-for-nfs.patch
ufs-nfs-support.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch

