From: akpm@linux-foundation.org
Subject: + security-add-const-to-security_task_setscheduler.patch added to -mm tree
Date: Wed, 07 Jul 2010 12:38:19 -0700
Message-ID: <201007071938.o67JcJmV023008@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754374Ab0GGTjL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jul 2010 15:39:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, jmorris@namei.org, mingo@elte.hu, rostedt@goodmis.org


The patch titled
     security: add const to security_task_setscheduler()
has been added to the -mm tree.  Its filename is
     security-add-const-to-security_task_setscheduler.patch

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
Subject: security: add const to security_task_setscheduler()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

All security modules shouldn't change sched_param parameter of
security_task_setscheduler().  This is not only meaningless, but also make
harmful result if caller pass static variable.

This patch adds const to it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: James Morris <jmorris@namei.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/security.h   |    9 +++++----
 security/commoncap.c       |    2 +-
 security/security.c        |    4 ++--
 security/selinux/hooks.c   |    3 ++-
 security/smack/smack_lsm.c |    2 +-
 5 files changed, 11 insertions(+), 9 deletions(-)

diff -puN include/linux/security.h~security-add-const-to-security_task_setscheduler include/linux/security.h
--- a/include/linux/security.h~security-add-const-to-security_task_setscheduler
+++ a/include/linux/security.h
@@ -74,7 +74,8 @@ extern int cap_file_mmap(struct file *fi
 extern int cap_task_fix_setuid(struct cred *new, const struct cred *old, int flags);
 extern int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			  unsigned long arg4, unsigned long arg5);
-extern int cap_task_setscheduler(struct task_struct *p, int policy, struct sched_param *lp);
+extern int cap_task_setscheduler(struct task_struct *p, int policy,
+				 const struct sched_param *lp);
 extern int cap_task_setioprio(struct task_struct *p, int ioprio);
 extern int cap_task_setnice(struct task_struct *p, int nice);
 extern int cap_syslog(int type, bool from_file);
@@ -1501,7 +1502,7 @@ struct security_operations {
 	int (*task_getioprio) (struct task_struct *p);
 	int (*task_setrlimit) (unsigned int resource, struct rlimit *new_rlim);
 	int (*task_setscheduler) (struct task_struct *p, int policy,
-				  struct sched_param *lp);
+				  const struct sched_param *lp);
 	int (*task_getscheduler) (struct task_struct *p);
 	int (*task_movememory) (struct task_struct *p);
 	int (*task_kill) (struct task_struct *p,
@@ -1750,8 +1751,8 @@ int security_task_setnice(struct task_st
 int security_task_setioprio(struct task_struct *p, int ioprio);
 int security_task_getioprio(struct task_struct *p);
 int security_task_setrlimit(unsigned int resource, struct rlimit *new_rlim);
-int security_task_setscheduler(struct task_struct *p,
-				int policy, struct sched_param *lp);
+int security_task_setscheduler(struct task_struct *p, int policy,
+			       const struct sched_param *lp);
 int security_task_getscheduler(struct task_struct *p);
 int security_task_movememory(struct task_struct *p);
 int security_task_kill(struct task_struct *p, struct siginfo *info,
diff -puN security/commoncap.c~security-add-const-to-security_task_setscheduler security/commoncap.c
--- a/security/commoncap.c~security-add-const-to-security_task_setscheduler
+++ a/security/commoncap.c
@@ -726,7 +726,7 @@ static int cap_safe_nice(struct task_str
  * specified task, returning 0 if permission is granted, -ve if denied.
  */
 int cap_task_setscheduler(struct task_struct *p, int policy,
-			   struct sched_param *lp)
+			  const struct sched_param *lp)
 {
 	return cap_safe_nice(p);
 }
diff -puN security/security.c~security-add-const-to-security_task_setscheduler security/security.c
--- a/security/security.c~security-add-const-to-security_task_setscheduler
+++ a/security/security.c
@@ -785,8 +785,8 @@ int security_task_setrlimit(unsigned int
 	return security_ops->task_setrlimit(resource, new_rlim);
 }
 
-int security_task_setscheduler(struct task_struct *p,
-				int policy, struct sched_param *lp)
+int security_task_setscheduler(struct task_struct *p, int policy,
+			       const struct sched_param *lp)
 {
 	return security_ops->task_setscheduler(p, policy, lp);
 }
diff -puN security/selinux/hooks.c~security-add-const-to-security_task_setscheduler security/selinux/hooks.c
--- a/security/selinux/hooks.c~security-add-const-to-security_task_setscheduler
+++ a/security/selinux/hooks.c
@@ -3353,7 +3353,8 @@ static int selinux_task_setrlimit(unsign
 	return 0;
 }
 
-static int selinux_task_setscheduler(struct task_struct *p, int policy, struct sched_param *lp)
+static int selinux_task_setscheduler(struct task_struct *p, int policy,
+				     const struct sched_param *lp)
 {
 	int rc;
 
diff -puN security/smack/smack_lsm.c~security-add-const-to-security_task_setscheduler security/smack/smack_lsm.c
--- a/security/smack/smack_lsm.c~security-add-const-to-security_task_setscheduler
+++ a/security/smack/smack_lsm.c
@@ -1280,7 +1280,7 @@ static int smack_task_getioprio(struct t
  * Return 0 if read access is permitted
  */
 static int smack_task_setscheduler(struct task_struct *p, int policy,
-				   struct sched_param *lp)
+				   const struct sched_param *lp)
 {
 	int rc;
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

acpi-fix-unused-function-warning.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-arugment-static-variables-in-some-sched_setscheduler-caller.patch
mm-use-memdup_user.patch
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
mm-rename-try_set_zone_oom-to-try_set_zonelist_oom.patch
oom-remove-constraint-argument-from-select_bad_process-and-__out_of_memory.patch
oom-fold-__out_of_memory-into-out_of_memory.patch
mm-use-for_each_online_cpu-in-vmstat.patch
mempolicy-reduce-stack-size-of-migrate_pages.patch
mempolicy-reduce-stack-size-of-migrate_pages-fix.patch
vmscan-zone_reclaim-dont-call-disable_swap_token.patch
vmscan-recalculate-lru_pages-on-each-priority.patch
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
oom-dont-try-to-kill-oom_unkillable-child-checkpatch-fixes.patch
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
rmap-add-exclusive-page-to-private-anon_vma-on-swapin.patch
mm-set-vm_fault_write-in-do_swap_page.patch
reiser4.patch

