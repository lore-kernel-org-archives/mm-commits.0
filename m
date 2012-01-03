From: akpm@linux-foundation.org
Subject: + mm-remove-del_page_from_lru-add-page_off_lru.patch added to -mm tree
Date: Tue, 03 Jan 2012 15:34:41 -0800
Message-ID: <20120103233442.CAEDE5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:34444 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755132Ab2ACXkJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jan 2012 18:40:09 -0500
Received: by lagu2 with SMTP id u2so597736lag.1
        for <mm-commits@vger.kernel.org>; Tue, 03 Jan 2012 15:40:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     Subject: mm: remove del_page_from_lru, add page_off_lru
has been added to the -mm tree.  Its filename is
     mm-remove-del_page_from_lru-add-page_off_lru.patch

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
Subject: mm: remove del_page_from_lru, add page_off_lru

del_page_from_lru() repeats del_page_from_lru_list(), also working out
which LRU the page was on, clearing the relevant bits.  Decouple those
functions: remove del_page_from_lru() and add page_off_lru().

Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   15 +++++++++------
 mm/swap.c                 |    4 ++--
 2 files changed, 11 insertions(+), 8 deletions(-)

diff -puN include/linux/mm_inline.h~mm-remove-del_page_from_lru-add-page_off_lru include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~mm-remove-del_page_from_lru-add-page_off_lru
+++ a/include/linux/mm_inline.h
@@ -54,8 +54,14 @@ static inline enum lru_list page_lru_bas
 	return LRU_INACTIVE_ANON;
 }
 
-static inline void
-del_page_from_lru(struct zone *zone, struct page *page)
+/**
+ * page_off_lru - which LRU list was page on? clearing its lru flags.
+ * @page: the page to test
+ *
+ * Returns the LRU list a page was on, as an index into the array of LRU
+ * lists; and clears its Unevictable or Active flags, ready for freeing.
+ */
+static inline enum lru_list page_off_lru(struct page *page)
 {
 	enum lru_list lru;
 
@@ -69,9 +75,7 @@ del_page_from_lru(struct zone *zone, str
 			lru += LRU_ACTIVE;
 		}
 	}
-	mem_cgroup_lru_del_list(page, lru);
-	list_del(&page->lru);
-	__mod_zone_page_state(zone, NR_LRU_BASE + lru, -hpage_nr_pages(page));
+	return lru;
 }
 
 /**
@@ -92,7 +96,6 @@ static inline enum lru_list page_lru(str
 		if (PageActive(page))
 			lru += LRU_ACTIVE;
 	}
-
 	return lru;
 }
 
diff -puN mm/swap.c~mm-remove-del_page_from_lru-add-page_off_lru mm/swap.c
--- a/mm/swap.c~mm-remove-del_page_from_lru-add-page_off_lru
+++ a/mm/swap.c
@@ -53,7 +53,7 @@ static void __page_cache_release(struct 
 		spin_lock_irqsave(&zone->lru_lock, flags);
 		VM_BUG_ON(!PageLRU(page));
 		__ClearPageLRU(page);
-		del_page_from_lru(zone, page);
+		del_page_from_lru_list(zone, page, page_off_lru(page));
 		spin_unlock_irqrestore(&zone->lru_lock, flags);
 	}
 }
@@ -617,7 +617,7 @@ void release_pages(struct page **pages, 
 			}
 			VM_BUG_ON(!PageLRU(page));
 			__ClearPageLRU(page);
-			del_page_from_lru(zone, page);
+			del_page_from_lru_list(zone, page, page_off_lru(page));
 		}
 
 		list_add(&page->lru, &pages_to_free);
_
Subject: Subject: mm: remove del_page_from_lru, add page_off_lru

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

