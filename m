From: akpm@linux-foundation.org
Subject: +
 mm-move-page-mem_cgroup-bad-page-handling-into-generic-code.patch added to
 -mm tree
Date: Tue, 04 Nov 2014 13:15:34 -0800
Message-ID: <545941f6.9Rb1fppuO90gLiDo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47826 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaKDVPe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2014 16:15:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, iamjoonsoo.kim@lge.com, kamezawa.hiroyu@jp.fujitsu.com, kirill@shutemov.name, mhocko@suse.cz, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move page->mem_cgroup bad page handling into generic code
has been added to the -mm tree.  Its filename is
     mm-move-page-mem_cgroup-bad-page-handling-into-generic-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-move-page-mem_cgroup-bad-page-handling-into-generic-code.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-move-page-mem_cgroup-bad-page-handling-into-generic-code.patch

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
Subject: mm: move page->mem_cgroup bad page handling into generic code

Now that the external page_cgroup data structure and its lookup is
gone, let the generic bad_page() check for page->mem_cgroup sanity.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Tejun Heo <tj@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ----
 mm/debug.c                 |    5 ++++-
 mm/memcontrol.c            |   15 ---------------
 mm/page_alloc.c            |   12 ++++++++----
 4 files changed, 12 insertions(+), 24 deletions(-)

diff -puN include/linux/memcontrol.h~mm-move-page-mem_cgroup-bad-page-handling-into-generic-code include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-move-page-mem_cgroup-bad-page-handling-into-generic-code
+++ a/include/linux/memcontrol.h
@@ -173,10 +173,6 @@ static inline void mem_cgroup_count_vm_e
 void mem_cgroup_split_huge_fixup(struct page *head);
 #endif
 
-#ifdef CONFIG_DEBUG_VM
-bool mem_cgroup_bad_page_check(struct page *page);
-void mem_cgroup_print_bad_page(struct page *page);
-#endif
 #else /* CONFIG_MEMCG */
 struct mem_cgroup;
 
diff -puN mm/debug.c~mm-move-page-mem_cgroup-bad-page-handling-into-generic-code mm/debug.c
--- a/mm/debug.c~mm-move-page-mem_cgroup-bad-page-handling-into-generic-code
+++ a/mm/debug.c
@@ -95,7 +95,10 @@ void dump_page_badflags(struct page *pag
 		dump_flags(page->flags & badflags,
 				pageflag_names, ARRAY_SIZE(pageflag_names));
 	}
-	mem_cgroup_print_bad_page(page);
+#ifdef CONFIG_MEMCG
+	if (page->mem_cgroup)
+		pr_alert("page->mem_cgroup:%p\n", page->mem_cgroup);
+#endif
 }
 
 void dump_page(struct page *page, const char *reason)
diff -puN mm/memcontrol.c~mm-move-page-mem_cgroup-bad-page-handling-into-generic-code mm/memcontrol.c
--- a/mm/memcontrol.c~mm-move-page-mem_cgroup-bad-page-handling-into-generic-code
+++ a/mm/memcontrol.c
@@ -3157,21 +3157,6 @@ static inline int mem_cgroup_move_swap_a
 }
 #endif
 
-#ifdef CONFIG_DEBUG_VM
-bool mem_cgroup_bad_page_check(struct page *page)
-{
-	if (mem_cgroup_disabled())
-		return false;
-
-	return page->mem_cgroup != NULL;
-}
-
-void mem_cgroup_print_bad_page(struct page *page)
-{
-	pr_alert("page->mem_cgroup:%p\n", page->mem_cgroup);
-}
-#endif
-
 static DEFINE_MUTEX(memcg_limit_mutex);
 
 static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
diff -puN mm/page_alloc.c~mm-move-page-mem_cgroup-bad-page-handling-into-generic-code mm/page_alloc.c
--- a/mm/page_alloc.c~mm-move-page-mem_cgroup-bad-page-handling-into-generic-code
+++ a/mm/page_alloc.c
@@ -638,8 +638,10 @@ static inline int free_pages_check(struc
 		bad_reason = "PAGE_FLAGS_CHECK_AT_FREE flag(s) set";
 		bad_flags = PAGE_FLAGS_CHECK_AT_FREE;
 	}
-	if (unlikely(mem_cgroup_bad_page_check(page)))
-		bad_reason = "cgroup check failed";
+#ifdef CONFIG_MEMCG
+	if (unlikely(page->mem_cgroup))
+		bad_reason = "page still charged to cgroup";
+#endif
 	if (unlikely(bad_reason)) {
 		bad_page(page, bad_reason, bad_flags);
 		return 1;
@@ -898,8 +900,10 @@ static inline int check_new_page(struct
 		bad_reason = "PAGE_FLAGS_CHECK_AT_PREP flag set";
 		bad_flags = PAGE_FLAGS_CHECK_AT_PREP;
 	}
-	if (unlikely(mem_cgroup_bad_page_check(page)))
-		bad_reason = "cgroup check failed";
+#ifdef CONFIG_MEMCG
+	if (unlikely(page->mem_cgroup))
+		bad_reason = "page still charged to cgroup";
+#endif
 	if (unlikely(bad_reason)) {
 		bad_page(page, bad_reason, bad_flags);
 		return 1;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_alloc-fix-incorrect-isolation-behavior-by-rechecking-migratetype.patch
mm-page_alloc-add-freepage-on-isolate-pageblock-to-correct-buddy-list.patch
mm-page_alloc-move-freepage-counting-logic-to-__free_one_page.patch
mm-page_alloc-restrict-max-order-of-merging-on-isolated-pageblock.patch
slab-print-slabinfo-header-in-seq-show.patch
mm-memcontrol-lockless-page-counters.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
mm-memcontrol-lockless-page-counters-fix-2.patch
mm-hugetlb_cgroup-convert-to-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
kernel-res_counter-remove-the-unused-api-fix.patch
kernel-res_counter-remove-the-unused-api-fix-2.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting-fix.patch
mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch
mm-memcontrol-remove-synchroneous-stock-draining-code.patch
mm-vmscan-count-only-dirty-pages-as-congested.patch
memcg-simplify-unreclaimable-groups-handling-in-soft-limit-reclaim.patch
mm-memcontrol-update-mem_cgroup_page_lruvec-documentation.patch
mm-memcontrol-clarify-migration-where-old-page-is-uncharged.patch
memcg-remove-activate_kmem_mutex.patch
mm-memcontrol-micro-optimize-mem_cgroup_split_huge_fixup.patch
mm-memcontrol-uncharge-pages-on-swapout.patch
mm-memcontrol-uncharge-pages-on-swapout-fix.patch
mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_mem-memory-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-inline-memcg-move_lock-locking.patch
mm-memcontrol-dont-pass-a-null-memcg-to-mem_cgroup_end_move.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
memcg-remove-mem_cgroup_reclaimable-check-from-soft-reclaim.patch
memcg-use-generic-slab-iterators-for-showing-slabinfo.patch
mm-memcontrol-shorten-the-page-statistics-update-slowpath.patch
mm-memcontrol-remove-bogus-null-check-after-mem_cgroup_from_task.patch
mm-memcontrol-pull-the-null-check-from-__mem_cgroup_same_or_subtree.patch
mm-memcontrol-drop-bogus-rcu-locking-from-mem_cgroup_same_or_subtree.patch
mm-memcg-fix-potential-undefined-when-for-page-stat-accounting.patch
mm-memcontrol-remove-stale-page_cgroup_lock-comment.patch
mm-embed-the-memcg-pointer-directly-into-struct-page.patch
mm-embed-the-memcg-pointer-directly-into-struct-page-fix.patch
mm-page_cgroup-rename-file-to-mm-swap_cgroupc.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix-2.patch
debugging-keep-track-of-page-owners.patch

