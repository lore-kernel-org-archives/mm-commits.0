Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177B43B3BE2
	for <mm-commits@vger.kernel.org>; Fri, 28 Aug 2026 04:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787890913; cv=none; b=iK+LQbCTvr/WywKU6sJDOqhanBHHpazr3+kbtEPlOf7GtB87DqAor/LISiWAjXL/eTu3CvVYFmk04XadyvMLDYBh2qtd8jRWEQsUYuoWFWyGIyYcOgs2wntFiwVRexZ+b9YLtc9X8cp17i1jwmVgwDb66WWH2QRroibBlXCLZno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787890913; c=relaxed/simple;
	bh=lAHb/M1zxR1oBvFUoUyoN4NBLvBvctLfG4GqVGSLe94=;
	h=Date:To:From:Subject:Message-Id; b=lt2Cv4RyKVIC/OS7T7IVkCChiXHrQID3NLYvDLxMs+uMjLBogCC9KdKGXKq3jHD6MPNkAfAzqMIm+9/GK7Mh+yo8CsA6sI0/cEIP8D7rH1Ktr0eZRiw7CUjxrD9MNzLXHwbet7Jdd8U26243lh1IbLS4SszW8pEyYOV/a1axGb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W3bopVoF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W3bopVoF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD7E1F000E9;
	Fri, 28 Aug 2026 04:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787890911;
	bh=6P656BXAPs+x86xqhI7OWTkXx3OOOWIkEpnQXyGjbl0=;
	h=Date:To:From:Subject;
	b=W3bopVoFTdcg0AfV4X3Zl5SemmQZ62huyHEv9skkshp/kSBuWN43D5y1G5P98cRuj
	 wvavcDxAd7pAkxpPJ0hXWHP0oi1sSfps4AFHiG0d+UQJfx5PVENLhl9NGMGx1e4ghM
	 H4ZYS98P/bHaJdZICwJh2yHhB5Y0V9O4zuwu6cnw=
Date: Thu, 27 Aug 2026 21:21:51 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-remove-huge_bootmem_cma.patch added to mm-new branch
Message-Id: <20260828042151.9CD7E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: remove HUGE_BOOTMEM_CMA
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-remove-huge_bootmem_cma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-remove-huge_bootmem_cma.patch

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
Subject: mm/hugetlb: remove HUGE_BOOTMEM_CMA
Date: Tue, 25 Aug 2026 16:46:06 +0800

Track early CMA hugetlb pages from the hstate instead of storing a
redundant bootmem flag.  This removes the unused helper and keeps the
bootmem metadata minimal.

Link: https://lore.kernel.org/20260825084608.47437-16-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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

 include/linux/hugetlb.h |    1 -
 mm/hugetlb.c            |   14 ++++----------
 2 files changed, 4 insertions(+), 11 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-remove-huge_bootmem_cma
+++ a/include/linux/hugetlb.h
@@ -676,7 +676,6 @@ struct hstate {
 };
 
 #define HUGE_BOOTMEM_ZONES_VALID	BIT(0)
-#define HUGE_BOOTMEM_CMA		BIT(1)
 
 int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
--- a/mm/hugetlb.c~mm-hugetlb-remove-huge_bootmem_cma
+++ a/mm/hugetlb.c
@@ -3124,7 +3124,7 @@ static bool __init alloc_bootmem_huge_pa
 	 */
 	INIT_LIST_HEAD(&m->list);
 	m->hstate = h;
-	m->flags = hugetlb_early_cma(h) ? HUGE_BOOTMEM_CMA : 0;
+	m->flags = 0;
 
 	/* CMA pages: zone-crossing is validated in hugetlb_cma_reserve(). */
 	if (!hugetlb_early_cma(h) &&
@@ -3200,11 +3200,6 @@ static void __init hugetlb_folio_init_vm
 	prep_compound_head(&folio->page, huge_page_order(h));
 }
 
-static bool __init hugetlb_bootmem_page_earlycma(struct huge_bootmem_page *m)
-{
-	return m->flags & HUGE_BOOTMEM_CMA;
-}
-
 /*
  * memblock-allocated pageblocks might not have the migrate type set
  * if marked with the 'noinit' flag. Set it to the default (MIGRATE_MOVABLE)
@@ -3295,9 +3290,6 @@ static void __init gather_bootmem_preall
 			folio_set_hugetlb_vmemmap_optimized(folio);
 		section_set_order_range(folio_pfn(folio), folio_nr_pages(folio), 0);
 
-		if (hugetlb_bootmem_page_earlycma(m))
-			folio_set_hugetlb_cma(folio);
-
 		list_add(&folio->lru, &folio_list);
 
 		/*
@@ -3308,7 +3300,9 @@ static void __init gather_bootmem_preall
 		 * For CMA pages, this is done in init_cma_pageblock
 		 * (via hugetlb_bootmem_init_migratetype), so skip it here.
 		 */
-		if (!folio_test_hugetlb_cma(folio))
+		if (hugetlb_early_cma(h))
+			folio_set_hugetlb_cma(folio);
+		else
 			adjust_managed_page_count(page, pages_per_huge_page(h));
 		cond_resched();
 	}
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

