From: akpm@linux-foundation.org
Subject: + security-remove-unused-parameter-from-security_task_setscheduler.patch added to -mm tree
Date: Tue, 05 Oct 2010 13:58:59 -0700
Message-ID: <201010052058.o95KwxhW019662@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756526Ab0JEU7M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 16:59:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, jmorris@namei.org, mingo@elte.hu, rostedt@goodmis.org


The patch titled
     security: remove unused parameter from security_task_setscheduler()
has been added to the -mm tree.  Its filename is
     security-remove-unused-parameter-from-security_task_setscheduler.patch

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
Subject: security: remove unused parameter from security_task_setscheduler()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

All security modules shouldn't change sched_param parameter of
security_task_setscheduler().  This is not only meaningless, but also make
a harmful result if caller pass a static variable.

This patch removes the policy and sched_param parameters from
security_task_setscheduler() becuase none of security module is using it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: James Morris <jmorris@namei.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/mips-mt-fpaff.c |    2 +-
 include/linux/security.h         |   14 +++++---------
 kernel/cpuset.c                  |    4 ++--
 kernel/sched.c                   |    4 ++--
 security/commoncap.c             |    5 +----
 security/security.c              |    5 ++---
 security/selinux/hooks.c         |    4 ++--
 security/smack/smack_lsm.c       |    5 ++---
 8 files changed, 17 insertions(+), 26 deletions(-)

diff -puN arch/mips/kernel/mips-mt-fpaff.c~security-remove-unused-parameter-from-security_task_setscheduler arch/mips/kernel/mips-mt-fpaff.c
--- a/arch/mips/kernel/mips-mt-fpaff.c~security-remove-unused-parameter-from-security_task_setscheduler
+++ a/arch/mips/kernel/mips-mt-fpaff.c
@@ -103,7 +103,7 @@ asmlinkage long mipsmt_sys_sched_setaffi
 	if (!check_same_owner(p) && !capable(CAP_SYS_NICE))
 		goto out_unlock;
 
-	retval = security_task_setscheduler(p, 0, NULL);
+	retval = security_task_setscheduler(p)
 	if (retval)
 		goto out_unlock;
 
diff -puN include/linux/security.h~security-remove-unused-parameter-from-security_task_setscheduler include/linux/security.h
--- a/include/linux/security.h~security-remove-unused-parameter-from-security_task_setscheduler
+++ a/include/linux/security.h
@@ -74,7 +74,7 @@ extern int cap_file_mmap(struct file *fi
 extern int cap_task_fix_setuid(struct cred *new, const struct cred *old, int flags);
 extern int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 			  unsigned long arg4, unsigned long arg5);
-extern int cap_task_setscheduler(struct task_struct *p, int policy, struct sched_param *lp);
+extern int cap_task_setscheduler(struct task_struct *p);
 extern int cap_task_setioprio(struct task_struct *p, int ioprio);
 extern int cap_task_setnice(struct task_struct *p, int nice);
 extern int cap_syslog(int type, bool from_file);
@@ -1501,8 +1501,7 @@ struct security_operations {
 	int (*task_getioprio) (struct task_struct *p);
 	int (*task_setrlimit) (struct task_struct *p, unsigned int resource,
 			struct rlimit *new_rlim);
-	int (*task_setscheduler) (struct task_struct *p, int policy,
-				  struct sched_param *lp);
+	int (*task_setscheduler) (struct task_struct *p);
 	int (*task_getscheduler) (struct task_struct *p);
 	int (*task_movememory) (struct task_struct *p);
 	int (*task_kill) (struct task_struct *p,
@@ -1752,8 +1751,7 @@ int security_task_setioprio(struct task_
 int security_task_getioprio(struct task_struct *p);
 int security_task_setrlimit(struct task_struct *p, unsigned int resource,
 		struct rlimit *new_rlim);
-int security_task_setscheduler(struct task_struct *p,
-				int policy, struct sched_param *lp);
+int security_task_setscheduler(struct task_struct *p);
 int security_task_getscheduler(struct task_struct *p);
 int security_task_movememory(struct task_struct *p);
 int security_task_kill(struct task_struct *p, struct siginfo *info,
@@ -2320,11 +2318,9 @@ static inline int security_task_setrlimi
 	return 0;
 }
 
-static inline int security_task_setscheduler(struct task_struct *p,
-					     int policy,
-					     struct sched_param *lp)
+static inline int security_task_setscheduler(struct task_struct *p)
 {
-	return cap_task_setscheduler(p, policy, lp);
+	return cap_task_setscheduler(p);
 }
 
 static inline int security_task_getscheduler(struct task_struct *p)
diff -puN kernel/cpuset.c~security-remove-unused-parameter-from-security_task_setscheduler kernel/cpuset.c
--- a/kernel/cpuset.c~security-remove-unused-parameter-from-security_task_setscheduler
+++ a/kernel/cpuset.c
@@ -1397,7 +1397,7 @@ static int cpuset_can_attach(struct cgro
 	if (tsk->flags & PF_THREAD_BOUND)
 		return -EINVAL;
 
-	ret = security_task_setscheduler(tsk, 0, NULL);
+	ret = security_task_setscheduler(tsk);
 	if (ret)
 		return ret;
 	if (threadgroup) {
@@ -1405,7 +1405,7 @@ static int cpuset_can_attach(struct cgro
 
 		rcu_read_lock();
 		list_for_each_entry_rcu(c, &tsk->thread_group, thread_group) {
-			ret = security_task_setscheduler(c, 0, NULL);
+			ret = security_task_setscheduler(c);
 			if (ret) {
 				rcu_read_unlock();
 				return ret;
diff -puN kernel/sched.c~security-remove-unused-parameter-from-security_task_setscheduler kernel/sched.c
--- a/kernel/sched.c~security-remove-unused-parameter-from-security_task_setscheduler
+++ a/kernel/sched.c
@@ -4643,7 +4643,7 @@ recheck:
 	}
 
 	if (user) {
-		retval = security_task_setscheduler(p, policy, param);
+		retval = security_task_setscheduler(p);
 		if (retval)
 			return retval;
 	}
@@ -4885,7 +4885,7 @@ long sched_setaffinity(pid_t pid, const 
 	if (!check_same_owner(p) && !capable(CAP_SYS_NICE))
 		goto out_unlock;
 
-	retval = security_task_setscheduler(p, 0, NULL);
+	retval = security_task_setscheduler(p);
 	if (retval)
 		goto out_unlock;
 
diff -puN security/commoncap.c~security-remove-unused-parameter-from-security_task_setscheduler security/commoncap.c
--- a/security/commoncap.c~security-remove-unused-parameter-from-security_task_setscheduler
+++ a/security/commoncap.c
@@ -719,14 +719,11 @@ static int cap_safe_nice(struct task_str
 /**
  * cap_task_setscheduler - Detemine if scheduler policy change is permitted
  * @p: The task to affect
- * @policy: The policy to effect
- * @lp: The parameters to the scheduling policy
  *
  * Detemine if the requested scheduler policy change is permitted for the
  * specified task, returning 0 if permission is granted, -ve if denied.
  */
-int cap_task_setscheduler(struct task_struct *p, int policy,
-			   struct sched_param *lp)
+int cap_task_setscheduler(struct task_struct *p)
 {
 	return cap_safe_nice(p);
 }
diff -puN security/security.c~security-remove-unused-parameter-from-security_task_setscheduler security/security.c
--- a/security/security.c~security-remove-unused-parameter-from-security_task_setscheduler
+++ a/security/security.c
@@ -778,10 +778,9 @@ int security_task_setrlimit(struct task_
 	return security_ops->task_setrlimit(p, resource, new_rlim);
 }
 
-int security_task_setscheduler(struct task_struct *p,
-				int policy, struct sched_param *lp)
+int security_task_setscheduler(struct task_struct *p)
 {
-	return security_ops->task_setscheduler(p, policy, lp);
+	return security_ops->task_setscheduler(p);
 }
 
 int security_task_getscheduler(struct task_struct *p)
diff -puN security/selinux/hooks.c~security-remove-unused-parameter-from-security_task_setscheduler security/selinux/hooks.c
--- a/security/selinux/hooks.c~security-remove-unused-parameter-from-security_task_setscheduler
+++ a/security/selinux/hooks.c
@@ -3354,11 +3354,11 @@ static int selinux_task_setrlimit(struct
 	return 0;
 }
 
-static int selinux_task_setscheduler(struct task_struct *p, int policy, struct sched_param *lp)
+static int selinux_task_setscheduler(struct task_struct *p)
 {
 	int rc;
 
-	rc = cap_task_setscheduler(p, policy, lp);
+	rc = cap_task_setscheduler(p);
 	if (rc)
 		return rc;
 
diff -puN security/smack/smack_lsm.c~security-remove-unused-parameter-from-security_task_setscheduler security/smack/smack_lsm.c
--- a/security/smack/smack_lsm.c~security-remove-unused-parameter-from-security_task_setscheduler
+++ a/security/smack/smack_lsm.c
@@ -1281,12 +1281,11 @@ static int smack_task_getioprio(struct t
  *
  * Return 0 if read access is permitted
  */
-static int smack_task_setscheduler(struct task_struct *p, int policy,
-				   struct sched_param *lp)
+static int smack_task_setscheduler(struct task_struct *p)
 {
 	int rc;
 
-	rc = cap_task_setscheduler(p, policy, lp);
+	rc = cap_task_setscheduler(p);
 	if (rc == 0)
 		rc = smk_curacc_on_task(p, MAY_WRITE);
 	return rc;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

linux-next.patch
security-remove-unused-parameter-from-security_task_setscheduler.patch
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
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch
proc-pid-smaps-export-amount-of-anonymous-memory-in-a-mapping.patch
proc-pid-smaps-export-amount-of-anonymous-memory-in-a-mapping-doc.patch
proc-pid-pagemap-document-in-documentation-filesystems-proctxt.patch

