From: akpm@linux-foundation.org
Subject: [merged] documentation-convert-pci-dma-mappingtxt-to-use-the-generic-dma-api.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:03:55 -0400
Message-ID: <201003150704.o2F74SuG017018@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935979Ab0COHEi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:04:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, davem@davemloft.net, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Documentation: convert PCI-DMA-mapping.txt to use the generic DMA API
has been removed from the -mm tree.  Its filename was
     documentation-convert-pci-dma-mappingtxt-to-use-the-generic-dma-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation: convert PCI-DMA-mapping.txt to use the generic DMA API
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

- replace the PCI DMA API (i.e. pci_dma_*) with the generic DMA API.

- make the document more generic (use the PCI specific explanation as
  an example).

[akpm@linux-foundation.org: fix things Randy noticed]
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "David S. Miller" <davem@davemloft.net>
Reviewed-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/PCI/PCI-DMA-mapping.txt |  348 +++++++++++-------------
 1 file changed, 170 insertions(+), 178 deletions(-)

diff -puN Documentation/PCI/PCI-DMA-mapping.txt~documentation-convert-pci-dma-mappingtxt-to-use-the-generic-dma-api Documentation/PCI/PCI-DMA-mapping.txt
--- a/Documentation/PCI/PCI-DMA-mapping.txt~documentation-convert-pci-dma-mappingtxt-to-use-the-generic-dma-api
+++ a/Documentation/PCI/PCI-DMA-mapping.txt
@@ -1,12 +1,12 @@
-			Dynamic DMA mapping
-			===================
+		     Dynamic DMA mapping Guide
+		     =========================
 
 		 David S. Miller <davem@redhat.com>
 		 Richard Henderson <rth@cygnus.com>
 		  Jakub Jelinek <jakub@redhat.com>
 
-This document describes the DMA mapping system in terms of the pci_
-API.  For a similar API that works for generic devices, see
+This is a guide to device driver writers on how to use the DMA API
+with example pseudo-code.  For a concise description of the API, see
 DMA-API.txt.
 
 Most of the 64bit platforms have special hardware that translates bus
@@ -26,12 +26,15 @@ mapped only for the time they are actual
 transfer.
 
 The following API will work of course even on platforms where no such
-hardware exists, see e.g. arch/x86/include/asm/pci.h for how it is implemented on
-top of the virt_to_bus interface.
+hardware exists.
+
+Note that the DMA API works with any bus independent of the underlying
+microprocessor architecture. You should use the DMA API rather than
+the bus specific DMA API (e.g. pci_dma_*).
 
 First of all, you should make sure
 
-#include <linux/pci.h>
+#include <linux/dma-mapping.h>
 
 is in your driver. This file will obtain for you the definition of the
 dma_addr_t (which can hold any valid DMA address for the platform)
@@ -78,44 +81,43 @@ for you to DMA from/to.
 			DMA addressing limitations
 
 Does your device have any DMA addressing limitations?  For example, is
-your device only capable of driving the low order 24-bits of address
-on the PCI bus for SAC DMA transfers?  If so, you need to inform the
-PCI layer of this fact.
+your device only capable of driving the low order 24-bits of address?
+If so, you need to inform the kernel of this fact.
 
 By default, the kernel assumes that your device can address the full
-32-bits in a SAC cycle.  For a 64-bit DAC capable device, this needs
-to be increased.  And for a device with limitations, as discussed in
-the previous paragraph, it needs to be decreased.
-
-pci_alloc_consistent() by default will return 32-bit DMA addresses.
-PCI-X specification requires PCI-X devices to support 64-bit
-addressing (DAC) for all transactions. And at least one platform (SGI
-SN2) requires 64-bit consistent allocations to operate correctly when
-the IO bus is in PCI-X mode. Therefore, like with pci_set_dma_mask(),
-it's good practice to call pci_set_consistent_dma_mask() to set the
-appropriate mask even if your device only supports 32-bit DMA
-(default) and especially if it's a PCI-X device.
-
-For correct operation, you must interrogate the PCI layer in your
-device probe routine to see if the PCI controller on the machine can
-properly support the DMA addressing limitation your device has.  It is
-good style to do this even if your device holds the default setting,
+32-bits.  For a 64-bit capable device, this needs to be increased.
+And for a device with limitations, as discussed in the previous
+paragraph, it needs to be decreased.
+
+Special note about PCI: PCI-X specification requires PCI-X devices to
+support 64-bit addressing (DAC) for all transactions.  And at least
+one platform (SGI SN2) requires 64-bit consistent allocations to
+operate correctly when the IO bus is in PCI-X mode.
+
+For correct operation, you must interrogate the kernel in your device
+probe routine to see if the DMA controller on the machine can properly
+support the DMA addressing limitation your device has.  It is good
+style to do this even if your device holds the default setting,
 because this shows that you did think about these issues wrt. your
 device.
 
-The query is performed via a call to pci_set_dma_mask():
+The query is performed via a call to dma_set_mask():
 
-	int pci_set_dma_mask(struct pci_dev *pdev, u64 device_mask);
+	int dma_set_mask(struct device *dev, u64 mask);
 
 The query for consistent allocations is performed via a call to
-pci_set_consistent_dma_mask():
+dma_set_coherent_mask():
 
-	int pci_set_consistent_dma_mask(struct pci_dev *pdev, u64 device_mask);
+	int dma_set_coherent_mask(struct device *dev, u64 mask);
 
-Here, pdev is a pointer to the PCI device struct of your device, and
-device_mask is a bit mask describing which bits of a PCI address your
-device supports.  It returns zero if your card can perform DMA
-properly on the machine given the address mask you provided.
+Here, dev is a pointer to the device struct of your device, and mask
+is a bit mask describing which bits of an address your device
+supports.  It returns zero if your card can perform DMA properly on
+the machine given the address mask you provided.  In general, the
+device struct of your device is embedded in the bus specific device
+struct of your device.  For example, a pointer to the device struct of
+your PCI device is pdev->dev (pdev is a pointer to the PCI device
+struct of your device).
 
 If it returns non-zero, your device cannot perform DMA properly on
 this platform, and attempting to do so will result in undefined
@@ -133,31 +135,30 @@ of your driver reports that performance 
 even detected, you can ask them for the kernel messages to find out
 exactly why.
 
-The standard 32-bit addressing PCI device would do something like
-this:
+The standard 32-bit addressing device would do something like this:
 
-	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
+	if (dma_set_mask(dev, DMA_BIT_MASK(32))) {
 		printk(KERN_WARNING
 		       "mydev: No suitable DMA available.\n");
 		goto ignore_this_device;
 	}
 
-Another common scenario is a 64-bit capable device.  The approach
-here is to try for 64-bit DAC addressing, but back down to a
-32-bit mask should that fail.  The PCI platform code may fail the
-64-bit mask not because the platform is not capable of 64-bit
-addressing.  Rather, it may fail in this case simply because
-32-bit SAC addressing is done more efficiently than DAC addressing.
-Sparc64 is one platform which behaves in this way.
+Another common scenario is a 64-bit capable device.  The approach here
+is to try for 64-bit addressing, but back down to a 32-bit mask that
+should not fail.  The kernel may fail the 64-bit mask not because the
+platform is not capable of 64-bit addressing.  Rather, it may fail in
+this case simply because 32-bit addressing is done more efficiently
+than 64-bit addressing.  For example, Sparc64 PCI SAC addressing is
+more efficient than DAC addressing.
 
 Here is how you would handle a 64-bit capable device which can drive
 all 64-bits when accessing streaming DMA:
 
 	int using_dac;
 
-	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
+	if (!dma_set_mask(dev, DMA_BIT_MASK(64))) {
 		using_dac = 1;
-	} else if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
+	} else if (!dma_set_mask(dev, DMA_BIT_MASK(32))) {
 		using_dac = 0;
 	} else {
 		printk(KERN_WARNING
@@ -170,36 +171,36 @@ the case would look like this:
 
 	int using_dac, consistent_using_dac;
 
-	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
+	if (!dma_set_mask(dev, DMA_BIT_MASK(64))) {
 		using_dac = 1;
 	   	consistent_using_dac = 1;
-		pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
-	} else if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
+		dma_set_coherent_mask(dev, DMA_BIT_MASK(64));
+	} else if (!dma_set_mask(dev, DMA_BIT_MASK(32))) {
 		using_dac = 0;
 		consistent_using_dac = 0;
-		pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
+		dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
 	} else {
 		printk(KERN_WARNING
 		       "mydev: No suitable DMA available.\n");
 		goto ignore_this_device;
 	}
 
-pci_set_consistent_dma_mask() will always be able to set the same or a
-smaller mask as pci_set_dma_mask(). However for the rare case that a
+dma_set_coherent_mask() will always be able to set the same or a
+smaller mask as dma_set_mask(). However for the rare case that a
 device driver only uses consistent allocations, one would have to
-check the return value from pci_set_consistent_dma_mask().
+check the return value from dma_set_coherent_mask().
 
 Finally, if your device can only drive the low 24-bits of
-address during PCI bus mastering you might do something like:
+address you might do something like:
 
-	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(24))) {
+	if (dma_set_mask(dev, DMA_BIT_MASK(24))) {
 		printk(KERN_WARNING
 		       "mydev: 24-bit DMA addressing not available.\n");
 		goto ignore_this_device;
 	}
 
-When pci_set_dma_mask() is successful, and returns zero, the PCI layer
-saves away this mask you have provided.  The PCI layer will use this
+When dma_set_mask() is successful, and returns zero, the kernel saves
+away this mask you have provided.  The kernel will use this
 information later when you make DMA mappings.
 
 There is a case which we are aware of at this time, which is worth
@@ -208,7 +209,7 @@ functions (for example a sound card prov
 functions) and the various different functions have _different_
 DMA addressing limitations, you may wish to probe each mask and
 only provide the functionality which the machine can handle.  It
-is important that the last call to pci_set_dma_mask() be for the
+is important that the last call to dma_set_mask() be for the
 most specific mask.
 
 Here is pseudo-code showing how this might be done:
@@ -217,17 +218,17 @@ Here is pseudo-code showing how this mig
 	#define RECORD_ADDRESS_BITS	DMA_BIT_MASK(24)
 
 	struct my_sound_card *card;
-	struct pci_dev *pdev;
+	struct device *dev;
 
 	...
-	if (!pci_set_dma_mask(pdev, PLAYBACK_ADDRESS_BITS)) {
+	if (!dma_set_mask(dev, PLAYBACK_ADDRESS_BITS)) {
 		card->playback_enabled = 1;
 	} else {
 		card->playback_enabled = 0;
 		printk(KERN_WARNING "%s: Playback disabled due to DMA limitations.\n",
 		       card->name);
 	}
-	if (!pci_set_dma_mask(pdev, RECORD_ADDRESS_BITS)) {
+	if (!dma_set_mask(dev, RECORD_ADDRESS_BITS)) {
 		card->record_enabled = 1;
 	} else {
 		card->record_enabled = 0;
@@ -252,8 +253,8 @@ There are two types of DMA mappings:
   Think of "consistent" as "synchronous" or "coherent".
 
   The current default is to return consistent memory in the low 32
-  bits of the PCI bus space.  However, for future compatibility you
-  should set the consistent mask even if this default is fine for your
+  bits of the bus space.  However, for future compatibility you should
+  set the consistent mask even if this default is fine for your
   driver.
 
   Good examples of what to use consistent mappings for are:
@@ -285,9 +286,9 @@ There are two types of DMA mappings:
 	     found in PCI bridges (such as by reading a register's value
 	     after writing it).
 
-- Streaming DMA mappings which are usually mapped for one DMA transfer,
-  unmapped right after it (unless you use pci_dma_sync_* below) and for which
-  hardware can optimize for sequential accesses.
+- Streaming DMA mappings which are usually mapped for one DMA
+  transfer, unmapped right after it (unless you use dma_sync_* below)
+  and for which hardware can optimize for sequential accesses.
 
   This of "streaming" as "asynchronous" or "outside the coherency
   domain".
@@ -302,8 +303,8 @@ There are two types of DMA mappings:
   optimizations the hardware allows.  To this end, when using
   such mappings you must be explicit about what you want to happen.
 
-Neither type of DMA mapping has alignment restrictions that come
-from PCI, although some devices may have such restrictions.
+Neither type of DMA mapping has alignment restrictions that come from
+the underlying bus, although some devices may have such restrictions.
 Also, systems with caches that aren't DMA-coherent will work better
 when the underlying buffers don't share cache lines with other data.
 
@@ -315,33 +316,27 @@ you should do:
 
 	dma_addr_t dma_handle;
 
-	cpu_addr = pci_alloc_consistent(pdev, size, &dma_handle);
+	cpu_addr = dma_alloc_coherent(dev, size, &dma_handle, gfp);
 
-where pdev is a struct pci_dev *. This may be called in interrupt context.
-You should use dma_alloc_coherent (see DMA-API.txt) for buses
-where devices don't have struct pci_dev (like ISA, EISA).
-
-This argument is needed because the DMA translations may be bus
-specific (and often is private to the bus which the device is attached
-to).
+where device is a struct device *. This may be called in interrupt
+context with the GFP_ATOMIC flag.
 
 Size is the length of the region you want to allocate, in bytes.
 
 This routine will allocate RAM for that region, so it acts similarly to
 __get_free_pages (but takes size instead of a page order).  If your
 driver needs regions sized smaller than a page, you may prefer using
-the pci_pool interface, described below.
+the dma_pool interface, described below.
 
-The consistent DMA mapping interfaces, for non-NULL pdev, will by
-default return a DMA address which is SAC (Single Address Cycle)
-addressable.  Even if the device indicates (via PCI dma mask) that it
-may address the upper 32-bits and thus perform DAC cycles, consistent
-allocation will only return > 32-bit PCI addresses for DMA if the
-consistent dma mask has been explicitly changed via
-pci_set_consistent_dma_mask().  This is true of the pci_pool interface
-as well.
+The consistent DMA mapping interfaces, for non-NULL dev, will by
+default return a DMA address which is 32-bit addressable.  Even if the
+device indicates (via DMA mask) that it may address the upper 32-bits,
+consistent allocation will only return > 32-bit addresses for DMA if
+the consistent DMA mask has been explicitly changed via
+dma_set_coherent_mask().  This is true of the dma_pool interface as
+well.
 
-pci_alloc_consistent returns two values: the virtual address which you
+dma_alloc_coherent returns two values: the virtual address which you
 can use to access it from the CPU and dma_handle which you pass to the
 card.
 
@@ -354,54 +349,54 @@ buffer you receive will not cross a 64K 
 
 To unmap and free such a DMA region, you call:
 
-	pci_free_consistent(pdev, size, cpu_addr, dma_handle);
+	dma_free_coherent(dev, size, cpu_addr, dma_handle);
 
-where pdev, size are the same as in the above call and cpu_addr and
-dma_handle are the values pci_alloc_consistent returned to you.
+where dev, size are the same as in the above call and cpu_addr and
+dma_handle are the values dma_alloc_coherent returned to you.
 This function may not be called in interrupt context.
 
 If your driver needs lots of smaller memory regions, you can write
-custom code to subdivide pages returned by pci_alloc_consistent,
-or you can use the pci_pool API to do that.  A pci_pool is like
-a kmem_cache, but it uses pci_alloc_consistent not __get_free_pages.
+custom code to subdivide pages returned by dma_alloc_coherent,
+or you can use the dma_pool API to do that.  A dma_pool is like
+a kmem_cache, but it uses dma_alloc_coherent not __get_free_pages.
 Also, it understands common hardware constraints for alignment,
 like queue heads needing to be aligned on N byte boundaries.
 
-Create a pci_pool like this:
+Create a dma_pool like this:
 
-	struct pci_pool *pool;
+	struct dma_pool *pool;
 
-	pool = pci_pool_create(name, pdev, size, align, alloc);
+	pool = dma_pool_create(name, dev, size, align, alloc);
 
-The "name" is for diagnostics (like a kmem_cache name); pdev and size
+The "name" is for diagnostics (like a kmem_cache name); dev and size
 are as above.  The device's hardware alignment requirement for this
 type of data is "align" (which is expressed in bytes, and must be a
 power of two).  If your device has no boundary crossing restrictions,
 pass 0 for alloc; passing 4096 says memory allocated from this pool
 must not cross 4KByte boundaries (but at that time it may be better to
-go for pci_alloc_consistent directly instead).
+go for dma_alloc_coherent directly instead).
 
-Allocate memory from a pci pool like this:
+Allocate memory from a dma pool like this:
 
-	cpu_addr = pci_pool_alloc(pool, flags, &dma_handle);
+	cpu_addr = dma_pool_alloc(pool, flags, &dma_handle);
 
 flags are SLAB_KERNEL if blocking is permitted (not in_interrupt nor
-holding SMP locks), SLAB_ATOMIC otherwise.  Like pci_alloc_consistent,
+holding SMP locks), SLAB_ATOMIC otherwise.  Like dma_alloc_coherent,
 this returns two values, cpu_addr and dma_handle.
 
-Free memory that was allocated from a pci_pool like this:
+Free memory that was allocated from a dma_pool like this:
 
-	pci_pool_free(pool, cpu_addr, dma_handle);
+	dma_pool_free(pool, cpu_addr, dma_handle);
 
-where pool is what you passed to pci_pool_alloc, and cpu_addr and
-dma_handle are the values pci_pool_alloc returned. This function
+where pool is what you passed to dma_pool_alloc, and cpu_addr and
+dma_handle are the values dma_pool_alloc returned. This function
 may be called in interrupt context.
 
-Destroy a pci_pool by calling:
+Destroy a dma_pool by calling:
 
-	pci_pool_destroy(pool);
+	dma_pool_destroy(pool);
 
-Make sure you've called pci_pool_free for all memory allocated
+Make sure you've called dma_pool_free for all memory allocated
 from a pool before you destroy the pool. This function may not
 be called in interrupt context.
 
@@ -411,15 +406,15 @@ The interfaces described in subsequent p
 take a DMA direction argument, which is an integer and takes on
 one of the following values:
 
- PCI_DMA_BIDIRECTIONAL
- PCI_DMA_TODEVICE
- PCI_DMA_FROMDEVICE
- PCI_DMA_NONE
+ DMA_BIDIRECTIONAL
+ DMA_TO_DEVICE
+ DMA_FROM_DEVICE
+ DMA_NONE
 
 One should provide the exact DMA direction if you know it.
 
-PCI_DMA_TODEVICE means "from main memory to the PCI device"
-PCI_DMA_FROMDEVICE means "from the PCI device to main memory"
+DMA_TO_DEVICE means "from main memory to the device"
+DMA_FROM_DEVICE means "from the device to main memory"
 It is the direction in which the data moves during the DMA
 transfer.
 
@@ -427,12 +422,12 @@ You are _strongly_ encouraged to specify
 as you possibly can.
 
 If you absolutely cannot know the direction of the DMA transfer,
-specify PCI_DMA_BIDIRECTIONAL.  It means that the DMA can go in
+specify DMA_BIDIRECTIONAL.  It means that the DMA can go in
 either direction.  The platform guarantees that you may legally
 specify this, and that it will work, but this may be at the
 cost of performance for example.
 
-The value PCI_DMA_NONE is to be used for debugging.  One can
+The value DMA_NONE is to be used for debugging.  One can
 hold this in a data structure before you come to know the
 precise direction, and this will help catch cases where your
 direction tracking logic has failed to set things up properly.
@@ -442,21 +437,21 @@ potential platform-specific optimization
 Some platforms actually have a write permission boolean which DMA
 mappings can be marked with, much like page protections in the user
 program address space.  Such platforms can and do report errors in the
-kernel logs when the PCI controller hardware detects violation of the
+kernel logs when the DMA controller hardware detects violation of the
 permission setting.
 
 Only streaming mappings specify a direction, consistent mappings
 implicitly have a direction attribute setting of
-PCI_DMA_BIDIRECTIONAL.
+DMA_BIDIRECTIONAL.
 
 The SCSI subsystem tells you the direction to use in the
 'sc_data_direction' member of the SCSI command your driver is
 working on.
 
 For Networking drivers, it's a rather simple affair.  For transmit
-packets, map/unmap them with the PCI_DMA_TODEVICE direction
+packets, map/unmap them with the DMA_TO_DEVICE direction
 specifier.  For receive packets, just the opposite, map/unmap them
-with the PCI_DMA_FROMDEVICE direction specifier.
+with the DMA_FROM_DEVICE direction specifier.
 
 		  Using Streaming DMA mappings
 
@@ -467,43 +462,43 @@ scatterlist.
 
 To map a single region, you do:
 
-	struct pci_dev *pdev = mydev->pdev;
+	struct device *dev = &my_dev->dev;
 	dma_addr_t dma_handle;
 	void *addr = buffer->ptr;
 	size_t size = buffer->len;
 
-	dma_handle = pci_map_single(pdev, addr, size, direction);
+	dma_handle = dma_map_single(dev, addr, size, direction);
 
 and to unmap it:
 
-	pci_unmap_single(pdev, dma_handle, size, direction);
+	dma_unmap_single(dev, dma_handle, size, direction);
 
-You should call pci_unmap_single when the DMA activity is finished, e.g.
+You should call dma_unmap_single when the DMA activity is finished, e.g.
 from the interrupt which told you that the DMA transfer is done.
 
 Using cpu pointers like this for single mappings has a disadvantage,
 you cannot reference HIGHMEM memory in this way.  Thus, there is a
-map/unmap interface pair akin to pci_{map,unmap}_single.  These
+map/unmap interface pair akin to dma_{map,unmap}_single.  These
 interfaces deal with page/offset pairs instead of cpu pointers.
 Specifically:
 
-	struct pci_dev *pdev = mydev->pdev;
+	struct device *dev = &my_dev->dev;
 	dma_addr_t dma_handle;
 	struct page *page = buffer->page;
 	unsigned long offset = buffer->offset;
 	size_t size = buffer->len;
 
-	dma_handle = pci_map_page(pdev, page, offset, size, direction);
+	dma_handle = dma_map_page(dev, page, offset, size, direction);
 
 	...
 
-	pci_unmap_page(pdev, dma_handle, size, direction);
+	dma_unmap_page(dev, dma_handle, size, direction);
 
 Here, "offset" means byte offset within the given page.
 
 With scatterlists, you map a region gathered from several regions by:
 
-	int i, count = pci_map_sg(pdev, sglist, nents, direction);
+	int i, count = dma_map_sg(dev, sglist, nents, direction);
 	struct scatterlist *sg;
 
 	for_each_sg(sglist, sg, count, i) {
@@ -527,16 +522,16 @@ accessed sg->address and sg->length as s
 
 To unmap a scatterlist, just call:
 
-	pci_unmap_sg(pdev, sglist, nents, direction);
+	dma_unmap_sg(dev, sglist, nents, direction);
 
 Again, make sure DMA activity has already finished.
 
-PLEASE NOTE:  The 'nents' argument to the pci_unmap_sg call must be
-              the _same_ one you passed into the pci_map_sg call,
+PLEASE NOTE:  The 'nents' argument to the dma_unmap_sg call must be
+              the _same_ one you passed into the dma_map_sg call,
 	      it should _NOT_ be the 'count' value _returned_ from the
-              pci_map_sg call.
+              dma_map_sg call.
 
-Every pci_map_{single,sg} call should have its pci_unmap_{single,sg}
+Every dma_map_{single,sg} call should have its dma_unmap_{single,sg}
 counterpart, because the bus address space is a shared resource (although
 in some ports the mapping is per each BUS so less devices contend for the
 same bus address space) and you could render the machine unusable by eating
@@ -547,14 +542,14 @@ the data in between the DMA transfers, t
 properly in order for the cpu and device to see the most uptodate and
 correct copy of the DMA buffer.
 
-So, firstly, just map it with pci_map_{single,sg}, and after each DMA
+So, firstly, just map it with dma_map_{single,sg}, and after each DMA
 transfer call either:
 
-	pci_dma_sync_single_for_cpu(pdev, dma_handle, size, direction);
+	dma_sync_single_for_cpu(dev, dma_handle, size, direction);
 
 or:
 
-	pci_dma_sync_sg_for_cpu(pdev, sglist, nents, direction);
+	dma_sync_sg_for_cpu(dev, sglist, nents, direction);
 
 as appropriate.
 
@@ -562,27 +557,27 @@ Then, if you wish to let the device get 
 finish accessing the data with the cpu, and then before actually
 giving the buffer to the hardware call either:
 
-	pci_dma_sync_single_for_device(pdev, dma_handle, size, direction);
+	dma_sync_single_for_device(dev, dma_handle, size, direction);
 
 or:
 
-	pci_dma_sync_sg_for_device(dev, sglist, nents, direction);
+	dma_sync_sg_for_device(dev, sglist, nents, direction);
 
 as appropriate.
 
 After the last DMA transfer call one of the DMA unmap routines
-pci_unmap_{single,sg}. If you don't touch the data from the first pci_map_*
-call till pci_unmap_*, then you don't have to call the pci_dma_sync_*
+dma_unmap_{single,sg}. If you don't touch the data from the first dma_map_*
+call till dma_unmap_*, then you don't have to call the dma_sync_*
 routines at all.
 
 Here is pseudo code which shows a situation in which you would need
-to use the pci_dma_sync_*() interfaces.
+to use the dma_sync_*() interfaces.
 
 	my_card_setup_receive_buffer(struct my_card *cp, char *buffer, int len)
 	{
 		dma_addr_t mapping;
 
-		mapping = pci_map_single(cp->pdev, buffer, len, PCI_DMA_FROMDEVICE);
+		mapping = dma_map_single(cp->dev, buffer, len, DMA_FROM_DEVICE);
 
 		cp->rx_buf = buffer;
 		cp->rx_len = len;
@@ -606,25 +601,25 @@ to use the pci_dma_sync_*() interfaces.
 			 * the DMA transfer with the CPU first
 			 * so that we see updated contents.
 			 */
-			pci_dma_sync_single_for_cpu(cp->pdev, cp->rx_dma,
-						    cp->rx_len,
-						    PCI_DMA_FROMDEVICE);
+			dma_sync_single_for_cpu(&cp->dev, cp->rx_dma,
+						cp->rx_len,
+						DMA_FROM_DEVICE);
 
 			/* Now it is safe to examine the buffer. */
 			hp = (struct my_card_header *) cp->rx_buf;
 			if (header_is_ok(hp)) {
-				pci_unmap_single(cp->pdev, cp->rx_dma, cp->rx_len,
-						 PCI_DMA_FROMDEVICE);
+				dma_unmap_single(&cp->dev, cp->rx_dma, cp->rx_len,
+						 DMA_FROM_DEVICE);
 				pass_to_upper_layers(cp->rx_buf);
 				make_and_setup_new_rx_buf(cp);
 			} else {
 				/* Just sync the buffer and give it back
 				 * to the card.
 				 */
-				pci_dma_sync_single_for_device(cp->pdev,
-							       cp->rx_dma,
-							       cp->rx_len,
-							       PCI_DMA_FROMDEVICE);
+				dma_sync_single_for_device(&cp->dev,
+							   cp->rx_dma,
+							   cp->rx_len,
+							   DMA_FROM_DEVICE);
 				give_rx_buf_to_card(cp);
 			}
 		}
@@ -634,19 +629,19 @@ Drivers converted fully to this interfac
 longer, nor should they use bus_to_virt. Some drivers have to be changed a
 little bit, because there is no longer an equivalent to bus_to_virt in the
 dynamic DMA mapping scheme - you have to always store the DMA addresses
-returned by the pci_alloc_consistent, pci_pool_alloc, and pci_map_single
-calls (pci_map_sg stores them in the scatterlist itself if the platform
+returned by the dma_alloc_coherent, dma_pool_alloc, and dma_map_single
+calls (dma_map_sg stores them in the scatterlist itself if the platform
 supports dynamic DMA mapping in hardware) in your driver structures and/or
 in the card registers.
 
-All PCI drivers should be using these interfaces with no exceptions.
-It is planned to completely remove virt_to_bus() and bus_to_virt() as
+All drivers should be using these interfaces with no exceptions.  It
+is planned to completely remove virt_to_bus() and bus_to_virt() as
 they are entirely deprecated.  Some ports already do not provide these
 as it is impossible to correctly support them.
 
 		Optimizing Unmap State Space Consumption
 
-On many platforms, pci_unmap_{single,page}() is simply a nop.
+On many platforms, dma_unmap_{single,page}() is simply a nop.
 Therefore, keeping track of the mapping address and length is a waste
 of space.  Instead of filling your drivers up with ifdefs and the like
 to "work around" this (which would defeat the whole purpose of a
@@ -655,7 +650,7 @@ portable API) the following facilities a
 Actually, instead of describing the macros one by one, we'll
 transform some example code.
 
-1) Use DECLARE_PCI_UNMAP_{ADDR,LEN} in state saving structures.
+1) Use DEFINE_DMA_UNMAP_{ADDR,LEN} in state saving structures.
    Example, before:
 
 	struct ring_state {
@@ -668,14 +663,11 @@ transform some example code.
 
 	struct ring_state {
 		struct sk_buff *skb;
-		DECLARE_PCI_UNMAP_ADDR(mapping)
-		DECLARE_PCI_UNMAP_LEN(len)
+		DEFINE_DMA_UNMAP_ADDR(mapping);
+		DEFINE_DMA_UNMAP_LEN(len);
 	};
 
-   NOTE: DO NOT put a semicolon at the end of the DECLARE_*()
-         macro.
-
-2) Use pci_unmap_{addr,len}_set to set these values.
+2) Use dma_unmap_{addr,len}_set to set these values.
    Example, before:
 
 	ringp->mapping = FOO;
@@ -683,21 +675,21 @@ transform some example code.
 
    after:
 
-	pci_unmap_addr_set(ringp, mapping, FOO);
-	pci_unmap_len_set(ringp, len, BAR);
+	dma_unmap_addr_set(ringp, mapping, FOO);
+	dma_unmap_len_set(ringp, len, BAR);
 
-3) Use pci_unmap_{addr,len} to access these values.
+3) Use dma_unmap_{addr,len} to access these values.
    Example, before:
 
-	pci_unmap_single(pdev, ringp->mapping, ringp->len,
-			 PCI_DMA_FROMDEVICE);
+	dma_unmap_single(dev, ringp->mapping, ringp->len,
+			 DMA_FROM_DEVICE);
 
    after:
 
-	pci_unmap_single(pdev,
-			 pci_unmap_addr(ringp, mapping),
-			 pci_unmap_len(ringp, len),
-			 PCI_DMA_FROMDEVICE);
+	dma_unmap_single(dev,
+			 dma_unmap_addr(ringp, mapping),
+			 dma_unmap_len(ringp, len),
+			 DMA_FROM_DEVICE);
 
 It really should be self-explanatory.  We treat the ADDR and LEN
 separately, because it is possible for an implementation to only
@@ -732,15 +724,15 @@ to "Closing".
 DMA address space is limited on some architectures and an allocation
 failure can be determined by:
 
-- checking if pci_alloc_consistent returns NULL or pci_map_sg returns 0
+- checking if dma_alloc_coherent returns NULL or dma_map_sg returns 0
 
-- checking the returned dma_addr_t of pci_map_single and pci_map_page
-  by using pci_dma_mapping_error():
+- checking the returned dma_addr_t of dma_map_single and dma_map_page
+  by using dma_mapping_error():
 
 	dma_addr_t dma_handle;
 
-	dma_handle = pci_map_single(pdev, addr, size, direction);
-	if (pci_dma_mapping_error(pdev, dma_handle)) {
+	dma_handle = dma_map_single(dev, addr, size, direction);
+	if (dma_mapping_error(dev, dma_handle)) {
 		/*
 		 * reduce current DMA mapping usage,
 		 * delay and try again later or
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch
linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
ssb-add-dma_dev-to-ssb_device-structure.patch
b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b43-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b44-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
ssb-remove-the-ssb-dma-api.patch

