From: akpm@linux-foundation.org
Subject: + pidns-remove-now-unused-kill_proc-function.patch added to -mm tree
Date: Mon, 30 Jun 2008 14:26:39 -0700
Message-ID: <200806302126.m5ULQdcj026197@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36081 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758518AbYF3V0y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 17:26:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, ebiederm@xmission.com, oleg@tv-sign.ru


The patch titled
     pidns: remove now unused kill_proc function
has been added to the -mm tree.  Its filename is
     pidns-remove-now-unused-kill_proc-function.patch

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
Subject: pidns: remove now unused kill_proc function
From: Pavel Emelyanov <xemul@openvz.org>

This function operated on a pid_t to kill a task, which is no longer valid
in a containerized system.

It has finally lost all its users and we can safely remove it from the
tree.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    1 -
 kernel/signal.c       |   12 ------------
 2 files changed, 13 deletions(-)

diff -puN include/linux/sched.h~pidns-remove-now-unused-kill_proc-function include/linux/sched.h
--- a/include/linux/sched.h~pidns-remove-now-unused-kill_proc-function
+++ a/include/linux/sched.h
@@ -1769,7 +1769,6 @@ extern void force_sig(int, struct task_s
 extern void force_sig_specific(int, struct task_struct *);
 extern int send_sig(int, struct task_struct *, int);
 extern void zap_other_threads(struct task_struct *p);
-extern int kill_proc(pid_t, int, int);
 extern struct sigqueue *sigqueue_alloc(void);
 extern void sigqueue_free(struct sigqueue *);
 extern int send_sigqueue(struct sigqueue *,  struct task_struct *, int group);
diff -puN kernel/signal.c~pidns-remove-now-unused-kill_proc-function kernel/signal.c
--- a/kernel/signal.c~pidns-remove-now-unused-kill_proc-function
+++ a/kernel/signal.c
@@ -1228,17 +1228,6 @@ int kill_pid(struct pid *pid, int sig, i
 }
 EXPORT_SYMBOL(kill_pid);
 
-int
-kill_proc(pid_t pid, int sig, int priv)
-{
-	int ret;
-
-	rcu_read_lock();
-	ret = kill_pid_info(sig, __si_special(priv), find_pid(pid));
-	rcu_read_unlock();
-	return ret;
-}
-
 /*
  * These functions support sending signals using preallocated sigqueue
  * structures.  This is needed "because realtime applications cannot
@@ -1908,7 +1897,6 @@ EXPORT_SYMBOL(recalc_sigpending);
 EXPORT_SYMBOL_GPL(dequeue_signal);
 EXPORT_SYMBOL(flush_signals);
 EXPORT_SYMBOL(force_sig);
-EXPORT_SYMBOL(kill_proc);
 EXPORT_SYMBOL(ptrace_notify);
 EXPORT_SYMBOL(send_sig);
 EXPORT_SYMBOL(send_sig_info);
_

Patches currently in -mm which might be from xemul@openvz.org are

mark-res_counter_charge_locked-with-__must_check.patch
cgroup-files-clean-up-whitespace-in-struct-cftype.patch
cgroup-files-add-write_string-cgroup-control-file-method.patch
cgroup-files-move-the-release_agent-file-to-use-typed-handlers.patch
cgroup-files-move-notify_on_release-file-to-separate-write-handler.patch
cgroup-files-turn-attach_task_by_pid-directly-into-a-cgroup-write-handler.patch
cgroup-files-remove-cpuset_common_file_write.patch
cgroup-files-convert-devcgroup_access_write-into-a-cgroup-write_string-handler.patch
cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler.patch
memcg-make-global-var-read_mostly.patch
memcg-avoid-unnecessary-initialization.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-handle-swap-cache.patch
memcg-handle-swap-cache-fix.patch
memcg-handle-swap-cache-fix-shmem-page-migration-incorrectness-on-memcgroup.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
sysctl-allow-override-of-proc-sys-net-with-cap_net_admin.patch
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
bsdacct-stir-up-comments-around-acct_process.patch
reiser4.patch

