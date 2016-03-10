From: akpm@linux-foundation.org
Subject: [merged] mm-fix-mixed-zone-detection-in-devm_memremap_pages.patch removed from -mm tree
Date: Thu, 10 Mar 2016 10:57:59 -0800
Message-ID: <56e1c3b7.ygubSL6tG6CLTPmf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbcCJS6A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Mar 2016 13:58:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, ross.zwisler@linux.intel.com, toshi.kani@hpe.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix mixed zone detection in devm_memremap_pages
has been removed from the -mm tree.  Its filename was
     mm-fix-mixed-zone-detection-in-devm_memremap_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: fix mixed zone detection in devm_memremap_pages

The check for whether we overlap "System RAM" needs to be done at section
granularity.  For example a system with the following mapping:

    100000000-37bffffff : System RAM
    37c000000-837ffffff : Persistent Memory

...is unable to use devm_memremap_pages() as it would result in two
zones colliding within a given section.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Toshi Kani <toshi.kani@hpe.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/memremap.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN kernel/memremap.c~mm-fix-mixed-zone-detection-in-devm_memremap_pages kernel/memremap.c
--- a/kernel/memremap.c~mm-fix-mixed-zone-detection-in-devm_memremap_pages
+++ a/kernel/memremap.c
@@ -270,13 +270,16 @@ struct dev_pagemap *find_dev_pagemap(res
 void *devm_memremap_pages(struct device *dev, struct resource *res,
 		struct percpu_ref *ref, struct vmem_altmap *altmap)
 {
-	int is_ram = region_intersects(res->start, resource_size(res),
-			"System RAM");
 	resource_size_t key, align_start, align_size, align_end;
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
@@ -314,8 +317,6 @@ void *devm_memremap_pages(struct device
 
 	mutex_lock(&pgmap_lock);
 	error = 0;
-	align_start = res->start & ~(SECTION_SIZE - 1);
-	align_size = ALIGN(resource_size(res), SECTION_SIZE);
 	align_end = align_start + align_size - 1;
 	for (key = align_start; key <= align_end; key += SECTION_SIZE) {
 		struct dev_pagemap *dup;
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

mm-exclude-zone_device-from-gfp_zone_table.patch
mm-zone_device-depends-on-sparsemem_vmemmap.patch

