Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3B937F33A
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 23:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789081258; cv=none; b=fknDt99PD7Q3BZE3prsGKr+mt/1kBq883baszx0R76CdncVNPj6YlHs+zxgH+lVaaUWnHTyw1kEQHwzfo9+dcRey0IQB+DIMbeGuN/shmtpWjZURJY649aTn9XLp1s7Gf2kSG7yuBETuQVxCi1f6cLH4uj0ncOhARh4/P+8dAs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789081258; c=relaxed/simple;
	bh=uI96E5hvhegPoYN4uD5/aBHK1Hzfy7EIsR+JqXK2DVg=;
	h=Date:To:From:Subject:Message-Id; b=HwZbYjs5dC/JWvx7tSdUG6db9QWOsVOSQCVU/87kR3hEnwz54o9l96aK49GhMxxo6k7ggNGfju6JHDYP4+pCqrMJoaH+DVP6Gqq/IYS11sylOvV41gCPr+GGHiJFC8qBuMaoaqwoeuMGKIfEQEL8l8XWsJ+TpW9UIZl+6wpZX/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wU2I9yWy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wU2I9yWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343851F00893;
	Thu, 10 Sep 2026 23:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789081257;
	bh=Ip7jTSCH4NJMy5lhshw7rfLXSMSBcRbIIMqk1OpjEzk=;
	h=Date:To:From:Subject;
	b=wU2I9yWy3B9LRPQkU5TiWNvgWhA+MbgvpdM2vNups/biePoyHaJXKN4aKeUcwaeWM
	 l/0tblIyLSElGF0/fIuw2W9oHPwQVe08DdvgJL/ZhUN1xdLvfIRnzQeDvMvniAISQb
	 5avqzlB8qwChQqNzYMMF9Zau+T42ByWIH0vWq25c=
Date: Thu, 10 Sep 2026 16:00:56 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb-remove-huge_bootmem_cma.patch removed from -mm tree
Message-Id: <20260910230057.343851F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: remove HUGE_BOOTMEM_CMA
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-remove-huge_bootmem_cma.patch

This patch was dropped because an updated version will be issued

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
@@ -3144,7 +3144,7 @@ static bool __init alloc_bootmem_huge_pa
 	 */
 	INIT_LIST_HEAD(&m->list);
 	m->hstate = h;
-	m->flags = hugetlb_early_cma(h) ? HUGE_BOOTMEM_CMA : 0;
+	m->flags = 0;
 
 	/* CMA pages: zone-crossing is validated in hugetlb_cma_reserve(). */
 	if (!hugetlb_early_cma(h) &&
@@ -3220,11 +3220,6 @@ static void __init hugetlb_folio_init_vm
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
@@ -3315,9 +3310,6 @@ static void __init gather_bootmem_preall
 			folio_set_hugetlb_vmemmap_optimized(folio);
 		section_set_order_range(folio_pfn(folio), folio_nr_pages(folio), 0);
 
-		if (hugetlb_bootmem_page_earlycma(m))
-			folio_set_hugetlb_cma(folio);
-
 		list_add(&folio->lru, &folio_list);
 
 		/*
@@ -3328,7 +3320,9 @@ static void __init gather_bootmem_preall
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

