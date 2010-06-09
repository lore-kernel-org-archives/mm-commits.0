From: akpm@linux-foundation.org
Subject: + oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch added to -mm tree
Date: Wed, 09 Jun 2010 14:41:18 -0700
Message-ID: <201006092141.o59LfIYo023301@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756506Ab0FIVmg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jun 2010 17:42:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, akpm@linux-foundation.org, balbir@in.ibm.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com


The patch titled
     oom: add has_intersects_mems_allowed UMA variant
has been added to the -mm tree.  Its filename is
     oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch

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
Subject: oom: add has_intersects_mems_allowed UMA variant
From: David Rientjes <rientjes@google.com>

has_intersects_mems_allowed() shall always return true for machines
without CONFIG_NUMA since filtering tasks by either cpuset mems or
mempolicy nodes is unnecessary on such machines.

While we're here, fix the comment to make it conform to kerneldoc style.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff -puN mm/oom_kill.c~oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant mm/oom_kill.c
--- a/mm/oom_kill.c~oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant
+++ a/mm/oom_kill.c
@@ -36,10 +36,15 @@ int sysctl_oom_dump_tasks;
 static DEFINE_SPINLOCK(zone_scan_lock);
 /* #define DEBUG */
 
-/*
- * Do all threads of the target process overlap our allowed nodes?
+#ifdef CONFIG_NUMA
+/**
+ * has_intersects_mems_allowed() - check task eligiblity for kill
  * @tsk: task struct of which task to consider
  * @mask: nodemask passed to page allocator for mempolicy ooms
+ *
+ * Task eligibility is determined by whether or not a candidate task, @tsk,
+ * shares the same mempolicy nodes as current if it is bound by such a policy
+ * and whether or not it has the same set of allowed cpuset nodes.
  */
 static bool has_intersects_mems_allowed(struct task_struct *tsk,
 					const nodemask_t *mask)
@@ -68,6 +73,13 @@ static bool has_intersects_mems_allowed(
 	} while (tsk != start);
 	return false;
 }
+#else
+static bool has_intersects_mems_allowed(struct task_struct *tsk,
+					const nodemask_t *mask)
+{
+	return true;
+}
+#endif /* CONFIG_NUMA */
 
 static struct task_struct *find_lock_task_mm(struct task_struct *p)
 {
_

Patches currently in -mm which might be from rientjes@google.com are

avr32-invoke-oom-killer-from-page-fault.patch
oom-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
oom-pf_exiting-check-should-take-mm-into-account.patch
oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch
oom-dump_tasks-use-find_lock_task_mm-too.patch
oom-improve-commentary-in-dump_tasks.patch
oom-dump_tasks-use-find_lock_task_mm-too-dump_tasks-use-find_lock_task_mm-too-fix.patch
oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch
oom-avoid-sending-exiting-tasks-a-sigkill.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-fix.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-introduce-find_lock_task_mm-to-fix-mm-false-positives-fix.patch
oom-enable-oom-tasklist-dump-by-default.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-extract-panic-helper-function.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-move-sysctl-declarations-to-oomh.patch
oom-remove-unnecessary-code-and-cleanup.patch

