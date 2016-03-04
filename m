From: akpm@linux-foundation.org
Subject: [withdrawn]
 libnvdimm-pmem-fix-pfn-support-for-section-misaligned-namespaces.patch
 removed from -mm tree
Date: Fri, 04 Mar 2016 11:58:30 -0800
Message-ID: <56d9e8e6.AAeq0CQ4hA125Esc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758796AbcCDT6c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2016 14:58:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: libnvdimm, pmem: fix 'pfn' support for section-misaligned namespaces
has been removed from the -mm tree.  Its filename was
     libnvdimm-pmem-fix-pfn-support-for-section-misaligned-namespaces.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: libnvdimm, pmem: fix 'pfn' support for section-misaligned namespaces

The altmap for a section-misaligned namespace needs to arrange for the
base_pfn to be section-aligned.  As a result the 'reserve' region (pfns
from base that do not have a struct page) must be increased.  Otherwise we
trip the altmap validation check in __add_pages:

	if (altmap->base_pfn != phys_start_pfn
			|| vmem_altmap_offset(altmap) > nr_pages) {
		pr_warn_once("memory add fail, invalid altmap\n");
		return -EINVAL;
	}

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/nvdimm/pmem.c |   29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff -puN drivers/nvdimm/pmem.c~libnvdimm-pmem-fix-pfn-support-for-section-misaligned-namespaces drivers/nvdimm/pmem.c
--- a/drivers/nvdimm/pmem.c~libnvdimm-pmem-fix-pfn-support-for-section-misaligned-namespaces
+++ a/drivers/nvdimm/pmem.c
@@ -356,6 +356,31 @@ static int nvdimm_namespace_detach_pfn(s
 	return 0;
 }
 
+/*
+ * We hotplug memory at section granularity, pad the reserved area from
+ * the previous section base to the namespace base address.
+ */
+static unsigned long init_altmap_base(resource_size_t base)
+{
+	unsigned long base_pfn = __phys_to_pfn(base);
+
+#ifdef CONFIG_SPARSEMEM
+	base_pfn = SECTION_ALIGN_DOWN(base_pfn);
+#endif
+	return base_pfn;
+}
+
+static unsigned long init_altmap_reserve(resource_size_t base)
+{
+	unsigned long base_pfn = __phys_to_pfn(base);
+	unsigned long reserve = __phys_to_pfn(SZ_8K);
+
+#ifdef CONFIG_SPARSEMEM
+	reserve += base_pfn - SECTION_ALIGN_DOWN(base_pfn);
+#endif
+	return reserve;
+}
+
 static int nvdimm_namespace_attach_pfn(struct nd_namespace_common *ndns)
 {
 	struct nd_namespace_io *nsio = to_nd_namespace_io(&ndns->dev);
@@ -369,8 +394,8 @@ static int nvdimm_namespace_attach_pfn(s
 	phys_addr_t offset;
 	int rc;
 	struct vmem_altmap __altmap = {
-		.base_pfn = __phys_to_pfn(nsio->res.start),
-		.reserve = __phys_to_pfn(SZ_8K),
+		.base_pfn = init_altmap_base(nsio->res.start),
+		.reserve = init_altmap_reserve(nsio->res.start),
 	};
 
 	if (!nd_pfn->uuid || !nd_pfn->ndns)
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

list-kill-list_force_poison.patch
mm-fix-mixed-zone-detection-in-devm_memremap_pages.patch
mm-config_nr_zones_extended.patch

