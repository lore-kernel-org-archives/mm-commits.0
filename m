From: akpm@linux-foundation.org
Subject: - uio-nopage.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:24:14 -0800
Message-ID: <200802070023.m170Nt98006565@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55502 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760538AbYBGAoo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, hjk@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     uio: nopage
has been removed from the -mm tree.  Its filename was
     uio-nopage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -417,30 +417,28 @@ static void uio_vma_close(struct vm_area
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

origin.patch
drm-convert-from-nopage-to-fault.patch
git-kvm.patch
nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
sg-nopage.patch
mm-special-mapping-nopage.patch
rewrite-rd.patch
rewrite-rd-fix.patch
rewrite-rd-fix-2.patch
rd-support-xip.patch
mm-remove-nopage.patch
buffer_head-fix-private_list-handling.patch
reiser4.patch
reiser4-correct-references-to-filemap_nopage.patch
