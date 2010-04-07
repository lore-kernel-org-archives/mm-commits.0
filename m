From: akpm@linux-foundation.org
Subject: [merged] exit-fix-oops-in-sync_mm_rss.patch removed from -mm tree
Date: Wed, 07 Apr 2010 11:49:24 -0400
Message-ID: <201004071850.o37IooiE001236@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753576Ab0DGSvI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Apr 2010 14:51:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, aarcange@redhat.com, minchan.kim@gmail.com, mst@redhat.com, riel@redhat.com, tlb@rapanden.dk, mm-commits@vger.kernel.org


The patch titled
     mm: avoid null-pointer deref in sync_mm_rss()
has been removed from the -mm tree.  Its filename was
     exit-fix-oops-in-sync_mm_rss.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: avoid null-pointer deref in sync_mm_rss()
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

- We weren't zeroing p->rss_stat[] at fork()

- Consequently sync_mm_rss() was dereferencing tsk->mm for kernel
  threads and was oopsing.

- Make __sync_task_rss_stat() static, too.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=15648

[akpm@linux-foundation.org: remove the BUG_ON(!mm->rss)]
Reported-by: Troels Liebe Bentsen <tlb@rapanden.dk>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
"Michael S. Tsirkin" <mst@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>                            
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    3 ++-
 kernel/fork.c |    3 +++
 mm/memory.c   |    3 +--
 3 files changed, 6 insertions(+), 3 deletions(-)

diff -puN kernel/exit.c~exit-fix-oops-in-sync_mm_rss kernel/exit.c
--- a/kernel/exit.c~exit-fix-oops-in-sync_mm_rss
+++ a/kernel/exit.c
@@ -953,7 +953,8 @@ NORET_TYPE void do_exit(long code)
 
 	acct_update_integrals(tsk);
 	/* sync mm's RSS info before statistics gathering */
-	sync_mm_rss(tsk, tsk->mm);
+	if (tsk->mm)
+		sync_mm_rss(tsk, tsk->mm);
 	group_dead = atomic_dec_and_test(&tsk->signal->live);
 	if (group_dead) {
 		hrtimer_cancel(&tsk->signal->real_timer);
diff -puN kernel/fork.c~exit-fix-oops-in-sync_mm_rss kernel/fork.c
--- a/kernel/fork.c~exit-fix-oops-in-sync_mm_rss
+++ a/kernel/fork.c
@@ -1052,6 +1052,9 @@ static struct task_struct *copy_process(
 	p->prev_utime = cputime_zero;
 	p->prev_stime = cputime_zero;
 #endif
+#if defined(SPLIT_RSS_COUNTING)
+	memset(&p->rss_stat, 0, sizeof(p->rss_stat));
+#endif
 
 	p->default_timer_slack_ns = current->timer_slack_ns;
 
diff -puN mm/memory.c~exit-fix-oops-in-sync_mm_rss mm/memory.c
--- a/mm/memory.c~exit-fix-oops-in-sync_mm_rss
+++ a/mm/memory.c
@@ -125,13 +125,12 @@ core_initcall(init_zero_pfn);
 
 #if defined(SPLIT_RSS_COUNTING)
 
-void __sync_task_rss_stat(struct task_struct *task, struct mm_struct *mm)
+static void __sync_task_rss_stat(struct task_struct *task, struct mm_struct *mm)
 {
 	int i;
 
 	for (i = 0; i < NR_MM_COUNTERS; i++) {
 		if (task->rss_stat.count[i]) {
-			BUG_ON(!mm);
 			add_mm_counter(mm, i, task->rss_stat.count[i]);
 			task->rss_stat.count[i] = 0;
 		}
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
linux-next.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
mm-remove-return-value-of-putback_lru_pages.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-badness-heuristic-rewrite.patch
oom-deprecate-oom_adj-tunable.patch
oom-replace-sysctls-with-quick-mode.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-remove-unnecessary-code-and-cleanup.patch
oom-default-to-killing-current-for-pagefault-ooms.patch
oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit.patch
oom-hold-tasklist_lock-when-dumping-tasks.patch
oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch
oom-avoid-sending-exiting-tasks-a-sigkill.patch
oom-clean-up-oom_kill_task.patch
oom-clean-up-oom_badness.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
mm-migration-take-a-reference-to-the-anon_vma-before-migrating.patch
mm-migration-do-not-try-to-migrate-unmapped-anonymous-pages.patch
mm-share-the-anon_vma-ref-counts-between-ksm-and-page-migration.patch
mm-allow-config_migration-to-be-set-without-config_numa-or-memory-hot-remove.patch
mm-export-unusable-free-space-index-via-proc-unusable_index.patch
mm-export-fragmentation-index-via-proc-extfrag_index.patch
mm-move-definition-for-lru-isolation-modes-to-a-header.patch
mm-compaction-memory-compaction-core.patch
mm-compaction-add-proc-trigger-for-memory-compaction.patch
mm-compaction-add-sys-trigger-for-per-node-memory-compaction.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails.patch
mm-compaction-add-a-tunable-that-decides-when-memory-should-be-compacted-and-when-it-should-be-reclaimed.patch
mm-compaction-do-not-compact-within-a-preferred-zone-after-a-compaction-failure.patch
mm-migration-allow-the-migration-of-pageswapcache-pages.patch
memcg-oom-wakeup-filter.patch
memcg-oom-wakeup-filter-update.patch
memcg-oom-notifier.patch
memcg-oom-notifier-update.patch
memcg-oom-kill-disable-and-oom-status.patch
memcg-oom-kill-disable-and-oom-status-update.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch

