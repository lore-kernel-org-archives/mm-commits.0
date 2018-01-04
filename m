From: akpm@linux-foundation.org
Subject: + mm-unclutter-thp-migration.patch added to -mm tree
Date: Wed, 03 Jan 2018 16:04:52 -0800
Message-ID: <5a4d6fa4.u8OgLpCZZ+7NfZId%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36064 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751014AbeADAEy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jan 2018 19:04:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, ar@linux.vnet.ibm.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, vbabka@suse.cz, zi.yan@cs.rutgers.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: unclutter THP migration
has been added to the -mm tree.  Its filename is
     mm-unclutter-thp-migration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-unclutter-thp-migration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-unclutter-thp-migration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm: unclutter THP migration

THP migration is hacked into the generic migration with rather surprising
semantic.  The migration allocation callback is supposed to check whether
the THP can be migrated at once and if that is not the case then it
allocates a simple page to migrate.  unmap_and_move then fixes that up by
spliting the THP into small pages while moving the head page to the newly
allocated order-0 page.  Remaning pages are moved to the LRU list by
split_huge_page.  The same happens if the THP allocation fails.  This is
really ugly and error prone [1].

I also believe that split_huge_page to the LRU lists is inherently wrong
because all tail pages are not migrated.  Some callers will just work
around that by retrying (e.g.  memory hotplug).  There are other pfn
walkers which are simply broken though.  e.g.  madvise_inject_error will
migrate head and then advances next pfn by the huge page size. 
do_move_page_to_node_array, queue_pages_range (migrate_pages, mbind), will
simply split the THP before migration if the THP migration is not
supported then falls back to single page migration but it doesn't handle
tail pages if the THP migration path is not able to allocate a fresh THP
so we end up with ENOMEM and fail the whole migration which is a
questionable behavior.  Page compaction doesn't try to migrate large pages
so it should be immune.

This patch tries to unclutter the situation by moving the special THP
handling up to the migrate_pages layer where it actually belongs.  We
simply split the THP page into the existing list if unmap_and_move fails
with ENOMEM and retry.  So we will _always_ migrate all THP subpages and
specific migrate_pages users do not have to deal with this case in a
special way.

[1] http://lkml.kernel.org/r/20171121021855.50525-1-zi.yan@sent.com

Link: http://lkml.kernel.org/r/20180103082555.14592-4-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Zi Yan <zi.yan@cs.rutgers.edu>
Cc: Andrea Reale <ar@linux.vnet.ibm.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    4 ++--
 mm/huge_memory.c        |    6 ++++++
 mm/memory_hotplug.c     |    2 +-
 mm/mempolicy.c          |   31 +++----------------------------
 mm/migrate.c            |   34 ++++++++++++++++++++++++----------
 5 files changed, 36 insertions(+), 41 deletions(-)

diff -puN include/linux/migrate.h~mm-unclutter-thp-migration include/linux/migrate.h
--- a/include/linux/migrate.h~mm-unclutter-thp-migration
+++ a/include/linux/migrate.h
@@ -42,9 +42,9 @@ static inline struct page *new_page_node
 		return alloc_huge_page_nodemask(page_hstate(compound_head(page)),
 				preferred_nid, nodemask);
 
-	if (thp_migration_supported() && PageTransHuge(page)) {
-		order = HPAGE_PMD_ORDER;
+	if (PageTransHuge(page)) {
 		gfp_mask |= GFP_TRANSHUGE;
+		order = HPAGE_PMD_ORDER;
 	}
 
 	if (PageHighMem(page) || (zone_idx(page_zone(page)) == ZONE_MOVABLE))
diff -puN mm/huge_memory.c~mm-unclutter-thp-migration mm/huge_memory.c
--- a/mm/huge_memory.c~mm-unclutter-thp-migration
+++ a/mm/huge_memory.c
@@ -2407,6 +2407,12 @@ static void __split_huge_page_tail(struc
 
 	page_tail->index = head->index + tail;
 	page_cpupid_xchg_last(page_tail, page_cpupid_last(head));
+
+	/*
+	 * always add to the tail because some iterators expect new
+	 * pages to show after the currently processed elements - e.g.
+	 * migrate_pages
+	 */
 	lru_add_page_tail(head, page_tail, lruvec, list);
 }
 
diff -puN mm/memory_hotplug.c~mm-unclutter-thp-migration mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-unclutter-thp-migration
+++ a/mm/memory_hotplug.c
@@ -1387,7 +1387,7 @@ do_migrate_range(unsigned long start_pfn
 			if (isolate_huge_page(page, &source))
 				move_pages -= 1 << compound_order(head);
 			continue;
-		} else if (thp_migration_supported() && PageTransHuge(page))
+		} else if (PageTransHuge(page))
 			pfn = page_to_pfn(compound_head(page))
 				+ hpage_nr_pages(page) - 1;
 
diff -puN mm/mempolicy.c~mm-unclutter-thp-migration mm/mempolicy.c
--- a/mm/mempolicy.c~mm-unclutter-thp-migration
+++ a/mm/mempolicy.c
@@ -446,15 +446,6 @@ static int queue_pages_pmd(pmd_t *pmd, s
 		__split_huge_pmd(walk->vma, pmd, addr, false, NULL);
 		goto out;
 	}
-	if (!thp_migration_supported()) {
-		get_page(page);
-		spin_unlock(ptl);
-		lock_page(page);
-		ret = split_huge_page(page);
-		unlock_page(page);
-		put_page(page);
-		goto out;
-	}
 	if (!queue_pages_required(page, qp)) {
 		ret = 1;
 		goto unlock;
@@ -495,7 +486,7 @@ static int queue_pages_pte_range(pmd_t *
 
 	if (pmd_trans_unstable(pmd))
 		return 0;
-retry:
+
 	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
 		if (!pte_present(*pte))
@@ -511,22 +502,6 @@ retry:
 			continue;
 		if (!queue_pages_required(page, qp))
 			continue;
-		if (PageTransCompound(page) && !thp_migration_supported()) {
-			get_page(page);
-			pte_unmap_unlock(pte, ptl);
-			lock_page(page);
-			ret = split_huge_page(page);
-			unlock_page(page);
-			put_page(page);
-			/* Failed to split -- skip. */
-			if (ret) {
-				pte = pte_offset_map_lock(walk->mm, pmd,
-						addr, &ptl);
-				continue;
-			}
-			goto retry;
-		}
-
 		migrate_page_add(page, qp->pagelist, flags);
 	}
 	pte_unmap_unlock(pte - 1, ptl);
@@ -948,7 +923,7 @@ struct page *alloc_new_node_page(struct
 	if (PageHuge(page))
 		return alloc_huge_page_node(page_hstate(compound_head(page)),
 					node);
-	else if (thp_migration_supported() && PageTransHuge(page)) {
+	else if (PageTransHuge(page)) {
 		struct page *thp;
 
 		thp = alloc_pages_node(node,
@@ -1124,7 +1099,7 @@ static struct page *new_page(struct page
 	if (PageHuge(page)) {
 		BUG_ON(!vma);
 		return alloc_huge_page_noerr(vma, address, 1);
-	} else if (thp_migration_supported() && PageTransHuge(page)) {
+	} else if (PageTransHuge(page)) {
 		struct page *thp;
 
 		thp = alloc_hugepage_vma(GFP_TRANSHUGE, vma, address,
diff -puN mm/migrate.c~mm-unclutter-thp-migration mm/migrate.c
--- a/mm/migrate.c~mm-unclutter-thp-migration
+++ a/mm/migrate.c
@@ -1138,6 +1138,9 @@ static ICE_noinline int unmap_and_move(n
 	int rc = MIGRATEPAGE_SUCCESS;
 	struct page *newpage;
 
+	if (!thp_migration_supported() && PageTransHuge(page))
+		return -ENOMEM;
+
 	newpage = get_new_page(page, private);
 	if (!newpage)
 		return -ENOMEM;
@@ -1159,14 +1162,6 @@ static ICE_noinline int unmap_and_move(n
 		goto out;
 	}
 
-	if (unlikely(PageTransHuge(page) && !PageTransHuge(newpage))) {
-		lock_page(page);
-		rc = split_huge_page(page);
-		unlock_page(page);
-		if (rc)
-			goto out;
-	}
-
 	rc = __unmap_and_move(page, newpage, force, mode);
 	if (rc == MIGRATEPAGE_SUCCESS)
 		set_page_owner_migrate_reason(newpage, reason);
@@ -1381,6 +1376,7 @@ int migrate_pages(struct list_head *from
 		retry = 0;
 
 		list_for_each_entry_safe(page, page2, from, lru) {
+retry:
 			cond_resched();
 
 			if (PageHuge(page))
@@ -1394,6 +1390,26 @@ int migrate_pages(struct list_head *from
 
 			switch(rc) {
 			case -ENOMEM:
+				/*
+				 * THP migration might be unsupported or the
+				 * allocation could've failed so we should
+				 * retry on the same page with the THP split
+				 * to base pages.
+				 *
+				 * Head page is retried immediately and tail
+				 * pages are added to the tail of the list so
+				 * we encounter them after the rest of the list
+				 * is processed.
+				 */
+				if (PageTransHuge(page)) {
+					lock_page(page);
+					rc = split_huge_page_to_list(page, from);
+					unlock_page(page);
+					if (!rc) {
+						list_safe_reset_next(page, page2, lru);
+						goto retry;
+					}
+				}
 				nr_failed++;
 				goto out;
 			case -EAGAIN:
@@ -1480,8 +1496,6 @@ static int add_page_for_migration(struct
 
 	/* FOLL_DUMP to ignore special (like zero) pages */
 	follflags = FOLL_GET | FOLL_DUMP;
-	if (!thp_migration_supported())
-		follflags |= FOLL_SPLIT;
 	page = follow_page(vma, addr, follflags);
 
 	err = PTR_ERR(page);
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-drop-hotplug-lock-from-lru_add_drain_all.patch
mm-hugetlb-drop-hugepages_treat_as_movable-sysctl.patch
mm-introduce-map_fixed_safe.patch
fs-elf-drop-map_fixed-usage-from-elf_map.patch
mm-numa-rework-do_pages_move.patch
mm-migrate-remove-reason-argument-from-new_page_t.patch
mm-unclutter-thp-migration.patch
mm-hugetlb-unify-core-page-allocation-accounting-and-initialization.patch
mm-hugetlb-integrate-giga-hugetlb-more-naturally-to-the-allocation-path.patch
mm-hugetlb-do-not-rely-on-overcommit-limit-during-migration.patch
mm-hugetlb-get-rid-of-surplus-page-accounting-tricks.patch
mm-hugetlb-further-simplify-hugetlb-allocation-api.patch
hugetlb-mempolicy-fix-the-mbind-hugetlb-migration.patch

