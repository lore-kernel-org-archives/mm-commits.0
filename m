From: akpm@linux-foundation.org
Subject: + mm-fix-mixed-zone-detection-in-devm_memremap_pages.patch added
 to -mm tree
Date: Tue, 01 Mar 2016 14:20:53 -0800
Message-ID: <56d615c5.1JgUloakEP5vOnbe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42703 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbcCAWUy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2016 17:20:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix mixed zone detection in devm_memremap_pages
has been added to the -mm tree.  Its filename is
     mm-fix-mixed-zone-detection-in-devm_memremap_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-mixed-zone-detection-in-devm_memremap_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-mixed-zone-detection-in-devm_memremap_pages.patch

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
Subject: mm: fix mixed zone detection in devm_memremap_pages

The check for whether we overlap "System RAM" needs to be done at section
granularity.  For example a system with the following mapping:

    100000000-37bffffff : System RAM
    37c000000-837ffffff : Persistent Memory

...is unable to use devm_memremap_pages() as it would result in two
zones colliding within a given section.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/memremap.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN kernel/memremap.c~mm-fix-mixed-zone-detection-in-devm_memremap_pages kernel/memremap.c
--- a/kernel/memremap.c~mm-fix-mixed-zone-detection-in-devm_memremap_pages
+++ a/kernel/memremap.c
@@ -270,9 +270,10 @@ struct dev_pagemap *find_dev_pagemap(res
 void *devm_memremap_pages(struct device *dev, struct resource *res,
 		struct percpu_ref *ref, struct vmem_altmap *altmap)
 {
-	int is_ram = region_intersects(res->start, resource_size(res),
-			"System RAM");
-	resource_size_t key, align_start, align_size, align_end;
+	resource_size_t align_start = res->start & ~(SECTION_SIZE - 1);
+	resource_size_t align_size = ALIGN(resource_size(res), SECTION_SIZE);
+	int is_ram = region_intersects(align_start, align_size, "System RAM");
+	resource_size_t key, align_end;
 	struct dev_pagemap *pgmap;
 	struct page_map *page_map;
 	unsigned long pfn;
@@ -314,8 +315,6 @@ void *devm_memremap_pages(struct device
 
 	mutex_lock(&pgmap_lock);
 	error = 0;
-	align_start = res->start & ~(SECTION_SIZE - 1);
-	align_size = ALIGN(resource_size(res), SECTION_SIZE);
 	align_end = align_start + align_size - 1;
 	for (key = align_start; key <= align_end; key += SECTION_SIZE) {
 		struct dev_pagemap *dup;
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

list-kill-list_force_poison.patch
libnvdimm-pmem-fix-pfn-support-for-section-misaligned-namespaces.patch
mm-fix-mixed-zone-detection-in-devm_memremap_pages.patch
mm-config_nr_zones_extended.patch

