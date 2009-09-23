From: akpm@linux-foundation.org
Subject: [merged] proc_flush_task-flush-proc-tid-task-pid-when-a-sub-thread-exits.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:56:36 -0700
Message-ID: <200909231956.n8NJuai8005244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753334AbZIWT5X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:57:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, Johnray.Fuller@gs.com, adobriyan@gmail.com, dduval@redhat.com, ebiederm@xmission.com, fhirtz@redhat.com, jleddy@redhat.com, lwoodman@redhat.com, pbatkowski@redhat.com


The patch titled
     proc_flush_task: flush /proc/tid/task/pid when a sub-thread exits
has been removed from the -mm tree.  Its filename was
     proc_flush_task-flush-proc-tid-task-pid-when-a-sub-thread-exits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc_flush_task: flush /proc/tid/task/pid when a sub-thread exits
From: Oleg Nesterov <oleg@redhat.com>

The exiting sub-thread flushes /proc/pid only, but this doesn't buy too
much: ps and friends mostly use /proc/tid/task/pid.

Remove "if (thread_group_leader())" checks from proc_flush_task() path,
this means we always remove /proc/tid/task/pid dentry on exit, and this
actually matches the comment above proc_flush_task().

The test-case:

	static void* tfunc(void *arg)
	{
		char name[256];

		sprintf(name, "/proc/%d/task/%ld/status", getpid(), gettid());
		close(open(name, O_RDONLY));

		return NULL;
	}

	int main(void)
	{
		pthread_t t;

		for (;;) {
			if (!pthread_create(&t, NULL, &tfunc, NULL))
				pthread_join(t, NULL);
		}
	}

slabtop shows that pid/proc_inode_cache/etc grow quickly and
"indefinitely" until the task is killed or shrink_slab() is called, not
good.  And the main thread needs a lot of time to exit.

The same can happen if something like "ps -efL" runs continuously, while
some application spawns short-living threads.

Reported-by: "James M. Leddy" <jleddy@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dominic Duval <dduval@redhat.com>
Cc: Frank Hirtz <fhirtz@redhat.com>
Cc: "Fuller, Johnray" <Johnray.Fuller@gs.com>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Paul Batkowski <pbatkowski@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN fs/proc/base.c~proc_flush_task-flush-proc-tid-task-pid-when-a-sub-thread-exits fs/proc/base.c
--- a/fs/proc/base.c~proc_flush_task-flush-proc-tid-task-pid-when-a-sub-thread-exits
+++ a/fs/proc/base.c
@@ -2604,9 +2604,6 @@ static void proc_flush_task_mnt(struct v
 		dput(dentry);
 	}
 
-	if (tgid == 0)
-		goto out;
-
 	name.name = buf;
 	name.len = snprintf(buf, sizeof(buf), "%d", tgid);
 	leader = d_hash_and_lookup(mnt->mnt_root, &name);
@@ -2663,17 +2660,16 @@ out:
 void proc_flush_task(struct task_struct *task)
 {
 	int i;
-	struct pid *pid, *tgid = NULL;
+	struct pid *pid, *tgid;
 	struct upid *upid;
 
 	pid = task_pid(task);
-	if (thread_group_leader(task))
-		tgid = task_tgid(task);
+	tgid = task_tgid(task);
 
 	for (i = 0; i <= pid->level; i++) {
 		upid = &pid->numbers[i];
 		proc_flush_task_mnt(upid->ns->proc_mnt, upid->nr,
-			tgid ? tgid->numbers[i].nr : 0);
+					tgid->numbers[i].nr);
 	}
 
 	upid = &pid->numbers[pid->level];
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
cgroups-revert-cgroups-fix-pid-namespace-bug.patch
cgroups-add-a-read-only-procs-file-similar-to-tasks-that-shows-only-unique-tgids.patch
cgroups-ensure-correct-concurrent-opening-reading-of-pidlists-across-pid-namespaces.patch
cgroups-use-vmalloc-for-large-cgroups-pidlist-allocations.patch
cgroups-change-css_set-freeing-mechanism-to-be-under-rcu.patch
cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time.patch
cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time-fix.patch
ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent.patch
do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case.patch
do_wait-wakeup-optimization-fix-child_wait_callback-eligible_child-usage.patch
do_wait-wakeup-optimization-simplify-task_pid_type.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
wait_consider_task-kill-parent-argument.patch
do_wait-fix-sys_waitid-specific-behaviour.patch
wait_noreap_copyout-check-for-wo_info-=-null.patch
signals-introduce-do_send_sig_info-helper.patch
signals-send_sigio-use-do_send_sig_info-to-avoid-check_kill_permission.patch
fcntl-add-f_etown_ex.patch
signals-inline-__fatal_signal_pending.patch
signals-tracehook_notify_jctl-change.patch
signals-tracehook_notify_jctl-change-do_signal_stop-do-not-call-tracehook_notify_jctl-in-task_stopped-state.patch
signals-introduce-tracehook_finish_jctl-helper.patch
utrace-core.patch
exec-fix-set_binfmt-vs-sys_delete_module-race.patch
fork-disable-clone_parent-for-init.patch
pidns-deny-clone_parentclone_newpid-combination.patch
task_struct-cleanup-move-binfmt-field-to-mm_struct.patch

