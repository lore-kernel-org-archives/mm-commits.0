From: akpm@linux-foundation.org
Subject: - pa-risc-use-page-allocator-instead-of-slab-allocator.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:40:03 -0700
Message-ID: <200710190340.l9J3e3Ee012679@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50756 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965763AbXJSDl1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:41:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, grundler@parisc-linux.org, hugh@veritas.com, kyle@mcmartin.ca, willy@debian.org, mm-commits@vger.kernel.org


The patch titled
     PA-RISC: Use page allocator instead of slab allocator
has been removed from the -mm tree.  Its filename was
     pa-risc-use-page-allocator-instead-of-slab-allocator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PA-RISC: Use page allocator instead of slab allocator
From: Christoph Lameter <clameter@sgi.com>

Slab pages obtained via kmalloc are not cachline aligned.  Nor is it
advisable to perform VM operations designed for page allocator pages on
memory obtained via kmalloc.

So replace the page sized allocations in kernel/pci-dma.c with page allocator
pages.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>,
Cc: Matthew Wilcox <willy@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/pci-dma.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN arch/parisc/kernel/pci-dma.c~pa-risc-use-page-allocator-instead-of-slab-allocator arch/parisc/kernel/pci-dma.c
--- a/arch/parisc/kernel/pci-dma.c~pa-risc-use-page-allocator-instead-of-slab-allocator
+++ a/arch/parisc/kernel/pci-dma.c
@@ -569,11 +569,10 @@ static void *fail_alloc_consistent(struc
 static void *pa11_dma_alloc_noncoherent(struct device *dev, size_t size,
 					  dma_addr_t *dma_handle, gfp_t flag)
 {
-	void *addr = NULL;
+	void *addr;
 
-	/* rely on kmalloc to be cacheline aligned */
-	addr = kmalloc(size, flag);
-	if(addr)
+	addr = (void *)__get_free_pages(flag, get_order(size));
+	if (addr)
 		*dma_handle = (dma_addr_t)virt_to_phys(addr);
 
 	return addr;
@@ -582,7 +581,7 @@ static void *pa11_dma_alloc_noncoherent(
 static void pa11_dma_free_noncoherent(struct device *dev, size_t size,
 					void *vaddr, dma_addr_t iova)
 {
-	kfree(vaddr);
+	free_pages((unsigned long)vaddr, get_order(size));
 	return;
 }
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
git-parisc.patch
mem-policy-fix-mempolicy-usage-in-pci-driver.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
git-x86.patch
slub-avoid-atomic-operation-for-slab_unlock.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
revoke-core-code.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-whitespace-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
