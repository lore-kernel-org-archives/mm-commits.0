From: akpm@linux-foundation.org
Subject: [folded] mm-correctly-synchronize-rss-counters-at-exit-exec-set-task-exit-code-before-complete_vfork_done.patch removed from -mm tree
Date: Wed, 25 Apr 2012 13:00:29 -0700
Message-ID: <20120425200029.9AF0AA038B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:48570 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758548Ab2DYUAa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Apr 2012 16:00:30 -0400
Received: by qabg24 with SMTP id g24so201140qab.1
        for <mm-commits@vger.kernel.org>; Wed, 25 Apr 2012 13:00:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, markus@trippelsdorf.de, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: set task exit code before complete_vfork_done()
has been removed from the -mm tree.  Its filename was
     mm-correctly-synchronize-rss-counters-at-exit-exec-set-task-exit-code-before-complete_vfork_done.patch

This patch was dropped because it was folded into mm-correctly-synchronize-rss-counters-at-exit-exec.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm: set task exit code before complete_vfork_done()

kthread_stop() uses task->vfork_done for synchronization.  The exiting
kthread shouldn't do complete_vfork_done() until it sets ->exit_code.

fix for mm-correctly-synchronize-rss-counters-at-exit-exec.patch

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/exit.c~mm-correctly-synchronize-rss-counters-at-exit-exec-set-task-exit-code-before-complete_vfork_done kernel/exit.c
--- a/kernel/exit.c~mm-correctly-synchronize-rss-counters-at-exit-exec-set-task-exit-code-before-complete_vfork_done
+++ a/kernel/exit.c
@@ -960,6 +960,9 @@ void do_exit(long code)
 
 	acct_update_integrals(tsk);
 
+	/* Set exit_code before complete_vfork_done() in mm_release() */
+	tsk->exit_code = code;
+
 	/* Release mm and sync mm's RSS info before statistics gathering */
 	mm_release(tsk, tsk->mm);
 
@@ -975,7 +978,6 @@ void do_exit(long code)
 		tty_audit_exit();
 	audit_free(tsk);
 
-	tsk->exit_code = code;
 	taskstats_exit(tsk, group_dead);
 
 	exit_mm(tsk);
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

mm-hugetlb-fix-warning-in-alloc_huge_page-dequeue_huge_page_vma.patch
linux-next.patch
mm-remove-swap-token-code.patch
mm-vmscan-remove-lumpy-reclaim.patch
mm-vmscan-do-not-stall-on-writeback-during-memory-compaction.patch
mm-vmscan-remove-reclaim_mode_t.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
mm-memcg-scanning_global_lru-means-mem_cgroup_disabled.patch
mm-memcg-move-reclaim_stat-into-lruvec.patch
mm-push-lru-index-into-shrink_active_list.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
mm-mark-mm-inline-functions-as-__always_inline.patch
mm-remove-lru-type-checks-from-__isolate_lru_page.patch
mm-memcg-kill-mem_cgroup_lru_del.patch
mm-memcg-use-vm_swappiness-from-target-memory-cgroup.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch

