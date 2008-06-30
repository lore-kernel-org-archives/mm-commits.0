From: akpm@linux-foundation.org
Subject: + pidns-remove-find_task_by_pid-unused-for-a-long-time.patch added to -mm tree
Date: Mon, 30 Jun 2008 14:26:43 -0700
Message-ID: <200806302126.m5ULQhbR026203@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51035 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761292AbYF3V0r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 17:26:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, ebiederm@xmission.com, oleg@tv-sign.ru


The patch titled
     pidns: remove find_task_by_pid, unused for a long time
has been added to the -mm tree.  Its filename is
     pidns-remove-find_task_by_pid-unused-for-a-long-time.patch

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
Subject: pidns: remove find_task_by_pid, unused for a long time
From: Pavel Emelyanov <xemul@openvz.org>

It seems to me that it was a mistake marking this function as deprecated
and scheduling it for removal, rather than resolutely removing it after
the last caller's death.

Anyway - better late, then never.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |   18 ------------------
 include/linux/pid.h                        |    2 +-
 include/linux/sched.h                      |    6 ------
 3 files changed, 1 insertion(+), 25 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~pidns-remove-find_task_by_pid-unused-for-a-long-time Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~pidns-remove-find_task_by_pid-unused-for-a-long-time
+++ a/Documentation/feature-removal-schedule.txt
@@ -138,24 +138,6 @@ Who:	Kay Sievers <kay.sievers@suse.de>
 
 ---------------------------
 
-What:	find_task_by_pid
-When:	2.6.26
-Why:	With pid namespaces, calling this funciton will return the
-	wrong task when called from inside a namespace.
-
-	The best way to save a task pid and find a task by this
-	pid later, is to find this task's struct pid pointer (or get
-	it directly from the task) and call pid_task() later.
-
-	If someone really needs to get a task by its pid_t, then
-	he most likely needs the find_task_by_vpid() to get the
-	task from the same namespace as the current task is in, but
-	this may be not so in general.
-
-Who:	Pavel Emelyanov <xemul@openvz.org>
-
----------------------------
-
 What:	ACPI procfs interface
 When:	July 2008
 Why:	ACPI sysfs conversion should be finished by January 2008.
diff -puN include/linux/pid.h~pidns-remove-find_task_by_pid-unused-for-a-long-time include/linux/pid.h
--- a/include/linux/pid.h~pidns-remove-find_task_by_pid-unused-for-a-long-time
+++ a/include/linux/pid.h
@@ -107,7 +107,7 @@ extern struct pid_namespace init_pid_ns;
  * find_pid_ns() finds the pid in the namespace specified
  * find_vpid() finr the pid by its virtual id, i.e. in the current namespace
  *
- * see also find_task_by_pid() set in include/linux/sched.h
+ * see also find_task_by_vpid() set in include/linux/sched.h
  */
 extern struct pid *find_pid_ns(int nr, struct pid_namespace *ns);
 extern struct pid *find_vpid(int nr);
diff -puN include/linux/sched.h~pidns-remove-find_task_by_pid-unused-for-a-long-time include/linux/sched.h
--- a/include/linux/sched.h~pidns-remove-find_task_by_pid-unused-for-a-long-time
+++ a/include/linux/sched.h
@@ -1684,8 +1684,6 @@ extern struct pid_namespace init_pid_ns;
  *      finds a task by its pid in the specified namespace
  * find_task_by_vpid():
  *      finds a task by its virtual pid
- * find_task_by_pid():
- *      finds a task by its global pid
  *
  * see also find_vpid() etc in include/linux/pid.h
  */
@@ -1693,10 +1691,6 @@ extern struct pid_namespace init_pid_ns;
 extern struct task_struct *find_task_by_pid_type_ns(int type, int pid,
 		struct pid_namespace *ns);
 
-static inline struct task_struct *__deprecated find_task_by_pid(pid_t nr)
-{
-	return find_task_by_pid_type_ns(PIDTYPE_PID, nr, &init_pid_ns);
-}
 extern struct task_struct *find_task_by_vpid(pid_t nr);
 extern struct task_struct *find_task_by_pid_ns(pid_t nr,
 		struct pid_namespace *ns);
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

