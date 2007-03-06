From: akpm@linux-foundation.org
Subject: + fbdev-mm-deferred-io-support-fix-2.patch added to -mm tree
Date: Mon, 05 Mar 2007 20:01:52 -0800
Message-ID: <200703060401.l2641qYA011282@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49526 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbXCFEB4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 23:01:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, adaplas@gmail.com, jayakumar.lkml@gmail.com


The patch titled
     fb: fsync() method for deferred I/O flush.
has been added to the -mm tree.  Its filename is
     fbdev-mm-deferred-io-support-fix-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fb: fsync() method for deferred I/O flush.
From: Paul Mundt <lethal@linux-sh.org>

There are cases when we do not want to wait on the delay for automatically
updating the "real" framebuffer, this implements a simple ->fsync() hook
for explicitly flushing the deferred I/O work.  The ->page_mkwrite()
handler will rearm the work queue normally.

(akpm: nuke unneeded ifdefs, forward-delcare struct dentry)

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fb_defio.c |   12 ++++++++++++
 drivers/video/fbmem.c    |    3 +++
 include/linux/fb.h       |    6 ++++--
 3 files changed, 19 insertions(+), 2 deletions(-)

diff -puN drivers/video/fb_defio.c~fbdev-mm-deferred-io-support-fix-2 drivers/video/fb_defio.c
--- a/drivers/video/fb_defio.c~fbdev-mm-deferred-io-support-fix-2
+++ a/drivers/video/fb_defio.c
@@ -47,6 +47,18 @@ static struct page* fb_deferred_io_nopag
 	return page;
 }
 
+int fb_deferred_io_fsync(struct file *file, struct dentry *dentry, int datasync)
+{
+	struct fb_info *info = file->private_data;
+
+	/* Kill off the delayed work */
+	cancel_rearming_delayed_work(&info->deferred_work);
+
+	/* Run it immediately */
+	return schedule_delayed_work(&info->deferred_work, 0);
+}
+EXPORT_SYMBOL_GPL(fb_deferred_io_fsync);
+
 /* vm_ops->page_mkwrite handler */
 static int fb_deferred_io_mkwrite(struct vm_area_struct *vma,
 				  struct page *page)
diff -puN drivers/video/fbmem.c~fbdev-mm-deferred-io-support-fix-2 drivers/video/fbmem.c
--- a/drivers/video/fbmem.c~fbdev-mm-deferred-io-support-fix-2
+++ a/drivers/video/fbmem.c
@@ -1266,6 +1266,9 @@ static const struct file_operations fb_f
 #ifdef HAVE_ARCH_FB_UNMAPPED_AREA
 	.get_unmapped_area = get_fb_unmapped_area,
 #endif
+#ifdef CONFIG_FB_DEFERRED_IO
+	.fsync =	fb_deferred_io_fsync,
+#endif
 };
 
 struct class *fb_class;
diff -puN include/linux/fb.h~fbdev-mm-deferred-io-support-fix-2 include/linux/fb.h
--- a/include/linux/fb.h~fbdev-mm-deferred-io-support-fix-2
+++ a/include/linux/fb.h
@@ -4,6 +4,8 @@
 #include <asm/types.h>
 #include <linux/i2c.h>
 
+struct dentry;
+
 /* Definitions of frame buffers						*/
 
 #define FB_MAJOR		29
@@ -927,11 +929,11 @@ static inline void __fb_pad_aligned_buff
 	}
 }
 
-#ifdef CONFIG_FB_DEFERRED_IO
 /* drivers/video/fb_defio.c */
 extern void fb_deferred_io_init(struct fb_info *info);
 extern void fb_deferred_io_cleanup(struct fb_info *info);
-#endif
+extern int fb_deferred_io_fsync(struct file *file, struct dentry *dentry,
+				int datasync);
 
 /* drivers/video/fbsysfs.c */
 extern struct fb_info *framebuffer_alloc(size_t size, struct device *dev);
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
make-aout-executables-work-again.patch
git-sh.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
simplify-the-stacktrace-code.patch
fbdev-mm-deferred-io-support-fix-2.patch
