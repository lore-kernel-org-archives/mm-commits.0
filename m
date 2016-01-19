From: akpm@linux-foundation.org
Subject: [merged]
 libnvdimm-pmem-move-request_queue-allocation-earlier-in-probe.patch removed from -mm tree
Date: Tue, 19 Jan 2016 12:13:44 -0800
Message-ID: <569e98f8.ENaJuzoSwie0DniO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44360 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143AbcASUNp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:13:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: libnvdimm, pmem: move request_queue allocation earlier in probe
has been removed from the -mm tree.  Its filename was
     libnvdimm-pmem-move-request_queue-allocation-earlier-in-probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -159,6 +159,7 @@ static struct pmem_device *pmem_alloc(st
 		struct resource *res, int id)
 {
 	struct pmem_device *pmem;
+	struct request_queue *q;
 
 	pmem = devm_kzalloc(dev, sizeof(*pmem), GFP_KERNEL);
 	if (!pmem)
@@ -176,6 +177,10 @@ static struct pmem_device *pmem_alloc(st
 		return ERR_PTR(-EBUSY);
 	}
 
+	q = blk_alloc_queue_node(GFP_KERNEL, dev_to_node(dev));
+	if (!q)
+		return ERR_PTR(-ENOMEM);
+
 	pmem->pfn_flags = PFN_DEV;
 	if (pmem_should_map_pages(dev)) {
 		pmem->virt_addr = (void __pmem *) devm_memremap_pages(dev, res,
@@ -186,9 +191,12 @@ static struct pmem_device *pmem_alloc(st
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
 
@@ -208,10 +216,6 @@ static int pmem_attach_disk(struct devic
 	int nid = dev_to_node(dev);
 	struct gendisk *disk;
 
-	pmem->pmem_queue = blk_alloc_queue_node(GFP_KERNEL, nid);
-	if (!pmem->pmem_queue)
-		return -ENOMEM;
-
 	blk_queue_make_request(pmem->pmem_queue, pmem_make_request);
 	blk_queue_physical_block_size(pmem->pmem_queue, PAGE_SIZE);
 	blk_queue_max_hw_sectors(pmem->pmem_queue, UINT_MAX);
@@ -446,19 +450,22 @@ static int nd_pmem_probe(struct device *
 		return -ENOMEM;
 	nvdimm_namespace_add_poison(ndns, &pmem->bb, 0);
 
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
