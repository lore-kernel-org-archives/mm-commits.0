From: akpm@linux-foundation.org
Subject: + intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch added to -mm tree
Date: Mon, 25 Jun 2007 23:43:01 -0700
Message-ID: <200706260643.l5Q6h1CS020232@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41169 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751891AbXFZGnX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 02:43:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anil.s.keshavamurthy@intel.com, a.p.zijlstra@chello.nl, ak@suse.de, arjan@infradead.org, ashok.raj@intel.com, clameter@sgi.com, davem@davemloft.net, greg@kroah.com, muli@il.ibm.com, suresh.b.siddha@intel.com


The patch titled
     Intel IOMMU: Avoid memory allocation failures in dma map api calls
has been added to the -mm tree.  Its filename is
     intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Intel IOMMU: Avoid memory allocation failures in dma map api calls
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>

Intel IOMMU driver needs memory during DMA map calls to setup its internal
page tables and for other data structures.  As we all know that these DMA map
calls are mostly called in the interrupt context or with the spinlock held by
the upper level drivers(network/storage drivers), so in order to avoid any
memory allocation failure due to low memory issues, this patch makes memory
allocation by temporarily setting PF_MEMALLOC flags for the current task
before making memory allocation calls.

We evaluated mempools as a backup when kmem_cache_alloc() fails
and found that mempools are really not useful here because
 1) We don't know for sure how much to reserve in advance
 2) And mempools are not useful for GFP_ATOMIC case (as we call
    memory alloc functions with GFP_ATOMIC)

(akpm: point 2 is wrong...)

With PF_MEMALLOC flag set in the current->flags, the VM subsystem avoids any
watermark checks before allocating memory thus guarantee'ing the memory till
the last free page.  Further, looking at the code in mm/page_alloc.c in
__alloc_pages() function, looks like this flag is useful only in the
non-interrupt context.

If we are in the interrupt context and memory allocation in IOMMU driver fails
for some reason, then the DMA map api's will return failure and it is up to
the higher level drivers to retry.  Suppose, if upper level driver programs
the controller with the buggy DMA virtual address, the IOMMU will block that
DMA transaction when that happens thus preventing any corruption to main
memory.

So far in our test scenario, we were unable to create any memory allocation
failure inside dma map api calls.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Ashok Raj <ashok.raj@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/intel-iommu.c |   30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff -puN drivers/pci/intel-iommu.c~intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls
+++ a/drivers/pci/intel-iommu.c
@@ -84,9 +84,31 @@ static struct kmem_cache *iommu_domain_c
 static struct kmem_cache *iommu_devinfo_cache;
 static struct kmem_cache *iommu_iova_cache;
 
+static inline void *iommu_kmem_cache_alloc(struct kmem_cache *cachep)
+{
+	unsigned int flags;
+	void *vaddr;
+
+	/* trying to avoid low memory issues */
+	flags = current->flags & PF_MEMALLOC;
+	current->flags |= PF_MEMALLOC;
+	vaddr = kmem_cache_alloc(cachep, GFP_ATOMIC);
+	current->flags &= (~PF_MEMALLOC | flags);
+	return vaddr;
+}
+
+
 static inline void *alloc_pgtable_page(void)
 {
-	return (void *)get_zeroed_page(GFP_ATOMIC);
+	unsigned int flags;
+	void *vaddr;
+
+	/* trying to avoid low memory issues */
+	flags = current->flags & PF_MEMALLOC;
+	current->flags |= PF_MEMALLOC;
+	vaddr = (void *)get_zeroed_page(GFP_ATOMIC);
+	current->flags &= (~PF_MEMALLOC | flags);
+	return vaddr;
 }
 
 static inline void free_pgtable_page(void *vaddr)
@@ -96,7 +118,7 @@ static inline void free_pgtable_page(voi
 
 static inline void *alloc_domain_mem(void)
 {
-	return kmem_cache_alloc(iommu_domain_cache, GFP_ATOMIC);
+	return iommu_kmem_cache_alloc(iommu_domain_cache);
 }
 
 static inline void free_domain_mem(void *vaddr)
@@ -106,7 +128,7 @@ static inline void free_domain_mem(void 
 
 static inline void * alloc_devinfo_mem(void)
 {
-	return kmem_cache_alloc(iommu_devinfo_cache, GFP_ATOMIC);
+	return iommu_kmem_cache_alloc(iommu_devinfo_cache);
 }
 
 static inline void free_devinfo_mem(void *vaddr)
@@ -116,7 +138,7 @@ static inline void free_devinfo_mem(void
 
 struct iova *alloc_iova_mem(void)
 {
-	return kmem_cache_alloc(iommu_iova_cache, GFP_ATOMIC);
+	return iommu_kmem_cache_alloc(iommu_iova_cache);
 }
 
 void free_iova_mem(struct iova *iova)
_

Patches currently in -mm which might be from anil.s.keshavamurthy@intel.com are

jprobes-make-struct-jprobeentry-a-void.patch
jprobes-remove-jprobe_entry.patch
jprobes-make-jprobes-a-little-safer-for-users.patch
jprobes-make-jprobes-a-little-safer-for-users-fix.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-pci-generic-helper-function-fix.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-iova-allocation-and-management-routines-fix.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-intel-iommu-driver-fix.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
intel-iommu-iommu-floppy-workaround-fix.patch
