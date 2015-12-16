From: akpm@linux-foundation.org
Subject: + mm-dax-pmem-introduce-pfn_t.patch added to -mm tree
Date: Tue, 15 Dec 2015 16:16:49 -0800
Message-ID: <5670ad71.pERRPBRXMfga10Rz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47252 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbbLPAQu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Dec 2015 19:16:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, dave.hansen@linux.intel.com, hch@lst.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, dax, pmem: introduce pfn_t
has been added to the -mm tree.  Its filename is
     mm-dax-pmem-introduce-pfn_t.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dax-pmem-introduce-pfn_t.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dax-pmem-introduce-pfn_t.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/axonram.c |    8 +--
 drivers/block/brd.c           |    4 -
 drivers/nvdimm/pmem.c         |   12 +++--
 drivers/s390/block/dcssblk.c  |   10 +---
 fs/dax.c                      |   10 ++--
 include/linux/blkdev.h        |    4 -
 include/linux/mm.h            |   66 ++++++++++++++++++++++++++++++++
 include/linux/pfn.h           |    9 ++++
 8 files changed, 100 insertions(+), 23 deletions(-)

diff -puN arch/powerpc/sysdev/axonram.c~mm-dax-pmem-introduce-pfn_t arch/powerpc/sysdev/axonram.c
--- a/arch/powerpc/sysdev/axonram.c~mm-dax-pmem-introduce-pfn_t
+++ a/arch/powerpc/sysdev/axonram.c
@@ -142,15 +142,13 @@ axon_ram_make_request(struct request_que
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
@@ -378,7 +378,7 @@ static int brd_rw_page(struct block_devi
 
 #ifdef CONFIG_BLK_DEV_RAM_DAX
 static long brd_direct_access(struct block_device *bdev, sector_t sector,
-			void __pmem **kaddr, unsigned long *pfn)
+			void __pmem **kaddr, pfn_t *pfn)
 {
 	struct brd_device *brd = bdev->bd_disk->private_data;
 	struct page *page;
@@ -389,7 +389,7 @@ static long brd_direct_access(struct blo
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
@@ -39,6 +39,7 @@ struct pmem_device {
 	phys_addr_t		phys_addr;
 	/* when non-zero this device is hosting a 'pfn' instance */
 	phys_addr_t		data_offset;
+	unsigned long		pfn_flags;
 	void __pmem		*virt_addr;
 	size_t			size;
 };
@@ -101,13 +102,13 @@ static int pmem_rw_page(struct block_dev
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
@@ -140,9 +141,11 @@ static struct pmem_device *pmem_alloc(st
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
@@ -353,6 +356,7 @@ static int nvdimm_namespace_attach_pfn(s
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
@@ -30,7 +30,7 @@ static void dcssblk_release(struct gendi
 static blk_qc_t dcssblk_make_request(struct request_queue *q,
 						struct bio *bio);
 static long dcssblk_direct_access(struct block_device *bdev, sector_t secnum,
-			 void __pmem **kaddr, unsigned long *pfn);
+			 void __pmem **kaddr, pfn_t *pfn);
 
 static char dcssblk_segments[DCSSBLK_PARM_LEN] = "\0";
 
@@ -883,20 +883,18 @@ fail:
 
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
+	*pfn = phys_to_pfn_t(dev_info->start + offset, PFN_DEV);
 
 	return dev_sz - offset;
 }
diff -puN fs/dax.c~mm-dax-pmem-introduce-pfn_t fs/dax.c
--- a/fs/dax.c~mm-dax-pmem-introduce-pfn_t
+++ a/fs/dax.c
@@ -362,7 +362,7 @@ static int dax_insert_mapping(struct ino
 	}
 	dax_unmap_atomic(bdev, &dax);
 
-	error = vm_insert_mixed(vma, vaddr, dax.pfn);
+	error = vm_insert_mixed(vma, vaddr, pfn_t_to_pfn(dax.pfn));
 
  out:
 	i_mmap_unlock_read(mapping);
@@ -667,7 +667,8 @@ int __dax_pmd_fault(struct vm_area_struc
 			result = VM_FAULT_SIGBUS;
 			goto out;
 		}
-		if ((length < PMD_SIZE) || (dax.pfn & PG_PMD_COLOUR)) {
+		if (length < PMD_SIZE
+				|| (pfn_t_to_pfn(dax.pfn) & PG_PMD_COLOUR)) {
 			dax_unmap_atomic(bdev, &dax);
 			goto fallback;
 		}
@@ -676,7 +677,7 @@ int __dax_pmd_fault(struct vm_area_struc
 		 * TODO: teach vmf_insert_pfn_pmd() to support
 		 * 'pte_special' for pmds
 		 */
-		if (pfn_valid(dax.pfn)) {
+		if (pfn_t_has_page(dax.pfn)) {
 			dax_unmap_atomic(bdev, &dax);
 			goto fallback;
 		}
@@ -690,7 +691,8 @@ int __dax_pmd_fault(struct vm_area_struc
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
@@ -1627,7 +1627,7 @@ struct blk_dax_ctl {
 	sector_t sector;
 	void __pmem *addr;
 	long size;
-	unsigned long pfn;
+	pfn_t pfn;
 };
 
 struct block_device_operations {
@@ -1637,7 +1637,7 @@ struct block_device_operations {
 	int (*ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	int (*compat_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	long (*direct_access)(struct block_device *, sector_t, void __pmem **,
-			unsigned long *pfn);
+			pfn_t *);
 	unsigned int (*check_events) (struct gendisk *disk,
 				      unsigned int clearing);
 	/* ->media_changed() is DEPRECATED, use ->check_events() instead */
diff -puN include/linux/mm.h~mm-dax-pmem-introduce-pfn_t include/linux/mm.h
--- a/include/linux/mm.h~mm-dax-pmem-introduce-pfn_t
+++ a/include/linux/mm.h
@@ -896,6 +896,72 @@ static inline void set_page_memcg(struct
 #endif
 
 /*
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
+static inline pfn_t phys_to_pfn_t(dma_addr_t addr, unsigned long flags)
+{
+	return __pfn_to_pfn_t(addr >> PAGE_SHIFT, flags);
+}
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
+
+/*
  * Some inline functions in vmstat.h depend on page_zone()
  */
 #include <linux/vmstat.h>
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
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

scatterlist-fix-sg_phys-masking.patch
pmem-dax-clean-up-clear_pmem.patch
dax-increase-granularity-of-dax_clear_blocks-operations.patch
dax-guarantee-page-aligned-results-from-bdev_direct_access.patch
dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic.patch
dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic-v3.patch
um-kill-pfn_t.patch
kvm-rename-pfn_t-to-kvm_pfn_t.patch
mm-dax-pmem-introduce-pfn_t.patch
mm-dax-pmem-introduce-pfn_t-v3.patch
mm-introduce-find_dev_pagemap.patch
x86-mm-introduce-vmem_altmap-to-augment-vmemmap_populate.patch
libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory.patch
avr32-convert-to-asm-generic-memory_modelh.patch
hugetlb-fix-compile-error-on-tile.patch
frv-fix-compiler-warning-from-definition-of-__pmd.patch
x86-mm-introduce-_page_devmap.patch
mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t.patch
mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t.patch
list-introduce-list_del_poison.patch
libnvdimm-pmem-move-request_queue-allocation-earlier-in-probe.patch
mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup.patch
mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd.patch
mm-x86-get_user_pages-for-dax-mappings.patch
dax-provide-diagnostics-for-pmd-mapping-failures.patch
dax-re-enable-dax-pmd-mappings.patch

