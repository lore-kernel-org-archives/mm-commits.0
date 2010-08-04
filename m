From: akpm@linux-foundation.org
Subject: + mm-fix-corruption-of-hibernation-caused-by-reusing-swap-during-image-saving.patch added to -mm tree
Date: Wed, 04 Aug 2010 15:30:32 -0700
Message-ID: <201008042230.o74MUWfe013851@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757837Ab0HDWaq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Aug 2010 18:30:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, andrea.gelmini@gmail.com, hughd@google.com, linux@rainbow-software.org, rjw@sisk.pl, stable@kernel.org


The patch titled
     mm: fix corruption of hibernation caused by reusing swap during image saving
has been added to the -mm tree.  Its filename is
     mm-fix-corruption-of-hibernation-caused-by-reusing-swap-during-image-saving.patch

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
Subject: mm: fix corruption of hibernation caused by reusing swap during image saving
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Since 2.6.31, swap_map[]'s refcounting was changed to show that a used
swap entry is just for swap-cache, can be reused.  Then, while scanning
free entry in swap_map[], a swap entry may be able to be reclaimed and
reused.  It was caused by commit c9e444103b5e7a5 ("mm: reuse unused swap
entry if necessary").

But this caused deta corruption at resume. The scenario is

- Assume a clean-swap cache, but mapped.

- at hibernation_snapshot[], clean-swap-cache is saved as
  clean-swap-cache and swap_map[] is marked as SWAP_HAS_CACHE.

- then, save_image() is called.  And reuse SWAP_HAS_CACHE entry to save
  image, and break the contents.

After resume:

- the memory reclaim runs and finds clean-not-referenced-swap-cache and
  discards it because it's marked as clean.  But here, the contents on
  disk and swap-cache is inconsistent.

Hance memory is corrupted.

This patch avoids the bug by not reclaiming swap-entry during hibernation.
This is a quick fix for backporting.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Reported-by: Ondreg Zary <linux@rainbow-software.org>
Tested-by: Andrea Gelmini <andrea.gelmini@gmail.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/swapfile.c~mm-fix-corruption-of-hibernation-caused-by-reusing-swap-during-image-saving mm/swapfile.c
--- a/mm/swapfile.c~mm-fix-corruption-of-hibernation-caused-by-reusing-swap-during-image-saving
+++ a/mm/swapfile.c
@@ -318,8 +318,10 @@ checks:
 	if (offset > si->highest_bit)
 		scan_base = offset = si->lowest_bit;
 
-	/* reuse swap entry of cache-only swap if not busy. */
-	if (vm_swap_full() && si->swap_map[offset] == SWAP_HAS_CACHE) {
+	/* reuse swap entry of cache-only swap if not hibernation. */
+	if (vm_swap_full()
+		&& usage == SWAP_HAS_CACHE
+		&& si->swap_map[offset] == SWAP_HAS_CACHE) {
 		int swap_was_freed;
 		spin_unlock(&swap_lock);
 		swap_was_freed = __try_to_reclaim_swap(si, offset);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

linux-next.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
mm-rename-anon_vma_lock-to-vma_lock_anon_vma.patch
mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function.patch
mm-track-the-root-oldest-anon_vma.patch
mm-always-lock-the-root-oldest-anon_vma.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root-fix.patch
oom-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch
oom-avoid-sending-exiting-tasks-a-sigkill.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-enable-oom-tasklist-dump-by-default.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-extract-panic-helper-function.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-move-sysctl-declarations-to-oomh.patch
oom-remove-unnecessary-code-and-cleanup.patch
mm-rename-try_set_zone_oom-to-try_set_zonelist_oom.patch
oom-remove-constraint-argument-from-select_bad_process-and-__out_of_memory.patch
oom-fold-__out_of_memory-into-out_of_memory.patch
mm-use-for_each_online_cpu-in-vmstat.patch
mempolicy-reduce-stack-size-of-migrate_pages.patch
mempolicy-reduce-stack-size-of-migrate_pages-fix.patch
rmap-always-use-anon_vma-root-pointer-fix-false-positive-bug_on-in-__page_set_anon_rmap.patch
rmap-always-use-anon_vma-root-pointer-fix-false-positive-bug_on-in-__page_set_anon_rmap-checkpatch-fixes.patch
vmscan-tracing-add-trace-events-for-kswapd-wakeup-sleeping-and-direct-reclaim.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation.patch
vmscan-tracing-add-trace-event-when-a-page-is-written.patch
vmscan-tracing-add-trace-event-when-a-page-is-written-update-trace-event-to-track-if-page-reclaim-io-is-for-anon-or-file-pages.patch
vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events.patch
vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events-update-post-processing-script-to-distinguish-between-anon-and-file-io-from-page-reclaim.patch
vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events-correct-units-in-post-processing-script.patch
vmscan-kill-prev_priority-completely.patch
vmscan-simplify-shrink_inactive_list.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages.patch
vmscan-set-up-pagevec-as-late-as-possible-in-shrink_inactive_list.patch
vmscan-set-up-pagevec-as-late-as-possible-in-shrink_page_list.patch
vmscan-update-isolated-page-counters-outside-of-main-path-in-shrink_inactive_list.patch
oom-dont-try-to-kill-oom_unkillable-child.patch
oom-oom_kill_process-doesnt-select-kthread-child.patch
oom-make-oom_unkillable_task-helper-function.patch
oom-oom_kill_process-needs-to-check-that-p-is-unkillable.patch
oom-proc-pid-oom_score-treat-kernel-thread-honestly.patch
oom-kill-duplicate-oom_disable-check.patch
oom-move-oom_disable-check-from-oom_kill_task-to-out_of_memory.patch
oom-cleanup-has_intersects_mems_allowed.patch
oom-remove-child-mm-check-from-oom_kill_process.patch
oom-give-the-dying-task-a-higher-priority.patch
oom-multi-threaded-process-coredump-dont-make-deadlock.patch
oom-move-badness-declaration-into-oomh.patch
oom-move-badness-declaration-into-oomh-fix.patch
oom-badness-heuristic-rewrite.patch
oom-deprecate-oom_adj-tunable.patch
vmscan-convert-direct-reclaim-tracepoint-to-define_trace.patch
memcg-vmscan-add-memcg-reclaim-tracepoint.patch
vmscan-convert-mm_vmscan_lru_isolate-to-define_event.patch
memcg-add-mm_vmscan_memcg_isolate-tracepoint.patch
vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages.patch
mm-fix-corruption-of-hibernation-caused-by-reusing-swap-during-image-saving.patch
hibernation-freeze-swap-at-hibernation-v2.patch
cgroups-save-space-for-the-terminator.patch
memcg-remove-experimental-from-swap-account-config.patch
memcg-clean-up-try_charge-main-loop-v2.patch
memcg-clean-up-waiting-move-acct-v2.patch
memcg-clean-up-waiting-move-acct-v2-fix.patch
memcg-remove-redundant-codes.patch
memcg-remove-mem-from-arg-of-charge_common.patch
memcg-use-find_lock_task_mm-in-memory-cgroups-oom.patch
memcg-avoid-css_get.patch
memcg-scnr_to_reclaim-should-be-initialized.patch
memcg-kill-unnecessary-initialization-in-mem_cgroup_shrink_node_zone.patch
memcg-mem_cgroup_shrink_node_zone-doesnt-need-scnodemask.patch
memcg-remove-nid-and-zid-argument-from-mem_cgroup_soft_limit_reclaim.patch
memcg-convert-to-use-zone_to_nid-from-bare-zone-zone_pgdat-node_id.patch

