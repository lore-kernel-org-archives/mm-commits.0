From: akpm@linux-foundation.org
Subject: [merged] mm-dax-pmem-introduce-pfn_t.patch removed from -mm tree
Date: Tue, 19 Jan 2016 12:13:22 -0800
Message-ID: <569e98e2.OAAVUe51Ub+igl2f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44302 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932930AbcASUNX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:13:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, dave@sr71.net, hch@lst.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, dax, pmem: introduce pfn_t
has been removed from the -mm tree.  Its filename was
     mm-dax-pmem-introduce-pfn_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm, dax, pmem: introduce pfn_t

For the purpose of communicating the optional presence of a 'struct page'
for the pfn returned from ->direct_access(), introduce a type that
encapsulates a page-frame-number plus flags.  These flags contain the
historical "page_link" encoding for a scatterlist entry, but can also
denote "device memory".  Where "device memory" is a set of pfns that are
not part of the kernel's linear mapping by default, but are accessed via
the same memory controller as ram.

The motivation for this new type is large capacity persistent memory that
needs struct page entries in the 'memmap' to support 3rd party DMA (i.e. 
O_DIRECT I/O with a persistent memory source/target).  However, we also
need it in support of maintaining a list of mapped inodes which need to be
unmapped at driver teardown or freeze_bdev() time.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Hansen <dave@sr71.net>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/axonram.c |    9 +---
 drivers/block/brd.c           |    7 ++-
 drivers/nvdimm/pmem.c         |   13 ++++--
 drivers/s390/block/dcssblk.c  |   11 ++---
 fs/dax.c                      |   11 +++--
 include/linux/blkdev.h        |    5 +-
 include/linux/pfn.h           |    9 ++++
 include/linux/pfn_t.h         |   67 ++++++++++++++++++++++++++++++++
 kernel/memremap.c             |    7 +++
 9 files changed, 116 insertions(+), 23 deletions(-)

diff -puN arch/powerpc/sysdev/axonram.c~mm-dax-pmem-introduce-pfn_t arch/powerpc/sysdev/axonram.c
--- a/arch/powerpc/sysdev/axonram.c~mm-dax-pmem-introduce-pfn_t
+++ a/arch/powerpc/sysdev/axonram.c
@@ -43,6 +43,7 @@
 #include <linux/types.h>
 #include <linux/of_device.h>
 #include <linux/of_platform.h>
+#include <linux/pfn_t.h>
 
 #include <asm/page.h>
 #include <asm/prom.h>
@@ -142,15 +143,13 @@ axon_ram_make_request(struct request_que
  */
 static long
 axon_ram_direct_access(struct block_device *device, sector_t sector,
-		       void __pmem **kaddr, unsigned long *pfn)
+		       void __pmem **kaddr, pfn_t *pfn)
 {
 	struct axon_ram_bank *bank = device->bd_disk->private_data;
 	loff_t offset = (loff_t)sector << AXON_RAM_SECTOR_SHIFT;
-	void *addr = (void *)(bank->ph_addr + offset);
-
-	*kaddr = (void __pmem *)addr;
-	*pfn = virt_to_phys(addr) >> PAGE_SHIFT;
 
+	*kaddr = (void __pmem __force *) bank->io_addr + offset;
+	*pfn = phys_to_pfn_t(bank->ph_addr + offset, PFN_DEV);
 	return bank->size - offset;
 }
 
diff -puN drivers/block/brd.c~mm-dax-pmem-introduce-pfn_t drivers/block/brd.c
--- a/drivers/block/brd.c~mm-dax-pmem-introduce-pfn_t
+++ a/drivers/block/brd.c
@@ -19,6 +19,9 @@
 #include <linux/radix-tree.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
+#ifdef CONFIG_BLK_DEV_RAM_DAX
+#include <linux/pfn_t.h>
+#endif
 
 #include <asm/uaccess.h>
 
@@ -378,7 +381,7 @@ static int brd_rw_page(struct block_devi
 
 #ifdef CONFIG_BLK_DEV_RAM_DAX
 static long brd_direct_access(struct block_device *bdev, sector_t sector,
-			void __pmem **kaddr, unsigned long *pfn)
+			void __pmem **kaddr, pfn_t *pfn)
 {
 	struct brd_device *brd = bdev->bd_disk->private_data;
 	struct page *page;
@@ -389,7 +392,7 @@ static long brd_direct_access(struct blo
 	if (!page)
 		return -ENOSPC;
 	*kaddr = (void __pmem *)page_address(page);
-	*pfn = page_to_pfn(page);
+	*pfn = page_to_pfn_t(page);
 
 	return PAGE_SIZE;
 }
diff -puN drivers/nvdimm/pmem.c~mm-dax-pmem-introduce-pfn_t drivers/nvdimm/pmem.c
--- a/drivers/nvdimm/pmem.c~mm-dax-pmem-introduce-pfn_t
+++ a/drivers/nvdimm/pmem.c
@@ -25,6 +25,7 @@
 #include <linux/moduleparam.h>
 #include <linux/badblocks.h>
 #include <linux/vmalloc.h>
+#include <linux/pfn_t.h>
 #include <linux/slab.h>
 #include <linux/pmem.h>
 #include <linux/nd.h>
@@ -40,6 +41,7 @@ struct pmem_device {
 	phys_addr_t		phys_addr;
 	/* when non-zero this device is hosting a 'pfn' instance */
 	phys_addr_t		data_offset;
+	unsigned long		pfn_flags;
 	void __pmem		*virt_addr;
 	size_t			size;
 	struct badblocks	bb;
@@ -135,13 +137,13 @@ static int pmem_rw_page(struct block_dev
 }
 
 static long pmem_direct_access(struct block_device *bdev, sector_t sector,
-		      void __pmem **kaddr, unsigned long *pfn)
+		      void __pmem **kaddr, pfn_t *pfn)
 {
 	struct pmem_device *pmem = bdev->bd_disk->private_data;
 	resource_size_t offset = sector * 512 + pmem->data_offset;
 
 	*kaddr = pmem->virt_addr + offset;
-	*pfn = (pmem->phys_addr + offset) >> PAGE_SHIFT;
+	*pfn = phys_to_pfn_t(pmem->phys_addr + offset, pmem->pfn_flags);
 
 	return pmem->size - offset;
 }
@@ -174,9 +176,11 @@ static struct pmem_device *pmem_alloc(st
 		return ERR_PTR(-EBUSY);
 	}
 
-	if (pmem_should_map_pages(dev))
+	pmem->pfn_flags = PFN_DEV;
+	if (pmem_should_map_pages(dev)) {
 		pmem->virt_addr = (void __pmem *) devm_memremap_pages(dev, res);
-	else
+		pmem->pfn_flags |= PFN_MAP;
+	} else
 		pmem->virt_addr = (void __pmem *) devm_memremap(dev,
 				pmem->phys_addr, pmem->size,
 				ARCH_MEMREMAP_PMEM);
@@ -384,6 +388,7 @@ static int nvdimm_namespace_attach_pfn(s
 	pmem = dev_get_drvdata(dev);
 	devm_memunmap(dev, (void __force *) pmem->virt_addr);
 	pmem->virt_addr = (void __pmem *) devm_memremap_pages(dev, &nsio->res);
+	pmem->pfn_flags |= PFN_MAP;
 	if (IS_ERR(pmem->virt_addr)) {
 		rc = PTR_ERR(pmem->virt_addr);
 		goto err;
diff -puN drivers/s390/block/dcssblk.c~mm-dax-pmem-introduce-pfn_t drivers/s390/block/dcssblk.c
--- a/drivers/s390/block/dcssblk.c~mm-dax-pmem-introduce-pfn_t
+++ a/drivers/s390/block/dcssblk.c
@@ -17,6 +17,7 @@
 #include <linux/completion.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
+#include <linux/pfn_t.h>
 #include <asm/extmem.h>
 #include <asm/io.h>
 
@@ -30,7 +31,7 @@ static void dcssblk_release(struct gendi
 static blk_qc_t dcssblk_make_request(struct request_queue *q,
 						struct bio *bio);
 static long dcssblk_direct_access(struct block_device *bdev, sector_t secnum,
-			 void __pmem **kaddr, unsigned long *pfn);
+			 void __pmem **kaddr, pfn_t *pfn);
 
 static char dcssblk_segments[DCSSBLK_PARM_LEN] = "\0";
 
@@ -883,20 +884,18 @@ fail:
 
 static long
 dcssblk_direct_access (struct block_device *bdev, sector_t secnum,
-			void __pmem **kaddr, unsigned long *pfn)
+			void __pmem **kaddr, pfn_t *pfn)
 {
 	struct dcssblk_dev_info *dev_info;
 	unsigned long offset, dev_sz;
-	void *addr;
 
 	dev_info = bdev->bd_disk->private_data;
 	if (!dev_info)
 		return -ENODEV;
 	dev_sz = dev_info->end - dev_info->start;
 	offset = secnum * 512;
-	addr = (void *) (dev_info->start + offset);
-	*pfn = virt_to_phys(addr) >> PAGE_SHIFT;
-	*kaddr = (void __pmem *) addr;
+	*kaddr = (void __pmem *) (dev_info->start + offset);
+	*pfn = __pfn_to_pfn_t(PFN_DOWN(dev_info->start + offset), PFN_DEV);
 
 	return dev_sz - offset;
 }
diff -puN fs/dax.c~mm-dax-pmem-introduce-pfn_t fs/dax.c
--- a/fs/dax.c~mm-dax-pmem-introduce-pfn_t
+++ a/fs/dax.c
@@ -28,6 +28,7 @@
 #include <linux/sched.h>
 #include <linux/uio.h>
 #include <linux/vmstat.h>
+#include <linux/pfn_t.h>
 #include <linux/sizes.h>
 
 static long dax_map_atomic(struct block_device *bdev, struct blk_dax_ctl *dax)
@@ -362,7 +363,7 @@ static int dax_insert_mapping(struct ino
 	}
 	dax_unmap_atomic(bdev, &dax);
 
-	error = vm_insert_mixed(vma, vaddr, dax.pfn);
+	error = vm_insert_mixed(vma, vaddr, pfn_t_to_pfn(dax.pfn));
 
  out:
 	i_mmap_unlock_read(mapping);
@@ -667,7 +668,8 @@ int __dax_pmd_fault(struct vm_area_struc
 			result = VM_FAULT_SIGBUS;
 			goto out;
 		}
-		if ((length < PMD_SIZE) || (dax.pfn & PG_PMD_COLOUR)) {
+		if (length < PMD_SIZE
+				|| (pfn_t_to_pfn(dax.pfn) & PG_PMD_COLOUR)) {
 			dax_unmap_atomic(bdev, &dax);
 			goto fallback;
 		}
@@ -676,7 +678,7 @@ int __dax_pmd_fault(struct vm_area_struc
 		 * TODO: teach vmf_insert_pfn_pmd() to support
 		 * 'pte_special' for pmds
 		 */
-		if (pfn_valid(dax.pfn)) {
+		if (pfn_t_has_page(dax.pfn)) {
 			dax_unmap_atomic(bdev, &dax);
 			goto fallback;
 		}
@@ -690,7 +692,8 @@ int __dax_pmd_fault(struct vm_area_struc
 		}
 		dax_unmap_atomic(bdev, &dax);
 
-		result |= vmf_insert_pfn_pmd(vma, address, pmd, dax.pfn, write);
+		result |= vmf_insert_pfn_pmd(vma, address, pmd,
+				pfn_t_to_pfn(dax.pfn), write);
 	}
 
  out:
diff -puN include/linux/blkdev.h~mm-dax-pmem-introduce-pfn_t include/linux/blkdev.h
--- a/include/linux/blkdev.h~mm-dax-pmem-introduce-pfn_t
+++ a/include/linux/blkdev.h
@@ -15,6 +15,7 @@
 #include <linux/backing-dev-defs.h>
 #include <linux/wait.h>
 #include <linux/mempool.h>
+#include <linux/pfn.h>
 #include <linux/bio.h>
 #include <linux/stringify.h>
 #include <linux/gfp.h>
@@ -1628,7 +1629,7 @@ struct blk_dax_ctl {
 	sector_t sector;
 	void __pmem *addr;
 	long size;
-	unsigned long pfn;
+	pfn_t pfn;
 };
 
 struct block_device_operations {
@@ -1638,7 +1639,7 @@ struct block_device_operations {
 	int (*ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	int (*compat_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	long (*direct_access)(struct block_device *, sector_t, void __pmem **,
-			unsigned long *pfn);
+			pfn_t *);
 	unsigned int (*check_events) (struct gendisk *disk,
 				      unsigned int clearing);
 	/* ->media_changed() is DEPRECATED, use ->check_events() instead */
diff -puN include/linux/pfn.h~mm-dax-pmem-introduce-pfn_t include/linux/pfn.h
--- a/include/linux/pfn.h~mm-dax-pmem-introduce-pfn_t
+++ a/include/linux/pfn.h
@@ -3,6 +3,15 @@
 
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
+
+/*
+ * pfn_t: encapsulates a page-frame number that is optionally backed
+ * by memmap (struct page).  Whether a pfn_t has a 'struct page'
+ * backing is indicated by flags in the high bits of the value.
+ */
+typedef struct {
+	unsigned long val;
+} pfn_t;
 #endif
 
 #define PFN_ALIGN(x)	(((unsigned long)(x) + (PAGE_SIZE - 1)) & PAGE_MASK)
diff -puN /dev/null include/linux/pfn_t.h
--- /dev/null
+++ a/include/linux/pfn_t.h
@@ -0,0 +1,67 @@
+#ifndef _LINUX_PFN_T_H_
+#define _LINUX_PFN_T_H_
+#include <linux/mm.h>
+
+/*
+ * PFN_FLAGS_MASK - mask of all the possible valid pfn_t flags
+ * PFN_SG_CHAIN - pfn is a pointer to the next scatterlist entry
+ * PFN_SG_LAST - pfn references a page and is the last scatterlist entry
+ * PFN_DEV - pfn is not covered by system memmap by default
+ * PFN_MAP - pfn has a dynamic page mapping established by a device driver
+ */
+#define PFN_FLAGS_MASK (((unsigned long) ~PAGE_MASK) \
+		<< (BITS_PER_LONG - PAGE_SHIFT))
+#define PFN_SG_CHAIN (1UL << (BITS_PER_LONG - 1))
+#define PFN_SG_LAST (1UL << (BITS_PER_LONG - 2))
+#define PFN_DEV (1UL << (BITS_PER_LONG - 3))
+#define PFN_MAP (1UL << (BITS_PER_LONG - 4))
+
+static inline pfn_t __pfn_to_pfn_t(unsigned long pfn, unsigned long flags)
+{
+	pfn_t pfn_t = { .val = pfn | (flags & PFN_FLAGS_MASK), };
+
+	return pfn_t;
+}
+
+/* a default pfn to pfn_t conversion assumes that @pfn is pfn_valid() */
+static inline pfn_t pfn_to_pfn_t(unsigned long pfn)
+{
+	return __pfn_to_pfn_t(pfn, 0);
+}
+
+extern pfn_t phys_to_pfn_t(dma_addr_t addr, unsigned long flags);
+
+static inline bool pfn_t_has_page(pfn_t pfn)
+{
+	return (pfn.val & PFN_MAP) == PFN_MAP || (pfn.val & PFN_DEV) == 0;
+}
+
+static inline unsigned long pfn_t_to_pfn(pfn_t pfn)
+{
+	return pfn.val & ~PFN_FLAGS_MASK;
+}
+
+static inline struct page *pfn_t_to_page(pfn_t pfn)
+{
+	if (pfn_t_has_page(pfn))
+		return pfn_to_page(pfn_t_to_pfn(pfn));
+	return NULL;
+}
+
+static inline dma_addr_t pfn_t_to_phys(pfn_t pfn)
+{
+	return PFN_PHYS(pfn_t_to_pfn(pfn));
+}
+
+static inline void *pfn_t_to_virt(pfn_t pfn)
+{
+	if (pfn_t_has_page(pfn))
+		return __va(pfn_t_to_phys(pfn));
+	return NULL;
+}
+
+static inline pfn_t page_to_pfn_t(struct page *page)
+{
+	return pfn_to_pfn_t(page_to_pfn(page));
+}
+#endif /* _LINUX_PFN_T_H_ */
diff -puN kernel/memremap.c~mm-dax-pmem-introduce-pfn_t kernel/memremap.c
--- a/kernel/memremap.c~mm-dax-pmem-introduce-pfn_t
+++ a/kernel/memremap.c
@@ -12,6 +12,7 @@
  */
 #include <linux/device.h>
 #include <linux/types.h>
+#include <linux/pfn_t.h>
 #include <linux/io.h>
 #include <linux/mm.h>
 #include <linux/memory_hotplug.h>
@@ -147,6 +148,12 @@ void devm_memunmap(struct device *dev, v
 }
 EXPORT_SYMBOL(devm_memunmap);
 
+pfn_t phys_to_pfn_t(dma_addr_t addr, unsigned long flags)
+{
+	return __pfn_to_pfn_t(addr >> PAGE_SHIFT, flags);
+}
+EXPORT_SYMBOL(phys_to_pfn_t);
+
 #ifdef CONFIG_ZONE_DEVICE
 struct page_map {
 	struct resource res;
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

dax-add-support-for-fsync-sync-v6-fix.patch

