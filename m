From: akpm@linux-foundation.org
Subject: + oom-select-task-from-tasklist-for-mempolicy-ooms-introduce-find_lock_task_mm-to-fix-mm-false-positives-fix.patch added to -mm tree
Date: Wed, 09 Jun 2010 14:41:20 -0700
Message-ID: <201006092141.o59LfK2S023306@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756506Ab0FIVmh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jun 2010 17:42:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, balbir@in.ibm.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com


The patch titled
     oom: introduce find_lock_task_mm to fix mm false positives fix
has been added to the -mm tree.  Its filename is
     oom-select-task-from-tasklist-for-mempolicy-ooms-introduce-find_lock_task_mm-to-fix-mm-false-positives-fix.patch

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
Subject: oom: introduce find_lock_task_mm to fix mm false positives fix
From: David Rientjes <rientjes@google.com>

find_lock_task_mm() should be documented so that we clearly understand
what it does and why we need it.

At the same time, remove a stale coment about dereferencing of a local
variable "mm" in badness() which no longer exists and was removed when
find_lock_task_mm() was added.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN mm/oom_kill.c~oom-select-task-from-tasklist-for-mempolicy-ooms-introduce-find_lock_task_mm-to-fix-mm-false-positives-fix mm/oom_kill.c
--- a/mm/oom_kill.c~oom-select-task-from-tasklist-for-mempolicy-ooms-introduce-find_lock_task_mm-to-fix-mm-false-positives-fix
+++ a/mm/oom_kill.c
@@ -81,6 +81,12 @@ static bool has_intersects_mems_allowed(
 }
 #endif /* CONFIG_NUMA */
 
+/*
+ * The process p may have detached its own ->mm while exiting or through
+ * use_mm(), but one or more of its subthreads may still have a valid
+ * pointer.  Return p, or any of its subthreads with a valid ->mm, with
+ * task_lock() held.
+ */
 static struct task_struct *find_lock_task_mm(struct task_struct *p)
 {
 	struct task_struct *t = p;
@@ -135,10 +141,6 @@ unsigned long badness(struct task_struct
 	 * The memory size of the process is the basis for the badness.
 	 */
 	points = p->mm->total_vm;
-
-	/*
-	 * After this unlock we can no longer dereference local variable `mm'
-	 */
 	task_unlock(p);
 
 	/*
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

