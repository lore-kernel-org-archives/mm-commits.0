From: akpm@linux-foundation.org
Subject: - document-de_thread-with-exit_notify-connection.patch removed from -mm tree
Date: Thu, 01 May 2008 02:27:33 -0700
Message-ID: <200805010927.m419RXPr030427@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50817 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757106AbYEAJio (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:38:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     document de_thread() with exit_notify() connection
has been removed from the -mm tree.  Its filename was
     document-de_thread-with-exit_notify-connection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: document de_thread() with exit_notify() connection
From: Oleg Nesterov <oleg@tv-sign.ru>

Add a couple of small comments, it is not easy to see what this code does.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c     |    2 +-
 kernel/exit.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/exec.c~document-de_thread-with-exit_notify-connection fs/exec.c
--- a/fs/exec.c~document-de_thread-with-exit_notify-connection
+++ a/fs/exec.c
@@ -798,7 +798,7 @@ static int de_thread(struct task_struct 
 	if (!thread_group_leader(tsk)) {
 		leader = tsk->group_leader;
 
-		sig->notify_count = -1;
+		sig->notify_count = -1;	/* for exit_notify() */
 		for (;;) {
 			write_lock_irq(&tasklist_lock);
 			if (likely(leader->exit_state))
diff -puN kernel/exit.c~document-de_thread-with-exit_notify-connection kernel/exit.c
--- a/kernel/exit.c~document-de_thread-with-exit_notify-connection
+++ a/kernel/exit.c
@@ -877,6 +877,7 @@ static void exit_notify(struct task_stru
 		state = EXIT_DEAD;
 	tsk->exit_state = state;
 
+	/* mt-exec, de_thread() is waiting for us */
 	if (thread_group_leader(tsk) &&
 	    tsk->signal->notify_count < 0 &&
 	    tsk->signal->group_exit_task)
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
workqueue-remove-redundant-function-invocation.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

