From: akpm@linux-foundation.org
Subject: [merged] acornfb-remove-fb_mmap-function.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:39:31 -0700
Message-ID: <200906171839.n5HIdVbw005596@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759030AbZFQSqB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:46:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     acornfb: remove fb_mmap function
has been removed from the -mm tree.  Its filename was
     acornfb-remove-fb_mmap-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
