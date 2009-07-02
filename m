From: akpm@linux-foundation.org
Subject: + do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch added to -mm tree
Date: Thu, 02 Jul 2009 14:29:19 -0700
Message-ID: <200907022129.n62LTKAi024287@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49720 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754261AbZGBV3p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jul 2009 17:29:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, mingo@elte.hu, rientjes@google.com, rnalumasu@gmail.com, roland@redhat.com, vmayatsk@redhat.com


The patch titled
     do_wait() optimization: do not place sub-threads on task_struct->children list
has been added to the -mm tree.  Its filename is
     do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch

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
Subject: do_wait() optimization: do not place sub-threads on task_struct->children list
From: Oleg Nesterov <oleg@redhat.com>

Thanks to Roland who pointed out de_thread() issues.

Currently we add sub-threads to ->real_parent->children list.  This buys
nothing but slows down do_wait().

With this patch ->children contains only main threads (group leaders). 
The only complication is that forget_original_parent() should iterate over
sub-threads by hand, and de_thread() needs another list_replace() when it
changes ->group_leader.

Henceforth do_wait_thread() can never see task_detached() && !EXIT_DEAD
tasks, we can remove this check (and we can unify do_wait_thread() and
ptrace_do_wait()).

This change can confuse the optimistic search in mm_update_next_owner(),
but this is fixable and minor.

Perhaps badness() and oom_kill_process() should be updated, but they
should be fixed in any case.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ratan Nalumasu <rnalumasu@gmail.com>
Cc: Vitaly Mayatskikh <vmayatsk@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c     |    2 ++
 kernel/exit.c |   36 +++++++++++++++++-------------------
 kernel/fork.c |    2 +-
 3 files changed, 20 insertions(+), 20 deletions(-)

diff -puN fs/exec.c~do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list fs/exec.c
--- a/fs/exec.c~do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list
+++ a/fs/exec.c
@@ -827,7 +827,9 @@ static int de_thread(struct task_struct 
 		attach_pid(tsk, PIDTYPE_PID,  task_pid(leader));
 		transfer_pid(leader, tsk, PIDTYPE_PGID);
 		transfer_pid(leader, tsk, PIDTYPE_SID);
+
 		list_replace_rcu(&leader->tasks, &tsk->tasks);
+		list_replace_init(&leader->sibling, &tsk->sibling);
 
 		tsk->group_leader = tsk;
 		leader->group_leader = tsk;
diff -puN kernel/exit.c~do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list kernel/exit.c
--- a/kernel/exit.c~do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list
+++ a/kernel/exit.c
@@ -68,10 +68,10 @@ static void __unhash_process(struct task
 		detach_pid(p, PIDTYPE_SID);
 
 		list_del_rcu(&p->tasks);
+		list_del_init(&p->sibling);
 		__get_cpu_var(process_counts)--;
 	}
 	list_del_rcu(&p->thread_group);
-	list_del_init(&p->sibling);
 }
 
 /*
@@ -738,12 +738,9 @@ static struct task_struct *find_new_reap
 /*
 * Any that need to be release_task'd are put on the @dead list.
  */
-static void reparent_thread(struct task_struct *father, struct task_struct *p,
+static void reparent_leader(struct task_struct *father, struct task_struct *p,
 				struct list_head *dead)
 {
-	if (p->pdeath_signal)
-		group_send_sig_info(p->pdeath_signal, SEND_SIG_NOINFO, p);
-
 	list_move_tail(&p->sibling, &p->real_parent->children);
 
 	if (task_detached(p))
@@ -782,12 +779,18 @@ static void forget_original_parent(struc
 	reaper = find_new_reaper(father);
 
 	list_for_each_entry_safe(p, n, &father->children, sibling) {
-		p->real_parent = reaper;
-		if (p->parent == father) {
-			BUG_ON(task_ptrace(p));
-			p->parent = p->real_parent;
-		}
-		reparent_thread(father, p, &dead_children);
+		struct task_struct *t = p;
+		do {
+			t->real_parent = reaper;
+			if (t->parent == father) {
+				BUG_ON(task_ptrace(t));
+				t->parent = t->real_parent;
+			}
+			if (t->pdeath_signal)
+				group_send_sig_info(t->pdeath_signal,
+						    SEND_SIG_NOINFO, t);
+		} while_each_thread(p, t);
+		reparent_leader(father, p, &dead_children);
 	}
 	write_unlock_irq(&tasklist_lock);
 
@@ -1541,14 +1544,9 @@ static int do_wait_thread(struct wait_op
 	struct task_struct *p;
 
 	list_for_each_entry(p, &tsk->children, sibling) {
-		/*
-		 * Do not consider detached threads.
-		 */
-		if (!task_detached(p)) {
-			int ret = wait_consider_task(wo, tsk, 0, p);
-			if (ret)
-				return ret;
-		}
+		int ret = wait_consider_task(wo, tsk, 0, p);
+		if (ret)
+			return ret;
 	}
 
 	return 0;
diff -puN kernel/fork.c~do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list kernel/fork.c
--- a/kernel/fork.c~do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list
+++ a/kernel/fork.c
@@ -1248,7 +1248,6 @@ static struct task_struct *copy_process(
 	}
 
 	if (likely(p->pid)) {
-		list_add_tail(&p->sibling, &p->real_parent->children);
 		tracehook_finish_clone(p, clone_flags, trace);
 
 		if (thread_group_leader(p)) {
@@ -1260,6 +1259,7 @@ static struct task_struct *copy_process(
 			p->signal->tty = tty_kref_get(current->signal->tty);
 			attach_pid(p, PIDTYPE_PGID, task_pgrp(current));
 			attach_pid(p, PIDTYPE_SID, task_session(current));
+			list_add_tail(&p->sibling, &p->real_parent->children);
 			list_add_tail_rcu(&p->tasks, &init_task.tasks);
 			__get_cpu_var(process_counts)++;
 		}
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
cred_guard_mutex-do-not-return-eintr-to-user-space.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch
do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch
do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch

