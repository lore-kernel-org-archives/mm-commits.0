Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99541B4F09
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 23:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789081244; cv=none; b=WHFv/jsfiE1kwFyyOpi41jQEPwSIh6C0frP/kKmYtZHfRt5PKOFjUNCM/Leu55H8pyMofSouSKVO9U2DIIsxm39U5OvqweWh8LkdtcOqdsEWKiyYBAVrjI0p9GLRZTY+m9td/wI6aXU5ChoU/FPjxpInZnEq17DBjS4OB3Fqpzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789081244; c=relaxed/simple;
	bh=2fbj3lXG3SDXKeso/cjGTvGlY63gm7JacjlPorgLXR0=;
	h=Date:To:From:Subject:Message-Id; b=lt/SmafGQvYXsfbg65/GfDcBiYj+XUCp4ZD0dK0kdzR0wSJnHUU0OCohnKHD0wdTD5KAfAbfc0j6DleAh39B/z9uUUluwQhD2YIVQ6i4+ELQPKyj/cqz95RozzYh+TjwfhuadDilBWLOURffixaeBVP0yL4+5i/fxVsYns5f03A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SMq8Dcz7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SMq8Dcz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACD21F000FF;
	Thu, 10 Sep 2026 23:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789081242;
	bh=KAIiUX+LVoQ6og/TLSgM+UQhD0Zt6fFYO5V8njA8gf4=;
	h=Date:To:From:Subject;
	b=SMq8Dcz7TElpI8mltiMd/QBQSgWJzSUEQR5/l2fnJqxGsGP+uZOzrGnNnDZGw6xR1
	 SjGWkKm0rIkestCqWyYfcceasvtEG4TzOxu70d8V8zjg9ViEdTXVq/yFMrolhqfbiw
	 YKUPtBOisyTU8oy3udF6+oyLzIzbah8Gil0b0eh4=
Date: Thu, 10 Sep 2026 16:00:42 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mm_init-skip-initializing-shared-vmemmap-tail-pages.patch removed from -mm tree
Message-Id: <20260910230042.9ACD21F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init: skip initializing shared vmemmap tail pages
has been removed from the -mm tree.  Its filename was
     mm-mm_init-skip-initializing-shared-vmemmap-tail-pages.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/mm_init: skip initializing shared vmemmap tail pages
Date: Tue, 25 Aug 2026 16:45:54 +0800

memmap_init_range() initializes every struct page in the target range. 
For compound pages with vmemmap optimization, the tail struct pages are
backed by a shared vmemmap page.

Initializing those tail struct pages would overwrite the shared vmemmap
page contents, requiring users such as HugeTLB to restore the metadata
afterwards.

Track the compound order for HVO-backed sections and use that metadata to
detect struct pages that fall into the shared tail vmemmap range.  Skip
those shared tail pages in memmap_init_range(), then initialize pageblock
migratetypes for the processed range with a helper after the per-page
initialization loop.

Keep direct mem_section access inside sparse helpers by exposing
pfn_to_section_order() to users that only need the order associated with a
PFN.  This lets memmap_init_range() skip shared tail vmemmap pages without
exposing __pfn_to_section() to !SPARSEMEM builds.

This is a preparatory change for consolidating handling across users of
vmemmap optimization, and it also avoids redundant initialization of
shared tail vmemmap pages during early boot.  That early-boot benefit
appears only once HugeTLB is switched to this common handling, since
HugeTLB is the early-boot user that creates those shared tail vmemmap
pages.

Link: https://lore.kernel.org/20260825084608.47437-4-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    8 +++++++
 mm/mm_init.c           |   40 ++++++++++++++++++++++-----------------
 mm/sparse.h            |   33 ++++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+), 17 deletions(-)

--- a/include/linux/mmzone.h~mm-mm_init-skip-initializing-shared-vmemmap-tail-pages
+++ a/include/linux/mmzone.h
@@ -2022,6 +2022,14 @@ struct mem_section {
 	unsigned long section_mem_map;
 
 	struct mem_section_usage *usage;
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+	/*
+	 * Normally, sections hold regular (order-0) pages. However, for
+	 * sections with HVO enabled, this tracks the compound page order
+	 * to enable deduplication of redundant vmemmap pages.
+	 */
+	unsigned int order;
+#endif
 #ifdef CONFIG_PAGE_EXTENSION
 	/*
 	 * If SPARSEMEM, pgdat doesn't have page_ext pointer. We use
--- a/mm/mm_init.c~mm-mm_init-skip-initializing-shared-vmemmap-tail-pages
+++ a/mm/mm_init.c
@@ -29,6 +29,7 @@
 #include <linux/cma.h>
 #include <linux/crash_dump.h>
 #include <linux/execmem.h>
+#include <linux/sizes.h>
 #include <linux/vmstat.h>
 #include <linux/kexec_handover.h>
 #include <linux/hugetlb.h>
@@ -677,21 +678,19 @@ static inline void fixup_hashdist(void)
 static inline void fixup_hashdist(void) {}
 #endif /* CONFIG_NUMA */
 
-#if defined(CONFIG_ZONE_DEVICE) || defined(CONFIG_DEFERRED_STRUCT_PAGE_INIT)
 static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
-		unsigned long nr_pages, int migratetype, bool atomic)
+		unsigned long nr_pages, int migratetype, bool isolate, bool atomic)
 {
 	const unsigned long end = pfn + nr_pages;
 
 	for (pfn = pageblock_align(pfn); pfn < end; pfn += pageblock_nr_pages) {
 		enum migratetype mt = kho_scratch_migratetype(pfn, migratetype);
 
-		init_pageblock_migratetype(pfn_to_page(pfn), mt, false);
-		if (!atomic && IS_ALIGNED(pfn, PAGES_PER_SECTION))
+		init_pageblock_migratetype(pfn_to_page(pfn), mt, isolate);
+		if (!atomic && IS_ALIGNED(pfn, PFN_DOWN(SZ_1G)))
 			cond_resched();
 	}
 }
-#endif
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 static inline void pgdat_set_deferred_range(pg_data_t *pgdat)
@@ -886,6 +885,17 @@ void __meminit memmap_init_range(unsigne
 			}
 		}
 
+		/*
+		 * Vmemmap-optimizable PFNs are backed by shared tail struct pages,
+		 * which have already been initialized during vmemmap population.
+		 */
+		if (vmemmap_optimizable_pfn(pfn)) {
+			unsigned int order = pfn_to_section_order(pfn);
+
+			pfn = min(ALIGN(pfn, 1UL << order), end_pfn);
+			continue;
+		}
+
 		page = pfn_to_page(pfn);
 		__init_single_page(page, pfn, zone, nid);
 		if (context == MEMINIT_HOTPLUG) {
@@ -897,19 +907,13 @@ void __meminit memmap_init_range(unsigne
 				__SetPageOffline(page);
 		}
 
-		/*
-		 * Usually, we want to mark the pageblock MIGRATE_MOVABLE,
-		 * such that unmovable allocations won't be scattered all
-		 * over the place during system boot.
-		 */
-		if (pageblock_aligned(pfn)) {
-			enum migratetype mt = kho_scratch_migratetype(pfn, migratetype);
-
-			init_pageblock_migratetype(page, mt, isolate_pageblock);
+		if (pageblock_aligned(pfn))
 			cond_resched();
-		}
 		pfn++;
 	}
+
+	pageblock_migratetype_init_range(start_pfn, pfn - start_pfn, migratetype,
+					 isolate_pageblock, /* atomic */ false);
 }
 
 static void __init memmap_init_zone_range(struct zone *zone,
@@ -1112,7 +1116,8 @@ void __ref memmap_init_zone_device(struc
 				     compound_nr_pages(pfn, altmap, pgmap));
 	}
 
-	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE, false);
+	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE,
+					 /* isolate */ false, /* atomic */ false);
 
 	pr_debug("%s initialised %lu pages in %ums\n", __func__,
 		nr_pages, jiffies_to_msecs(jiffies - start));
@@ -1921,7 +1926,8 @@ static void __init deferred_free_pages(u
 	if (!nr_pages)
 		return;
 
-	pageblock_migratetype_init_range(pfn, nr_pages, MIGRATE_MOVABLE, true);
+	pageblock_migratetype_init_range(pfn, nr_pages, MIGRATE_MOVABLE,
+					 /* isolate */ false, /* atomic */ true);
 
 	page = pfn_to_page(pfn);
 
--- a/mm/sparse.h~mm-mm_init-skip-initializing-shared-vmemmap-tail-pages
+++ a/mm/sparse.h
@@ -10,6 +10,39 @@
 
 #include <linux/mmzone.h>
 
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+static inline unsigned int section_order(const struct mem_section *section)
+{
+	return section->order;
+}
+
+static inline unsigned int pfn_to_section_order(unsigned long pfn)
+{
+	return section_order(__pfn_to_section(pfn));
+}
+#else
+static inline unsigned int section_order(const struct mem_section *section)
+{
+	return 0;
+}
+
+static inline unsigned int pfn_to_section_order(unsigned long pfn)
+{
+	return 0;
+}
+#endif
+
+static inline bool vmemmap_optimizable_pfn(unsigned long pfn)
+{
+	const unsigned int order = pfn_to_section_order(pfn);
+	const unsigned long nr_pages = 1UL << order;
+
+	if (!is_power_of_2(sizeof(struct page)))
+		return false;
+
+	return (pfn & (nr_pages - 1)) >= VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
+}
+
 /*
  * mm/sparse.c
  */
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-sparse-vmemmap-initialize-shared-tail-vmemmap-pages-on-allocation.patch
mm-sparse-vmemmap-support-section-based-vmemmap-accounting.patch
mm-mm_init-factor-out-pfn_to_zone.patch
mm-sparse-vmemmap-move-helpers-ahead-of-future-callers.patch
mm-sparse-vmemmap-support-section-based-vmemmap-optimization.patch
mm-sparse-initialize-memory-sections-earlier.patch
mm-hugetlb-switch-hugetlb-to-section-based-vmemmap-optimization.patch
mm-sparse-vmemmap-remove-sparsemem_vmemmap_preinit-support.patch
mm-sparse-inline-usemap-allocation-into-sparse_init_nid.patch
mm-sparse-remove-section_map_size.patch
mm-hugetlb-remove-huge_bootmem_hvo.patch
mm-hugetlb-remove-huge_bootmem_cma.patch
mm-hugetlb-localize-struct-huge_bootmem_page.patch
mm-hugetlb-localize-huge_bootmem_zones_valid.patch
mm-sparse-vmemmap-introduce-config_sparsemem_vmemmap_optimization.patch
mm-sparse-vmemmap-factor-out-shared-vmemmap-tail-page-allocation.patch
mm-sparse-vmemmap-open-code-init_compound_tail.patch
mm-sparse-vmemmap-prepare-dax-vmemmap-population-for-section-orders.patch
mm-sparse-vmemmap-set-section-order-for-device-dax.patch
mm-sparse-vmemmap-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-move-hvo-helpers-to-a-public-header.patch
powerpc-mm-switch-device-dax-to-shared-tail-vmemmap-pages.patch
mm-sparse-vmemmap-drop-the-extra-tail-page-from-device-dax-reservation.patch
mm-sparse-vmemmap-drop-unused-section_nr_vmemmap_pages-arguments.patch
documentation-mm-update-dax-vmemmap-deduplication-docs.patch

