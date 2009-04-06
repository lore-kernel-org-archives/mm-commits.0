From: akpm@linux-foundation.org
Subject: [merged] ptrace-simplify-ptrace_exit-ignoring_children-path.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:35:36 -0700
Message-ID: <200904061935.n36JZaYW012124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36711 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757758AbZDFTjn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:39:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, dvlasenk@redhat.com, jmarchan@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace: simplify ptrace_exit()->ignoring_children() path
has been removed from the -mm tree.  Its filename was
     ptrace-simplify-ptrace_exit-ignoring_children-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: simplify ptrace_exit()->ignoring_children() path
From: Oleg Nesterov <oleg@redhat.com>

ignoring_children() takes parent->sighand->siglock and checks
k_sigaction[SIGCHLD] atomically.  But this buys nothing, we can't get the
"really" wrong result even if we race with sigaction(SIGCHLD).  If we read
the "stale" sa_handler/sa_flags we can pretend it was changed right after
the check.

Remove spin_lock(->siglock), and kill "int ign" which caches the result of
ignoring_children() which becomes rather trivial.

Perhaps it makes sense to export this helper, do_notify_parent() can use
it too.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff -puN kernel/exit.c~ptrace-simplify-ptrace_exit-ignoring_children-path kernel/exit.c
--- a/kernel/exit.c~ptrace-simplify-ptrace_exit-ignoring_children-path
+++ a/kernel/exit.c
@@ -732,19 +732,15 @@ static void exit_mm(struct task_struct *
 }
 
 /*
- * Return nonzero if @parent's children should reap themselves.
- *
- * Called with write_lock_irq(&tasklist_lock) held.
+ * Called with irqs disabled, returns true if childs should reap themselves.
  */
-static int ignoring_children(struct task_struct *parent)
+static int ignoring_children(struct sighand_struct *sigh)
 {
 	int ret;
-	struct sighand_struct *psig = parent->sighand;
-	unsigned long flags;
-	spin_lock_irqsave(&psig->siglock, flags);
-	ret = (psig->action[SIGCHLD-1].sa.sa_handler == SIG_IGN ||
-	       (psig->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDWAIT));
-	spin_unlock_irqrestore(&psig->siglock, flags);
+	spin_lock(&sigh->siglock);
+	ret = (sigh->action[SIGCHLD-1].sa.sa_handler == SIG_IGN) ||
+	      (sigh->action[SIGCHLD-1].sa.sa_flags & SA_NOCLDWAIT);
+	spin_unlock(&sigh->siglock);
 	return ret;
 }
 
@@ -757,7 +753,6 @@ static int ignoring_children(struct task
 static void ptrace_exit(struct task_struct *parent, struct list_head *dead)
 {
 	struct task_struct *p, *n;
-	int ign = -1;
 
 	list_for_each_entry_safe(p, n, &parent->ptraced, ptrace_entry) {
 		__ptrace_unlink(p);
@@ -779,12 +774,8 @@ static void ptrace_exit(struct task_stru
 		if (!task_detached(p) && thread_group_empty(p)) {
 			if (!same_thread_group(p->real_parent, parent))
 				do_notify_parent(p, p->exit_signal);
-			else {
-				if (ign < 0)
-					ign = ignoring_children(parent);
-				if (ign)
-					p->exit_signal = -1;
-			}
+			else if (ignoring_children(parent->sighand))
+				p->exit_signal = -1;
 		}
 
 		if (task_detached(p)) {
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
getrusage-fill-ru_maxrss-value.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
signals-tracehook_notify_jctl-change.patch

