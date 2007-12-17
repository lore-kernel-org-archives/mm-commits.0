From: akpm@linux-foundation.org
Subject: - ieee1394-nopage.patch removed from -mm tree
Date: Mon, 17 Dec 2007 15:39:06 -0800
Message-ID: <200712172339.lBHNd64m008097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39708 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756479AbXLQXjW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Dec 2007 18:39:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, stefanr@s5r6.in-berlin.de, mm-commits@vger.kernel.org


The patch titled
     ieee1394: nopage
has been removed from the -mm tree.  Its filename was
     ieee1394-nopage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ieee1394: nopage
From: Nick Piggin <npiggin@suse.de>

Convert ieee1394 from nopage to fault.
Remove redundant vma range checks (correct resource range check is retained).

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ieee1394/dma.c |   39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff -puN drivers/ieee1394/dma.c~ieee1394-nopage drivers/ieee1394/dma.c
--- a/drivers/ieee1394/dma.c~ieee1394-nopage
+++ a/drivers/ieee1394/dma.c
@@ -231,37 +231,32 @@ void dma_region_sync_for_device(struct d
 
 #ifdef CONFIG_MMU
 
-/* nopage() handler for mmap access */
+/* fault() handler for mmap access */
 
-static struct page *dma_region_pagefault(struct vm_area_struct *area,
-					 unsigned long address, int *type)
+static int dma_region_pagefault(struct vm_area_struct *vma,
+					struct vm_fault *vmf)
 {
-	unsigned long offset;
 	unsigned long kernel_virt_addr;
-	struct page *ret = NOPAGE_SIGBUS;
 
-	struct dma_region *dma = (struct dma_region *)area->vm_private_data;
+	struct dma_region *dma = (struct dma_region *)vma->vm_private_data;
 
 	if (!dma->kvirt)
-		goto out;
+		goto error;
 
-	if ((address < (unsigned long)area->vm_start) ||
-	    (address >
-	     (unsigned long)area->vm_start + (dma->n_pages << PAGE_SHIFT)))
-		goto out;
-
-	if (type)
-		*type = VM_FAULT_MINOR;
-	offset = address - area->vm_start;
-	kernel_virt_addr = (unsigned long)dma->kvirt + offset;
-	ret = vmalloc_to_page((void *)kernel_virt_addr);
-	get_page(ret);
-      out:
-	return ret;
+	if (vmf->pgoff >= dma->n_pages)
+		goto error;
+
+	kernel_virt_addr = (unsigned long)dma->kvirt + (vmf->pgoff << PAGE_SHIFT);
+	vmf->page = vmalloc_to_page((void *)kernel_virt_addr);
+	get_page(vmf->page);
+	return 0;
+
+      error:
+	return VM_FAULT_SIGBUS;
 }
 
 static struct vm_operations_struct dma_region_vm_ops = {
-	.nopage = dma_region_pagefault,
+	.fault = dma_region_pagefault,
 };
 
 /**
@@ -275,7 +270,7 @@ int dma_region_mmap(struct dma_region *d
 	if (!dma->kvirt)
 		return -EINVAL;
 
-	/* must be page-aligned */
+	/* must be page-aligned (XXX: comment is wrong, we could allow pgoff) */
 	if (vma->vm_pgoff != 0)
 		return -EINVAL;
 
_

Patches currently in -mm which might be from npiggin@suse.de are

git-alsa.patch
git-dvb.patch
ia64-ia32-nopage.patch
git-ieee1394.patch
git-infiniband.patch
git-jfs.patch
git-kvm.patch
nfs-use-gfp_nofs-preloads-for-radix-tree-insertion.patch
git-sched.patch
sg-nopage.patch
git-block.patch
usb-mon-nopage.patch
git-x86.patch
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
ext2-xip-check-fix.patch
fb-defio-nopage.patch
rewrite-rd.patch
rewrite-rd-fix.patch
rd-support-xip.patch
reiser4.patch
