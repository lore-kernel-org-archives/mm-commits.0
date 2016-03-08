From: akpm@linux-foundation.org
Subject: + mm-fix-mixed-zone-detection-in-devm_memremap_pages-fix.patch
 added to -mm tree
Date: Tue, 08 Mar 2016 15:17:23 -0800
Message-ID: <56df5d83.TjJ23JADsSUVJaxn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60863 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbcCHXRY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Mar 2016 18:17:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, toshi.kani@hpe.com, mm-commits@vger.kernel.org


The patch titled
     From: Dan Williams <dan.j.williams@intel.com>
has been added to the -mm tree.  Its filename is
     mm-fix-mixed-zone-detection-in-devm_memremap_pages-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-mixed-zone-detection-in-devm_memremap_pages-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-mixed-zone-detection-in-devm_memremap_pages-fix.patch

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
Subject: mm: fix 'size' alignment in devm_memremap_pages()

We need to align the end address, not just the size.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Toshi Kani <toshi.kani@hpe.com>
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
mm-fix-mixed-zone-detection-in-devm_memremap_pages-fix.patch
mm-exclude-zone_device-from-gfp_zone_table.patch
mm-zone_device-depends-on-sparsemem_vmemmap.patch

