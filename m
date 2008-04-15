From: akpm@linux-foundation.org
Subject: + fb-convert-proc-fb-to-seq_file-interface.patch added to -mm tree
Date: Mon, 14 Apr 2008 23:31:59 -0700
Message-ID: <200804150631.m3F6Vxo6014791@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34374 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751677AbYDOGcd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 02:32:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, adaplas@pol.net


The patch titled
     fb: convert /proc/fb to seq_file interface
has been added to the -mm tree.  Its filename is
     fb-convert-proc-fb-to-seq_file-interface.patch

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
Subject: fb: convert /proc/fb to seq_file interface
From: Alexey Dobriyan <adobriyan@gmail.com>

Note: looks like accesses to "registered_fb" are done without any exclusion
so there're none in new proc code, too. This should be fixed in separate
patch.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbmem.c |   61 ++++++++++++++++++++++++++++------------
 1 file changed, 43 insertions(+), 18 deletions(-)

diff -puN drivers/video/fbmem.c~fb-convert-proc-fb-to-seq_file-interface drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fb-convert-proc-fb-to-seq_file-interface
+++ a/drivers/video/fbmem.c
@@ -26,6 +26,7 @@
 #include <linux/init.h>
 #include <linux/linux_logo.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/console.h>
 #ifdef CONFIG_KMOD
 #include <linux/kmod.h>
@@ -632,27 +633,51 @@ int fb_prepare_logo(struct fb_info *info
 int fb_show_logo(struct fb_info *info, int rotate) { return 0; }
 #endif /* CONFIG_LOGO */
 
-static int fbmem_read_proc(char *buf, char **start, off_t offset,
-			   int len, int *eof, void *private)
+static void * fb_seq_start(struct seq_file *m, loff_t *pos)
 {
-	struct fb_info **fi;
-	int clen;
+	return (*pos < FB_MAX) ? pos : NULL;
+}
 
-	clen = 0;
-	for (fi = registered_fb; fi < &registered_fb[FB_MAX] && clen < 4000;
-	     fi++)
-		if (*fi)
-			clen += sprintf(buf + clen, "%d %s\n",
-				        (*fi)->node,
-				        (*fi)->fix.id);
-	*start = buf + offset;
-	if (clen > offset)
-		clen -= offset;
-	else
-		clen = 0;
-	return clen < len ? clen : len;
+static void * fb_seq_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	(*pos)++;
+	return (*pos < FB_MAX) ? pos : NULL;
+}
+
+static void fb_seq_stop(struct seq_file *m, void *v)
+{
+}
+
+static int fb_seq_show(struct seq_file *m, void *v)
+{
+	int i = *(loff_t *)v;
+	struct fb_info *fi = registered_fb[i];
+
+	if (fi)
+		seq_printf(m, "%d %s\n", fi->node, fi->fix.id);
+	return 0;
 }
 
+static const struct seq_operations proc_fb_seq_ops = {
+	.start	= fb_seq_start,
+	.next	= fb_seq_next,
+	.stop	= fb_seq_stop,
+	.show	= fb_seq_show,
+};
+
+static int proc_fb_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &proc_fb_seq_ops);
+}
+
+static const struct file_operations fb_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= proc_fb_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 static ssize_t
 fb_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 {
@@ -1533,7 +1558,7 @@ void fb_set_suspend(struct fb_info *info
 static int __init
 fbmem_init(void)
 {
-	create_proc_read_entry("fb", 0, NULL, fbmem_read_proc, NULL);
+	proc_create("fb", 0, NULL, &fb_proc_fops);
 
 	if (register_chrdev(FB_MAJOR,"fb",&fb_fops))
 		printk("unable to get major %d for fb devs\n", FB_MAJOR);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

fbdev-fix-proc-fb-oops-after-module-removal.patch
v4l-fix-concurrent-read-from-proc-videocodecs.patch
tags-add-menuconfig-symbols-as-well.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
remove-the-macro-get_personality.patch
nv-drop-useless-module-ifdefs.patch
nv-drop-useless-config_pci-checks.patch
nv-fix-sparse-noise.patch
fb-convert-proc-fb-to-seq_file-interface.patch
ipmi-remove-write_proc-code.patch
procfs-mem-permission-cleanup.patch
proc-simplify-locking-in-remove_proc_entry.patch
proc-less-special-case-in-xlate-code.patch
proc-drop-several-pde-valid-invalid-checks.patch
proc-remove-proc_bus.patch
proc-remove-proc_root_fs.patch
proc-remove-proc_root_driver.patch
proc-remove-proc_root-from-drivers.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

