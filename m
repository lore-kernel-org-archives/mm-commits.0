From: akpm@linux-foundation.org
Subject: + mm-shmem-use-new-radix-tree-iterator.patch added to -mm tree
Date: Fri, 01 Feb 2013 15:40:43 -0800
Message-ID: <20130201234043.98FFC31C1BF@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:61066 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756800Ab3BAXko (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2013 18:40:44 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so501294qcq.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Feb 2013 15:40:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, hughd@google.com, khlebnikov@openvz.org


The patch titled
     Subject: mm: shmem: use new radix tree iterator
has been added to the -mm tree.  Its filename is
     mm-shmem-use-new-radix-tree-iterator.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: shmem: use new radix tree iterator

In shmem_find_get_pages_and_swap(), use the faster radix tree iterator
construct from 78c1d78 ("radix-tree: introduce bit-optimized iterator").

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff -puN mm/shmem.c~mm-shmem-use-new-radix-tree-iterator mm/shmem.c
--- a/mm/shmem.c~mm-shmem-use-new-radix-tree-iterator
+++ a/mm/shmem.c
@@ -335,19 +335,19 @@ static unsigned shmem_find_get_pages_and
 					pgoff_t start, unsigned int nr_pages,
 					struct page **pages, pgoff_t *indices)
 {
-	unsigned int i;
-	unsigned int ret;
-	unsigned int nr_found;
+	void **slot;
+	unsigned int ret = 0;
+	struct radix_tree_iter iter;
+
+	if (!nr_pages)
+		return 0;
 
 	rcu_read_lock();
 restart:
-	nr_found = radix_tree_gang_lookup_slot(&mapping->page_tree,
-				(void ***)pages, indices, start, nr_pages);
-	ret = 0;
-	for (i = 0; i < nr_found; i++) {
+	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, start) {
 		struct page *page;
 repeat:
-		page = radix_tree_deref_slot((void **)pages[i]);
+		page = radix_tree_deref_slot(slot);
 		if (unlikely(!page))
 			continue;
 		if (radix_tree_exception(page)) {
@@ -364,17 +364,16 @@ repeat:
 			goto repeat;
 
 		/* Has the page moved? */
-		if (unlikely(page != *((void **)pages[i]))) {
+		if (unlikely(page != *slot)) {
 			page_cache_release(page);
 			goto repeat;
 		}
 export:
-		indices[ret] = indices[i];
+		indices[ret] = iter.index;
 		pages[ret] = page;
-		ret++;
+		if (++ret == nr_pages)
+			break;
 	}
-	if (unlikely(!ret && nr_found))
-		goto restart;
 	rcu_read_unlock();
 	return ret;
 }
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

memcg-fix-typo-in-kmemcg-cache-walk-macro.patch
linux-next.patch
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
memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pages.patch
mmotm-memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pagespatch-fix-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
memcg-prevent-changes-to-move_charge_at_immigrate-during-task-attach.patch
memcg-split-part-of-memcg-creation-to-css_online.patch
memcg-fast-hierarchy-aware-child-test.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock.patch
memcg-increment-static-branch-right-after-limit-set.patch
memcg-avoid-dangling-reference-count-in-creation-failure.patch
mm-memmap_init_zone-performance-improvement.patch
mm-shmem-use-new-radix-tree-iterator.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
mm-prevent-addition-of-pages-to-swap-if-may_writepage-is-unset.patch

