From: akpm@linux-foundation.org
Subject: +
 libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory.patch added
 to -mm tree
Date: Tue, 15 Dec 2015 16:16:58 -0800
Message-ID: <5670ad7a.0SWkBDvhVqae+G67%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47289 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932463AbbLPAQ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Dec 2015 19:16:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, david@fromorbit.com, hch@lst.de, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: libnvdimm, pfn, pmem: allocate memmap array in persistent memory
has been added to the -mm tree.  Its filename is
     libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory.patch

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
Subject: libnvdimm, pfn, pmem: allocate memmap array in persistent memory

Use the new vmem_altmap capability to enable the pmem driver to arrange
for a struct page memmap to be established in persistent memory.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/page.h |    1 +
 drivers/nvdimm/pfn_devs.c    |    3 +--
 drivers/nvdimm/pmem.c        |   19 +++++++++++++++++--
 3 files changed, 19 insertions(+), 4 deletions(-)

diff -puN arch/ia64/include/asm/page.h~libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory arch/ia64/include/asm/page.h
--- a/arch/ia64/include/asm/page.h~libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory
+++ a/arch/ia64/include/asm/page.h
@@ -105,6 +105,7 @@ extern struct page *vmem_map;
 #ifdef CONFIG_DISCONTIGMEM
 # define page_to_pfn(page)	((unsigned long) (page - vmem_map))
 # define pfn_to_page(pfn)	(vmem_map + (pfn))
+# define __pfn_to_phys(pfn)	PFN_PHYS(pfn)
 #else
 # include <asm-generic/memory_model.h>
 #endif
diff -puN drivers/nvdimm/pfn_devs.c~libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory drivers/nvdimm/pfn_devs.c
--- a/drivers/nvdimm/pfn_devs.c~libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory
+++ a/drivers/nvdimm/pfn_devs.c
@@ -83,8 +83,7 @@ static ssize_t mode_store(struct device
 
 		if (strncmp(buf, "pmem\n", n) == 0
 				|| strncmp(buf, "pmem", n) == 0) {
-			/* TODO: allocate from PMEM support */
-			rc = -ENOTTY;
+			nd_pfn->mode = PFN_MODE_PMEM;
 		} else if (strncmp(buf, "ram\n", n) == 0
 				|| strncmp(buf, "ram", n) == 0)
 			nd_pfn->mode = PFN_MODE_RAM;
diff -puN drivers/nvdimm/pmem.c~libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory drivers/nvdimm/pmem.c
--- a/drivers/nvdimm/pmem.c~libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory
+++ a/drivers/nvdimm/pmem.c
@@ -315,12 +315,16 @@ static int nvdimm_namespace_attach_pfn(s
 	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
 	struct nd_pfn *nd_pfn = to_nd_pfn(ndns->claim);
 	struct device *dev = &nd_pfn->dev;
-	struct vmem_altmap *altmap;
 	struct nd_region *nd_region;
+	struct vmem_altmap *altmap;
 	struct nd_pfn_sb *pfn_sb;
 	struct pmem_device *pmem;
 	phys_addr_t offset;
 	int rc;
+	struct vmem_altmap __altmap = {
+		.base_pfn = __phys_to_pfn(nsio->res.start),
+		.reserve = __phys_to_pfn(SZ_8K),
+	};
 
 	if (!nd_pfn->uuid || !nd_pfn->ndns)
 		return -ENODEV;
@@ -348,6 +352,17 @@ static int nvdimm_namespace_attach_pfn(s
 			return -EINVAL;
 		nd_pfn->npfns = le64_to_cpu(pfn_sb->npfns);
 		altmap = NULL;
+	} else if (nd_pfn->mode == PFN_MODE_PMEM) {
+		nd_pfn->npfns = (resource_size(&nsio->res) - offset)
+			/ PAGE_SIZE;
+		if (le64_to_cpu(nd_pfn->pfn_sb->npfns) > nd_pfn->npfns)
+			dev_info(&nd_pfn->dev,
+					"number of pfns truncated from %lld to %ld\n",
+					le64_to_cpu(nd_pfn->pfn_sb->npfns),
+					nd_pfn->npfns);
+		altmap = & __altmap;
+		altmap->free = __phys_to_pfn(offset - SZ_8K);
+		altmap->alloc = 0;
 	} else {
 		rc = -ENXIO;
 		goto err;
@@ -357,7 +372,7 @@ static int nvdimm_namespace_attach_pfn(s
 	pmem = dev_get_drvdata(dev);
 	devm_memunmap(dev, (void __force *) pmem->virt_addr);
 	pmem->virt_addr = (void __pmem *) devm_memremap_pages(dev, &nsio->res,
-			NULL);
+			altmap);
 	pmem->pfn_flags |= PFN_MAP;
 	if (IS_ERR(pmem->virt_addr)) {
 		rc = PTR_ERR(pmem->virt_addr);
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

