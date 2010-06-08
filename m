From: akpm@linux-foundation.org
Subject: + oom-remove-unnecessary-code-and-cleanup.patch added to -mm tree
Date: Tue, 08 Jun 2010 14:28:39 -0700
Message-ID: <201006082128.o58LSdO0025833@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424Ab0FHV2s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jun 2010 17:28:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     oom: remove unnecessary code and cleanup
has been added to the -mm tree.  Its filename is
     oom-remove-unnecessary-code-and-cleanup.patch

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
Subject: oom: remove unnecessary code and cleanup
From: David Rientjes <rientjes@google.com>

Remove the redundancy in __oom_kill_task() since:

 - init can never be passed to this function: it will never be PF_EXITING
   or selectable from select_bad_process(), and

 - it will never be passed a task from oom_kill_task() without an ->mm
   and we're unconcerned about detachment from exiting tasks, there's no
   reason to protect them against SIGKILL or access to memory reserves.

Also moves the kernel log message to a higher level since the verbosity is
not always emitted here; we need not print an error message if an exiting
task is given a longer timeslice.

__oom_kill_task() only has a single caller, so it can be merged into that
function at the same time.

Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   56 ++++++++----------------------------------------
 1 file changed, 10 insertions(+), 46 deletions(-)

diff -puN mm/oom_kill.c~oom-remove-unnecessary-code-and-cleanup mm/oom_kill.c
--- a/mm/oom_kill.c~oom-remove-unnecessary-code-and-cleanup
+++ a/mm/oom_kill.c
@@ -401,61 +401,25 @@ static void dump_header(struct task_stru
 }
 
 #define K(x) ((x) << (PAGE_SHIFT-10))
-
-/*
- * Send SIGKILL to the selected  process irrespective of  CAP_SYS_RAW_IO
- * flag though it's unlikely that  we select a process with CAP_SYS_RAW_IO
- * set.
- */
-static void __oom_kill_task(struct task_struct *p, int verbose)
+static int oom_kill_task(struct task_struct *p)
 {
-	if (is_global_init(p)) {
-		WARN_ON(1);
-		printk(KERN_WARNING "tried to kill init!\n");
-		return;
-	}
-
 	p = find_lock_task_mm(p);
-	if (!p)
-		return;
-
-	if (verbose)
-		printk(KERN_ERR "Killed process %d (%s) "
-		       "vsz:%lukB, anon-rss:%lukB, file-rss:%lukB\n",
-		       task_pid_nr(p), p->comm,
-		       K(p->mm->total_vm),
-		       K(get_mm_counter(p->mm, MM_ANONPAGES)),
-		       K(get_mm_counter(p->mm, MM_FILEPAGES)));
+	if (!p || p->signal->oom_adj == OOM_DISABLE) {
+		task_unlock(p);
+		return 1;
+	}
+	pr_err("Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB\n",
+		task_pid_nr(p), p->comm, K(p->mm->total_vm),
+		K(get_mm_counter(p->mm, MM_ANONPAGES)),
+		K(get_mm_counter(p->mm, MM_FILEPAGES)));
 	task_unlock(p);
 
-	/*
-	 * We give our sacrificial lamb high priority and access to
-	 * all the memory it needs. That way it should be able to
-	 * exit() and clear out its resources quickly...
-	 */
 	p->rt.time_slice = HZ;
 	set_tsk_thread_flag(p, TIF_MEMDIE);
-
 	force_sig(SIGKILL, p);
-}
-
-static int oom_kill_task(struct task_struct *p)
-{
-	/* WARNING: mm may not be dereferenced since we did not obtain its
-	 * value from get_task_mm(p).  This is OK since all we need to do is
-	 * compare mm to q->mm below.
-	 *
-	 * Furthermore, even if mm contains a non-NULL value, p->mm may
-	 * change to NULL at any time since we do not hold task_lock(p).
-	 * However, this is of no concern to us.
-	 */
-	if (!p->mm || p->signal->oom_adj == OOM_DISABLE)
-		return 1;
-
-	__oom_kill_task(p, 1);
-
 	return 0;
 }
+#undef K
 
 static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 			    unsigned long points, struct mem_cgroup *mem,
_

Patches currently in -mm which might be from rientjes@google.com are

avr32-invoke-oom-killer-from-page-fault.patch
oom-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch
oom-dump_tasks-use-find_lock_task_mm-too.patch
oom-pf_exiting-check-should-take-mm-into-account.patch
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

