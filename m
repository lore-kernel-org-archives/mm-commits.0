From: akpm@linux-foundation.org
Subject: + mm-remove-offlining-arg-to-migrate_pages.patch added to -mm tree
Date: Mon, 28 Jan 2013 15:51:05 -0800
Message-ID: <20130128235106.4C0635A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f202.google.com ([209.85.210.202]:36330 "EHLO
	mail-ia0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab3A1XvI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jan 2013 18:51:08 -0500
Received: by mail-ia0-f202.google.com with SMTP id p22so623229iad.5
        for <mm-commits@vger.kernel.org>; Mon, 28 Jan 2013 15:51:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, aarcange@redhat.com, gerald.schaefer@de.ibm.com, izik.eidus@ravellosystems.com, kosaki.motohiro@gmail.com, pholasek@redhat.com, riel@redhat.com


The patch titled
     Subject: mm: remove offlining arg to migrate_pages
has been added to the -mm tree.  Its filename is
     mm-remove-offlining-arg-to-migrate_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: remove offlining arg to migrate_pages

No functional change, but the only purpose of the offlining argument to
migrate_pages() etc, was to ensure that __unmap_and_move() could migrate a
KSM page for memory hotremove (which took ksm_thread_mutex) but not for
other callers.  Now all cases are safe, remove the arg.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Petr Holasek <pholasek@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Izik Eidus <izik.eidus@ravellosystems.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |   14 ++++++--------
 mm/compaction.c         |    2 +-
 mm/memory-failure.c     |    7 +++----
 mm/memory_hotplug.c     |    3 +--
 mm/mempolicy.c          |    8 +++-----
 mm/migrate.c            |   35 +++++++++++++----------------------
 mm/page_alloc.c         |    6 ++----
 7 files changed, 29 insertions(+), 46 deletions(-)

diff -puN include/linux/migrate.h~mm-remove-offlining-arg-to-migrate_pages include/linux/migrate.h
--- a/include/linux/migrate.h~mm-remove-offlining-arg-to-migrate_pages
+++ a/include/linux/migrate.h
@@ -40,11 +40,9 @@ extern void putback_movable_pages(struct
 extern int migrate_page(struct address_space *,
 			struct page *, struct page *, enum migrate_mode);
 extern int migrate_pages(struct list_head *l, new_page_t x,
-			unsigned long private, bool offlining,
-			enum migrate_mode mode, int reason);
+		unsigned long private, enum migrate_mode mode, int reason);
 extern int migrate_huge_page(struct page *, new_page_t x,
-			unsigned long private, bool offlining,
-			enum migrate_mode mode);
+		unsigned long private, enum migrate_mode mode);
 
 extern int fail_migrate_page(struct address_space *,
 			struct page *, struct page *);
@@ -62,11 +60,11 @@ extern int migrate_huge_page_move_mappin
 static inline void putback_lru_pages(struct list_head *l) {}
 static inline void putback_movable_pages(struct list_head *l) {}
 static inline int migrate_pages(struct list_head *l, new_page_t x,
-		unsigned long private, bool offlining,
-		enum migrate_mode mode, int reason) { return -ENOSYS; }
+		unsigned long private, enum migrate_mode mode, int reason)
+	{ return -ENOSYS; }
 static inline int migrate_huge_page(struct page *page, new_page_t x,
-		unsigned long private, bool offlining,
-		enum migrate_mode mode) { return -ENOSYS; }
+		unsigned long private, enum migrate_mode mode)
+	{ return -ENOSYS; }
 
 static inline int migrate_prep(void) { return -ENOSYS; }
 static inline int migrate_prep_local(void) { return -ENOSYS; }
diff -puN mm/compaction.c~mm-remove-offlining-arg-to-migrate_pages mm/compaction.c
--- a/mm/compaction.c~mm-remove-offlining-arg-to-migrate_pages
+++ a/mm/compaction.c
@@ -980,7 +980,7 @@ static int compact_zone(struct zone *zon
 
 		nr_migrate = cc->nr_migratepages;
 		err = migrate_pages(&cc->migratepages, compaction_alloc,
-				(unsigned long)cc, false,
+				(unsigned long)cc,
 				cc->sync ? MIGRATE_SYNC_LIGHT : MIGRATE_ASYNC,
 				MR_COMPACTION);
 		update_nr_listpages(cc);
diff -puN mm/memory-failure.c~mm-remove-offlining-arg-to-migrate_pages mm/memory-failure.c
--- a/mm/memory-failure.c~mm-remove-offlining-arg-to-migrate_pages
+++ a/mm/memory-failure.c
@@ -1455,7 +1455,7 @@ static int soft_offline_huge_page(struct
 	unlock_page(hpage);
 
 	/* Keep page count to indicate a given hugepage is isolated. */
-	ret = migrate_huge_page(hpage, new_page, MPOL_MF_MOVE_ALL, false,
+	ret = migrate_huge_page(hpage, new_page, MPOL_MF_MOVE_ALL,
 				MIGRATE_SYNC);
 	put_page(hpage);
 	if (ret) {
@@ -1587,11 +1587,10 @@ static int __soft_offline_page(struct pa
 	if (!ret) {
 		LIST_HEAD(pagelist);
 		inc_zone_page_state(page, NR_ISOLATED_ANON +
-					    page_is_file_cache(page));
+					page_is_file_cache(page));
 		list_add(&page->lru, &pagelist);
 		ret = migrate_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL,
-							false, MIGRATE_SYNC,
-							MR_MEMORY_FAILURE);
+					MIGRATE_SYNC, MR_MEMORY_FAILURE);
 		if (ret) {
 			putback_lru_pages(&pagelist);
 			pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
diff -puN mm/memory_hotplug.c~mm-remove-offlining-arg-to-migrate_pages mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-remove-offlining-arg-to-migrate_pages
+++ a/mm/memory_hotplug.c
@@ -1286,8 +1286,7 @@ do_migrate_range(unsigned long start_pfn
 		 * migrate_pages returns # of failed pages.
 		 */
 		ret = migrate_pages(&source, alloc_migrate_target, 0,
-							true, MIGRATE_SYNC,
-							MR_MEMORY_HOTPLUG);
+					MIGRATE_SYNC, MR_MEMORY_HOTPLUG);
 		if (ret)
 			putback_lru_pages(&source);
 	}
diff -puN mm/mempolicy.c~mm-remove-offlining-arg-to-migrate_pages mm/mempolicy.c
--- a/mm/mempolicy.c~mm-remove-offlining-arg-to-migrate_pages
+++ a/mm/mempolicy.c
@@ -1014,8 +1014,7 @@ static int migrate_to_node(struct mm_str
 
 	if (!list_empty(&pagelist)) {
 		err = migrate_pages(&pagelist, new_node_page, dest,
-							false, MIGRATE_SYNC,
-							MR_SYSCALL);
+					MIGRATE_SYNC, MR_SYSCALL);
 		if (err)
 			putback_lru_pages(&pagelist);
 	}
@@ -1259,9 +1258,8 @@ static long do_mbind(unsigned long start
 		if (!list_empty(&pagelist)) {
 			WARN_ON_ONCE(flags & MPOL_MF_LAZY);
 			nr_failed = migrate_pages(&pagelist, new_vma_page,
-						(unsigned long)vma,
-						false, MIGRATE_SYNC,
-						MR_MEMPOLICY_MBIND);
+					(unsigned long)vma,
+					MIGRATE_SYNC, MR_MEMPOLICY_MBIND);
 			if (nr_failed)
 				putback_lru_pages(&pagelist);
 		}
diff -puN mm/migrate.c~mm-remove-offlining-arg-to-migrate_pages mm/migrate.c
--- a/mm/migrate.c~mm-remove-offlining-arg-to-migrate_pages
+++ a/mm/migrate.c
@@ -701,7 +701,7 @@ static int move_to_new_page(struct page 
 }
 
 static int __unmap_and_move(struct page *page, struct page *newpage,
-			int force, bool offlining, enum migrate_mode mode)
+				int force, enum migrate_mode mode)
 {
 	int rc = -EAGAIN;
 	int remap_swapcache = 1;
@@ -847,8 +847,7 @@ out:
  * to the newly allocated page in newpage.
  */
 static int unmap_and_move(new_page_t get_new_page, unsigned long private,
-			struct page *page, int force, bool offlining,
-			enum migrate_mode mode)
+			struct page *page, int force, enum migrate_mode mode)
 {
 	int rc = 0;
 	int *result = NULL;
@@ -866,7 +865,7 @@ static int unmap_and_move(new_page_t get
 		if (unlikely(split_huge_page(page)))
 			goto out;
 
-	rc = __unmap_and_move(page, newpage, force, offlining, mode);
+	rc = __unmap_and_move(page, newpage, force, mode);
 
 	if (unlikely(rc == MIGRATEPAGE_BALLOON_SUCCESS)) {
 		/*
@@ -926,8 +925,7 @@ out:
  */
 static int unmap_and_move_huge_page(new_page_t get_new_page,
 				unsigned long private, struct page *hpage,
-				int force, bool offlining,
-				enum migrate_mode mode)
+				int force, enum migrate_mode mode)
 {
 	int rc = 0;
 	int *result = NULL;
@@ -989,9 +987,8 @@ out:
  *
  * Return: Number of pages not migrated or error code.
  */
-int migrate_pages(struct list_head *from,
-		new_page_t get_new_page, unsigned long private, bool offlining,
-		enum migrate_mode mode, int reason)
+int migrate_pages(struct list_head *from, new_page_t get_new_page,
+		unsigned long private, enum migrate_mode mode, int reason)
 {
 	int retry = 1;
 	int nr_failed = 0;
@@ -1012,8 +1009,7 @@ int migrate_pages(struct list_head *from
 			cond_resched();
 
 			rc = unmap_and_move(get_new_page, private,
-						page, pass > 2, offlining,
-						mode);
+						page, pass > 2, mode);
 
 			switch(rc) {
 			case -ENOMEM:
@@ -1046,15 +1042,13 @@ out:
 }
 
 int migrate_huge_page(struct page *hpage, new_page_t get_new_page,
-		      unsigned long private, bool offlining,
-		      enum migrate_mode mode)
+		      unsigned long private, enum migrate_mode mode)
 {
 	int pass, rc;
 
 	for (pass = 0; pass < 10; pass++) {
-		rc = unmap_and_move_huge_page(get_new_page,
-					      private, hpage, pass > 2, offlining,
-					      mode);
+		rc = unmap_and_move_huge_page(get_new_page, private,
+						hpage, pass > 2, mode);
 		switch (rc) {
 		case -ENOMEM:
 			goto out;
@@ -1177,8 +1171,7 @@ set_status:
 	err = 0;
 	if (!list_empty(&pagelist)) {
 		err = migrate_pages(&pagelist, new_page_node,
-				(unsigned long)pm, 0, MIGRATE_SYNC,
-				MR_SYSCALL);
+				(unsigned long)pm, MIGRATE_SYNC, MR_SYSCALL);
 		if (err)
 			putback_lru_pages(&pagelist);
 	}
@@ -1613,10 +1606,8 @@ int migrate_misplaced_page(struct page *
 		goto out;
 
 	list_add(&page->lru, &migratepages);
-	nr_remaining = migrate_pages(&migratepages,
-			alloc_misplaced_dst_page,
-			node, false, MIGRATE_ASYNC,
-			MR_NUMA_MISPLACED);
+	nr_remaining = migrate_pages(&migratepages, alloc_misplaced_dst_page,
+				     node, MIGRATE_ASYNC, MR_NUMA_MISPLACED);
 	if (nr_remaining) {
 		putback_lru_pages(&migratepages);
 		isolated = 0;
diff -puN mm/page_alloc.c~mm-remove-offlining-arg-to-migrate_pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-offlining-arg-to-migrate_pages
+++ a/mm/page_alloc.c
@@ -6079,10 +6079,8 @@ static int __alloc_contig_migrate_range(
 							&cc->migratepages);
 		cc->nr_migratepages -= nr_reclaimed;
 
-		ret = migrate_pages(&cc->migratepages,
-				    alloc_migrate_target,
-				    0, false, MIGRATE_SYNC,
-				    MR_CMA);
+		ret = migrate_pages(&cc->migratepages, alloc_migrate_target,
+				    0, MIGRATE_SYNC, MR_CMA);
 	}
 	if (ret < 0) {
 		putback_movable_pages(&cc->migratepages);
_

Patches currently in -mm which might be from hughd@google.com are

linux-next.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
mm-memcg-only-evict-file-pages-when-we-have-plenty.patch
mm-vmscan-save-work-scanning-almost-empty-lru-lists.patch
mm-vmscan-clarify-how-swappiness-highest-priority-memcg-interact.patch
mm-vmscan-improve-comment-on-low-page-cache-handling.patch
mm-vmscan-clean-up-get_scan_count.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-reduce-rmap-overhead-for-ex-ksm-page-copies-created-on-swap-faults.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mmksm-use-new-hashtable-implementation.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix-fix.patch
mm-avoid-calling-pgdat_balanced-needlessly.patch
mm-numa-fix-minor-typo-in-numa_next_scan.patch
mm-numa-take-thp-into-account-when-migrating-pages-for-numa-balancing.patch
mm-numa-handle-side-effects-in-count_vm_numa_events-for-config_numa_balancing.patch
mm-move-page-flags-layout-to-separate-header.patch
mm-fold-page-_last_nid-into-page-flags-where-possible.patch
mm-numa-cleanup-flow-of-transhuge-page-migration.patch
mm-dont-inline-page_mapping.patch
swap-make-each-swap-partition-have-one-address_space.patch
swap-make-each-swap-partition-have-one-address_space-fix.patch
swap-add-per-partition-lock-for-swapfile.patch
memcg-reduce-the-size-of-struct-memcg-244-fold.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
ksm-allow-trees-per-numa-node.patch
ksm-add-sysfs-abi-documentation.patch
ksm-trivial-tidyups.patch
ksm-reorganize-ksm_check_stable_tree.patch
ksm-get_ksm_page-locked.patch
ksm-remove-old-stable-nodes-more-thoroughly.patch
ksm-make-ksm-page-migration-possible.patch
ksm-make-merge_across_nodes-migration-safe.patch
ksm-enable-ksm-page-migration.patch
mm-remove-offlining-arg-to-migrate_pages.patch
ksm-stop-hotremove-lockdep-warning.patch
mm-prevent-addition-of-pages-to-swap-if-may_writepage-is-unset.patch

