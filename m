From: akpm@linux-foundation.org
Subject: +
 libnvdimm-pmem-move-request_queue-allocation-earlier-in-probe.patch added
 to -mm tree
Date: Tue, 15 Dec 2015 16:17:14 -0800
Message-ID: <5670ad8a.s8sTnThYKMVz+6gG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47318 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932727AbbLPARP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Dec 2015 19:17:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: libnvdimm, pmem: move request_queue allocation earlier in probe
has been added to the -mm tree.  Its filename is
     libnvdimm-pmem-move-request_queue-allocation-earlier-in-probe.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/libnvdimm-pmem-move-request_queue-allocation-earlier-in-probe.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/libnvdimm-pmem-move-request_queue-allocation-earlier-in-probe.patch

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
Subject: libnvdimm, pmem: move request_queue allocation earlier in probe

Before the dynamically allocated struct pages from devm_memremap_pages()
can be put to use outside the driver, we need a mechanism to track whether
they are still in use at teardown.  Towards that goal reorder the
initialization sequence to allow the 'q_usage_counter' from the
request_queue to be used by the devm_memremap_pages() implementation (in
subsequent patches).

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/nvdimm/pmem.c |   33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff -puN drivers/nvdimm/pmem.c~libnvdimm-pmem-move-request_queue-allocation-earlier-in-probe drivers/nvdimm/pmem.c
--- a/drivers/nvdimm/pmem.c~libnvdimm-pmem-move-request_queue-allocation-earlier-in-probe
+++ a/drivers/nvdimm/pmem.c
@@ -124,6 +124,7 @@ static struct pmem_device *pmem_alloc(st
 		struct resource *res, int id)
 {
 	struct pmem_device *pmem;
+	struct request_queue *q;
 
 	pmem = devm_kzalloc(dev, sizeof(*pmem), GFP_KERNEL);
 	if (!pmem)
@@ -141,6 +142,10 @@ static struct pmem_device *pmem_alloc(st
 		return ERR_PTR(-EBUSY);
 	}
 
+	q = blk_alloc_queue_node(GFP_KERNEL, dev_to_node(dev));
+	if (!q)
+		return ERR_PTR(-ENOMEM);
+
 	pmem->pfn_flags = PFN_DEV;
 	if (pmem_should_map_pages(dev)) {
 		pmem->virt_addr = (void __pmem *) devm_memremap_pages(dev, res,
@@ -151,9 +156,12 @@ static struct pmem_device *pmem_alloc(st
 				pmem->phys_addr, pmem->size,
 				ARCH_MEMREMAP_PMEM);
 
-	if (IS_ERR(pmem->virt_addr))
+	if (IS_ERR(pmem->virt_addr)) {
+		blk_cleanup_queue(q);
 		return (void __force *) pmem->virt_addr;
+	}
 
+	pmem->pmem_queue = q;
 	return pmem;
 }
 
@@ -173,10 +181,6 @@ static int pmem_attach_disk(struct devic
 	int nid = dev_to_node(dev);
 	struct gendisk *disk;
 
-	pmem->pmem_queue = blk_alloc_queue_node(GFP_KERNEL, nid);
-	if (!pmem->pmem_queue)
-		return -ENOMEM;
-
 	blk_queue_make_request(pmem->pmem_queue, pmem_make_request);
 	blk_queue_physical_block_size(pmem->pmem_queue, PAGE_SIZE);
 	blk_queue_max_hw_sectors(pmem->pmem_queue, UINT_MAX);
@@ -411,19 +415,22 @@ static int nd_pmem_probe(struct device *
 	dev_set_drvdata(dev, pmem);
 	ndns->rw_bytes = pmem_rw_bytes;
 
-	if (is_nd_btt(dev))
+	if (is_nd_btt(dev)) {
+		/* btt allocates its own request_queue */
+		blk_cleanup_queue(pmem->pmem_queue);
+		pmem->pmem_queue = NULL;
 		return nvdimm_namespace_attach_btt(ndns);
+	}
 
 	if (is_nd_pfn(dev))
 		return nvdimm_namespace_attach_pfn(ndns);
 
-	if (nd_btt_probe(ndns, pmem) == 0) {
-		/* we'll come back as btt-pmem */
-		return -ENXIO;
-	}
-
-	if (nd_pfn_probe(ndns, pmem) == 0) {
-		/* we'll come back as pfn-pmem */
+	if (nd_btt_probe(ndns, pmem) == 0 || nd_pfn_probe(ndns, pmem) == 0) {
+		/*
+		 * We'll come back as either btt-pmem, or pfn-pmem, so
+		 * drop the queue allocation for now.
+		 */
+		blk_cleanup_queue(pmem->pmem_queue);
 		return -ENXIO;
 	}
 
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

