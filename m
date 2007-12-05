From: akpm@linux-foundation.org
Subject: + fb-defio-nopage.patch added to -mm tree
Date: Wed, 05 Dec 2007 14:44:54 -0800
Message-ID: <200712052244.lB5MisFW028883@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41746 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752552AbXLEWpE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Dec 2007 17:45:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, adaplas@pol.net, jayakumar.lkml@gmail.com, lethal@linux-sh.org


The patch titled
     fb: defio nopage
has been added to the -mm tree.  Its filename is
     fb-defio-nopage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fb: defio nopage
From: Nick Piggin <npiggin@suse.de>

Convert fb defio from nopage to fault.
Switch from OOM to SIGBUS if the resource is not available.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fb/deferred_io.txt |    6 +++---
 drivers/video/fb_defio.c         |   17 ++++++++---------
 2 files changed, 11 insertions(+), 12 deletions(-)

diff -puN Documentation/fb/deferred_io.txt~fb-defio-nopage Documentation/fb/deferred_io.txt
--- a/Documentation/fb/deferred_io.txt~fb-defio-nopage
+++ a/Documentation/fb/deferred_io.txt
@@ -7,10 +7,10 @@ IO. The following example may be a usefu
 works:
 
 - userspace app like Xfbdev mmaps framebuffer
-- deferred IO and driver sets up nopage and page_mkwrite handlers
+- deferred IO and driver sets up fault and page_mkwrite handlers
 - userspace app tries to write to mmaped vaddress
-- we get pagefault and reach nopage handler
-- nopage handler finds and returns physical page
+- we get pagefault and reach fault handler
+- fault handler finds and returns physical page
 - we get page_mkwrite where we add this page to a list
 - schedule a workqueue task to be run after a delay
 - app continues writing to that page with no additional cost. this is
diff -puN drivers/video/fb_defio.c~fb-defio-nopage drivers/video/fb_defio.c
--- a/drivers/video/fb_defio.c~fb-defio-nopage
+++ a/drivers/video/fb_defio.c
@@ -25,8 +25,8 @@
 #include <linux/pagemap.h>
 
 /* this is to find and return the vmalloc-ed fb pages */
-static struct page* fb_deferred_io_nopage(struct vm_area_struct *vma,
-					unsigned long vaddr, int *type)
+static int fb_deferred_io_fault(struct vm_area_struct *vma,
+				struct vm_fault *vmf)
 {
 	unsigned long offset;
 	struct page *page;
@@ -34,18 +34,17 @@ static struct page* fb_deferred_io_nopag
 	/* info->screen_base is in System RAM */
 	void *screen_base = (void __force *) info->screen_base;
 
-	offset = (vaddr - vma->vm_start) + (vma->vm_pgoff << PAGE_SHIFT);
+	offset = vmf->pgoff << PAGE_SHIFT;
 	if (offset >= info->fix.smem_len)
-		return NOPAGE_SIGBUS;
+		return VM_FAULT_SIGBUS;
 
 	page = vmalloc_to_page(screen_base + offset);
 	if (!page)
-		return NOPAGE_OOM;
+		return VM_FAULT_SIGBUS;
 
 	get_page(page);
-	if (type)
-		*type = VM_FAULT_MINOR;
-	return page;
+	vmf->page = page;
+	return 0;
 }
 
 int fb_deferred_io_fsync(struct file *file, struct dentry *dentry, int datasync)
@@ -84,7 +83,7 @@ static int fb_deferred_io_mkwrite(struct
 }
 
 static struct vm_operations_struct fb_deferred_io_vm_ops = {
-	.nopage   	= fb_deferred_io_nopage,
+	.fault		= fb_deferred_io_fault,
 	.page_mkwrite	= fb_deferred_io_mkwrite,
 };
 
_

Patches currently in -mm which might be from npiggin@suse.de are

mm-fix-xip-file-writes.patch
git-jfs.patch
nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
slub-use-non-atomic-bit-unlock.patch
radix-tree-avoid-atomic-allocations-for-preloaded-insertions.patch
mm-dont-allow-ioremapping-of-ranges-larger-than-vmalloc-space.patch
vt-bitlock-fix.patch
radix_treeh-trivial-comment-correction.patch
inotify-fix-race.patch
inotify-remove-debug-code.patch
rewrite-rd.patch
rewrite-rd-fix.patch
rd-support-xip.patch
reiser4.patch
ia64-ia32-nopage.patch
relay-nopage.patch
uio-nopage.patch
ieee1394-nopage.patch
v4l-nopage.patch
fb-defio-nopage.patch
agp-alpha-nopage.patch
sg-nopage.patch
ib-nopage.patch
usb-mon-nopage.patch
alsa-nopage.patch
alsa-usx2y-nopage.patch
mm-special-mapping-nopage.patch
