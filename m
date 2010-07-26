From: akpm@linux-foundation.org
Subject: + rmap-always-use-anon_vma-root-pointer-fix-false-positive-bug_on-in-__page_set_anon_rmap.patch added to -mm tree
Date: Mon, 26 Jul 2010 13:46:16 -0700
Message-ID: <201007262046.o6QKkHcn009052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56824 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608Ab0GZUrF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jul 2010 16:47:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, aarcange@redhat.com, riel@redhat.com


The patch titled
     Fix false positive BUG_ON in __page_set_anon_rmap
has been added to the -mm tree.  Its filename is
     rmap-always-use-anon_vma-root-pointer-fix-false-positive-bug_on-in-__page_set_anon_rmap.patch

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
Subject: Fix false positive BUG_ON in __page_set_anon_rmap
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Problem: wrong BUG_ON() in  __page_set_anon_rmap().
Kernel version: mmotm-0719

How to reproduce:
  create a small cgroup
  # mount -t cgroup none /cgroup -o memory
  # mkdir /cgroup/A
  # echo 30M > /cgroup/A/memory.limit_in_bytes

and run a malloc() program to cause swap-in v.s. swap-out ping-pong.

Description:
  Even if SwapCache is fully unmapped and mapcount goes down to 0,
  page->mapping is not cleared and will remain on memory until kswapd or some
  finds it. If a thread cause a page fault onto such "unmapped-but-not-discarded"
  swapcache, it will see a swap cache whose mapcount is 0 but page->mapping has a
  valid value.

  When it's reused at do_swap_page(), __page_set_anon_rmap() is called with
  "exclusive==1" and hits BUG_ON(). But this BUG_ON() is wrong. Nothing bad
  with rmapping a page which has page->mapping isn't 0.

Log:
Jul 22 16:06:02 ubuntu kernel: [  892.542485]
Jul 22 16:06:02 ubuntu kernel: [  892.542488] Pid: 2951, comm: malloc Not tainted 2.6.35-rc5-mm1 #3 440BX Desktop Reference Platform/VMware Virtual Platform
Jul 22 16:06:02 ubuntu kernel: [  892.542491] RIP: 0010:[<ffffffff810e676c>]  [<ffffffff810e676c>] __page_set_anon_rmap+0x39/0x54
Jul 22 16:06:02 ubuntu kernel: [  892.542503] RSP: 0000:ffff880056a31dd8  EFLAGS: 00010202
Jul 22 16:06:02 ubuntu kernel: [  892.542505] RAX: ffff880059be7810 RBX: ffffea0001228038 RCX: ffff880059be7801
Jul 22 16:06:02 ubuntu kernel: [  892.542507] RDX: 0000000002823000 RSI: ffff8800569c5580 RDI: ffff8800569c5580
Jul 22 16:06:02 ubuntu kernel: [  892.542509] RBP: ffff880056a31de8 R08: ffff880056a31db8 R09: 00000000ffffffec
Jul 22 16:06:02 ubuntu kernel: [  892.542511] R10: ffff880056a31ec0 R11: ffffffff00000000 R12: ffff8800569c5580
Jul 22 16:06:02 ubuntu kernel: [  892.542514] R13: 0000000000000001 R14: 0000000000000008 R15: ffffea0001228038
Jul 22 16:06:02 ubuntu kernel: [  892.542517] FS:  00007f8c8d618700(0000) GS:ffff880001e00000(0000) knlGS:0000000000000000
Jul 22 16:06:02 ubuntu kernel: [  892.542520] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jul 22 16:06:02 ubuntu kernel: [  892.542522] CR2: 0000000002823000 CR3: 00000000607e2000 CR4: 00000000000006f0
Jul 22 16:06:02 ubuntu kernel: [  892.542527] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jul 22 16:06:02 ubuntu kernel: [  892.542532] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jul 22 16:06:02 ubuntu kernel: [  892.542535] Process malloc (pid: 2951, threadinfo ffff880056a30000, task ffff880037b796d0)
Jul 22 16:06:02 ubuntu kernel: [  892.542538]  ffff880056a31de8 ffffea0001228038 ffff880056a31e28 ffffffff810e6b3f
Jul 22 16:06:02 ubuntu kernel: [  892.542544] <0> ffff880000000001 0000000002823000 ffff8800569c5580 ffff8800569c5580
Jul 22 16:06:02 ubuntu kernel: [  892.542548] <0> ffff88005ed2f0a0 ffff88006359e300 ffff880056a31ef8 ffffffff810e07b8
Jul 22 16:06:02 ubuntu kernel: [  892.542556]  [<ffffffff810e6b3f>] do_page_add_anon_rmap+0x62/0x6d
Jul 22 16:06:02 ubuntu kernel: [  892.542560]  [<ffffffff810e07b8>] handle_mm_fault+0x716/0x8d7
Jul 22 16:06:02 ubuntu kernel: [  892.542567]  [<ffffffff8100870a>] ? __switch_to+0x215/0x227
Jul 22 16:06:02 ubuntu kernel: [  892.542571]  [<ffffffff81040d03>] ? pick_next_task_fair+0xdb/0xec
Jul 22 16:06:02 ubuntu kernel: [  892.542576]  [<ffffffff8144e42a>] ? schedule+0x589/0x5db
Jul 22 16:06:02 ubuntu kernel: [  892.542579]  [<ffffffff81453192>] do_page_fault+0x2c4/0x2dc
Jul 22 16:06:02 ubuntu kernel: [  892.542582]  [<ffffffff814502b5>] page_fault+0x25/0x30
Jul 22 16:06:02 ubuntu kernel: [  892.542619]  RSP <ffff880056a31dd8>
Jul 22 16:06:02 ubuntu kernel: [  892.542622] ---[ end trace 3e21bbaadd2d0799 ]---

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN mm/rmap.c~rmap-always-use-anon_vma-root-pointer-fix-false-positive-bug_on-in-__page_set_anon_rmap mm/rmap.c
--- a/mm/rmap.c~rmap-always-use-anon_vma-root-pointer-fix-false-positive-bug_on-in-__page_set_anon_rmap
+++ a/mm/rmap.c
@@ -782,8 +782,16 @@ static void __page_set_anon_rmap(struct 
 		if (PageAnon(page))
 			return;
 		anon_vma = anon_vma->root;
-	} else
-		BUG_ON(PageAnon(page));
+	} else {
+		/*
+ 		 * In this case, swapped-out-but-not-discarded swap-cache
+ 		 * is remapped. So, no need to update page->mapping here.
+ 		 * We convice anon_vma poitned by page->mapping is not obsolete
+ 		 * because vma->anon_vma is necessary to be a family of it.
+ 		 */
+		if (PageAnon(page))
+			return;
+	}
 
 	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
 	page->mapping = (struct address_space *) anon_vma;
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
vmscan-tracing-add-trace-events-for-kswapd-wakeup-sleeping-and-direct-reclaim.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation.patch
vmscan-tracing-add-trace-event-when-a-page-is-written.patch
vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events.patch
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
cgroups-save-space-for-the-terminator.patch
memcg-remove-experimental-from-swap-account-config.patch
memcg-clean-up-try_charge-main-loop-v2.patch
memcg-clean-up-waiting-move-acct-v2.patch
memcg-clean-up-waiting-move-acct-v2-fix.patch
memcg-remove-redundant-codes.patch
memcg-remove-mem-from-arg-of-charge_common.patch
memcg-use-find_lock_task_mm-in-memory-cgroups-oom.patch
memcg-avoid-css_get.patch

