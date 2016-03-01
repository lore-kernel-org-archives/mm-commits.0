From: akpm@linux-foundation.org
Subject: +
 libnvdimm-pmem-fix-pfn-support-for-section-misaligned-namespaces.patch
 added to -mm tree
Date: Tue, 01 Mar 2016 14:20:49 -0800
Message-ID: <56d615c1.8QoHQFKDEoeCDwLI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbcCAWUu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2016 17:20:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: libnvdimm, pmem: fix 'pfn' support for section-misaligned namespaces
has been added to the -mm tree.  Its filename is
     libnvdimm-pmem-fix-pfn-support-for-section-misaligned-namespaces.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/libnvdimm-pmem-fix-pfn-support-for-section-misaligned-namespaces.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/libnvdimm-pmem-fix-pfn-support-for-section-misaligned-namespaces.patch

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
libnvdimm-pmem-fix-pfn-support-for-section-misaligned-namespaces.patch
mm-fix-mixed-zone-detection-in-devm_memremap_pages.patch
mm-config_nr_zones_extended.patch

