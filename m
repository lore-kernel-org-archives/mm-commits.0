Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2F0A953
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 20:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723579985; cv=none; b=mMAUKN5TdEVnb3Slurz5br8S5W7x+JvRmWgXyc0SNZrdQXktlNELZZeR9QAMC7A3coji3mmuhgiyTu+MSd5xAM15UJC8mtKEfBqzisTjOOaE6RXGLedaIcTVqemXObWVPL/6Dsl8SCUuwZ87jRBr8OjN0W3NQmgrfSkXJjjnuh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723579985; c=relaxed/simple;
	bh=y3Z6+y2l0Id0LHX/Lk4X2TOLvbpHNnbIL5ijaFx7m84=;
	h=Date:To:From:Subject:Message-Id; b=cnz6Zn4qg2EYMQ0F+nqDGPOYEg/R1Fk4h7BCnFkZ42u4CafNelsHnQoYHoEk+6Va830cAwqgN8qyb3wTeKwP2xL6HRXyQXbeh+6go8IHqK+qoeUbfyUCzZl4DQ8A6bS3+RyDuL+qZV2NP/Yj37bSvftSMU5UNFu6Te6hCahHGJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YJji5dch; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YJji5dch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD705C32782;
	Tue, 13 Aug 2024 20:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723579984;
	bh=y3Z6+y2l0Id0LHX/Lk4X2TOLvbpHNnbIL5ijaFx7m84=;
	h=Date:To:From:Subject:From;
	b=YJji5dch/wesNJfEMxhUijXahB6W1k1cWKwZOQWb5Z8xxgEHVrYIl0ejsVTJnxKnE
	 lTbm4cTRHMKIaA828tTCglBHC6Oed4SyRqcGIrlWH30riA8C8jKhd5Dxya/+IaHZhb
	 n3qMghJRmPZXkc48l7sy7AfjQBotG475af0QrzCw=
Date: Tue, 13 Aug 2024 13:13:04 -0700
To: mm-commits@vger.kernel.org,zhais@google.com,yuzhao@google.com,willy@infradead.org,shakeel.butt@linux.dev,ryan.roberts@arm.com,rppt@kernel.org,roman.gushchin@linux.dev,riel@surriel.com,hannes@cmpxchg.org,david@redhat.com,corbet@lwn.net,cerasuolodomenico@gmail.com,baohua@kernel.org,alexlzhu@fb.com,ak@linux.intel.com,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-a-pageflag-for-partially-mapped-folios.patch added to mm-unstable branch
Message-Id: <20240813201304.AD705C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce a pageflag for partially mapped folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-a-pageflag-for-partially-mapped-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-a-pageflag-for-partially-mapped-folios.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Usama Arif <usamaarif642@gmail.com>
Subject: mm: introduce a pageflag for partially mapped folios
Date: Tue, 13 Aug 2024 13:02:47 +0100

Currently folio->_deferred_list is used to keep track of partially_mapped
folios that are going to be split under memory pressure.  In the next
patch, all THPs that are faulted in and collapsed by khugepaged are also
going to be tracked using _deferred_list.

This patch introduces a pageflag to be able to distinguish between
partially mapped folios and others in the deferred_list at split time in
deferred_split_scan.  Its needed as __folio_remove_rmap decrements
_mapcount, _large_mapcount and _entire_mapcount, hence it won't be
possible to distinguish between partially mapped folios and others in
deferred_split_scan.

Eventhough it introduces an extra flag to track if the folio is partially
mapped, there is no functional change intended with this patch and the
flag is not useful in this patch itself, it will become useful in the next
patch when _deferred_list has non partially mapped folios.

Link: https://lkml.kernel.org/r/20240813120328.1275952-5-usamaarif642@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Cc: Alexander Zhu <alexlzhu@fb.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Shuang Zhai <zhais@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h    |    4 ++--
 include/linux/page-flags.h |    3 +++
 mm/huge_memory.c           |   21 +++++++++++++--------
 mm/hugetlb.c               |    1 +
 mm/internal.h              |    4 +++-
 mm/memcontrol.c            |    3 ++-
 mm/migrate.c               |    3 ++-
 mm/page_alloc.c            |    5 +++--
 mm/rmap.c                  |    3 ++-
 mm/vmscan.c                |    3 ++-
 10 files changed, 33 insertions(+), 17 deletions(-)

--- a/include/linux/huge_mm.h~mm-introduce-a-pageflag-for-partially-mapped-folios
+++ a/include/linux/huge_mm.h
@@ -321,7 +321,7 @@ static inline int split_huge_page(struct
 {
 	return split_huge_page_to_list_to_order(page, NULL, 0);
 }
-void deferred_split_folio(struct folio *folio);
+void deferred_split_folio(struct folio *folio, bool partially_mapped);
 
 void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long address, bool freeze, struct folio *folio);
@@ -495,7 +495,7 @@ static inline int split_huge_page(struct
 {
 	return 0;
 }
-static inline void deferred_split_folio(struct folio *folio) {}
+static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
 #define split_huge_pmd(__vma, __pmd, __address)	\
 	do { } while (0)
 
--- a/include/linux/page-flags.h~mm-introduce-a-pageflag-for-partially-mapped-folios
+++ a/include/linux/page-flags.h
@@ -182,6 +182,7 @@ enum pageflags {
 	/* At least one page in this folio has the hwpoison flag set */
 	PG_has_hwpoisoned = PG_active,
 	PG_large_rmappable = PG_workingset, /* anon or file-backed */
+	PG_partially_mapped, /* was identified to be partially mapped */
 };
 
 #define PAGEFLAGS_MASK		((1UL << NR_PAGEFLAGS) - 1)
@@ -861,8 +862,10 @@ static inline void ClearPageCompound(str
 	ClearPageHead(page);
 }
 FOLIO_FLAG(large_rmappable, FOLIO_SECOND_PAGE)
+FOLIO_FLAG(partially_mapped, FOLIO_SECOND_PAGE)
 #else
 FOLIO_FLAG_FALSE(large_rmappable)
+FOLIO_FLAG_FALSE(partially_mapped)
 #endif
 
 #define PG_head_mask ((1UL << PG_head))
--- a/mm/huge_memory.c~mm-introduce-a-pageflag-for-partially-mapped-folios
+++ a/mm/huge_memory.c
@@ -3390,6 +3390,7 @@ int split_huge_page_to_list_to_order(str
 			 * page_deferred_list.
 			 */
 			list_del_init(&folio->_deferred_list);
+			folio_clear_partially_mapped(folio);
 		}
 		spin_unlock(&ds_queue->split_queue_lock);
 		if (mapping) {
@@ -3446,11 +3447,12 @@ void __folio_undo_large_rmappable(struct
 	if (!list_empty(&folio->_deferred_list)) {
 		ds_queue->split_queue_len--;
 		list_del_init(&folio->_deferred_list);
+		folio_clear_partially_mapped(folio);
 	}
 	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
 }
 
-void deferred_split_folio(struct folio *folio)
+void deferred_split_folio(struct folio *folio, bool partially_mapped)
 {
 	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
 #ifdef CONFIG_MEMCG
@@ -3478,14 +3480,17 @@ void deferred_split_folio(struct folio *
 	if (folio_test_swapcache(folio))
 		return;
 
-	if (!list_empty(&folio->_deferred_list))
-		return;
-
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
+	if (partially_mapped)
+		folio_set_partially_mapped(folio);
+	else
+		folio_clear_partially_mapped(folio);
 	if (list_empty(&folio->_deferred_list)) {
-		if (folio_test_pmd_mappable(folio))
-			count_vm_event(THP_DEFERRED_SPLIT_PAGE);
-		count_mthp_stat(folio_order(folio), MTHP_STAT_SPLIT_DEFERRED);
+		if (partially_mapped) {
+			if (folio_test_pmd_mappable(folio))
+				count_vm_event(THP_DEFERRED_SPLIT_PAGE);
+			count_mthp_stat(folio_order(folio), MTHP_STAT_SPLIT_DEFERRED);
+		}
 		list_add_tail(&folio->_deferred_list, &ds_queue->split_queue);
 		ds_queue->split_queue_len++;
 #ifdef CONFIG_MEMCG
@@ -3534,6 +3539,7 @@ static unsigned long deferred_split_scan
 		} else {
 			/* We lost race with folio_put() */
 			list_del_init(&folio->_deferred_list);
+			folio_clear_partially_mapped(folio);
 			ds_queue->split_queue_len--;
 		}
 		if (!--sc->nr_to_scan)
@@ -3551,7 +3557,6 @@ static unsigned long deferred_split_scan
 next:
 		folio_put(folio);
 	}
-
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
 	list_splice_tail(&list, &ds_queue->split_queue);
 	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
--- a/mm/hugetlb.c~mm-introduce-a-pageflag-for-partially-mapped-folios
+++ a/mm/hugetlb.c
@@ -1758,6 +1758,7 @@ static void __update_and_free_hugetlb_fo
 		free_gigantic_folio(folio, huge_page_order(h));
 	} else {
 		INIT_LIST_HEAD(&folio->_deferred_list);
+		folio_clear_partially_mapped(folio);
 		folio_put(folio);
 	}
 }
--- a/mm/internal.h~mm-introduce-a-pageflag-for-partially-mapped-folios
+++ a/mm/internal.h
@@ -662,8 +662,10 @@ static inline void prep_compound_head(st
 	atomic_set(&folio->_entire_mapcount, -1);
 	atomic_set(&folio->_nr_pages_mapped, 0);
 	atomic_set(&folio->_pincount, 0);
-	if (order > 1)
+	if (order > 1) {
 		INIT_LIST_HEAD(&folio->_deferred_list);
+		folio_clear_partially_mapped(folio);
+	}
 }
 
 static inline void prep_compound_tail(struct page *head, int tail_idx)
--- a/mm/memcontrol.c~mm-introduce-a-pageflag-for-partially-mapped-folios
+++ a/mm/memcontrol.c
@@ -4649,7 +4649,8 @@ static void uncharge_folio(struct folio
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 	VM_BUG_ON_FOLIO(folio_order(folio) > 1 &&
 			!folio_test_hugetlb(folio) &&
-			!list_empty(&folio->_deferred_list), folio);
+			!list_empty(&folio->_deferred_list) &&
+			folio_test_partially_mapped(folio), folio);
 
 	/*
 	 * Nobody should be changing or seriously looking at
--- a/mm/migrate.c~mm-introduce-a-pageflag-for-partially-mapped-folios
+++ a/mm/migrate.c
@@ -1734,7 +1734,8 @@ static int migrate_pages_batch(struct li
 			 * use _deferred_list.
 			 */
 			if (nr_pages > 2 &&
-			   !list_empty(&folio->_deferred_list)) {
+			   !list_empty(&folio->_deferred_list) &&
+			   folio_test_partially_mapped(folio)) {
 				if (!try_split_folio(folio, split_folios, mode)) {
 					nr_failed++;
 					stats->nr_thp_failed += is_thp;
--- a/mm/page_alloc.c~mm-introduce-a-pageflag-for-partially-mapped-folios
+++ a/mm/page_alloc.c
@@ -962,8 +962,9 @@ static int free_tail_page_prepare(struct
 		break;
 	case 2:
 		/* the second tail page: deferred_list overlaps ->mapping */
-		if (unlikely(!list_empty(&folio->_deferred_list))) {
-			bad_page(page, "on deferred list");
+		if (unlikely(!list_empty(&folio->_deferred_list) &&
+		    folio_test_partially_mapped(folio))) {
+			bad_page(page, "partially mapped folio on deferred list");
 			goto out;
 		}
 		break;
--- a/mm/rmap.c~mm-introduce-a-pageflag-for-partially-mapped-folios
+++ a/mm/rmap.c
@@ -1579,7 +1579,8 @@ static __always_inline void __folio_remo
 	 */
 	if (partially_mapped && folio_test_anon(folio) &&
 	    list_empty(&folio->_deferred_list))
-		deferred_split_folio(folio);
+		deferred_split_folio(folio, true);
+
 	__folio_mod_stat(folio, -nr, -nr_pmdmapped);
 
 	/*
--- a/mm/vmscan.c~mm-introduce-a-pageflag-for-partially-mapped-folios
+++ a/mm/vmscan.c
@@ -1233,7 +1233,8 @@ retry:
 					 * Split partially mapped folios right away.
 					 * We can free the unmapped pages without IO.
 					 */
-					if (data_race(!list_empty(&folio->_deferred_list)) &&
+					if (data_race(!list_empty(&folio->_deferred_list) &&
+					    folio_test_partially_mapped(folio)) &&
 					    split_folio_to_list(folio, folio_list))
 						goto activate_locked;
 				}
_

Patches currently in -mm which might be from usamaarif642@gmail.com are

mm-introduce-a-pageflag-for-partially-mapped-folios.patch
mm-split-underutilized-thps.patch
mm-add-sysfs-entry-to-disable-splitting-underutilized-thps.patch

