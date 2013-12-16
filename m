From: akpm@linux-foundation.org
Subject: +
 mm-migrate-remove-putback_lru_pages-fix-comment-on-putback_movable_pages.patch added to -mm tree
Date: Mon, 16 Dec 2013 11:55:53 -0800
Message-ID: <52af5ac9.4vTDR6fRSqUcKndG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45329 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab3LPTzy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Dec 2013 14:55:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, vbabka@suse.cz, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, liwanp@linux.vnet.ibm.com, cl@linux.com, aquini@redhat.com, iamjoonsoo.kim@lge.com

Subject: + mm-migrate-remove-putback_lru_pages-fix-comment-on-putback_movable_pages.patch added to -mm tree
To: iamjoonsoo.kim@lge.com,aquini@redhat.com,cl@linux.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com,riel@redhat.com,vbabka@suse.cz,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Mon, 16 Dec 2013 11:55:53 -0800


The patch titled
     Subject: mm/migrate: remove putback_lru_pages, fix comment on putback_movable_pages
has been added to the -mm tree.  Its filename is
     mm-migrate-remove-putback_lru_pages-fix-comment-on-putback_movable_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-remove-putback_lru_pages-fix-comment-on-putback_movable_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-remove-putback_lru_pages-fix-comment-on-putback_movable_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/migrate: remove putback_lru_pages, fix comment on putback_movable_pages

Some part of putback_lru_pages() and putback_movable_pages() is
duplicated, so it could confuse us what we should use.  We can remove
putback_lru_pages() since it is not really needed now.  This makes us
undestand and maintain the code more easily.

And comment on putback_movable_pages() is stale now, so fix it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |    2 --
 mm/memory-failure.c     |    8 +++++++-
 mm/migrate.c            |   29 +++++++++--------------------
 3 files changed, 16 insertions(+), 23 deletions(-)

diff -puN include/linux/migrate.h~mm-migrate-remove-putback_lru_pages-fix-comment-on-putback_movable_pages include/linux/migrate.h
--- a/include/linux/migrate.h~mm-migrate-remove-putback_lru_pages-fix-comment-on-putback_movable_pages
+++ a/include/linux/migrate.h
@@ -35,7 +35,6 @@ enum migrate_reason {
 
 #ifdef CONFIG_MIGRATION
 
-extern void putback_lru_pages(struct list_head *l);
 extern void putback_movable_pages(struct list_head *l);
 extern int migrate_page(struct address_space *,
 			struct page *, struct page *, enum migrate_mode);
@@ -58,7 +57,6 @@ extern int migrate_page_move_mapping(str
 		struct buffer_head *head, enum migrate_mode mode);
 #else
 
-static inline void putback_lru_pages(struct list_head *l) {}
 static inline void putback_movable_pages(struct list_head *l) {}
 static inline int migrate_pages(struct list_head *l, new_page_t x,
 		unsigned long private, enum migrate_mode mode, int reason)
diff -puN mm/memory-failure.c~mm-migrate-remove-putback_lru_pages-fix-comment-on-putback_movable_pages mm/memory-failure.c
--- a/mm/memory-failure.c~mm-migrate-remove-putback_lru_pages-fix-comment-on-putback_movable_pages
+++ a/mm/memory-failure.c
@@ -1575,7 +1575,13 @@ static int __soft_offline_page(struct pa
 		ret = migrate_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL,
 					MIGRATE_SYNC, MR_MEMORY_FAILURE);
 		if (ret) {
-			putback_lru_pages(&pagelist);
+			if (!list_empty(&pagelist)) {
+				list_del(&page->lru);
+				dec_zone_page_state(page, NR_ISOLATED_ANON +
+						page_is_file_cache(page));
+				putback_lru_page(page);
+			}
+
 			pr_info("soft offline: %#lx: migration failed %d, type %lx\n",
 				pfn, ret, page->flags);
 			if (ret > 0)
diff -puN mm/migrate.c~mm-migrate-remove-putback_lru_pages-fix-comment-on-putback_movable_pages mm/migrate.c
--- a/mm/migrate.c~mm-migrate-remove-putback_lru_pages-fix-comment-on-putback_movable_pages
+++ a/mm/migrate.c
@@ -72,28 +72,12 @@ int migrate_prep_local(void)
 }
 
 /*
- * Add isolated pages on the list back to the LRU under page lock
- * to avoid leaking evictable pages back onto unevictable list.
- */
-void putback_lru_pages(struct list_head *l)
-{
-	struct page *page;
-	struct page *page2;
-
-	list_for_each_entry_safe(page, page2, l, lru) {
-		list_del(&page->lru);
-		dec_zone_page_state(page, NR_ISOLATED_ANON +
-				page_is_file_cache(page));
-			putback_lru_page(page);
-	}
-}
-
-/*
  * Put previously isolated pages back onto the appropriate lists
  * from where they were once taken off for compaction/migration.
  *
- * This function shall be used instead of putback_lru_pages(),
- * whenever the isolated pageset has been built by isolate_migratepages_range()
+ * This function shall be used whenever the isolated pageset has been
+ * built from lru, balloon, hugetlbfs page. See isolate_migratepages_range()
+ * and isolate_huge_page().
  */
 void putback_movable_pages(struct list_head *l)
 {
@@ -1724,7 +1708,12 @@ int migrate_misplaced_page(struct page *
 	nr_remaining = migrate_pages(&migratepages, alloc_misplaced_dst_page,
 				     node, MIGRATE_ASYNC, MR_NUMA_MISPLACED);
 	if (nr_remaining) {
-		putback_lru_pages(&migratepages);
+		if (!list_empty(&migratepages)) {
+			list_del(&page->lru);
+			dec_zone_page_state(page, NR_ISOLATED_ANON +
+					page_is_file_cache(page));
+			putback_lru_page(page);
+		}
 		isolated = 0;
 	} else
 		count_vm_numa_event(NUMA_PAGE_MIGRATE);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-mempolicy-correct-putback-method-for-isolate-pages-if-failed.patch
mm-compaction-respect-ignore_skip_hint-in-update_pageblock_skip.patch
mm-rmap-recompute-pgoff-for-huge-page.patch
mm-rmap-factor-nonlinear-handling-out-of-try_to_unmap_file.patch
mm-rmap-factor-lock-function-out-of-rmap_walk_anon.patch
mm-rmap-make-rmap_walk-to-get-the-rmap_walk_control-argument.patch
mm-rmap-extend-rmap_walk_xxx-to-cope-with-different-cases.patch
mm-rmap-use-rmap_walk-in-try_to_unmap.patch
mm-rmap-use-rmap_walk-in-try_to_munlock.patch
mm-rmap-use-rmap_walk-in-page_referenced.patch
mm-rmap-use-rmap_walk-in-page_mkclean.patch
mm-compaction-trace-compaction-begin-and-end.patch
mm-compaction-encapsulate-defer-reset-logic.patch
mm-compaction-reset-cached-scanner-pfns-before-reading-them.patch
mm-compaction-detect-when-scanners-meet-in-isolate_freepages.patch
mm-compaction-do-not-mark-unmovable-pageblocks-as-skipped-in-async-compaction.patch
mm-compaction-reset-scanner-positions-immediately-when-they-meet.patch
mm-migrate-add-comment-about-permanent-failure-path.patch
mm-migrate-correct-failure-handling-if-hugepage_migration_support.patch
mm-migrate-remove-putback_lru_pages-fix-comment-on-putback_movable_pages.patch
mm-migrate-remove-unused-function-fail_migrate_page.patch

