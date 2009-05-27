From: akpm@linux-foundation.org
Subject: + acornfb-remove-fb_mmap-function.patch added to -mm tree
Date: Tue, 26 May 2009 23:16:08 -0700
Message-ID: <200905270616.n4R6G87V029643@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39400 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757348AbZE0GQc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 May 2009 02:16:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, rmk@arm.linux.org.uk


The patch titled
     acornfb: remove fb_mmap function
has been added to the -mm tree.  Its filename is
     acornfb-remove-fb_mmap-function.patch

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
Subject: acornfb: remove fb_mmap function
From: Krzysztof Helt <krzysztof.h1@wp.pl>

The driver's fb_mmap function is essentially the same as a generic fb_mmap
function.  Delete driver's function and use the generic one.

A difference is that generic function marks frame buffer memory as VM_IO |
VM_RESERVED.  The driver's function marks it as VM_IO only.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/acornfb.c |   38 --------------------------------------
 1 file changed, 38 deletions(-)

diff -puN drivers/video/acornfb.c~acornfb-remove-fb_mmap-function drivers/video/acornfb.c
--- a/drivers/video/acornfb.c~acornfb-remove-fb_mmap-function
+++ a/drivers/video/acornfb.c
@@ -859,43 +859,6 @@ acornfb_pan_display(struct fb_var_screen
 	return 0;
 }
 
-/*
- * Note that we are entered with the kernel locked.
- */
-static int
-acornfb_mmap(struct fb_info *info, struct vm_area_struct *vma)
-{
-	unsigned long off, start;
-	u32 len;
-
-	off = vma->vm_pgoff << PAGE_SHIFT;
-
-	start = info->fix.smem_start;
-	len = PAGE_ALIGN(start & ~PAGE_MASK) + info->fix.smem_len;
-	start &= PAGE_MASK;
-	if ((vma->vm_end - vma->vm_start + off) > len)
-		return -EINVAL;
-	off += start;
-	vma->vm_pgoff = off >> PAGE_SHIFT;
-
-	/* This is an IO map - tell maydump to skip this VMA */
-	vma->vm_flags |= VM_IO;
-
-	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
-
-	/*
-	 * Don't alter the page protection flags; we want to keep the area
-	 * cached for better performance.  This does mean that we may miss
-	 * some updates to the screen occasionally, but process switches
-	 * should cause the caches and buffers to be flushed often enough.
-	 */
-	if (io_remap_pfn_range(vma, vma->vm_start, off >> PAGE_SHIFT,
-				vma->vm_end - vma->vm_start,
-				vma->vm_page_prot))
-		return -EAGAIN;
-	return 0;
-}
-
 static struct fb_ops acornfb_ops = {
 	.owner		= THIS_MODULE,
 	.fb_check_var	= acornfb_check_var,
@@ -905,7 +868,6 @@ static struct fb_ops acornfb_ops = {
 	.fb_fillrect	= cfb_fillrect,
 	.fb_copyarea	= cfb_copyarea,
 	.fb_imageblit	= cfb_imageblit,
-	.fb_mmap	= acornfb_mmap,
 };
 
 /*
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

revert-fbdev-fix-info-lock-deadlock-in-fbcon_event_notify.patch
revert-fbdev-uninline-lock_fb_info.patch
revert-fbmem-fix-fb_info-lock-and-mm-mmap_sem-circular-locking-dependency.patch
revert-fbmem-dont-call-copy_from-to_user-with-mutex-held.patch
fbdev-move-back-to-bkl-solution.patch
linux-next.patch
fbdev-permit-setting-of-vesa-modes-when-using-compiled-in-drivers.patch
intelfb-fix-color-map-setting-with-an-lvds-display.patch
chipsfb-remove-redundant-assignment.patch
igafb-use-framebuffer_alloc-to-allocate-fb_info-struct.patch
offb-use-framebuffer_alloc-to-allocate-fb_info-struct.patch
acornfb-remove-fb_mmap-function.patch

