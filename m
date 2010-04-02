From: akpm@linux-foundation.org
Subject: + oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch added to -mm tree
Date: Fri, 02 Apr 2010 15:25:53 -0700
Message-ID: <201004022225.o32MPred008836@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755564Ab0DBW0h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Apr 2010 18:26:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, riel@redhat.com


The patch titled
     oom: give current access to memory reserves if it has been killed
has been added to the -mm tree.  Its filename is
     oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch

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
Subject: oom: give current access to memory reserves if it has been killed
From: David Rientjes <rientjes@google.com>

It's possible to livelock the page allocator if a thread has mm->mmap_sem
and fails to make forward progress because the oom killer selects another
thread sharing the same ->mm to kill that cannot exit until the semaphore
is dropped.

The oom killer will not kill multiple tasks at the same time; each oom
killed task must exit before another task may be killed.  Thus, if one
thread is holding mm->mmap_sem and cannot allocate memory, all threads
sharing the same ->mm are blocked from exiting as well.  In the oom kill
case, that means the thread holding mm->mmap_sem will never free
additional memory since it cannot get access to memory reserves and the
thread that depends on it with access to memory reserves cannot exit
because it cannot acquire the semaphore.  Thus, the page allocators
livelocks.

When the oom killer is called and current happens to have a pending
SIGKILL, this patch automatically gives it access to memory reserves and
returns.  Upon returning to the page allocator, its allocation will
hopefully succeed so it can quickly exit and free its memory.  If not, the
page allocator will fail the allocation if it is not __GFP_NOFAIL.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN mm/oom_kill.c~oom-give-current-access-to-memory-reserves-if-it-has-been-killed mm/oom_kill.c
--- a/mm/oom_kill.c~oom-give-current-access-to-memory-reserves-if-it-has-been-killed
+++ a/mm/oom_kill.c
@@ -684,6 +684,16 @@ void out_of_memory(struct zonelist *zone
 		return;
 
 	/*
+	 * If current has a pending SIGKILL, then automatically select it.  The
+	 * goal is to allow it to allocate so that it may quickly exit and free
+	 * its memory.
+	 */
+	if (fatal_signal_pending(current)) {
+		set_tsk_thread_flag(current, TIF_MEMDIE);
+		return;
+	}
+
+	/*
 	 * Check if there were limitations on the allocation (only relevant for
 	 * NUMA) that may require different handling.
 	 */
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
acpi-map-pxms-to-low-node-ids.patch
mempolicy-remove-redundant-code.patch
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
oom-select_bad_process-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
oom-select_bad_process-pf_exiting-check-should-take-mm-into-account.patch
oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch
oom-oom_forkbomb_penalty-move-thread_group_cputime-out-of-task_lock.patch
oom-hold-tasklist_lock-when-dumping-tasks.patch
oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch
oom-avoid-sending-exiting-tasks-a-sigkill.patch
oom-clean-up-oom_kill_task.patch
oom-clean-up-oom_badness.patch
mempolicy-remove-case-mpol_interleave-from-policy_zonelist.patch
mempolicy-remove-redundant-check.patch
mempolicy-dont-call-mpol_set_nodemask-when-no_context.patch
mempolicy-lose-unnecessary-loop-variable-in-mpol_parse_str.patch
mempolicy-rename-policy_types-and-cleanup-initialization.patch
mempolicy-factor-mpol_shared_policy_init-return-paths.patch
mempolicy-document-cpuset-interaction-with-tmpfs-mpol-mount-option.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
oom-move-sysctl-declarations-to-oomh.patch
memcg-oom-wakeup-filter.patch
memcg-oom-wakeup-filter-update.patch
memcg-oom-notifier.patch
memcg-oom-notifier-update.patch
memcg-oom-kill-disable-and-oom-status.patch
memcg-oom-kill-disable-and-oom-status-update.patch

