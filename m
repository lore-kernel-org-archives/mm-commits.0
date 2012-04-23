From: akpm@linux-foundation.org
Subject: + mm-fix-s390-bug-by-__set_page_dirty_no_writeback-on-swap.patch added to -mm tree
Date: Mon, 23 Apr 2012 13:43:51 -0700
Message-ID: <20120423204352.3A42AA00AE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:45371 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046Ab2DWUnx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Apr 2012 16:43:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, heiko.carstens@de.ibm.com, kenchen@google.com, mgorman@suse.de, riel@redhat.com, schwidefsky@de.ibm.com, stable@vger.kernel.org


The patch titled
     Subject: mm: fix s390 BUG by __set_page_dirty_no_writeback on swap
has been added to the -mm tree.  Its filename is
     mm-fix-s390-bug-by-__set_page_dirty_no_writeback-on-swap.patch

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
Subject: mm: fix s390 BUG by __set_page_dirty_no_writeback on swap

Mel reports a BUG_ON(slot == NULL) in radix_tree_tag_set() on s390 3.0.13:
called from __set_page_dirty_nobuffers() when page_remove_rmap() tries to
transfer dirty flag from s390 storage key to struct page and radix_tree.

That would be because of reclaim's shrink_page_list() calling
add_to_swap() on this page at the same time: first PageSwapCache is set
(causing page_mapping(page) to appear as &swapper_space), then
page->private set, then tree_lock taken, then page inserted into
radix_tree - so there's an interval before taking the lock when the
radix_tree slot is empty.

We could fix this by moving __add_to_swap_cache()'s spin_lock_irq up
before the SetPageSwapCache.  But a better fix is simply to do what's five
years overdue: Ken Chen introduced __set_page_dirty_no_writeback() (if
!PageDirty TestSetPageDirty) for tmpfs to skip all the radix_tree
overhead, and swap is just the same - it ignores the radix_tree tag, and
does not participate in dirty page accounting, so should be using
__set_page_dirty_no_writeback() too.

s390 testing now confirms that this does indeed fix the problem.

Reported-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ken Chen <kenchen@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swap_state.c~mm-fix-s390-bug-by-__set_page_dirty_no_writeback-on-swap mm/swap_state.c
--- a/mm/swap_state.c~mm-fix-s390-bug-by-__set_page_dirty_no_writeback-on-swap
+++ a/mm/swap_state.c
@@ -26,7 +26,7 @@
  */
 static const struct address_space_operations swap_aops = {
 	.writepage	= swap_writepage,
-	.set_page_dirty	= __set_page_dirty_nobuffers,
+	.set_page_dirty	= __set_page_dirty_no_writeback,
 	.migratepage	= migrate_page,
 };
 
_
Subject: Subject: mm: fix s390 BUG by __set_page_dirty_no_writeback on swap

Patches currently in -mm which might be from hughd@google.com are

linux-next.patch
mm-fix-up-the-vmscan-stat-in-vmstat.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
mm-correctly-synchronize-rss-counters-at-exit-exec-fix.patch
mm-correctly-synchronize-rss-counters-at-exit-exec-set-task-exit-code-before-complete_vfork_done.patch
revert-proc-clear_refs-do-not-clear-reserved-pages.patch
mm-fix-null-ptr-dereference-in-migrate_pages.patch
mm-fix-null-ptr-dereference-in-move_pages.patch
mm-fix-s390-bug-by-__set_page_dirty_no_writeback-on-swap.patch
kvm-dont-call-mmu_shrinker-w-o-used_mmu_pages.patch
mm-remove-swap-token-code.patch
mm-vmscan-remove-lumpy-reclaim.patch
mm-vmscan-do-not-stall-on-writeback-during-memory-compaction.patch
mm-vmscan-remove-reclaim_mode_t.patch
memcg-fix-change-behavior-of-shared-anon-at-moving-task.patch
memcg-swap-mem_cgroup_move_swap_account-never-needs-fixup.patch
memcg-swap-use-mem_cgroup_uncharge_swap.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
mm-huge_memoryc-use-lockdep_assert_held.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-unify-ptrace_may_access-locking-code.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch
proc-use-is_err_or_null.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
prio_tree-debugging-patch.patch

