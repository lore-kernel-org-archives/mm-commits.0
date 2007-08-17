From: akpm@linux-foundation.org
Subject: + isolate-some-explicit-usage-of-task-tgid.patch added to -mm tree
Date: Fri, 17 Aug 2007 14:11:55 -0700
Message-ID: <200708172111.l7HLBtAe029649@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46028 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753737AbXHQVMR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 17:12:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, ebiederm@xmission.com, oleg@tv-sign.ru, sukadev@us.ibm.com


The patch titled
     Isolate some explicit usage of task->tgid
has been added to the -mm tree.  Its filename is
     isolate-some-explicit-usage-of-task-tgid.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Isolate some explicit usage of task->tgid
From: Pavel Emelyanov <xemul@openvz.org>

With pid namespaces this field is now dangerous to use explicitly, so hide
it behind the helpers.

Also the pid and pgrp fields o task_struct and signal_struct are to be
deprecated.  Unfortunately this patch cannot be sent right now as this
leads to tons of warnings, so start isolating them, and deprecate later.

Actually the p->tgid == pid has to be changed to has_group_leader_pid(),
but Oleg pointed out that in case of posix cpu timers this is the same, and
thread_group_leader() is more preferable.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c                 |    4 ++--
 fs/proc/base.c            |    2 +-
 include/linux/sched.h     |    6 ++++++
 kernel/posix-cpu-timers.c |   12 ++++++------
 kernel/posix-timers.c     |    4 ++--
 kernel/ptrace.c           |    2 +-
 kernel/signal.c           |    2 +-
 mm/oom_kill.c             |    2 +-
 8 files changed, 20 insertions(+), 14 deletions(-)

diff -puN fs/exec.c~isolate-some-explicit-usage-of-task-tgid fs/exec.c
--- a/fs/exec.c~isolate-some-explicit-usage-of-task-tgid
+++ a/fs/exec.c
@@ -858,8 +858,8 @@ static int de_thread(struct task_struct 
 
 		write_lock_irq(&tasklist_lock);
 
-		BUG_ON(leader->tgid != tsk->tgid);
-		BUG_ON(tsk->pid == tsk->tgid);
+		BUG_ON(!same_thread_group(leader, tsk));
+		BUG_ON(has_group_leader_pid(tsk));
 		/*
 		 * An exec() starts a new thread group with the
 		 * TGID of the previous thread group. Rehash the
diff -puN fs/proc/base.c~isolate-some-explicit-usage-of-task-tgid fs/proc/base.c
--- a/fs/proc/base.c~isolate-some-explicit-usage-of-task-tgid
+++ a/fs/proc/base.c
@@ -2474,7 +2474,7 @@ static struct dentry *proc_task_lookup(s
 	rcu_read_unlock();
 	if (!task)
 		goto out;
-	if (leader->tgid != task->tgid)
+	if (!same_thread_group(leader, task))
 		goto out_drop_task;
 
 	result = proc_task_instantiate(dir, dentry, task, NULL);
diff -puN include/linux/sched.h~isolate-some-explicit-usage-of-task-tgid include/linux/sched.h
--- a/include/linux/sched.h~isolate-some-explicit-usage-of-task-tgid
+++ a/include/linux/sched.h
@@ -1684,6 +1684,12 @@ static inline int has_group_leader_pid(s
 	return p->pid == p->tgid;
 }
 
+static inline
+int same_thread_group(struct task_struct *p1, struct task_struct *p2)
+{
+	return p1->tgid == p2->tgid;
+}
+
 static inline struct task_struct *next_thread(const struct task_struct *p)
 {
 	return list_entry(rcu_dereference(p->thread_group.next),
diff -puN kernel/posix-cpu-timers.c~isolate-some-explicit-usage-of-task-tgid kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~isolate-some-explicit-usage-of-task-tgid
+++ a/kernel/posix-cpu-timers.c
@@ -21,8 +21,8 @@ static int check_clock(const clockid_t w
 
 	read_lock(&tasklist_lock);
 	p = find_task_by_pid(pid);
-	if (!p || (CPUCLOCK_PERTHREAD(which_clock) ?
-		   p->tgid != current->tgid : p->tgid != pid)) {
+	if (!p || !(CPUCLOCK_PERTHREAD(which_clock) ?
+		   same_thread_group(p, current) : thread_group_leader(p))) {
 		error = -EINVAL;
 	}
 	read_unlock(&tasklist_lock);
@@ -308,13 +308,13 @@ int posix_cpu_clock_get(const clockid_t 
 		p = find_task_by_pid(pid);
 		if (p) {
 			if (CPUCLOCK_PERTHREAD(which_clock)) {
-				if (p->tgid == current->tgid) {
+				if (same_thread_group(p, current)) {
 					error = cpu_clock_sample(which_clock,
 								 p, &rtn);
 				}
 			} else {
 				read_lock(&tasklist_lock);
-				if (p->tgid == pid && p->signal) {
+				if (thread_group_leader(p) && p->signal) {
 					error =
 					    cpu_clock_sample_group(which_clock,
 							           p, &rtn);
@@ -355,7 +355,7 @@ int posix_cpu_timer_create(struct k_itim
 			p = current;
 		} else {
 			p = find_task_by_pid(pid);
-			if (p && p->tgid != current->tgid)
+			if (p && !same_thread_group(p, current))
 				p = NULL;
 		}
 	} else {
@@ -363,7 +363,7 @@ int posix_cpu_timer_create(struct k_itim
 			p = current->group_leader;
 		} else {
 			p = find_task_by_pid(pid);
-			if (p && p->tgid != pid)
+			if (p && !thread_group_leader(p))
 				p = NULL;
 		}
 	}
diff -puN kernel/posix-timers.c~isolate-some-explicit-usage-of-task-tgid kernel/posix-timers.c
--- a/kernel/posix-timers.c~isolate-some-explicit-usage-of-task-tgid
+++ a/kernel/posix-timers.c
@@ -404,7 +404,7 @@ static struct task_struct * good_sigeven
 
 	if ((event->sigev_notify & SIGEV_THREAD_ID ) &&
 		(!(rtn = find_task_by_pid(event->sigev_notify_thread_id)) ||
-		 rtn->tgid != current->tgid ||
+		 !same_thread_group(rtn, current) ||
 		 (event->sigev_notify & ~SIGEV_THREAD_ID) != SIGEV_SIGNAL))
 		return NULL;
 
@@ -608,7 +608,7 @@ static struct k_itimer * lock_timer(time
 		spin_lock(&timr->it_lock);
 
 		if ((timr->it_id != timer_id) || !(timr->it_process) ||
-				timr->it_process->tgid != current->tgid) {
+				!same_thread_group(timr->it_process, current)) {
 			spin_unlock(&timr->it_lock);
 			spin_unlock_irqrestore(&idr_lock, *flags);
 			timr = NULL;
diff -puN kernel/ptrace.c~isolate-some-explicit-usage-of-task-tgid kernel/ptrace.c
--- a/kernel/ptrace.c~isolate-some-explicit-usage-of-task-tgid
+++ a/kernel/ptrace.c
@@ -169,7 +169,7 @@ int ptrace_attach(struct task_struct *ta
 	retval = -EPERM;
 	if (task->pid <= 1)
 		goto out;
-	if (task->tgid == current->tgid)
+	if (same_thread_group(task, current))
 		goto out;
 
 repeat:
diff -puN kernel/signal.c~isolate-some-explicit-usage-of-task-tgid kernel/signal.c
--- a/kernel/signal.c~isolate-some-explicit-usage-of-task-tgid
+++ a/kernel/signal.c
@@ -1155,7 +1155,7 @@ static int kill_something_info(int sig, 
 
 		read_lock(&tasklist_lock);
 		for_each_process(p) {
-			if (p->pid > 1 && p->tgid != current->tgid) {
+			if (p->pid > 1 && !same_thread_group(p, current)) {
 				int err = group_send_sig_info(sig, info, p);
 				++count;
 				if (err != -EPERM)
diff -puN mm/oom_kill.c~isolate-some-explicit-usage-of-task-tgid mm/oom_kill.c
--- a/mm/oom_kill.c~isolate-some-explicit-usage-of-task-tgid
+++ a/mm/oom_kill.c
@@ -330,7 +330,7 @@ static int oom_kill_task(struct task_str
 	 * to memory reserves though, otherwise we might deplete all memory.
 	 */
 	do_each_thread(g, q) {
-		if (q->mm == mm && q->tgid != p->tgid)
+		if (q->mm == mm && !same_thread_group(q, p))
 			force_sig(SIGKILL, q);
 	} while_each_thread(g, q);
 
_

Patches currently in -mm which might be from xemul@openvz.org are

git-net.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
make-access-to-tasks-nsproxy-lighter.patch
pid-namespaces-rework-forget_original_parent.patch
pid-namespaces-move-exit_task_namespaces.patch
pid-namespaces-introduce-ms_kernmount-flag.patch
pid-namespaces-prepare-proc_flust_task-to-flush-entries-from-multiple-proc-trees.patch
pid-namespaces-introduce-struct-upid.patch
pid-namespaces-add-support-for-pid-namespaces-hierarchy.patch
pid-namespaces-make-alloc_pid-free_pid-and-put_pid-work-with-struct-upid.patch
pid-namespaces-helpers-to-obtain-pid-numbers.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch
pid-namespaces-move-alloc_pid-lower-in-copy_process.patch
pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace.patch
pid-namespaces-miscelaneous-preparations-for-pid-namespaces.patch
pid-namespaces-allow-cloning-of-new-namespace.patch
pid-namespaces-allow-cloning-of-new-namespace-fix-check-for-return-value-of-create_pid_namespace.patch
pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces.patch
pid-namespaces-initialize-the-namespaces-proc_mnt.patch
pid-namespaces-allow-signalling-container-init.patch
pid-namespaces-destroy-pid-namespace-on-inits-death.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix-the-return-value-of-sys_set_tid_address.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual.patch
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
isolate-some-explicit-usage-of-task-tgid.patch
