From: akpm@linux-foundation.org
Subject: + fbdev-mm-deferred-io-support.patch added to -mm tree
Date: Tue, 27 Feb 2007 13:10:22 -0800
Message-ID: <200702272110.l1RLAQos028712@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52322 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633AbXB0VKa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 16:10:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jayakumar.lkml@gmail.com, adaplas@gmail.com


The patch titled
     fbdev: mm: Deferred IO support
has been added to the -mm tree.  Its filename is
     fbdev-mm-deferred-io-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fbdev: mm: Deferred IO support
From: Jaya Kumar <jayakumar.lkml@gmail.com>

This implements deferred IO support in fbdev.  Deferred IO is a way to delay
and repurpose IO.  This implementation is done using mm's page_mkwrite and
page_mkclean hooks in order to detect, delay and then rewrite IO.  This
functionality is used by hecubafb.

[adaplas]
This is useful for graphics hardware with no directly addressable/mappable
framebuffer. Implementing this will allow the "framebuffer" to be accesible
from user space via mmap().

Signed-off-by: Jaya Kumar <jayakumar.lkml@gmail.com>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fb/deferred_io.txt |   75 +++++++++++++++
 drivers/video/Kconfig            |    5 +
 drivers/video/Makefile           |    1 
 drivers/video/fb_defio.c         |  137 +++++++++++++++++++++++++++++
 include/linux/fb.h               |   20 ++++
 mm/rmap.c                        |    1 
 6 files changed, 239 insertions(+)

diff -puN /dev/null Documentation/fb/deferred_io.txt
--- /dev/null
+++ a/Documentation/fb/deferred_io.txt
@@ -0,0 +1,75 @@
+Deferred IO
+-----------
+
+Deferred IO is a way to delay and repurpose IO. It uses host memory as a
+buffer and the MMU pagefault as a pretrigger for when to perform the device
+IO. The following example may be a useful explaination of how one such setup
+works:
+
+- userspace app like Xfbdev mmaps framebuffer
+- deferred IO and driver sets up nopage and page_mkwrite handlers
+- userspace app tries to write to mmaped vaddress
+- we get pagefault and reach nopage handler
+- nopage handler finds and returns physical page
+- we get page_mkwrite where we add this page to a list
+- schedule a workqueue task to be run after a delay
+- app continues writing to that page with no additional cost. this is
+  the key benefit.
+- the workqueue task comes in and mkcleans the pages on the list, then
+ completes the work associated with updating the framebuffer. this is
+  the real work talking to the device.
+- app tries to write to the address (that has now been mkcleaned)
+- get pagefault and the above sequence occurs again
+
+As can be seen from above, one benefit is roughly to allow bursty framebuffer
+writes to occur at minimum cost. Then after some time when hopefully things
+have gone quiet, we go and really update the framebuffer which would be
+a relatively more expensive operation.
+
+For some types of nonvolatile high latency displays, the desired image is
+the final image rather than the intermediate stages which is why it's okay
+to not update for each write that is occuring.
+
+It may be the case that this is useful in other scenarios as well. Paul Mundt
+has mentioned a case where it is beneficial to use the page count to decide
+whether to coalesce and issue SG DMA or to do memory bursts.
+
+Another one may be if one has a device framebuffer that is in an usual format,
+say diagonally shifting RGB, this may then be a mechanism for you to allow
+apps to pretend to have a normal framebuffer but reswizzle for the device
+framebuffer at vsync time based on the touched pagelist.
+
+How to use it: (for applications)
+---------------------------------
+No changes needed. mmap the framebuffer like normal and just use it.
+
+How to use it: (for fbdev drivers)
+----------------------------------
+The following example may be helpful.
+
+1. Setup your structure. Eg:
+
+static struct fb_deferred_io hecubafb_defio = {
+	.delay		= HZ,
+	.deferred_io	= hecubafb_dpy_deferred_io,
+};
+
+The delay is the minimum delay between when the page_mkwrite trigger occurs
+and when the deferred_io callback is called. The deferred_io callback is
+explained below.
+
+2. Setup your deferred IO callback. Eg:
+static void hecubafb_dpy_deferred_io(struct fb_info *info,
+				struct list_head *pagelist)
+
+The deferred_io callback is where you would perform all your IO to the display
+device. You receive the pagelist which is the list of pages that were written
+to during the delay. You must not modify this list. This callback is called
+from a workqueue.
+
+3. Call init
+	info->fbdefio = &hecubafb_defio;
+	fb_deferred_io_init(info);
+
+4. Call cleanup
+	fb_deferred_io_cleanup(info);
diff -puN drivers/video/Kconfig~fbdev-mm-deferred-io-support drivers/video/Kconfig
--- a/drivers/video/Kconfig~fbdev-mm-deferred-io-support
+++ a/drivers/video/Kconfig
@@ -91,6 +91,11 @@ config FB_CFB_IMAGEBLIT
 	  blitting. This is used by drivers that don't provide their own
 	  (accelerated) version.
 
+config FB_DEFERRED_IO
+	bool
+	depends on FB
+	default y
+
 config FB_SVGALIB
 	tristate
 	depends on FB
diff -puN drivers/video/Makefile~fbdev-mm-deferred-io-support drivers/video/Makefile
--- a/drivers/video/Makefile~fbdev-mm-deferred-io-support
+++ a/drivers/video/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_FB_CFB_IMAGEBLIT) += cfbimg
 obj-$(CONFIG_FB_SVGALIB)       += svgalib.o
 obj-$(CONFIG_FB_MACMODES)      += macmodes.o
 obj-$(CONFIG_FB_DDC)           += fb_ddc.o
+obj-$(CONFIG_FB_DEFERRED_IO)   += fb_defio.o
 
 # Hardware specific drivers go first
 obj-$(CONFIG_FB_AMIGA)            += amifb.o c2p.o
diff -puN /dev/null drivers/video/fb_defio.c
--- /dev/null
+++ a/drivers/video/fb_defio.c
@@ -0,0 +1,137 @@
+/*
+ *  linux/drivers/video/fb_defio.c
+ *
+ *  Copyright (C) 2006 Jaya Kumar
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file COPYING in the main directory of this archive
+ * for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/fb.h>
+#include <linux/list.h>
+#include <asm/uaccess.h>
+
+/* to support deferred IO */
+#include <linux/rmap.h>
+#include <linux/pagemap.h>
+
+/* this is to find and return the vmalloc-ed fb pages */
+static struct page* fb_deferred_io_nopage(struct vm_area_struct *vma,
+					unsigned long vaddr, int *type)
+{
+	unsigned long offset;
+	struct page *page;
+	struct fb_info *info = vma->vm_private_data;
+
+	offset = (vaddr - vma->vm_start) + (vma->vm_pgoff << PAGE_SHIFT);
+	if (offset >= info->fix.smem_len)
+		return NOPAGE_SIGBUS;
+
+	page = vmalloc_to_page(info->screen_base + offset);
+	if (!page)
+		return NOPAGE_OOM;
+
+	get_page(page);
+	if (type)
+		*type = VM_FAULT_MINOR;
+	return page;
+}
+
+/* vm_ops->page_mkwrite handler */
+int fb_deferred_io_mkwrite(struct vm_area_struct *vma,
+					struct page *page)
+{
+	struct fb_info *info = vma->vm_private_data;
+	struct fb_deferred_io *fbdefio = info->fbdefio;
+
+	/* this is a callback we get when userspace first tries to
+	write to the page. we schedule a workqueue. that workqueue
+	will eventually mkclean the touched pages and execute the
+	deferred framebuffer IO. then if userspace touches a page
+	again, we repeat the same scheme */
+
+	/* protect against the workqueue changing the page list */
+	mutex_lock(&fbdefio->lock);
+	list_add(&page->lru, &fbdefio->pagelist);
+	mutex_unlock(&fbdefio->lock);
+
+	/* come back after delay to process the deferred IO */
+	schedule_delayed_work(&info->deferred_work, fbdefio->delay);
+	return 0;
+}
+
+static struct vm_operations_struct fb_deferred_io_vm_ops = {
+	.nopage   	= fb_deferred_io_nopage,
+	.page_mkwrite	= fb_deferred_io_mkwrite,
+};
+
+static int fb_deferred_io_mmap(struct fb_info *info, struct vm_area_struct *vma)
+{
+	vma->vm_ops = &fb_deferred_io_vm_ops;
+	vma->vm_flags |= ( VM_IO | VM_RESERVED | VM_DONTEXPAND );
+	vma->vm_private_data = info;
+	return 0;
+}
+
+/* workqueue callback */
+static void fb_deferred_io_work(struct work_struct *work)
+{
+	struct fb_info *info = container_of(work, struct fb_info,
+						deferred_work.work);
+	struct list_head *node, *next;
+	struct page *cur;
+	struct fb_deferred_io *fbdefio = info->fbdefio;
+
+	/* here we mkclean the pages, then do all deferred IO */
+	mutex_lock(&fbdefio->lock);
+	list_for_each_entry(cur, &fbdefio->pagelist, lru) {
+		lock_page(cur);
+		page_mkclean(cur);
+		unlock_page(cur);
+	}
+
+	/* driver's callback with pagelist */
+	fbdefio->deferred_io(info, &fbdefio->pagelist);
+
+	/* clear the list */
+	list_for_each_safe(node, next, &fbdefio->pagelist) {
+		list_del(node);
+	}
+	mutex_unlock(&fbdefio->lock);
+}
+
+void fb_deferred_io_init(struct fb_info *info)
+{
+	struct fb_deferred_io *fbdefio = info->fbdefio;
+
+	BUG_ON(!fbdefio);
+	mutex_init(&fbdefio->lock);
+	info->fbops->fb_mmap = fb_deferred_io_mmap;
+	INIT_DELAYED_WORK(&info->deferred_work, fb_deferred_io_work);
+	INIT_LIST_HEAD(&fbdefio->pagelist);
+	if (fbdefio->delay == 0) /* set a default of 1 s */
+		fbdefio->delay = HZ;
+}
+EXPORT_SYMBOL_GPL(fb_deferred_io_init);
+
+void fb_deferred_io_cleanup(struct fb_info *info)
+{
+	struct fb_deferred_io *fbdefio = info->fbdefio;
+
+	BUG_ON(!fbdefio);
+	cancel_delayed_work(&info->deferred_work);
+	flush_scheduled_work();
+}
+EXPORT_SYMBOL_GPL(fb_deferred_io_cleanup);
+
+MODULE_LICENSE("GPL");
diff -puN include/linux/fb.h~fbdev-mm-deferred-io-support include/linux/fb.h
--- a/include/linux/fb.h~fbdev-mm-deferred-io-support
+++ a/include/linux/fb.h
@@ -561,6 +561,16 @@ struct fb_pixmap {
 	void (*readio) (struct fb_info *info, void *dst, void __iomem *src, unsigned int size);
 };
 
+#ifdef CONFIG_FB_DEFERRED_IO
+struct fb_deferred_io {
+	/* delay between mkwrite and deferred handler */
+	unsigned long delay;
+	struct mutex lock; /* mutex that protects the page list */
+	struct list_head pagelist; /* list of touched pages */
+	/* callback */
+	void (*deferred_io)(struct fb_info *info, struct list_head *pagelist);
+};
+#endif
 
 /*
  * Frame buffer operations
@@ -778,6 +788,10 @@ struct fb_info {
 	struct mutex bl_curve_mutex;	
 	u8 bl_curve[FB_BACKLIGHT_LEVELS];
 #endif
+#ifdef CONFIG_FB_DEFERRED_IO
+	struct delayed_work deferred_work;
+	struct fb_deferred_io *fbdefio;
+#endif
 
 	struct fb_ops *fbops;
 	struct device *device;		/* This is the parent */
@@ -913,6 +927,12 @@ static inline void __fb_pad_aligned_buff
 	}
 }
 
+#ifdef CONFIG_FB_DEFERRED_IO
+/* drivers/video/fb_defio.c */
+extern void fb_deferred_io_init(struct fb_info *info);
+extern void fb_deferred_io_cleanup(struct fb_info *info);
+#endif
+
 /* drivers/video/fbsysfs.c */
 extern struct fb_info *framebuffer_alloc(size_t size, struct device *dev);
 extern void framebuffer_release(struct fb_info *info);
diff -puN mm/rmap.c~fbdev-mm-deferred-io-support mm/rmap.c
--- a/mm/rmap.c~fbdev-mm-deferred-io-support
+++ a/mm/rmap.c
@@ -504,6 +504,7 @@ int page_mkclean(struct page *page)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(page_mkclean);
 
 /**
  * page_set_anon_rmap - setup new anonymous rmap
_

Patches currently in -mm which might be from jayakumar.lkml@gmail.com are

fbdev-mm-deferred-io-support.patch
fbdev-hecuba-framebuffer-driver.patch
