From: akpm@linux-foundation.org
Subject: + signals-introduce-kill_pid_ns_info.patch added to -mm tree
Date: Tue, 22 Jul 2008 01:22:01 -0700
Message-ID: <200807220822.m6M8M1Xl018412@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755238AbYGVIW4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 04:22:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, daniel@hozac.com, oleg@tv-sign.ru, roland@redhat.com


The patch titled
     signals: introduce kill_pid_ns_info
has been added to the -mm tree.  Its filename is
     signals-introduce-kill_pid_ns_info.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: introduce kill_pid_ns_info
From: Eric W. Biederman <ebiederm@xmission.com>

Implement the basic helper function that walks all of the processes in a
pid namespace and sends them all a signal.

Both locations that could use this functions are also updated to use this
function.

I use find_ge_pid instead of for_each_process because it has a chance of
not touching every process in the system.

[daniel@hozac.com: Optimize away nr <= 1 check, against latest Linus tree]
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Daniel Hokka Zakrisson <daniel@hozac.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h  |    2 +
 kernel/pid_namespace.c |   17 ------------
 kernel/signal.c        |   52 ++++++++++++++++++++++++++++++---------
 3 files changed, 43 insertions(+), 28 deletions(-)

diff -puN include/linux/sched.h~signals-introduce-kill_pid_ns_info include/linux/sched.h
--- a/include/linux/sched.h~signals-introduce-kill_pid_ns_info
+++ a/include/linux/sched.h
@@ -1779,6 +1779,8 @@ extern void release_task(struct task_str
 extern int send_sig_info(int, struct siginfo *, struct task_struct *);
 extern int force_sigsegv(int, struct task_struct *);
 extern int force_sig_info(int, struct siginfo *, struct task_struct *);
+extern int __kill_pid_ns_info(int sig, struct siginfo *info, struct pid_namespace *ns);
+extern int kill_pid_ns_info(int sig, struct siginfo *info, struct pid_namespace *ns);
 extern int __kill_pgrp_info(int sig, struct siginfo *info, struct pid *pgrp);
 extern int kill_pid_info(int sig, struct siginfo *info, struct pid *pid);
 extern int kill_pid_info_as_uid(int, struct siginfo *, struct pid *, uid_t, uid_t, u32);
diff -puN kernel/pid_namespace.c~signals-introduce-kill_pid_ns_info kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~signals-introduce-kill_pid_ns_info
+++ a/kernel/pid_namespace.c
@@ -153,29 +153,14 @@ void free_pid_ns(struct kref *kref)
 
 void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 {
-	int nr;
 	int rc;
 
 	/*
 	 * The last thread in the cgroup-init thread group is terminating.
 	 * Find remaining pid_ts in the namespace, signal and wait for them
 	 * to exit.
-	 *
-	 * Note:  This signals each threads in the namespace - even those that
-	 * 	  belong to the same thread group, To avoid this, we would have
-	 * 	  to walk the entire tasklist looking a processes in this
-	 * 	  namespace, but that could be unnecessarily expensive if the
-	 * 	  pid namespace has just a few processes. Or we need to
-	 * 	  maintain a tasklist for each pid namespace.
-	 *
 	 */
-	read_lock(&tasklist_lock);
-	nr = next_pidmap(pid_ns, 1);
-	while (nr > 0) {
-		kill_proc_info(SIGKILL, SEND_SIG_PRIV, nr);
-		nr = next_pidmap(pid_ns, nr);
-	}
-	read_unlock(&tasklist_lock);
+	kill_pid_ns_info(SIGKILL, SEND_SIG_PRIV, pid_ns);
 
 	do {
 		clear_thread_flag(TIF_SIGPENDING);
diff -puN kernel/signal.c~signals-introduce-kill_pid_ns_info kernel/signal.c
--- a/kernel/signal.c~signals-introduce-kill_pid_ns_info
+++ a/kernel/signal.c
@@ -1109,6 +1109,45 @@ out_unlock:
 }
 EXPORT_SYMBOL_GPL(kill_pid_info_as_uid);
 
+int __kill_pid_ns_info(int sig, struct siginfo *info, struct pid_namespace *ns)
+{
+	int retval = 0, count = 0;
+	struct task_struct *p;
+	struct pid *pid;
+	int nr;
+
+	/* Since there isn't a pid namespace list of tasks use the closest
+	 * approximation we have: find_ge_pid.
+	 */
+	nr = 1;
+	while ((pid = find_ge_pid(nr + 1, ns))) {
+		int err;
+
+		nr = pid_nr_ns(pid, ns);
+		p = pid_task(pid, PIDTYPE_PID);
+		if (!p || !thread_group_leader(p) ||
+		    same_thread_group(p, current))
+			continue;
+
+		err = group_send_sig_info(sig, info, p);
+		++count;
+		if (err != -EPERM)
+			retval = err;
+	}
+	return count ? retval : -ESRCH;
+}
+
+int kill_pid_ns_info(int sig, struct siginfo *info, struct pid_namespace *ns)
+{
+	int retval;
+
+	read_lock(&tasklist_lock);
+	retval = __kill_pid_ns_info(sig, info, ns);
+	read_unlock(&tasklist_lock);
+
+	return retval;
+}
+
 /*
  * kill_something_info() interprets pid in interesting ways just like kill(2).
  *
@@ -1132,18 +1171,7 @@ static int kill_something_info(int sig, 
 		ret = __kill_pgrp_info(sig, info,
 				pid ? find_vpid(-pid) : task_pgrp(current));
 	} else {
-		int retval = 0, count = 0;
-		struct task_struct * p;
-
-		for_each_process(p) {
-			if (p->pid > 1 && !same_thread_group(p, current)) {
-				int err = group_send_sig_info(sig, info, p);
-				++count;
-				if (err != -EPERM)
-					retval = err;
-			}
-		}
-		ret = count ? retval : -ESRCH;
+		ret = __kill_pid_ns_info(sig, info, task_active_pid_ns(current));
 	}
 	read_unlock(&tasklist_lock);
 
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
linux-next.patch
generic-irqs-enable-polling-for-disabled-screaming-irqs.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-remove-refcnt-from-page_cgroup-memcg-fix-shmem_unuse_inode-charging.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-helper-function-for-relcaim-from-shmem-memcg-shmem_getpage-release-page-sooner.patch
memcg-helper-function-for-relcaim-from-shmem-memcg-mem_cgroup_shrink_usage-css_put.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
signals-introduce-kill_pid_ns_info.patch
sysctl-check-for-bogus-modes.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch
shrink-struct-pid-by-removing-padding-on-64-bit-builds.patch
pidns-remove-now-unused-kill_proc-function.patch
pidns-remove-now-unused-find_pid-function.patch
pidns-remove-find_task_by_pid-unused-for-a-long-time.patch
bsdacct-rename-acct_blbls-to-bsd_acct_struct.patch
pidns-use-kzalloc-when-allocating-new-pid_namespace-struct.patch
pidns-add-the-struct-bsd_acct_struct-pointer-on-pid_namespace-struct.patch
bsdacct-truthify-a-comment-near-acct_process.patch
bsdacct-make-check-timer-accept-a-bsd_acct_struct-argument.patch
bsdacct-turn-the-acct_lock-from-on-the-struct-to-global.patch
bsdacct-make-internal-code-work-with-passed-bsd_acct_struct-not-global.patch
bsdacct-switch-from-global-bsd_acct_struct-instance-to-per-pidns-one.patch
bsdacct-turn-acct-off-for-all-pidns-s-on-umount-time.patch
bsdacct-account-dying-tasks-in-all-relevant-namespaces.patch
kernel-kexecc-make-kimage_terminate-void.patch
kexec-jump.patch
kexec-jump-save-restore-device-state.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch

