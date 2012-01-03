From: akpm@linux-foundation.org
Subject: + mm-fewer-underscores-in-____pagevec_lru_add.patch added to -mm tree
Date: Tue, 03 Jan 2012 15:34:31 -0800
Message-ID: <20120103233432.476A71E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:55859 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125Ab2ACXed (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jan 2012 18:34:33 -0500
Received: by yenm5 with SMTP id m5so2060568yen.1
        for <mm-commits@vger.kernel.org>; Tue, 03 Jan 2012 15:34:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     Subject: mm: fewer underscores in ____pagevec_lru_add
has been added to the -mm tree.  Its filename is
     mm-fewer-underscores-in-____pagevec_lru_add.patch

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
Subject: mm: fewer underscores in ____pagevec_lru_add

What's so special about ____pagevec_lru_add() that it needs four leading
underscores?  Nothing, it just helped to distinguish from
__pagevec_lru_add() in 2.6.28 development.  Cut two leading underscores.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagevec.h |   10 +++++-----
 mm/swap.c               |   12 ++++++------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff -puN include/linux/pagevec.h~mm-fewer-underscores-in-____pagevec_lru_add include/linux/pagevec.h
--- a/include/linux/pagevec.h~mm-fewer-underscores-in-____pagevec_lru_add
+++ a/include/linux/pagevec.h
@@ -21,7 +21,7 @@ struct pagevec {
 };
 
 void __pagevec_release(struct pagevec *pvec);
-void ____pagevec_lru_add(struct pagevec *pvec, enum lru_list lru);
+void __pagevec_lru_add(struct pagevec *pvec, enum lru_list lru);
 unsigned pagevec_lookup(struct pagevec *pvec, struct address_space *mapping,
 		pgoff_t start, unsigned nr_pages);
 unsigned pagevec_lookup_tag(struct pagevec *pvec,
@@ -66,22 +66,22 @@ static inline void pagevec_release(struc
 
 static inline void __pagevec_lru_add_anon(struct pagevec *pvec)
 {
-	____pagevec_lru_add(pvec, LRU_INACTIVE_ANON);
+	__pagevec_lru_add(pvec, LRU_INACTIVE_ANON);
 }
 
 static inline void __pagevec_lru_add_active_anon(struct pagevec *pvec)
 {
-	____pagevec_lru_add(pvec, LRU_ACTIVE_ANON);
+	__pagevec_lru_add(pvec, LRU_ACTIVE_ANON);
 }
 
 static inline void __pagevec_lru_add_file(struct pagevec *pvec)
 {
-	____pagevec_lru_add(pvec, LRU_INACTIVE_FILE);
+	__pagevec_lru_add(pvec, LRU_INACTIVE_FILE);
 }
 
 static inline void __pagevec_lru_add_active_file(struct pagevec *pvec)
 {
-	____pagevec_lru_add(pvec, LRU_ACTIVE_FILE);
+	__pagevec_lru_add(pvec, LRU_ACTIVE_FILE);
 }
 
 static inline void pagevec_lru_add_file(struct pagevec *pvec)
diff -puN mm/swap.c~mm-fewer-underscores-in-____pagevec_lru_add mm/swap.c
--- a/mm/swap.c~mm-fewer-underscores-in-____pagevec_lru_add
+++ a/mm/swap.c
@@ -378,7 +378,7 @@ void __lru_cache_add(struct page *page, 
 
 	page_cache_get(page);
 	if (!pagevec_add(pvec, page))
-		____pagevec_lru_add(pvec, lru);
+		__pagevec_lru_add(pvec, lru);
 	put_cpu_var(lru_add_pvecs);
 }
 EXPORT_SYMBOL(__lru_cache_add);
@@ -506,7 +506,7 @@ static void drain_cpu_pagevecs(int cpu)
 	for_each_lru(lru) {
 		pvec = &pvecs[lru - LRU_BASE];
 		if (pagevec_count(pvec))
-			____pagevec_lru_add(pvec, lru);
+			__pagevec_lru_add(pvec, lru);
 	}
 
 	pvec = &per_cpu(lru_rotate_pvecs, cpu);
@@ -698,7 +698,7 @@ void lru_add_page_tail(struct zone* zone
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-static void ____pagevec_lru_add_fn(struct page *page, void *arg)
+static void __pagevec_lru_add_fn(struct page *page, void *arg)
 {
 	enum lru_list lru = (enum lru_list)arg;
 	struct zone *zone = page_zone(page);
@@ -720,14 +720,14 @@ static void ____pagevec_lru_add_fn(struc
  * Add the passed pages to the LRU, then drop the caller's refcount
  * on them.  Reinitialises the caller's pagevec.
  */
-void ____pagevec_lru_add(struct pagevec *pvec, enum lru_list lru)
+void __pagevec_lru_add(struct pagevec *pvec, enum lru_list lru)
 {
 	VM_BUG_ON(is_unevictable_lru(lru));
 
-	pagevec_lru_move_fn(pvec, ____pagevec_lru_add_fn, (void *)lru);
+	pagevec_lru_move_fn(pvec, __pagevec_lru_add_fn, (void *)lru);
 }
 
-EXPORT_SYMBOL(____pagevec_lru_add);
+EXPORT_SYMBOL(__pagevec_lru_add);
 
 /**
  * pagevec_lookup - gang pagecache lookup
_
Subject: Subject: mm: fewer underscores in ____pagevec_lru_add

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
mm-add-free_hot_cold_page_list-helper.patch
mm-add-free_hot_cold_page_list-helper-v2.patch
mm-add-free_hot_cold_page_list-helper-v3.patch
mm-remove-unused-pagevec_free.patch
mm-tracepoint-rename-page-free-events.patch
mm-tracepoint-fixup-documentation-and-examples.patch
mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma.patch
mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma-update.patch
mm-simplify-find_vma_prev.patch
mm-test-pageswapbacked-in-lumpy-reclaim.patch
mm-vmscan-fix-typo-in-isolating-lru-pages.patch
memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue.patch
mm-memcg-consolidate-hierarchy-iteration-primitives.patch
mm-vmscan-distinguish-global-reclaim-from-global-lru-scanning.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
mm-memcg-per-priority-per-zone-hierarchy-scan-generations.patch
mm-move-memcg-hierarchy-reclaim-to-generic-reclaim-code.patch
mm-memcg-remove-optimization-of-keeping-the-root_mem_cgroup-lru-lists-empty.patch
mm-vmscan-convert-global-reclaim-to-per-memcg-lru-lists.patch
mm-collect-lru-list-heads-into-struct-lruvec.patch
mm-make-per-memcg-lru-lists-exclusive.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags.patch
mm-memcg-remove-unused-node-section-info-from-pc-flags-fix.patch
mm-oom_kill-remove-memcg-argument-from-oom_kill_task.patch
mm-unify-remaining-mem_cont-mem-etc-variable-names-to-memcg.patch
mm-memcg-clean-up-fault-accounting.patch
mm-memcg-lookup_page_cgroup-almost-never-returns-null.patch
mm-memcg-lookup_page_cgroup-almost-never-returns-null-fix.patch
mm-page_cgroup-check-page_cgroup-arrays-in-lookup_page_cgroup-only-when-necessary.patch
mm-memcg-remove-unneeded-checks-from-newpage_charge.patch
mm-memcg-remove-unneeded-checks-from-uncharge_page.patch
memcg-clean-up-soft_limit_tree-if-allocation-fails.patch
memcg-simplify-page-cache-charging.patch
memcg-simplify-corner-case-handling-of-lru.patch
memcg-clear-pc-mem_cgorup-if-necessary.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-2.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-2-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-3.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-page-migration-to-reset_owner.patch
memcg-simplify-lru-handling-by-new-rule.patch
memcg-simplify-lru-handling-by-new-rule-fix.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix-null-mem_cgroup_try_charge.patch
memcg-fix-split_huge_page_refcounts.patch
memcg-fix-mem_cgroup_print_bad_page.patch
mm-take-pagevecs-off-reclaim-stack.patch
mm-fewer-underscores-in-____pagevec_lru_add.patch
mm-no-blank-line-after-export_symbol-in-swapc.patch
mm-enum-lru_list-lru.patch
mm-remove-del_page_from_lru-add-page_off_lru.patch
mm-remove-isolate_pages.patch
mm-rearrange-putback_inactive_pages.patch
procfs-add-hidepid=-and-gid=-mount-options.patch
radix_tree-remove-radix_tree_indirect_to_ptr.patch
radix_tree-take-radix_tree_path-off-stack.patch
radix_tree-take-radix_tree_path-off-stack-expand-comment-on-optimization.patch
prio_tree-debugging-patch.patch

