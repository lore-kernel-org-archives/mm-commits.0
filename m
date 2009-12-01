From: akpm@linux-foundation.org
Subject: + parisc-convert-proc-pdc-lcdled-to-seq_file.patch added to -mm tree
Date: Tue, 01 Dec 2009 14:05:40 -0800
Message-ID: <200912012205.nB1M5eDe025386@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37426 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753353AbZLAWG2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2009 17:06:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, grundler@parisc-linux.org, kyle@mcmartin.ca


The patch titled
     parisc: convert /proc/pdc/{lcd,led} to seq_file
has been added to the -mm tree.  Its filename is
     parisc-convert-proc-pdc-lcdled-to-seq_file.patch

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
Subject: parisc: convert /proc/pdc/{lcd,led} to seq_file
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parisc/led.c |   59 ++++++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 30 deletions(-)

diff -puN drivers/parisc/led.c~parisc-convert-proc-pdc-lcdled-to-seq_file drivers/parisc/led.c
--- a/drivers/parisc/led.c~parisc-convert-proc-pdc-lcdled-to-seq_file
+++ a/drivers/parisc/led.c
@@ -38,6 +38,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/reboot.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/ctype.h>
 #include <linux/blkdev.h>
 #include <linux/workqueue.h>
@@ -147,41 +148,34 @@ device_initcall(start_task);
 static void (*led_func_ptr) (unsigned char) __read_mostly;
 
 #ifdef CONFIG_PROC_FS
-static int led_proc_read(char *page, char **start, off_t off, int count, 
-	int *eof, void *data)
+static int led_proc_show(struct seq_file *m, void *v)
 {
-	char *out = page;
-	int len;
-
-	switch ((long)data)
+	switch ((long)m->private)
 	{
 	case LED_NOLCD:
-		out += sprintf(out, "Heartbeat: %d\n", led_heartbeat);
-		out += sprintf(out, "Disk IO: %d\n", led_diskio);
-		out += sprintf(out, "LAN Rx/Tx: %d\n", led_lanrxtx);
+		seq_printf(m, "Heartbeat: %d\n", led_heartbeat);
+		seq_printf(m, "Disk IO: %d\n", led_diskio);
+		seq_printf(m, "LAN Rx/Tx: %d\n", led_lanrxtx);
 		break;
 	case LED_HASLCD:
-		out += sprintf(out, "%s\n", lcd_text);
+		seq_printf(m, "%s\n", lcd_text);
 		break;
 	default:
-		*eof = 1;
 		return 0;
 	}
+	return 0;
+}
 
-	len = out - page - off;
-	if (len < count) {
-		*eof = 1;
-		if (len <= 0) return 0;
-	} else {
-		len = count;
-	}
-	*start = page + off;
-	return len;
+static int led_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, led_proc_show, PDE(inode)->data);
 }
 
-static int led_proc_write(struct file *file, const char *buf, 
-	unsigned long count, void *data)
+
+static ssize_t led_proc_write(struct file *file, const char *buf,
+	size_t count, loff_t *pos)
 {
+	void *data = PDE(file->f_path.dentry->d_inode)->data;
 	char *cur, lbuf[count + 1];
 	int d;
 
@@ -234,6 +228,15 @@ parse_error:
 	return -EINVAL;
 }
 
+static const struct file_operations led_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= led_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= led_proc_write,
+};
+
 static int __init led_create_procfs(void)
 {
 	struct proc_dir_entry *proc_pdc_root = NULL;
@@ -243,19 +246,15 @@ static int __init led_create_procfs(void
 
 	proc_pdc_root = proc_mkdir("pdc", 0);
 	if (!proc_pdc_root) return -1;
-	ent = create_proc_entry("led", S_IFREG|S_IRUGO|S_IWUSR, proc_pdc_root);
+	ent = proc_create_data("led", S_IRUGO|S_IWUSR, proc_pdc_root,
+				&led_proc_fops, (void *)LED_NOLCD); /* LED */
 	if (!ent) return -1;
-	ent->data = (void *)LED_NOLCD; /* LED */
-	ent->read_proc = led_proc_read;
-	ent->write_proc = led_proc_write;
 
 	if (led_type == LED_HASLCD)
 	{
-		ent = create_proc_entry("lcd", S_IFREG|S_IRUGO|S_IWUSR, proc_pdc_root);
+		ent = proc_create_data("lcd", S_IRUGO|S_IWUSR, proc_pdc_root,
+					&led_proc_fops, (void *)LED_HASLCD); /* LCD */
 		if (!ent) return -1;
-		ent->data = (void *)LED_HASLCD; /* LCD */
-		ent->read_proc = led_proc_read;
-		ent->write_proc = led_proc_write;
 	}
 
 	return 0;
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
uml-convert-to-seq_file-proc_fops.patch
alpha-convert-srm-code-to-seq_file.patch
iseries-convert-to-proc_fops.patch
clps711xfb-convert-to-proc_fops.patch
parisc-convert-proc-pdc-lcdled-to-seq_file.patch
via-pmu-convert-to-proc_fops-seq_file.patch

