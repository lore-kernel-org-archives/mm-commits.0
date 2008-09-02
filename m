From: akpm@linux-foundation.org
Subject: - exit-signals-use-of-uninitialized-field-notify_count.patch removed from -mm tree
Date: Tue, 02 Sep 2008 12:48:29 -0700
Message-ID: <200809021948.m82JmTiL009545@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42030 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754290AbYIBTus (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 15:50:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vandebo-lkml@NerdBox.Net, mingo@elte.hu, oleg@tv-sign.ru, roland@redhat.comvandebo-lkml@NerdBox.Net, mm-commits@vger.kernel.org


The patch titled
     exit signals: use of uninitialized field notify_count
has been removed from the -mm tree.  Its filename was
     exit-signals-use-of-uninitialized-field-notify_count.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: exit signals: use of uninitialized field notify_count
From: Steve VanDeBogart <vandebo-lkml@NerdBox.Net>

task->signal->notify_count is only initialized if
task->signal->group_exit_task is not NULL.  Reorder a conditional so
that uninitialised memory is not used.  Found by Valgrind.

Signed-off-by: Steve VanDeBogart <vandebo-lkml@nerdbox.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/exit.c~exit-signals-use-of-uninitialized-field-notify_count kernel/exit.c
--- a/kernel/exit.c~exit-signals-use-of-uninitialized-field-notify_count
+++ a/kernel/exit.c
@@ -918,8 +918,8 @@ static void exit_notify(struct task_stru
 
 	/* mt-exec, de_thread() is waiting for us */
 	if (thread_group_leader(tsk) &&
-	    tsk->signal->notify_count < 0 &&
-	    tsk->signal->group_exit_task)
+	    tsk->signal->group_exit_task &&
+	    tsk->signal->notify_count < 0)
 		wake_up_process(tsk->signal->group_exit_task);
 
 	write_unlock_irq(&tasklist_lock);
_

Patches currently in -mm which might be from vandebo-lkml@NerdBox.Net are


