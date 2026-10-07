Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB6E27E05F
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334152; cv=none; b=SAwR9D1NVDn5ujvZHCKLjFftP/ysKKGaDhZ5UnqbVNz7/s0OWJaOtzOVkqvercm66XxGdOmqvLNblZunIFnKTeAUXF1VOQfiKQ66OJ8tsCHO6fRjMuN9jCot7udVwomXnWgED7VxqXcOmFqzCFCIMafqEKcCEp6PwS2xPJFk6M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334152; c=relaxed/simple;
	bh=+D9ujnjDrcood9swnfcqx5UMAtpP9to7OuwThU7/h/Q=;
	h=Date:To:From:Subject:Message-Id; b=CWHgkF/qgev7+LIBNFMo1w+tS5WDxGD+f0D3mz3vVnviCooPoTf05FeX+VLaleQl27B07OE3uMjyBu7xyClQCq2zt/L4hS6aY2+Yb3wo4bCXU66Hje2O8d3BxA74ngHdfwRlBwvBmCcARBtOF4ggtoHY+OUqyAYoNyRrG3++6o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fadCyTHT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fadCyTHT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E621F0089C;
	Wed,  7 Oct 2026 00:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334150;
	bh=RoEq3UDFleu4CxOqUo49IJJXAukAZLgzs1JQvX/d3M4=;
	h=Date:To:From:Subject;
	b=fadCyTHTtp6HGkFqVbTg3iGfZjBdNjTrd4abYcFXn+zk61zGD1FyLHyfUWrtkBoHz
	 xQzCzM/4fHPP1v5kqb6U2C7//+9S/dhaL1lwLP28AqZXVjgQTX840A1dvx1jLjUuWl
	 8zx2Gx6lJOZhVPBlRYx6c1Jvun2UIQKPgFvh5Hy8=
Date: Tue, 06 Oct 2026 17:49:10 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david.laight.linux@gmail.com,david@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_init-skip-initializing-shared-vmemmap-tail-pages.patch removed from -mm tree
Message-Id: <20261007004910.90E621F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init: skip initializing shared vmemmap tail pages
has been removed from the -mm tree.  Its filename was
     mm-mm_init-skip-initializing-shared-vmemmap-tail-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/mm_init: skip initializing shared vmemmap tail pages
Date: Thu, 10 Sep 2026 14:32:42 +0800

memmap_init_range() initializes every struct page in the target range. 
For compound pages with vmemmap optimization, the tail struct pages are
backed by a shared vmemmap page.

Initializing those tail struct pages would overwrite the shared vmemmap
page contents, requiring users such as HugeTLB to restore the metadata
afterwards.

Track the compound page order for HVO-backed sections and use that
metadata to detect struct pages that fall into the shared tail vmemmap
range.  Skip those shared tail pages in memmap_init_range(), then
initialize pageblock migratetypes for the processed range with a helper
after the per-page initialization loop.

Keep direct mem_section access inside sparse helpers.  Expose
pfn_to_section_compound_order() for callers that only need the order
associated with a PFN.  This lets memmap_init_range() skip shared tail
vmemmap pages without exposing __pfn_to_section() to !SPARSEMEM builds.

This is a preparatory change for consolidating handling across users of
vmemmap optimization, and it also avoids redundant initialization of
shared tail vmemmap pages during early boot.  That early-boot benefit
appears only once HugeTLB is switched to this common handling, since
HugeTLB is the early-boot user that creates those shared tail vmemmap
pages.

Link: https://lore.kernel.org/20260910063256.64386-4-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
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
+	unsigned int compound_page_order;
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
+			const unsigned int order = pfn_to_section_compound_order(pfn);
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
+static inline unsigned int section_compound_order(const struct mem_section *section)
+{
+	return section->compound_page_order;
+}
+
+static inline unsigned int pfn_to_section_compound_order(unsigned long pfn)
+{
+	return section_compound_order(__pfn_to_section(pfn));
+}
+#else
+static inline unsigned int section_compound_order(const struct mem_section *section)
+{
+	return 0;
+}
+
+static inline unsigned int pfn_to_section_compound_order(unsigned long pfn)
+{
+	return 0;
+}
+#endif
+
+static inline bool vmemmap_optimizable_pfn(unsigned long pfn)
+{
+	const unsigned int order = pfn_to_section_compound_order(pfn);
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


