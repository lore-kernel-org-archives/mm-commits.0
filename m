From: akpm@linux-foundation.org
Subject: + exec-dont-turn-pf_kthread-off-when-a-target-command-was-not-found.patch added to -mm tree
Date: Tue, 19 Oct 2010 16:23:44 -0700
Message-ID: <201010192323.o9JNNiGv012555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753013Ab0JSXX5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Oct 2010 19:23:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, roland@redhat.com


The patch titled
     exec: don't turn PF_KTHREAD off when a target command was not found
has been added to the -mm tree.  Its filename is
     exec-dont-turn-pf_kthread-off-when-a-target-command-was-not-found.patch

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
Subject: exec: don't turn PF_KTHREAD off when a target command was not found
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Presently do_execve() turns PF_KTHREAD off before search_binary_handler().
 THis has a theorical risk of PF_KTHREAD getting lost.  We don't have to
turn PF_KTHREAD off in the ENOEXEC case.

This patch moves this flag modification to after the finding of the
executable file.

This is only a theorical issue because kthreads do not call do_execve()
directly.  But fixing would be better.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Roland McGrath <roland@redhat.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/exec.c~exec-dont-turn-pf_kthread-off-when-a-target-command-was-not-found fs/exec.c
--- a/fs/exec.c~exec-dont-turn-pf_kthread-off-when-a-target-command-was-not-found
+++ a/fs/exec.c
@@ -1009,7 +1009,7 @@ int flush_old_exec(struct linux_binprm *
 
 	bprm->mm = NULL;		/* We're using it now */
 
-	current->flags &= ~PF_RANDOMIZE;
+	current->flags &= ~(PF_RANDOMIZE | PF_KTHREAD);
 	flush_thread();
 	current->personality &= ~bprm->per_clear;
 
@@ -1412,7 +1412,6 @@ int do_execve(const char * filename,
 	if (retval < 0)
 		goto out;
 
-	current->flags &= ~PF_KTHREAD;
 	retval = search_binary_handler(bprm,regs);
 	if (retval < 0)
 		goto out;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

mm-page-allocator-do-not-check-the-state-of-a-non-existant-buddy-during-free.patch
linux-next.patch
mm-fix-return-value-of-scan_lru_pages-in-memory-unplug.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
oom-add-per-mm-oom-disable-count.patch
oom-add-per-mm-oom-disable-count-protect-oom_disable_count-with-task_lock-in-fork.patch
oom-add-per-mm-oom-disable-count-use-old_mm-for-oom_disable_count-in-exec.patch
oom-avoid-killing-a-task-if-a-thread-sharing-its-mm-cannot-be-killed.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled.patch
vmscan-prevent-background-aging-of-anon-page-in-no-swap-system.patch
mm-mempolicy-check-return-code-of-check_range.patch
mm-add-account_page_writeback.patch
writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat.patch
writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat-update.patch
writeback-add-sys-devices-system-node-node-vmstat.patch
writeback-add-sys-devices-system-node-node-vmstat-update.patch
writeback-report-dirty-thresholds-in-proc-vmstat.patch
vmscan-delete-dead-code.patch
tracing-vmscan-add-trace-events-for-lru-list-shrinking.patch
writeback-account-for-time-spent-congestion_waited.patch
vmscan-synchronous-lumpy-reclaim-should-not-call-congestion_wait.patch
vmscan-narrow-the-scenarios-lumpy-reclaim-uses-synchrounous-reclaim.patch
vmscan-remove-dead-code-in-shrink_inactive_list.patch
vmscan-isolated_lru_pages-stop-neighbour-search-if-neighbour-cannot-be-isolated.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encountered-in-the-current-zone.patch
writeback-do-not-sleep-on-the-congestion-queue-if-there-are-no-congested-bdis-or-if-significant-congestion-is-not-being-encounted-in-the-current-zone-fix.patch
writeback-remove-the-internal-5%-low-bound-on-dirty_ratio.patch
vmscantmpfs-treat-used-once-pages-on-tmpfs-as-used-once.patch
mm-memory_hotplugc-make-scan_lru_pages-static.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch
proc-pid-smaps-export-amount-of-anonymous-memory-in-a-mapping.patch
proc-pid-smaps-export-amount-of-anonymous-memory-in-a-mapping-doc.patch
proc-pid-pagemap-document-in-documentation-filesystems-proctxt.patch
exec-dont-turn-pf_kthread-off-when-a-target-command-was-not-found.patch

