From: akpm@linux-foundation.org
Subject: [merged]
 libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory.patch removed from -mm tree
Date: Tue, 19 Jan 2016 12:13:30 -0800
Message-ID: <569e98ea.tDiNq0BeApwEGK3k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44325 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933103AbcASUNb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:13:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, david@fromorbit.com, hch@lst.de, linux@roeck-us.net, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: libnvdimm, pfn, pmem: allocate memmap array in persistent memory
has been removed from the -mm tree.  Its filename was
     libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: libnvdimm, pfn, pmem: allocate memmap array in persistent memory

Use the new vmem_altmap capability to enable the pmem driver to arrange
for a struct page memmap to be established in persistent memory.

[linux@roeck-us.net: mn10300: declare __pfn_to_phys() to fix build error]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/page.h    |    1 +
 arch/mn10300/include/asm/page.h |    1 +
 drivers/nvdimm/pfn_devs.c       |    3 +--
 drivers/nvdimm/pmem.c           |   19 +++++++++++++++++--
 4 files changed, 20 insertions(+), 4 deletions(-)

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
diff -puN arch/mn10300/include/asm/page.h~libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory arch/mn10300/include/asm/page.h
--- a/arch/mn10300/include/asm/page.h~libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory
+++ a/arch/mn10300/include/asm/page.h
@@ -107,6 +107,7 @@ static inline int get_order(unsigned lon
 #define pfn_to_kaddr(pfn)	__va((pfn) << PAGE_SHIFT)
 #define pfn_to_page(pfn)	(mem_map + ((pfn) - __pfn_disp))
 #define page_to_pfn(page)	((unsigned long)((page) - mem_map) + __pfn_disp)
+#define __pfn_to_phys(pfn)	PFN_PHYS(pfn)
 
 #define pfn_valid(pfn)					\
 ({							\
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
@@ -357,12 +357,16 @@ static int nvdimm_namespace_attach_pfn(s
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
@@ -380,6 +384,17 @@ static int nvdimm_namespace_attach_pfn(s
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
@@ -389,7 +404,7 @@ static int nvdimm_namespace_attach_pfn(s
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

dax-add-support-for-fsync-sync-v6-fix.patch

