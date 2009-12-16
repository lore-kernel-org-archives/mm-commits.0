From: akpm@linux-foundation.org
Subject: [merged] clps711xfb-convert-to-proc_fops.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:36:16 -0800
Message-ID: <200912162036.nBGKaG70013155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935421AbZLPUgS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:36:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     clps711xfb: convert to proc_fops
has been removed from the -mm tree.  Its filename was
     clps711xfb-convert-to-proc_fops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
