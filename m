From: akpm@linux-foundation.org
Subject: + clps711xfb-convert-to-proc_fops.patch added to -mm tree
Date: Tue, 01 Dec 2009 14:05:38 -0800
Message-ID: <200912012205.nB1M5cBI025324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752430AbZLAWGF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2009 17:06:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com


The patch titled
     clps711xfb: convert to proc_fops
has been added to the -mm tree.  Its filename is
     clps711xfb-convert-to-proc_fops.patch

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
Subject: clps711xfb: convert to proc_fops
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/clps711xfb.c |   50 ++++++++++++++---------------------
 1 file changed, 21 insertions(+), 29 deletions(-)

diff -puN drivers/video/clps711xfb.c~clps711xfb-convert-to-proc_fops drivers/video/clps711xfb.c
--- a/drivers/video/clps711xfb.c~clps711xfb-convert-to-proc_fops
+++ a/drivers/video/clps711xfb.c
@@ -19,8 +19,10 @@
  *
  *  Framebuffer driver for the CLPS7111 and EP7212 processors.
  */
+#include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/fb.h>
 #include <linux/init.h>
@@ -38,14 +40,6 @@ struct fb_info	*cfb;
 
 #define CMAP_MAX_SIZE	16
 
-/* The /proc entry for the backlight. */
-static struct proc_dir_entry *clps7111fb_backlight_proc_entry = NULL;
-
-static int clps7111fb_proc_backlight_read(char *page, char **start, off_t off,
-		int count, int *eof, void *data);
-static int clps7111fb_proc_backlight_write(struct file *file, 
-		const char *buffer, unsigned long count, void *data);
-
 /*
  * LCD AC Prescale.  This comes from the LCD panel manufacturers specifications.
  * This determines how many clocks + 1 of CL1 before the M signal toggles.
@@ -221,26 +215,23 @@ static struct fb_ops clps7111fb_ops = {
 	.fb_imageblit	= cfb_imageblit,
 };
 
-static int 
-clps7111fb_proc_backlight_read(char *page, char **start, off_t off,
-		int count, int *eof, void *data)
+static int backlight_proc_show(struct seq_file *m, void *v)
 {
-	/* We need at least two characters, one for the digit, and one for
-	 * the terminating NULL. */
-	if (count < 2) 
-		return -EINVAL;
-
 	if (machine_is_edb7211()) {
-		return sprintf(page, "%d\n", 
+		seq_printf(m, "%d\n",
 				(clps_readb(PDDR) & EDB_PD3_LCDBL) ? 1 : 0);
 	}
 
 	return 0;
 }
 
-static int 
-clps7111fb_proc_backlight_write(struct file *file, const char *buffer, 
-		unsigned long count, void *data)
+static int backlight_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, backlight_proc_show, NULL);
+}
+
+static ssize_t backlight_proc_write(struct file *file, const char *buffer,
+				    size_t count, loff_t *pos)
 {
 	unsigned char char_value;
 	int value;
@@ -271,6 +262,15 @@ clps7111fb_proc_backlight_write(struct f
 	return count;
 }
 
+static const struct file_operations backlight_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= backlight_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= backlight_proc_write,
+};
+
 static void __init clps711x_guess_lcd_params(struct fb_info *info)
 {
 	unsigned int lcdcon, syscon, size;
@@ -379,19 +379,11 @@ int __init clps711xfb_init(void)
 
 	fb_alloc_cmap(&cfb->cmap, CMAP_MAX_SIZE, 0);
 
-	/* Register the /proc entries. */
-	clps7111fb_backlight_proc_entry = create_proc_entry("backlight", 0444,
-		NULL);
-	if (clps7111fb_backlight_proc_entry == NULL) {
+	if (!proc_create("backlight", 0444, NULL, &backlight_proc_fops)) {
 		printk("Couldn't create the /proc entry for the backlight.\n");
 		return -EINVAL;
 	}
 
-	clps7111fb_backlight_proc_entry->read_proc = 
-		&clps7111fb_proc_backlight_read;
-	clps7111fb_backlight_proc_entry->write_proc = 
-		&clps7111fb_proc_backlight_write;
-
 	/*
 	 * Power up the LCD
 	 */
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

