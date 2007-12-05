From: akpm@linux-foundation.org
Subject: + uio-nopage.patch added to -mm tree
Date: Wed, 05 Dec 2007 14:44:48 -0800
Message-ID: <200712052244.lB5Mimv3028874@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51431 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752558AbXLEWpI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Dec 2007 17:45:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, hjk@linutronix.de


The patch titled
     uio: nopage
has been added to the -mm tree.  Its filename is
     uio-nopage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uio: nopage
From: Nick Piggin <npiggin@suse.de>

Convert uio from nopage to fault.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Hans J Koch <hjk@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/uio/uio.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN drivers/uio/uio.c~uio-nopage drivers/uio/uio.c
--- a/drivers/uio/uio.c~uio-nopage
+++ a/drivers/uio/uio.c
@@ -412,30 +412,28 @@ static void uio_vma_close(struct vm_area
 	idev->vma_count--;
 }
 
-static struct page *uio_vma_nopage(struct vm_area_struct *vma,
-				   unsigned long address, int *type)
+static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct uio_device *idev = vma->vm_private_data;
-	struct page* page = NOPAGE_SIGBUS;
+	struct page *page;
 
 	int mi = uio_find_mem_index(vma);
 	if (mi < 0)
-		return page;
+		return VM_FAULT_SIGBUS;
 
 	if (idev->info->mem[mi].memtype == UIO_MEM_LOGICAL)
 		page = virt_to_page(idev->info->mem[mi].addr);
 	else
 		page = vmalloc_to_page((void*)idev->info->mem[mi].addr);
 	get_page(page);
-	if (type)
-		*type = VM_FAULT_MINOR;
-	return page;
+	vmf->page = page;
+	return 0;
 }
 
 static struct vm_operations_struct uio_vm_ops = {
 	.open = uio_vma_open,
 	.close = uio_vma_close,
-	.nopage = uio_vma_nopage,
+	.fault = uio_vma_fault,
 };
 
 static int uio_mmap_physical(struct vm_area_struct *vma)
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
