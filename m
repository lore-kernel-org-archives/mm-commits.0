From: akpm@linux-foundation.org
Subject: + hibernation-freeze-swap-at-hibernation-v2.patch added to -mm tree
Date: Wed, 04 Aug 2010 15:22:18 -0700
Message-ID: <201008042222.o74MMIj8013492@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751831Ab0HDWXn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Aug 2010 18:23:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, aarcange@redhat.com, balbir@in.ibm.com, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, linux@rainbow-software.org, rjw@sisk.pl


The patch titled
     hibernation: freeze swap at hibernation
has been added to the -mm tree.  Its filename is
     hibernation-freeze-swap-at-hibernation-v2.patch

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
Subject: hibernation: freeze swap at hibernation
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

When taking a memory snapshot in hibernate_snapshot(), all (directly
called) memory allocations use GFP_ATOMIC.  Hence swap misusage during
hibernation never occurs.

But from a pessimistic point of view, there is no guarantee that no page
allcation has __GFP_WAIT.  It is better to have a global indication "we
enter hibernation, don't use swap!".

This patch tries to freeze new-swap-allocation during hibernation.  (All
user processes are frozenm so swapin is not a concern).

This way, no updates will happen to swap_map[] between
hibernate_snapshot() and save_image().  Swap is thawed when swsusp_free()
is called.  We can be assured that swap corruption will not occur.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Hugh Dickins <hughd@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ondrej Zary <linux@rainbow-software.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h     |    8 ++-
 kernel/power/hibernate.c |    1 
 kernel/power/snapshot.c  |    1 
 kernel/power/swap.c      |    6 +-
 mm/swapfile.c            |   94 ++++++++++++++++++++++++++++---------
 5 files changed, 84 insertions(+), 26 deletions(-)

diff -puN include/linux/swap.h~hibernation-freeze-swap-at-hibernation-v2 include/linux/swap.h
--- a/include/linux/swap.h~hibernation-freeze-swap-at-hibernation-v2
+++ a/include/linux/swap.h
@@ -316,7 +316,6 @@ extern long nr_swap_pages;
 extern long total_swap_pages;
 extern void si_swapinfo(struct sysinfo *);
 extern swp_entry_t get_swap_page(void);
-extern swp_entry_t get_swap_page_of_type(int);
 extern int valid_swaphandles(swp_entry_t, unsigned long *);
 extern int add_swap_count_continuation(swp_entry_t, gfp_t);
 extern void swap_shmem_alloc(swp_entry_t);
@@ -333,6 +332,13 @@ extern int reuse_swap_page(struct page *
 extern int try_to_free_swap(struct page *);
 struct backing_dev_info;
 
+#ifdef CONFIG_HIBERNATION
+void hibernation_freeze_swap(void);
+void hibernation_thaw_swap(void);
+swp_entry_t get_swap_for_hibernation(int type);
+void swap_free_for_hibernation(swp_entry_t val);
+#endif
+
 /* linux/mm/thrash.c */
 extern struct mm_struct *swap_token_mm;
 extern void grab_swap_token(struct mm_struct *);
diff -puN kernel/power/hibernate.c~hibernation-freeze-swap-at-hibernation-v2 kernel/power/hibernate.c
--- a/kernel/power/hibernate.c~hibernation-freeze-swap-at-hibernation-v2
+++ a/kernel/power/hibernate.c
@@ -338,6 +338,7 @@ int hibernation_snapshot(int platform_mo
 		goto Close;
 
 	suspend_console();
+	hibernation_freeze_swap();
 	saved_mask = clear_gfp_allowed_mask(GFP_IOFS);
 	error = dpm_suspend_start(PMSG_FREEZE);
 	if (error)
diff -puN kernel/power/snapshot.c~hibernation-freeze-swap-at-hibernation-v2 kernel/power/snapshot.c
--- a/kernel/power/snapshot.c~hibernation-freeze-swap-at-hibernation-v2
+++ a/kernel/power/snapshot.c
@@ -1086,6 +1086,7 @@ void swsusp_free(void)
 	buffer = NULL;
 	alloc_normal = 0;
 	alloc_highmem = 0;
+	hibernation_thaw_swap();
 }
 
 /* Helper functions used for the shrinking of memory. */
diff -puN kernel/power/swap.c~hibernation-freeze-swap-at-hibernation-v2 kernel/power/swap.c
--- a/kernel/power/swap.c~hibernation-freeze-swap-at-hibernation-v2
+++ a/kernel/power/swap.c
@@ -135,10 +135,10 @@ sector_t alloc_swapdev_block(int swap)
 {
 	unsigned long offset;
 
-	offset = swp_offset(get_swap_page_of_type(swap));
+	offset = swp_offset(get_swap_for_hibernation(swap));
 	if (offset) {
 		if (swsusp_extents_insert(offset))
-			swap_free(swp_entry(swap, offset));
+			swap_free_for_hibernation(swp_entry(swap, offset));
 		else
 			return swapdev_block(swap, offset);
 	}
@@ -162,7 +162,7 @@ void free_all_swap_pages(int swap)
 		ext = container_of(node, struct swsusp_extent, node);
 		rb_erase(node, &swsusp_extents);
 		for (offset = ext->start; offset <= ext->end; offset++)
-			swap_free(swp_entry(swap, offset));
+			swap_free_for_hibernation(swp_entry(swap, offset));
 
 		kfree(ext);
 	}
diff -puN mm/swapfile.c~hibernation-freeze-swap-at-hibernation-v2 mm/swapfile.c
--- a/mm/swapfile.c~hibernation-freeze-swap-at-hibernation-v2
+++ a/mm/swapfile.c
@@ -47,6 +47,8 @@ long nr_swap_pages;
 long total_swap_pages;
 static int least_priority;
 
+static bool swap_for_hibernation;
+
 static const char Bad_file[] = "Bad swap file entry ";
 static const char Unused_file[] = "Unused swap file entry ";
 static const char Bad_offset[] = "Bad swap offset entry ";
@@ -449,6 +451,8 @@ swp_entry_t get_swap_page(void)
 	spin_lock(&swap_lock);
 	if (nr_swap_pages <= 0)
 		goto noswap;
+	if (swap_for_hibernation)
+		goto noswap;
 	nr_swap_pages--;
 
 	for (type = swap_list.next; type >= 0 && wrapped < 2; type = next) {
@@ -481,28 +485,6 @@ noswap:
 	return (swp_entry_t) {0};
 }
 
-/* The only caller of this function is now susupend routine */
-swp_entry_t get_swap_page_of_type(int type)
-{
-	struct swap_info_struct *si;
-	pgoff_t offset;
-
-	spin_lock(&swap_lock);
-	si = swap_info[type];
-	if (si && (si->flags & SWP_WRITEOK)) {
-		nr_swap_pages--;
-		/* This is called for allocating swap entry, not cache */
-		offset = scan_swap_map(si, 1);
-		if (offset) {
-			spin_unlock(&swap_lock);
-			return swp_entry(type, offset);
-		}
-		nr_swap_pages++;
-	}
-	spin_unlock(&swap_lock);
-	return (swp_entry_t) {0};
-}
-
 static struct swap_info_struct *swap_info_get(swp_entry_t entry)
 {
 	struct swap_info_struct *p;
@@ -762,6 +744,74 @@ int mem_cgroup_count_swap_user(swp_entry
 #endif
 
 #ifdef CONFIG_HIBERNATION
+
+static pgoff_t hibernation_offset[MAX_SWAPFILES];
+/*
+ * Once hibernation starts to use swap, we freeze swap_map[]. Otherwise,
+ * saved swap_map[] image to the disk will be an incomplete because it's
+ * changing without synchronization with hibernation snap shot.
+ * At resume, we just make swap_for_hibernation=false. We can forget
+ * used maps easily.
+ */
+void hibernation_freeze_swap(void)
+{
+	int i;
+
+	spin_lock(&swap_lock);
+
+	printk(KERN_INFO "PM: Freeze Swap\n");
+	swap_for_hibernation = true;
+	for (i = 0; i < MAX_SWAPFILES; i++)
+		hibernation_offset[i] = 1;
+	spin_unlock(&swap_lock);
+}
+
+void hibernation_thaw_swap(void)
+{
+	spin_lock(&swap_lock);
+	if (swap_for_hibernation) {
+		printk(KERN_INFO "PM: Thaw Swap\n");
+		swap_for_hibernation = false;
+	}
+	spin_unlock(&swap_lock);
+}
+
+/*
+ * Because updateing swap_map[] can make not-saved-status-change,
+ * we use our own easy allocator.
+ * Please see kernel/power/swap.c, Used swaps are recorded into
+ * RB-tree.
+ */
+swp_entry_t get_swap_for_hibernation(int type)
+{
+	pgoff_t off;
+	swp_entry_t val = {0};
+	struct swap_info_struct *si;
+
+	spin_lock(&swap_lock);
+
+	si = swap_info[type];
+	if (!si || !(si->flags & SWP_WRITEOK))
+		goto done;
+
+	for (off = hibernation_offset[type]; off < si->max; ++off) {
+		if (!si->swap_map[off])
+			break;
+	}
+	if (off < si->max) {
+		val = swp_entry(type, off);
+		hibernation_offset[type] = off + 1;
+	}
+done:
+	spin_unlock(&swap_lock);
+	return val;
+}
+
+void swap_free_for_hibernation(swp_entry_t ent)
+{
+	/* Nothing to do */
+}
+
 /*
  * Find the swap type that corresponds to given device (if any).
  *
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

