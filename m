From: akpm@linux-foundation.org
Subject: - pid-namespaces-rework-forget_original_parent.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:51:18 -0700
Message-ID: <200710192251.l9JMpIh7024173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48507 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966088AbXJSXGa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:06:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ebiederm@xmission.com, menage@google.com, sukadev@us.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     pid namespaces: rework forget_original_parent()
has been removed from the -mm tree.  Its filename was
     pid-namespaces-rework-forget_original_parent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pid namespaces: rework forget_original_parent()
From: Oleg Nesterov <oleg@tv-sign.ru>

A pid namespace is a "view" of a particular set of tasks on the system.  They
work in a similar way to filesystem namespaces.  A file (or a process) can be
accessed in multiple namespaces, but it may have a different name in each.  In
a filesystem, this name might be /etc/passwd in one namespace, but
/chroot/etc/passwd in another.

For processes, a process may have pid 1234 in one namespace, but be pid 1 in
another.  This allows new pid namespaces to have basically arbitrary pids, and
not have to worry about what pids exist in other namespaces.  This is
essential for checkpoint/restart where a restarted process's pid might collide
with an existing process on the system's pid.

In this particular implementation, pid namespaces have a parent-child
relationship, just like processes.  A process in a pid namespace may see all
of the processes in the same namespace, as well as all of the processes in all
of the namespaces which are children of its namespace.  Processes may not,
however, see others which are in their parent's namespace, but not in their
own.  The same goes for sibling namespaces.

The know issue to be solved in the nearest future is signal handling in the
namespace boundary.  That is, currently the namespace's init is treated like
an ordinary task that can be killed from within an namespace.  Ideally, the
signal handling by the namespace's init should have two sides: when signaling
the init from its namespace, the init should look like a real init task, i.e. 
receive only those signals, that is explicitly wants to; when signaling the
init from one of the parent namespaces, init should look like an ordinary
task, i.e.  receive any signal, only taking the general permissions into
account.

The pid namespace was developed by Pavel Emlyanov and Sukadev Bhattiprolu and
we eventually came to almost the same implementation, which differed in some
details.  This set is based on Pavel's patches, but it includes comments and
patches that from Sukadev.

Many thanks to Oleg, who reviewed the patches, pointed out many BUGs and made
valuable advises on how to make this set cleaner.



This patch:

We have to call exit_task_namespaces() only after the exiting task has
reparented all his children and is sure that no other threads will reparent
theirs for it.  Why this is needed is explained in appropriate patch.  This
one only reworks the forget_original_parent() so that after calling this a
task cannot be/become parent of any other task.

We check PF_EXITING instead of ->exit_state while choosing the new parent. 
Note that tasklits_lock acts as a barrier, everyone who takes tasklist after
us (when forget_original_parent() drops it) must see PF_EXITING.

The other changes are just cleanups.  They just move some code from
exit_notify to forget_original_parent().  It is a bit silly to declare
ptrace_dead in exit_notify(), take tasklist, pass ptrace_dead to
forget_original_parent(), unlock-lock-unlock tasklist, and then use
ptrace_dead.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff -puN kernel/exit.c~pid-namespaces-rework-forget_original_parent kernel/exit.c
--- a/kernel/exit.c~pid-namespaces-rework-forget_original_parent
+++ a/kernel/exit.c
@@ -666,10 +666,14 @@ reparent_thread(struct task_struct *p, s
  * the child reaper process (ie "init") in our pid
  * space.
  */
-static void
-forget_original_parent(struct task_struct *father, struct list_head *to_release)
+static void forget_original_parent(struct task_struct *father)
 {
 	struct task_struct *p, *n, *reaper = father;
+	struct list_head ptrace_dead;
+
+	INIT_LIST_HEAD(&ptrace_dead);
+
+	write_lock_irq(&tasklist_lock);
 
 	do {
 		reaper = next_thread(reaper);
@@ -677,7 +681,7 @@ forget_original_parent(struct task_struc
 			reaper = task_child_reaper(father);
 			break;
 		}
-	} while (reaper->exit_state);
+	} while (reaper->flags & PF_EXITING);
 
 	/*
 	 * There are only two places where our children can be:
@@ -714,12 +718,23 @@ forget_original_parent(struct task_struc
 		 * while it was being traced by us, to be able to see it in wait4.
 		 */
 		if (unlikely(ptrace && p->exit_state == EXIT_ZOMBIE && p->exit_signal == -1))
-			list_add(&p->ptrace_list, to_release);
+			list_add(&p->ptrace_list, &ptrace_dead);
 	}
+
 	list_for_each_entry_safe(p, n, &father->ptrace_children, ptrace_list) {
 		p->real_parent = reaper;
 		reparent_thread(p, father, 1);
 	}
+
+	write_unlock_irq(&tasklist_lock);
+	BUG_ON(!list_empty(&father->children));
+	BUG_ON(!list_empty(&father->ptrace_children));
+
+	list_for_each_entry_safe(p, n, &ptrace_dead, ptrace_list) {
+		list_del_init(&p->ptrace_list);
+		release_task(p);
+	}
+
 }
 
 /*
@@ -730,7 +745,6 @@ static void exit_notify(struct task_stru
 {
 	int state;
 	struct task_struct *t;
-	struct list_head ptrace_dead, *_p, *_n;
 	struct pid *pgrp;
 
 	if (signal_pending(tsk) && !(tsk->signal->flags & SIGNAL_GROUP_EXIT)
@@ -751,8 +765,6 @@ static void exit_notify(struct task_stru
 		spin_unlock_irq(&tsk->sighand->siglock);
 	}
 
-	write_lock_irq(&tasklist_lock);
-
 	/*
 	 * This does two things:
 	 *
@@ -761,12 +773,9 @@ static void exit_notify(struct task_stru
 	 *	as a result of our exiting, and if they have any stopped
 	 *	jobs, send them a SIGHUP and then a SIGCONT.  (POSIX 3.2.2.2)
 	 */
+	forget_original_parent(tsk);
 
-	INIT_LIST_HEAD(&ptrace_dead);
-	forget_original_parent(tsk, &ptrace_dead);
-	BUG_ON(!list_empty(&tsk->children));
-	BUG_ON(!list_empty(&tsk->ptrace_children));
-
+	write_lock_irq(&tasklist_lock);
 	/*
 	 * Check to see if any process groups have become orphaned
 	 * as a result of our exiting, and if they have any stopped
@@ -831,12 +840,6 @@ static void exit_notify(struct task_stru
 
 	write_unlock_irq(&tasklist_lock);
 
-	list_for_each_safe(_p, _n, &ptrace_dead) {
-		list_del_init(_p);
-		t = list_entry(_p, struct task_struct, ptrace_list);
-		release_task(t);
-	}
-
 	/* If the process is dead, release it - nobody will wait for it */
 	if (state == EXIT_DEAD)
 		release_task(tsk);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
