From: akpm@linux-foundation.org
Subject: + memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix.patch added to -mm tree
Date: Mon, 22 Dec 2008 17:31:58 -0800
Message-ID: <200812230131.mBN1VwJN018796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753463AbYLWBcJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Dec 2008 20:32:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     memcg: avoid reclaim_stat oops when disabled
has been added to the -mm tree.  Its filename is
     memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: avoid reclaim_stat oops when disabled
From: Hugh Dickins <hugh@veritas.com>

mem_cgroup_get_reclaim_stat_from_page() oopses in page_cgroup_zoneinfo()
when you boot with cgroup_disabled=memory: it needs to check for that.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix
+++ a/mm/memcontrol.c
@@ -473,9 +473,14 @@ struct zone_reclaim_stat *mem_cgroup_get
 struct zone_reclaim_stat *
 mem_cgroup_get_reclaim_stat_from_page(struct page *page)
 {
-	struct page_cgroup *pc = lookup_page_cgroup(page);
-	struct mem_cgroup_per_zone *mz = page_cgroup_zoneinfo(pc);
+	struct page_cgroup *pc;
+	struct mem_cgroup_per_zone *mz;
 
+	if (mem_cgroup_disabled())
+		return NULL;
+
+	pc = lookup_page_cgroup(page);
+	mz = page_cgroup_zoneinfo(pc);
 	if (!mz)
 		return NULL;
 
_

Patches currently in -mm which might be from hugh@veritas.com are

linux-next.patch
bio-zero-inlined-bio_vec.patch
mm-dont-mark_page_accessed-in-shmem_fault.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
mm-remove-cgroup_mm_owner_callbacks.patch
mm-remove-aop_writepage_activate.patch
mm-remove-gfp_highuser_pagecache.patch
mm-add-setclearpageswapcache-stubs.patch
mm-replace-some-bug_ons-by-vm_bug_ons.patch
mm-add_active_or_unevictable-into-rmap.patch
mm-make-page_lock_anon_vma-static.patch
mm-further-cleanup-page_add_new_anon_rmap.patch
mm-gup-persist-for-write-permission.patch
mm-wp-lock-page-before-deciding-cow.patch
mm-reuse_swap_page-replaces-can_share_swap_page.patch
mm-try_to_free_swap-replaces-remove_exclusive_swap_page.patch
mm-try_to_unuse-check-removing-right-swap.patch
mm-remove-try_to_munlock-from-vmscan.patch
mm-remove-gfp_mask-from-add_to_swap.patch
mm-add-add_to_swap-stub.patch
mm-optimize-get_scan_ratio-for-no-swap.patch
swapfile-swapon-needs-larger-size-type.patch
swapfile-remove-swp_active-mask.patch
swapfile-remove-surplus-whitespace.patch
swapfile-remove-v0-swap-space-message.patch
swapfile-rearrange-scan-and-swap_info.patch
swapfile-swapon-use-discard-trim.patch
swapfile-swap-allocation-use-discard.patch
swapfile-swapon-randomize-if-nonrot.patch
swapfile-swap-allocation-cycle-if-nonrot.patch
swapfile-change-discard-pgoff_t-to-sector_t.patch
swapfile-change-discard-pgoff_t-to-sector_t-fix.patch
swapfile-let-others-seed-random.patch
badpage-simplify-page_alloc-flag-checkclear.patch
badpage-keep-any-bad-page-out-of-circulation.patch
badpage-replace-page_remove_rmap-eeek-and-bug.patch
badpage-vm_normal_page-use-print_bad_pte.patch
badpage-zap-print_bad_pte-on-swap-and-file.patch
badpage-remove-vma-from-page_remove_rmap.patch
badpage-ratelimit-print_bad_pte-and-bad_page.patch
badpage-kern_alert-bug-instead-of-kern_emerg.patch
hugetlb-unsigned-ret-cannot-be-negative.patch
mm-make-get_user_pages-interruptible.patch
mm-make-get_user_pages-interruptible-mmotm-ignore-sigkill-in-get_user_pages-during-munlock.patch
shmem-unify-regular-and-tiny-shmem.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-mmapc-fix-coding-style.patch
mm-mmapc-fix-coding-style-fix.patch
introduce-get_mm_hiwater_xxx-fix-taskstats-hiwater_xxx-accounting.patch
mm-shmemc-fix-division-by-zero.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-explain-details-and-test-document.patch
memcg-fix-swap-accounting-leak-v3.patch
memcg-fix-swap-accounting-leak-doc-fix.patch
memcg-fix-shmems-swap-accounting.patch
prio_tree-debugging-patch.patch

