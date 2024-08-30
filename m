Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B5F1C230B
	for <mm-commits@vger.kernel.org>; Fri, 30 Aug 2024 22:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725057435; cv=none; b=AJXUmLxTiywtok3sp745U6DJLy+MkRMV7sBWQLSdF5OBlhfkoAgmBpIS7yCSK2iqHGoEuRLxotOPu3SavbbJHW8A8h6VgpHL6Kvoxp87OCt6zkT3cgaadjV4F1QMXxbJ+Eiqt0ronVW6hdinnpO5tGiJRi5suHg6SrXpBWIlAGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725057435; c=relaxed/simple;
	bh=uMFd+k6YMM7utmVPNsfVPUTtOf7JrISqUUKB/EZyl3o=;
	h=Date:To:From:Subject:Message-Id; b=s1hfPR06nnIfmvfAqq0shvskuL1RJSaUENjkU9WSuPYYl4ksKfYPc9PpwXDuuqj7sNyM3mT8Gn0yhsaaTYnPgoctLPRqOw4aOBrSx4K6eymvtiTPqZe3aEvIvf8n97M1eDMwSPBXjrX38D+0bV+n38DpLnNiLNm7kKnxjtF2fpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kMqOXqHd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kMqOXqHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87407C4CEC2;
	Fri, 30 Aug 2024 22:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725057434;
	bh=uMFd+k6YMM7utmVPNsfVPUTtOf7JrISqUUKB/EZyl3o=;
	h=Date:To:From:Subject:From;
	b=kMqOXqHduHnE5z6MokiFqUrTUJjpXY+ogLCtPhZDYf2Mhe2TJeGeO01/o1NPMfa3G
	 mg2QEHKkYVFejm4vkm8aljoCaaDi3vRBMMK4ErX7korWvXW7HfjQ0C+79B27Pov21D
	 ZtrNXnvxiG6c7M2JeNPv4FoaTvut+r/U9U3Ctkt8=
Date: Fri, 30 Aug 2024 15:37:14 -0700
To: mm-commits@vger.kernel.org,zhais@google.com,yuzhao@google.com,willy@infradead.org,shakeel.butt@linux.dev,ryncsn@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,roman.gushchin@linux.dev,riel@surriel.com,npache@redhat.com,hannes@cmpxchg.org,david@redhat.com,corbet@lwn.net,cerasuolodomenico@gmail.com,baohua@kernel.org,alexlzhu@fb.com,usamaarif642@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-a-pageflag-for-partially-mapped-folios.patch added to mm-unstable branch
Message-Id: <20240830223714.87407C4CEC2@smtp.kernel.org>
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
Date: Fri, 30 Aug 2024 11:03:38 +0100

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

Link: https://lkml.kernel.org/r/20240830100438.3623486-5-usamaarif642@gmail.com
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Cc: Alexander Zhu <alexlzhu@fb.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Shuang Zhai <zhais@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h    |    4 +--
 include/linux/page-flags.h |   13 ++++++++++-
 mm/huge_memory.c           |   41 +++++++++++++++++++++++++----------
 mm/memcontrol.c            |    3 +-
 mm/migrate.c               |    3 +-
 mm/page_alloc.c            |    5 ++--
 mm/rmap.c                  |    5 ++--
 mm/vmscan.c                |    3 +-
 8 files changed, 56 insertions(+), 21 deletions(-)

--- a/include/linux/huge_mm.h~mm-introduce-a-pageflag-for-partially-mapped-folios
+++ a/include/linux/huge_mm.h
@@ -333,7 +333,7 @@ static inline int split_huge_page(struct
 {
 	return split_huge_page_to_list_to_order(page, NULL, 0);
 }
-void deferred_split_folio(struct folio *folio);
+void deferred_split_folio(struct folio *folio, bool partially_mapped);
 
 void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long address, bool freeze, struct folio *folio);
@@ -502,7 +502,7 @@ static inline int split_huge_page(struct
 {
 	return 0;
 }
-static inline void deferred_split_folio(struct folio *folio) {}
+static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
 #define split_huge_pmd(__vma, __pmd, __address)	\
 	do { } while (0)
 
--- a/include/linux/page-flags.h~mm-introduce-a-pageflag-for-partially-mapped-folios
+++ a/include/linux/page-flags.h
@@ -186,6 +186,7 @@ enum pageflags {
 	/* At least one page in this folio has the hwpoison flag set */
 	PG_has_hwpoisoned = PG_active,
 	PG_large_rmappable = PG_workingset, /* anon or file-backed */
+	PG_partially_mapped = PG_reclaim, /* was identified to be partially mapped */
 };
 
 #define PAGEFLAGS_MASK		((1UL << NR_PAGEFLAGS) - 1)
@@ -859,8 +860,18 @@ static inline void ClearPageCompound(str
 	ClearPageHead(page);
 }
 FOLIO_FLAG(large_rmappable, FOLIO_SECOND_PAGE)
+FOLIO_TEST_FLAG(partially_mapped, FOLIO_SECOND_PAGE)
+/*
+ * PG_partially_mapped is protected by deferred_split split_queue_lock,
+ * so its safe to use non-atomic set/clear.
+ */
+__FOLIO_SET_FLAG(partially_mapped, FOLIO_SECOND_PAGE)
+__FOLIO_CLEAR_FLAG(partially_mapped, FOLIO_SECOND_PAGE)
 #else
 FOLIO_FLAG_FALSE(large_rmappable)
+FOLIO_TEST_FLAG_FALSE(partially_mapped)
+__FOLIO_SET_FLAG_NOOP(partially_mapped)
+__FOLIO_CLEAR_FLAG_NOOP(partially_mapped)
 #endif
 
 #define PG_head_mask ((1UL << PG_head))
@@ -1171,7 +1182,7 @@ static __always_inline void __ClearPageA
  */
 #define PAGE_FLAGS_SECOND						\
 	(0xffUL /* order */		| 1UL << PG_has_hwpoisoned |	\
-	 1UL << PG_large_rmappable)
+	 1UL << PG_large_rmappable	| 1UL << PG_partially_mapped)
 
 #define PAGE_FLAGS_PRIVATE				\
 	(1UL << PG_private | 1UL << PG_private_2)
--- a/mm/huge_memory.c~mm-introduce-a-pageflag-for-partially-mapped-folios
+++ a/mm/huge_memory.c
@@ -3503,7 +3503,11 @@ int split_huge_page_to_list_to_order(str
 		if (folio_order(folio) > 1 &&
 		    !list_empty(&folio->_deferred_list)) {
 			ds_queue->split_queue_len--;
-			mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
+			if (folio_test_partially_mapped(folio)) {
+				__folio_clear_partially_mapped(folio);
+				mod_mthp_stat(folio_order(folio),
+					      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
+			}
 			/*
 			 * Reinitialize page_deferred_list after removing the
 			 * page from the split_queue, otherwise a subsequent
@@ -3570,13 +3574,18 @@ void __folio_undo_large_rmappable(struct
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
 	if (!list_empty(&folio->_deferred_list)) {
 		ds_queue->split_queue_len--;
-		mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
+		if (folio_test_partially_mapped(folio)) {
+			__folio_clear_partially_mapped(folio);
+			mod_mthp_stat(folio_order(folio),
+				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
+		}
 		list_del_init(&folio->_deferred_list);
 	}
 	spin_unlock_irqrestore(&ds_queue->split_queue_lock, flags);
 }
 
-void deferred_split_folio(struct folio *folio)
+/* partially_mapped=false won't clear PG_partially_mapped folio flag */
+void deferred_split_folio(struct folio *folio, bool partially_mapped)
 {
 	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
 #ifdef CONFIG_MEMCG
@@ -3604,15 +3613,21 @@ void deferred_split_folio(struct folio *
 	if (folio_test_swapcache(folio))
 		return;
 
-	if (!list_empty(&folio->_deferred_list))
-		return;
-
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
+	if (partially_mapped) {
+		if (!folio_test_partially_mapped(folio)) {
+			__folio_set_partially_mapped(folio);
+			if (folio_test_pmd_mappable(folio))
+				count_vm_event(THP_DEFERRED_SPLIT_PAGE);
+			count_mthp_stat(folio_order(folio), MTHP_STAT_SPLIT_DEFERRED);
+			mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, 1);
+
+		}
+	} else {
+		/* partially mapped folios cannot become non-partially mapped */
+		VM_WARN_ON_FOLIO(folio_test_partially_mapped(folio), folio);
+	}
 	if (list_empty(&folio->_deferred_list)) {
-		if (folio_test_pmd_mappable(folio))
-			count_vm_event(THP_DEFERRED_SPLIT_PAGE);
-		count_mthp_stat(folio_order(folio), MTHP_STAT_SPLIT_DEFERRED);
-		mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, 1);
 		list_add_tail(&folio->_deferred_list, &ds_queue->split_queue);
 		ds_queue->split_queue_len++;
 #ifdef CONFIG_MEMCG
@@ -3660,7 +3675,11 @@ static unsigned long deferred_split_scan
 			list_move(&folio->_deferred_list, &list);
 		} else {
 			/* We lost race with folio_put() */
-			mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
+			if (folio_test_partially_mapped(folio)) {
+				__folio_clear_partially_mapped(folio);
+				mod_mthp_stat(folio_order(folio),
+					      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
+			}
 			list_del_init(&folio->_deferred_list);
 			ds_queue->split_queue_len--;
 		}
--- a/mm/memcontrol.c~mm-introduce-a-pageflag-for-partially-mapped-folios
+++ a/mm/memcontrol.c
@@ -4630,7 +4630,8 @@ static void uncharge_folio(struct folio
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
@@ -1766,7 +1766,8 @@ static int migrate_pages_batch(struct li
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
@@ -1579,8 +1579,9 @@ static __always_inline void __folio_remo
 	 * Check partially_mapped first to ensure it is a large folio.
 	 */
 	if (partially_mapped && folio_test_anon(folio) &&
-	    list_empty(&folio->_deferred_list))
-		deferred_split_folio(folio);
+	    !folio_test_partially_mapped(folio))
+		deferred_split_folio(folio, true);
+
 	__folio_mod_stat(folio, -nr, -nr_pmdmapped);
 
 	/*
--- a/mm/vmscan.c~mm-introduce-a-pageflag-for-partially-mapped-folios
+++ a/mm/vmscan.c
@@ -1238,7 +1238,8 @@ retry:
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

revert-mm-skip-cma-pages-when-they-are-not-available.patch
revert-mm-skip-cma-pages-when-they-are-not-available-update.patch
mm-store-zero-pages-to-be-swapped-out-in-a-bitmap.patch
mm-remove-code-to-handle-same-filled-pages.patch
mm-introduce-a-pageflag-for-partially-mapped-folios.patch
mm-split-underused-thps.patch
mm-add-sysfs-entry-to-disable-splitting-underused-thps.patch

