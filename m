Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8761A6806
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 04:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787890877; cv=none; b=R1u/MhG+gA+026tmpLgoZItX8Sh9Yzwhckw+SYRvl2S9GfzQA5qUGM40sqmw7Qat+Vr4uQNJ/xVZkYvShMXjpcco4cjheBrVhVNHyGpkUKgHJBAXgxMvr9I3f394s3zhiCAIbb605u6P25r3lmcztsHxk9KzyGZEvgedbe4Vb7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787890877; c=relaxed/simple;
	bh=jTz9/8i9X8G5kRbOaoaqO4imW3BqmUQ/3Euirj0mJdE=;
	h=Date:To:From:Subject:Message-Id; b=CfJDq3Hvn+NyPC7OM+FWFjbbvhPsohZAtjo6ZogxMhIFhmpoDZ1oUaADWD9gB65GUeMZNUrAdrzDRtunujFocYsPRpDH0aZ1/TrM3EWZmbzAadF1GzZkHoXo2UuVCr3YcAm0d15nKnW7Dgc4oi9ZIFGIfKqspkhgp2eZSToQf1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1f3gfXZN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1f3gfXZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD581F000E9;
	Fri, 28 Aug 2026 04:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787890875;
	bh=xMANMxaoVUP3tqe0wldtWVponEvioTdtHPe0eIHnY/k=;
	h=Date:To:From:Subject;
	b=1f3gfXZNLKyfnpLzm3q4oajcllGTHb6p+LVCiE5f6Lq+okj2HjGgk6X7tuOTDI/ib
	 ij3hyhI/MR54cxGj9Gp+KmdSaQhJVChxmWpnpoLztJw3rr36DbW5vYpwuib4ce5nGa
	 yxPGP/PYYbLoOQP+sVTDvFtYWdEjuSv910EJ3xDA=
Date: Thu, 27 Aug 2026 21:21:14 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_init-skip-initializing-shared-vmemmap-tail-pages.patch added to mm-new branch
Message-Id: <20260828042115.1CD581F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init: skip initializing shared vmemmap tail pages
has been added to the -mm mm-new branch.  Its filename is
     mm-mm_init-skip-initializing-shared-vmemmap-tail-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_init-skip-initializing-shared-vmemmap-tail-pages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
@@ -1907,7 +1912,8 @@ static void __init deferred_free_pages(u
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

mm-sparse-relax-struct-mem_section-size-constraints.patch
mm-sparse-vmemmap-rename-hvo-order-macros.patch
mm-mm_init-skip-initializing-shared-vmemmap-tail-pages.patch
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

