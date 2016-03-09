From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-fix-mixed-zone-detection-in-devm_memremap_pages-fix.patch removed from
 -mm tree
Date: Wed, 09 Mar 2016 14:05:26 -0800
Message-ID: <56e09e26.gdyM0iWtQemAjY+J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56739 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934308AbcCIWF1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2016 17:05:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, toshi.kani@hpe.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix 'size' alignment in devm_memremap_pages()
has been removed from the -mm tree.  Its filename was
     mm-fix-mixed-zone-detection-in-devm_memremap_pages-fix.patch

This patch was dropped because it was folded into mm-fix-mixed-zone-detection-in-devm_memremap_pages.patch

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: fix 'size' alignment in devm_memremap_pages()

We need to align the end address, not just the size.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Toshi Kani <toshi.kani@hpe.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/memremap.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN kernel/memremap.c~mm-fix-mixed-zone-detection-in-devm_memremap_pages-fix kernel/memremap.c
--- a/kernel/memremap.c~mm-fix-mixed-zone-detection-in-devm_memremap_pages-fix
+++ a/kernel/memremap.c
@@ -270,14 +270,16 @@ struct dev_pagemap *find_dev_pagemap(res
 void *devm_memremap_pages(struct device *dev, struct resource *res,
 		struct percpu_ref *ref, struct vmem_altmap *altmap)
 {
-	resource_size_t align_start = res->start & ~(SECTION_SIZE - 1);
-	resource_size_t align_size = ALIGN(resource_size(res), SECTION_SIZE);
-	int is_ram = region_intersects(align_start, align_size, "System RAM");
-	resource_size_t key, align_end;
+	resource_size_t key, align_start, align_size, align_end;
 	struct dev_pagemap *pgmap;
 	struct page_map *page_map;
+	int error, nid, is_ram;
 	unsigned long pfn;
-	int error, nid;
+
+	align_start = res->start & ~(SECTION_SIZE - 1);
+	align_size = ALIGN(res->start + resource_size(res), SECTION_SIZE)
+		- align_start;
+	is_ram = region_intersects(align_start, align_size, "System RAM");
 
 	if (is_ram == REGION_MIXED) {
 		WARN_ONCE(1, "%s attempted on mixed region %pr\n",
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

list-kill-list_force_poison.patch
mm-fix-mixed-zone-detection-in-devm_memremap_pages.patch
mm-exclude-zone_device-from-gfp_zone_table.patch
mm-zone_device-depends-on-sparsemem_vmemmap.patch

