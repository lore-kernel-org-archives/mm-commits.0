From: akpm@osdl.org
Subject: + pm-fix-freezing-of-stopped-tasks.patch added to -mm tree
Date: Sun, 10 Dec 2006 13:21:01 -0800
Message-ID: <200612102121.kBALL1JG003544@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35501 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762616AbWLJVV1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 16:21:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, pavel@ucw.cz


The patch titled
     PM: Fix freezing of stopped tasks
has been added to the -mm tree.  Its filename is
     pm-fix-freezing-of-stopped-tasks.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PM: Fix freezing of stopped tasks
From: "Rafael J. Wysocki" <rjw@sisk.pl>

Currently, if a task is stopped (ie.  it's in the TASK_STOPPED state), it
is considered by the freezer as unfreezeable.  However, there may be a race
between the freezer and the delivery of the continuation signal to the task
resulting in the task running after we have finished freezing the other
tasks.  This, in turn, may lead to undesirable effects up to and including
data corruption.

To prevent this from happening we first need to make the freezer consider
stopped tasks as freezeable.  For this purpose we need to make freezeable()
stop returning 0 for these tasks and we need to force them to enter the
refrigerator.  However, if there's no continuation signal in the meantime,
the stopped tasks should remain stopped after all processes have been
thawed, so we need to send an additional SIGSTOP to each of them before
waking it up.

Also, a stopped task that has just been woken up should first check if
there's a freezing request for it and go to the refrigerator if that's the
case.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/power/process.c |   12 ++++++------
 kernel/signal.c        |    4 +++-
 2 files changed, 9 insertions(+), 7 deletions(-)

diff -puN kernel/power/process.c~pm-fix-freezing-of-stopped-tasks kernel/power/process.c
--- a/kernel/power/process.c~pm-fix-freezing-of-stopped-tasks
+++ a/kernel/power/process.c
@@ -28,8 +28,7 @@ static inline int freezeable(struct task
 	if ((p == current) || 
 	    (p->flags & PF_NOFREEZE) ||
 	    (p->exit_state == EXIT_ZOMBIE) ||
-	    (p->exit_state == EXIT_DEAD) ||
-	    (p->state == TASK_STOPPED))
+	    (p->exit_state == EXIT_DEAD))
 		return 0;
 	return 1;
 }
@@ -61,9 +60,12 @@ static inline void freeze_process(struct
 	unsigned long flags;
 
 	if (!freezing(p)) {
+		if (p->state == TASK_STOPPED)
+			force_sig_specific(SIGSTOP, p);
+
 		freeze(p);
 		spin_lock_irqsave(&p->sighand->siglock, flags);
-		signal_wake_up(p, 0);
+		signal_wake_up(p, p->state == TASK_STOPPED);
 		spin_unlock_irqrestore(&p->sighand->siglock, flags);
 	}
 }
@@ -103,9 +105,7 @@ static unsigned int try_to_freeze_tasks(
 			if (frozen(p))
 				continue;
 
-			if (p->state == TASK_TRACED &&
-			    (frozen(p->parent) ||
-			     p->parent->state == TASK_STOPPED)) {
+			if (p->state == TASK_TRACED && frozen(p->parent)) {
 				cancel_freezing(p);
 				continue;
 			}
diff -puN kernel/signal.c~pm-fix-freezing-of-stopped-tasks kernel/signal.c
--- a/kernel/signal.c~pm-fix-freezing-of-stopped-tasks
+++ a/kernel/signal.c
@@ -1705,7 +1705,9 @@ finish_stop(int stop_count)
 		read_unlock(&tasklist_lock);
 	}
 
-	schedule();
+	do {
+		schedule();
+	} while (try_to_freeze());
 	/*
 	 * Now we don't run again until continued.
 	 */
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
pm-fix-freezing-of-stopped-tasks.patch
pm-fix-smp-races-in-the-freezer.patch
md-change-lifetime-rules-for-md-devices.patch

