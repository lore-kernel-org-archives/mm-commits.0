From: akpm@linux-foundation.org
Subject: - doc-dma-api-update.patch removed from -mm tree
Date: Tue, 31 Jul 2007 16:56:24 -0700
Message-ID: <200707312356.l6VNuOg8029321@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39793 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763546AbXHAARU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 20:17:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, James.Bottomley@steeleye.com, muli@il.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Doc: DMA-API update
has been removed from the -mm tree.  Its filename was
     doc-dma-api-update.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Doc: DMA-API update
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix typos and update function parameters.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-API.txt |   79 +++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 41 deletions(-)

diff -puN Documentation/DMA-API.txt~doc-dma-api-update Documentation/DMA-API.txt
--- a/Documentation/DMA-API.txt~doc-dma-api-update
+++ a/Documentation/DMA-API.txt
@@ -26,7 +26,7 @@ Part Ia - Using large dma-coherent buffe
 
 void *
 dma_alloc_coherent(struct device *dev, size_t size,
-			     dma_addr_t *dma_handle, int flag)
+			     dma_addr_t *dma_handle, gfp_t flag)
 void *
 pci_alloc_consistent(struct pci_dev *dev, size_t size,
 			     dma_addr_t *dma_handle)
@@ -38,7 +38,7 @@ to make sure to flush the processor's wr
 devices to read that memory.)
 
 This routine allocates a region of <size> bytes of consistent memory.
-it also returns a <dma_handle> which may be cast to an unsigned
+It also returns a <dma_handle> which may be cast to an unsigned
 integer the same width as the bus and used as the physical address
 base of the region.
 
@@ -52,21 +52,21 @@ The simplest way to do that is to use th
 
 The flag parameter (dma_alloc_coherent only) allows the caller to
 specify the GFP_ flags (see kmalloc) for the allocation (the
-implementation may chose to ignore flags that affect the location of
+implementation may choose to ignore flags that affect the location of
 the returned memory, like GFP_DMA).  For pci_alloc_consistent, you
 must assume GFP_ATOMIC behaviour.
 
 void
-dma_free_coherent(struct device *dev, size_t size, void *cpu_addr
+dma_free_coherent(struct device *dev, size_t size, void *cpu_addr,
 			   dma_addr_t dma_handle)
 void
-pci_free_consistent(struct pci_dev *dev, size_t size, void *cpu_addr
+pci_free_consistent(struct pci_dev *dev, size_t size, void *cpu_addr,
 			   dma_addr_t dma_handle)
 
 Free the region of consistent memory you previously allocated.  dev,
 size and dma_handle must all be the same as those passed into the
 consistent allocate.  cpu_addr must be the virtual address returned by
-the consistent allocate
+the consistent allocate.
 
 
 Part Ib - Using small dma-coherent buffers
@@ -77,9 +77,9 @@ To get this part of the dma_ API, you mu
 Many drivers need lots of small dma-coherent memory regions for DMA
 descriptors or I/O buffers.  Rather than allocating in units of a page
 or more using dma_alloc_coherent(), you can use DMA pools.  These work
-much like a struct kmem_cache, except that they use the dma-coherent allocator
+much like a struct kmem_cache, except that they use the dma-coherent allocator,
 not __get_free_pages().  Also, they understand common hardware constraints
-for alignment, like queue heads needing to be aligned on N byte boundaries.
+for alignment, like queue heads needing to be aligned on N-byte boundaries.
 
 
 	struct dma_pool *
@@ -102,15 +102,15 @@ crossing restrictions, pass 0 for alloc;
 from this pool must not cross 4KByte boundaries.
 
 
-	void *dma_pool_alloc(struct dma_pool *pool, int gfp_flags,
+	void *dma_pool_alloc(struct dma_pool *pool, gfp_t gfp_flags,
 			dma_addr_t *dma_handle);
 
-	void *pci_pool_alloc(struct pci_pool *pool, int gfp_flags,
+	void *pci_pool_alloc(struct pci_pool *pool, gfp_t gfp_flags,
 			dma_addr_t *dma_handle);
 
 This allocates memory from the pool; the returned memory will meet the size
 and alignment requirements specified at creation time.  Pass GFP_ATOMIC to
-prevent blocking, or if it's permitted (not in_interrupt, not holding SMP locks)
+prevent blocking, or if it's permitted (not in_interrupt, not holding SMP locks),
 pass GFP_KERNEL to allow blocking.  Like dma_alloc_coherent(), this returns
 two values:  an address usable by the cpu, and the dma address usable by the
 pool's device.
@@ -123,7 +123,7 @@ pool's device.
 			dma_addr_t addr);
 
 This puts memory back into the pool.  The pool is what was passed to
-the pool allocation routine; the cpu and dma addresses are what
+the pool allocation routine; the cpu (vaddr) and dma addresses are what
 were returned when that routine allocated the memory being freed.
 
 
@@ -209,18 +209,18 @@ Notes:  Not all memory regions in a mach
 API.  Further, regions that appear to be physically contiguous in
 kernel virtual space may not be contiguous as physical memory.  Since
 this API does not provide any scatter/gather capability, it will fail
-if the user tries to map a non physically contiguous piece of memory.
+if the user tries to map a non-physically contiguous piece of memory.
 For this reason, it is recommended that memory mapped by this API be
-obtained only from sources which guarantee to be physically contiguous
+obtained only from sources which guarantee it to be physically contiguous
 (like kmalloc).
 
 Further, the physical address of the memory must be within the
 dma_mask of the device (the dma_mask represents a bit mask of the
-addressable region for the device.  i.e. if the physical address of
+addressable region for the device.  I.e., if the physical address of
 the memory anded with the dma_mask is still equal to the physical
 address, then the device can perform DMA to the memory).  In order to
 ensure that the memory allocated by kmalloc is within the dma_mask,
-the driver may specify various platform dependent flags to restrict
+the driver may specify various platform-dependent flags to restrict
 the physical memory range of the allocation (e.g. on x86, GFP_DMA
 guarantees to be within the first 16Mb of available physical memory,
 as required by ISA devices).
@@ -244,14 +244,14 @@ are guaranteed also to be cache line bou
 
 DMA_TO_DEVICE synchronisation must be done after the last modification
 of the memory region by the software and before it is handed off to
-the driver.  Once this primitive is used.  Memory covered by this
-primitive should be treated as read only by the device.  If the device
+the driver.  Once this primitive is used, memory covered by this
+primitive should be treated as read-only by the device.  If the device
 may write to it at any point, it should be DMA_BIDIRECTIONAL (see
 below).
 
 DMA_FROM_DEVICE synchronisation must be done before the driver
 accesses data that may be changed by the device.  This memory should
-be treated as read only by the driver.  If the driver needs to write
+be treated as read-only by the driver.  If the driver needs to write
 to it at any point, it should be DMA_BIDIRECTIONAL (see below).
 
 DMA_BIDIRECTIONAL requires special handling: it means that the driver
@@ -261,7 +261,7 @@ you must always sync bidirectional memor
 memory is handed off to the device (to make sure all memory changes
 are flushed from the processor) and once before the data may be
 accessed after being used by the device (to make sure any processor
-cache lines are updated with data that the device may have changed.
+cache lines are updated with data that the device may have changed).
 
 void
 dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t size,
@@ -302,8 +302,8 @@ pci_dma_mapping_error(dma_addr_t dma_add
 
 In some circumstances dma_map_single and dma_map_page will fail to create
 a mapping. A driver can check for these errors by testing the returned
-dma address with dma_mapping_error(). A non zero return value means the mapping
-could not be created and the driver should take appropriate action (eg
+dma address with dma_mapping_error(). A non-zero return value means the mapping
+could not be created and the driver should take appropriate action (e.g.
 reduce current DMA mapping usage or delay and try again later).
 
 	int
@@ -315,7 +315,7 @@ reduce current DMA mapping usage or dela
 
 Maps a scatter gather list from the block layer.
 
-Returns: the number of physical segments mapped (this may be shorted
+Returns: the number of physical segments mapped (this may be shorter
 than <nents> passed in if the block layer determines that some
 elements of the scatter/gather list are physically adjacent and thus
 may be mapped with a single entry).
@@ -357,7 +357,7 @@ accessed sg->address and sg->length as s
 	pci_unmap_sg(struct pci_dev *hwdev, struct scatterlist *sg,
 		int nents, int direction)
 
-unmap the previously mapped scatter/gather list.  All the parameters
+Unmap the previously mapped scatter/gather list.  All the parameters
 must be the same as those and passed in to the scatter/gather mapping
 API.
 
@@ -377,7 +377,7 @@ void
 pci_dma_sync_sg(struct pci_dev *hwdev, struct scatterlist *sg,
 		       int nelems, int direction)
 
-synchronise a single contiguous or scatter/gather mapping.  All the
+Synchronise a single contiguous or scatter/gather mapping.  All the
 parameters must be the same as those passed into the single mapping
 API.
 
@@ -406,7 +406,7 @@ API at all.
 
 void *
 dma_alloc_noncoherent(struct device *dev, size_t size,
-			       dma_addr_t *dma_handle, int flag)
+			       dma_addr_t *dma_handle, gfp_t flag)
 
 Identical to dma_alloc_coherent() except that the platform will
 choose to return either consistent or non-consistent memory as it sees
@@ -426,34 +426,34 @@ void
 dma_free_noncoherent(struct device *dev, size_t size, void *cpu_addr,
 			      dma_addr_t dma_handle)
 
-free memory allocated by the nonconsistent API.  All parameters must
+Free memory allocated by the nonconsistent API.  All parameters must
 be identical to those passed in (and returned by
 dma_alloc_noncoherent()).
 
 int
 dma_is_consistent(struct device *dev, dma_addr_t dma_handle)
 
-returns true if the device dev is performing consistent DMA on the memory
+Returns true if the device dev is performing consistent DMA on the memory
 area pointed to by the dma_handle.
 
 int
 dma_get_cache_alignment(void)
 
-returns the processor cache alignment.  This is the absolute minimum
+Returns the processor cache alignment.  This is the absolute minimum
 alignment *and* width that you must observe when either mapping
 memory or doing partial flushes.
 
 Notes: This API may return a number *larger* than the actual cache
 line, but it will guarantee that one or more cache lines fit exactly
 into the width returned by this call.  It will also always be a power
-of two for easy alignment
+of two for easy alignment.
 
 void
 dma_sync_single_range(struct device *dev, dma_addr_t dma_handle,
 		      unsigned long offset, size_t size,
 		      enum dma_data_direction direction)
 
-does a partial sync.  starting at offset and continuing for size.  You
+Does a partial sync, starting at offset and continuing for size.  You
 must be careful to observe the cache alignment and width when doing
 anything like this.  You must also be extra careful about accessing
 memory you intend to sync partially.
@@ -472,21 +472,20 @@ dma_declare_coherent_memory(struct devic
 			    dma_addr_t device_addr, size_t size, int
 			    flags)
 
-
 Declare region of memory to be handed out by dma_alloc_coherent when
 it's asked for coherent memory for this device.
 
 bus_addr is the physical address to which the memory is currently
 assigned in the bus responding region (this will be used by the
-platform to perform the mapping)
+platform to perform the mapping).
 
 device_addr is the physical address the device needs to be programmed
 with actually to address this memory (this will be handed out as the
-dma_addr_t in dma_alloc_coherent())
+dma_addr_t in dma_alloc_coherent()).
 
 size is the size of the area (must be multiples of PAGE_SIZE).
 
-flags can be or'd together and are
+flags can be or'd together and are:
 
 DMA_MEMORY_MAP - request that the memory returned from
 dma_alloc_coherent() be directly writable.
@@ -494,7 +493,7 @@ dma_alloc_coherent() be directly writabl
 DMA_MEMORY_IO - request that the memory returned from
 dma_alloc_coherent() be addressable using read/write/memcpy_toio etc.
 
-One or both of these flags must be present
+One or both of these flags must be present.
 
 DMA_MEMORY_INCLUDES_CHILDREN - make the declared memory be allocated by
 dma_alloc_coherent of any child devices of this one (for memory residing
@@ -528,7 +527,7 @@ dma_release_declared_memory(struct devic
 Remove the memory region previously declared from the system.  This
 API performs *no* in-use checking for this region and will return
 unconditionally having removed all the required structures.  It is the
-drivers job to ensure that no parts of this memory region are
+driver's job to ensure that no parts of this memory region are
 currently in use.
 
 void *
@@ -538,12 +537,10 @@ dma_mark_declared_memory_occupied(struct
 This is used to occupy specific regions of the declared space
 (dma_alloc_coherent() will hand out the first free region it finds).
 
-device_addr is the *device* address of the region requested
+device_addr is the *device* address of the region requested.
 
-size is the size (and should be a page sized multiple).
+size is the size (and should be a page-sized multiple).
 
 The return value will be either a pointer to the processor virtual
 address of the memory, or an error (via PTR_ERR()) if any part of the
 region is occupied.
-
-
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
fix-auditscc-kernel-doc.patch
git-mtd.patch
aha152x-in-debug-mode.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-kgdb-kernel-doc.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
profile-likely-unlikely-macros.patch
