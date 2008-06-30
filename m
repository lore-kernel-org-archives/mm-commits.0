From: akpm@linux-foundation.org
Subject: + pidns-remove-now-unused-find_pid-function.patch added to -mm tree
Date: Mon, 30 Jun 2008 14:26:41 -0700
Message-ID: <200806302126.m5ULQfSb026200@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36890 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757675AbYF3V0p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 17:26:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, ebiederm@xmission.com, oleg@tv-sign.ru


The patch titled
     pidns: remove now unused find_pid function.
has been added to the -mm tree.  Its filename is
     pidns-remove-now-unused-find_pid-function.patch

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
Subject: pidns: remove now unused find_pid function.
From: Pavel Emelyanov <xemul@openvz.org>

This one had the only users so far - the kill_proc, which is removed, so
drop this (invalid in namespaced world) call too.

And of course - erase all references on it from comments.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid.h   |    4 +---
 include/linux/sched.h |    2 +-
 kernel/pid.c          |    8 +-------
 3 files changed, 3 insertions(+), 11 deletions(-)

diff -puN include/linux/pid.h~pidns-remove-now-unused-find_pid-function include/linux/pid.h
--- a/include/linux/pid.h~pidns-remove-now-unused-find_pid-function
+++ a/include/linux/pid.h
@@ -48,7 +48,7 @@ enum pid_type
  */
 
 struct upid {
-	/* Try to keep pid_chain in the same cacheline as nr for find_pid */
+	/* Try to keep pid_chain in the same cacheline as nr for find_vpid */
 	int nr;
 	struct pid_namespace *ns;
 	struct hlist_node pid_chain;
@@ -105,14 +105,12 @@ extern struct pid_namespace init_pid_ns;
  * or rcu_read_lock() held.
  *
  * find_pid_ns() finds the pid in the namespace specified
- * find_pid() find the pid by its global id, i.e. in the init namespace
  * find_vpid() finr the pid by its virtual id, i.e. in the current namespace
  *
  * see also find_task_by_pid() set in include/linux/sched.h
  */
 extern struct pid *find_pid_ns(int nr, struct pid_namespace *ns);
 extern struct pid *find_vpid(int nr);
-extern struct pid *find_pid(int nr);
 
 /*
  * Lookup a PID in the hash table, and return with it's count elevated.
diff -puN include/linux/sched.h~pidns-remove-now-unused-find_pid-function include/linux/sched.h
--- a/include/linux/sched.h~pidns-remove-now-unused-find_pid-function
+++ a/include/linux/sched.h
@@ -1687,7 +1687,7 @@ extern struct pid_namespace init_pid_ns;
  * find_task_by_pid():
  *      finds a task by its global pid
  *
- * see also find_pid() etc in include/linux/pid.h
+ * see also find_vpid() etc in include/linux/pid.h
  */
 
 extern struct task_struct *find_task_by_pid_type_ns(int type, int pid,
diff -puN kernel/pid.c~pidns-remove-now-unused-find_pid-function kernel/pid.c
--- a/kernel/pid.c~pidns-remove-now-unused-find_pid-function
+++ a/kernel/pid.c
@@ -309,12 +309,6 @@ struct pid *find_vpid(int nr)
 }
 EXPORT_SYMBOL_GPL(find_vpid);
 
-struct pid *find_pid(int nr)
-{
-	return find_pid_ns(nr, &init_pid_ns);
-}
-EXPORT_SYMBOL_GPL(find_pid);
-
 /*
  * attach_pid() must be called with the tasklist_lock write-held.
  */
@@ -483,7 +477,7 @@ EXPORT_SYMBOL(task_session_nr_ns);
 /*
  * Used by proc to find the first pid that is greater then or equal to nr.
  *
- * If there is a pid at nr this function is exactly the same as find_pid.
+ * If there is a pid at nr this function is exactly the same as find_pid_ns.
  */
 struct pid *find_ge_pid(int nr, struct pid_namespace *ns)
 {
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

