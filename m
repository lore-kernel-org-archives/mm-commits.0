From: akpm@linux-foundation.org
Subject: +
 mm-introduce-common-definitions-for-the-size-and-mask-of-a-section.patch
 added to -mm tree
Date: Thu, 19 Jan 2017 16:05:56 -0800
Message-ID: <58815464.dBv39JHImREveroF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44950 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753462AbdATANw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 Jan 2017 19:13:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, hannes@cmpxchg.org, logang@deltatee.com, mgorman@techsingularity.net, mhocko@suse.com, stephen.bates@microsemi.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce common definitions for the size and mask of a section
has been added to the -mm tree.  Its filename is
     mm-introduce-common-definitions-for-the-size-and-mask-of-a-section.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-common-definitions-for-the-size-and-mask-of-a-section.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-common-definitions-for-the-size-and-mask-of-a-section.patch

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
Subject: mm: introduce common definitions for the size and mask of a section

Up-level the local section size and mask from kernel/memremap.c to global
definitions.  These will be used by the new sub-section hotplug support.

Link: http://lkml.kernel.org/r/148486362333.19694.14241079169560958896.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Stephen Bates <stephen.bates@microsemi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 ++
 kernel/memremap.c      |   10 ++++------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN include/linux/mmzone.h~mm-introduce-common-definitions-for-the-size-and-mask-of-a-section include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-introduce-common-definitions-for-the-size-and-mask-of-a-section
+++ a/include/linux/mmzone.h
@@ -1048,6 +1048,8 @@ static inline unsigned long early_pfn_to
  * PFN_SECTION_SHIFT		pfn to/from section number
  */
 #define PA_SECTION_SHIFT	(SECTION_SIZE_BITS)
+#define PA_SECTION_SIZE		(1UL << PA_SECTION_SHIFT)
+#define PA_SECTION_MASK		(~(PA_SECTION_SIZE-1))
 #define PFN_SECTION_SHIFT	(SECTION_SIZE_BITS - PAGE_SHIFT)
 
 #define NR_MEM_SECTIONS		(1UL << SECTIONS_SHIFT)
diff -puN kernel/memremap.c~mm-introduce-common-definitions-for-the-size-and-mask-of-a-section kernel/memremap.c
--- a/kernel/memremap.c~mm-introduce-common-definitions-for-the-size-and-mask-of-a-section
+++ a/kernel/memremap.c
@@ -172,8 +172,6 @@ EXPORT_SYMBOL(devm_memunmap);
 #ifdef CONFIG_ZONE_DEVICE
 static DEFINE_MUTEX(pgmap_lock);
 static RADIX_TREE(pgmap_radix, GFP_KERNEL);
-#define SECTION_MASK ~((1UL << PA_SECTION_SHIFT) - 1)
-#define SECTION_SIZE (1UL << PA_SECTION_SHIFT)
 
 struct page_map {
 	struct resource res;
@@ -267,8 +265,8 @@ static void devm_memremap_pages_release(
 	}
 
 	/* pages are dead and unused, undo the arch mapping */
-	align_start = res->start & ~(SECTION_SIZE - 1);
-	align_size = ALIGN(resource_size(res), SECTION_SIZE);
+	align_start = res->start & PA_SECTION_MASK;
+	align_size = ALIGN(resource_size(res), PA_SECTION_SIZE);
 	mem_hotplug_begin();
 	arch_remove_memory(align_start, align_size);
 	mem_hotplug_done();
@@ -314,8 +312,8 @@ void *devm_memremap_pages(struct device
 	struct page_map *page_map;
 	int error, nid, is_ram;
 
-	align_start = res->start & ~(SECTION_SIZE - 1);
-	align_size = ALIGN(res->start + resource_size(res), SECTION_SIZE)
+	align_start = res->start & PA_SECTION_MASK;
+	align_size = ALIGN(res->start + resource_size(res), PA_SECTION_SIZE)
 		- align_start;
 	is_ram = region_intersects(align_start, align_size,
 		IORESOURCE_SYSTEM_RAM, IORES_DESC_NONE);
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

mm-fix-type-width-of-section-to-from-pfn-conversion-macros.patch
mm-devm_memremap_pages-use-multi-order-radix-for-zone_device-lookups.patch
mm-introduce-struct-mem_section_usage-to-track-partial-population-of-a-section.patch
mm-introduce-common-definitions-for-the-size-and-mask-of-a-section.patch
mm-cleanup-sparse_init_one_section-return-value.patch
mm-track-active-portions-of-a-section-at-boot.patch
mm-fix-register_new_memory-zone-type-detection.patch
mm-convert-kmalloc_section_memmap-to-populate_section_memmap.patch
mm-prepare-for-hot-add-remove-of-sub-section-ranges.patch
mm-support-section-unaligned-zone_device-memory-ranges.patch
mm-enable-section-unaligned-devm_memremap_pages.patch
libnvdimm-pfn-dax-stop-padding-pmem-namespaces-to-section-alignment.patch

