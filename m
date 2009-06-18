From: akpm@linux-foundation.org
Subject: [merged] ptrace-wait_task_zombie-s-parent-real_parent.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:46:43 -0700
Message-ID: <200906182246.n5IMkh31005757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758715AbZFRWr0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:47:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace: wait_task_zombie: s/->parent/->real_parent/
has been removed from the -mm tree.  Its filename was
     ptrace-wait_task_zombie-s-parent-real_parent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: wait_task_zombie: s/->parent/->real_parent/
From: Oleg Nesterov <oleg@redhat.com>

Change wait_task_zombie() to use ->real_parent instead of ->parent.  We
could even use current afaics, but ->real_parent is more clean.

We know that the child is not ptrace_reparented() and thus they are equal.
 But we should avoid using task_struct->parent, we are going to remove it.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/exit.c~ptrace-wait_task_zombie-s-parent-real_parent kernel/exit.c
--- a/kernel/exit.c~ptrace-wait_task_zombie-s-parent-real_parent
+++ a/kernel/exit.c
@@ -1204,7 +1204,7 @@ static int wait_task_zombie(struct task_
 		 * p->signal fields, because they are only touched by
 		 * __exit_signal, which runs with tasklist_lock
 		 * write-locked anyway, and so is excluded here.  We do
-		 * need to protect the access to p->parent->signal fields,
+		 * need to protect the access to parent->signal fields,
 		 * as other threads in the parent group can be right
 		 * here reaping other children at the same time.
 		 *
@@ -1213,8 +1213,8 @@ static int wait_task_zombie(struct task_
 		 * group including the group leader.
 		 */
 		thread_group_cputime(p, &cputime);
-		spin_lock_irq(&p->parent->sighand->siglock);
-		psig = p->parent->signal;
+		spin_lock_irq(&p->real_parent->sighand->siglock);
+		psig = p->real_parent->signal;
 		sig = p->signal;
 		psig->cutime =
 			cputime_add(psig->cutime,
@@ -1245,7 +1245,7 @@ static int wait_task_zombie(struct task_
 			sig->oublock + sig->coublock;
 		task_io_accounting_add(&psig->ioac, &p->ioac);
 		task_io_accounting_add(&psig->ioac, &sig->ioac);
-		spin_unlock_irq(&p->parent->sighand->siglock);
+		spin_unlock_irq(&p->real_parent->sighand->siglock);
 	}
 
 	/*
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
ptrace-wait_task_zombie-do-not-account-traced-sub-threads.patch
linux-next.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch

