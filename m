Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7FF0296BAF
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334172; cv=none; b=htOzENVG4nFVM1KBVXB6NeG0IwGsRNa0VPXFM1E98OI2GCUaBoy+J8kZGpZ/lxJN69K4xHLusWZKkfijq9ALAST6bh1XfjG9J8HUpPJ0JRvQesySM7q/UYNiSg1o/JGTyG6cYBK7LVrqvOL59Nn5wyR9JHbEYfcTrKKCaxU5Sd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334172; c=relaxed/simple;
	bh=wf8sfKkROnfcIWi/xjvXeQm/nOUYpmNKBkAbvuMPLjI=;
	h=Date:To:From:Subject:Message-Id; b=UV5WJeWNv19ROqg3ZCifXCFqMhsuG4g5AJkAEK3TxpIu8g59RqMAh4IqA+iqxgwbdFAQ2KB539uBxUJ8ouJZ4cEz8oGkhc8LShmxEuj6cb9BG4LReUQihfdO/Zxw1hSHKi6uBEmXdrOtLzvEUHifWf2j5wdCc05blvAg4OIg+Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kUbTX0vI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kUbTX0vI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8101F0089B;
	Wed,  7 Oct 2026 00:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334170;
	bh=o7cGLQdiWZ3h3aMuUEAbWspmSlqUsSZ+kKBj07+4kiE=;
	h=Date:To:From:Subject;
	b=kUbTX0vIJGMafR19GAwVMFVv/EAlu3JdLwqDCAeGPKFl8/KJfViDdaKp4BYiYnAZX
	 Cj1WcDzZKKahIxuPz2FckcwuGUmmtUEaNsHjZalr2FHjsEZvEHL3eMMO+pEv28/7kx
	 IqGK9jBfclVDCpLCTPAXBdoj9AxUEDh2PyOA/rik=
Date: Tue, 06 Oct 2026 17:49:30 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,qi.zheng@linux.dev,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david.laight.linux@gmail.com,david@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-remove-huge_bootmem_cma.patch removed from -mm tree
Message-Id: <20261007004930.BB8101F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: remove HUGE_BOOTMEM_CMA
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-remove-huge_bootmem_cma.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/hugetlb: remove HUGE_BOOTMEM_CMA
Date: Thu, 10 Sep 2026 14:32:54 +0800

Track early CMA hugetlb pages from the hstate instead of storing a
redundant bootmem flag.  This removes the unused helper and keeps the
bootmem metadata minimal.

Link: https://lore.kernel.org/20260910063256.64386-16-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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
@@ -3133,7 +3133,7 @@ static bool __init alloc_bootmem_huge_pa
 	 */
 	INIT_LIST_HEAD(&m->list);
 	m->hstate = h;
-	m->flags = hugetlb_early_cma(h) ? HUGE_BOOTMEM_CMA : 0;
+	m->flags = 0;
 
 	/* CMA pages: zone-crossing is validated in hugetlb_cma_reserve(). */
 	if (!hugetlb_early_cma(h) &&
@@ -3209,11 +3209,6 @@ static void __init hugetlb_folio_init_vm
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
@@ -3305,9 +3300,6 @@ static void __init gather_bootmem_preall
 			folio_set_hugetlb_vmemmap_optimized(folio);
 		section_set_compound_order_range(pfn, folio_nr_pages(folio), 0);
 
-		if (hugetlb_bootmem_page_earlycma(m))
-			folio_set_hugetlb_cma(folio);
-
 		list_add(&folio->lru, &folio_list);
 
 		/*
@@ -3318,7 +3310,9 @@ static void __init gather_bootmem_preall
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


