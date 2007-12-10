From: akpm@linux-foundation.org
Subject: - v4l-nopage.patch removed from -mm tree
Date: Mon, 10 Dec 2007 15:22:04 -0800
Message-ID: <200712102322.lBANM4q9024316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37415 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752061AbXLJXWu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Dec 2007 18:22:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     v4l: nopage
has been removed from the -mm tree.  Its filename was
     v4l-nopage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: v4l: nopage
From: Nick Piggin <npiggin@suse.de>

Convert v4l from nopage to fault.
Remove redundant vma range checks.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/videobuf-dma-sg.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff -puN drivers/media/video/videobuf-dma-sg.c~v4l-nopage drivers/media/video/videobuf-dma-sg.c
--- a/drivers/media/video/videobuf-dma-sg.c~v4l-nopage
+++ a/drivers/media/video/videobuf-dma-sg.c
@@ -385,30 +385,26 @@ videobuf_vm_close(struct vm_area_struct 
  * now ...).  Bounce buffers don't work very well for the data rates
  * video capture has.
  */
-static struct page*
-videobuf_vm_nopage(struct vm_area_struct *vma, unsigned long vaddr,
-		   int *type)
+static int
+videobuf_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct page *page;
 
-	dprintk(3,"nopage: fault @ %08lx [vma %08lx-%08lx]\n",
-		vaddr,vma->vm_start,vma->vm_end);
-	if (vaddr > vma->vm_end)
-		return NOPAGE_SIGBUS;
+	dprintk(3,"fault: fault @ %08lx [vma %08lx-%08lx]\n",
+		(unsigned long)vmf->virtual_address,vma->vm_start,vma->vm_end);
 	page = alloc_page(GFP_USER | __GFP_DMA32);
 	if (!page)
-		return NOPAGE_OOM;
+		return VM_FAULT_OOM;
 	clear_user_page(page_address(page), vaddr, page);
-	if (type)
-		*type = VM_FAULT_MINOR;
-	return page;
+	vmf->page = page;
+	return 0;
 }
 
 static struct vm_operations_struct videobuf_vm_ops =
 {
 	.open     = videobuf_vm_open,
 	.close    = videobuf_vm_close,
-	.nopage   = videobuf_vm_nopage,
+	.fault    = videobuf_vm_fault,
 };
 
 /* ---------------------------------------------------------------------
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
alsa-nopage.patch
alsa-usx2y-nopage.patch
git-dvb.patch
ia64-ia32-nopage.patch
ieee1394-nopage.patch
ib-nopage.patch
git-jfs.patch
git-kvm.patch
nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
sg-nopage.patch
usb-mon-nopage.patch
slub-use-non-atomic-bit-unlock.patch
radix-tree-avoid-atomic-allocations-for-preloaded-insertions.patch
mm-dont-allow-ioremapping-of-ranges-larger-than-vmalloc-space.patch
mm-special-mapping-nopage.patch
agp-alpha-nopage.patch
vt-bitlock-fix.patch
radix_treeh-trivial-comment-correction.patch
inotify-fix-race.patch
inotify-remove-debug-code.patch
relay-nopage.patch
uio-nopage.patch
fb-defio-nopage.patch
rewrite-rd.patch
rewrite-rd-fix.patch
rd-support-xip.patch
reiser4.patch
