From: akpm@linux-foundation.org
Subject: + clone-fix-race-between-copy_process-and-de_thread.patch added to -mm tree
Date: Mon, 24 Aug 2009 14:39:04 -0700
Message-ID: <200908242139.n7OLd58N021988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37101 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752533AbZHXVk6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Aug 2009 17:40:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, h-shimamoto@ct.jp.nec.com, kamezawa.hiroyu@jp.fujitsu.com, roland@redhat.com, stable@kernel.org


The patch titled
     clone(): fix race between copy_process() and de_thread()
has been added to the -mm tree.  Its filename is
     clone-fix-race-between-copy_process-and-de_thread.patch

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
Subject: clone(): fix race between copy_process() and de_thread()
From: Oleg Nesterov <oleg@redhat.com>

Spotted by Hiroshi Shimamoto who also provided the test-case below.

copy_process() uses signal->count as a reference counter, but it is not. 
This test case

	#include <sys/types.h>
	#include <sys/wait.h>
	#include <unistd.h>
	#include <stdio.h>
	#include <errno.h>
	#include <pthread.h>

	void *null_thread(void *p)
	{
		for (;;)
			sleep(1);

		return NULL;
	}

	void *exec_thread(void *p)
	{
		execl("/bin/true", "/bin/true", NULL);

		return null_thread(p);
	}

	int main(int argc, char **argv)
	{
		for (;;) {
			pid_t pid;
			int ret, status;

			pid = fork();
			if (pid < 0)
				break;

			if (!pid) {
				pthread_t tid;

				pthread_create(&tid, NULL, exec_thread, NULL);
				for (;;)
					pthread_create(&tid, NULL, null_thread, NULL);
			}

			do {
				ret = waitpid(pid, &status, 0);
			} while (ret == -1 && errno == EINTR);
		}

		return 0;
	}

quickly creates an unkillable task.

If copy_process(CLONE_THREAD) races with de_thread()
copy_signal()->atomic(signal->count) breaks the signal->notify_count
logic, and the execing thread can hang forever in kernel space.

Change copy_process() to increment count/live only when we know for sure
we can't fail.  In this case the forked thread will take care of its
reference to signal correctly.

If copy_process() fails, check CLONE_THREAD flag.  If it it set - do
nothing, the counters were not changed and current belongs to the same
thread group.  If it is not set, ->signal must be released in any case
(and ->count must be == 1), the forked child is the only thread in the
thread group.

We need more cleanups here, in particular signal->count should not be used
by de_thread/__exit_signal at all.  This patch only fixes the bug.

Reported-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff -puN kernel/fork.c~clone-fix-race-between-copy_process-and-de_thread kernel/fork.c
--- a/kernel/fork.c~clone-fix-race-between-copy_process-and-de_thread
+++ a/kernel/fork.c
@@ -821,11 +821,8 @@ static int copy_signal(unsigned long clo
 {
 	struct signal_struct *sig;
 
-	if (clone_flags & CLONE_THREAD) {
-		atomic_inc(&current->signal->count);
-		atomic_inc(&current->signal->live);
+	if (clone_flags & CLONE_THREAD)
 		return 0;
-	}
 
 	sig = kmem_cache_alloc(signal_cachep, GFP_KERNEL);
 	tsk->signal = sig;
@@ -883,16 +880,6 @@ void __cleanup_signal(struct signal_stru
 	kmem_cache_free(signal_cachep, sig);
 }
 
-static void cleanup_signal(struct task_struct *tsk)
-{
-	struct signal_struct *sig = tsk->signal;
-
-	atomic_dec(&sig->live);
-
-	if (atomic_dec_and_test(&sig->count))
-		__cleanup_signal(sig);
-}
-
 static void copy_flags(unsigned long clone_flags, struct task_struct *p)
 {
 	unsigned long new_flags = p->flags;
@@ -1245,6 +1232,8 @@ static struct task_struct *copy_process(
 	}
 
 	if (clone_flags & CLONE_THREAD) {
+		atomic_inc(&current->signal->count);
+		atomic_inc(&current->signal->live);
 		p->group_leader = current->group_leader;
 		list_add_tail_rcu(&p->thread_group, &p->group_leader->thread_group);
 	}
@@ -1288,7 +1277,8 @@ bad_fork_cleanup_mm:
 	if (p->mm)
 		mmput(p->mm);
 bad_fork_cleanup_signal:
-	cleanup_signal(p);
+	if (!(clone_flags & CLONE_THREAD))
+		__cleanup_signal(p->signal);
 bad_fork_cleanup_sighand:
 	__cleanup_sighand(p->sighand);
 bad_fork_cleanup_fs:
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
clone-fix-race-between-copy_process-and-de_thread.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
proc_flush_task-flush-proc-tid-task-pid-when-a-sub-thread-exits.patch
cgroups-revert-cgroups-fix-pid-namespace-bug.patch
cgroups-add-a-read-only-procs-file-similar-to-tasks-that-shows-only-unique-tgids.patch
cgroups-ensure-correct-concurrent-opening-reading-of-pidlists-across-pid-namespaces.patch
cgroups-use-vmalloc-for-large-cgroups-pidlist-allocations.patch
cgroups-change-css_set-freeing-mechanism-to-be-under-rcu.patch
cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time.patch
cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time-fix.patch
cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup.patch
cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup-fix.patch
cgroups-add-ability-to-move-all-threads-in-a-process-to-a-new-cgroup-atomically.patch
ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent.patch
do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case.patch
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

