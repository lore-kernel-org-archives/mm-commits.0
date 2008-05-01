From: akpm@linux-foundation.org
Subject: - signals-de_thread-simplify-the-child_reaper-switching.patch removed from -mm tree
Date: Thu, 01 May 2008 02:27:09 -0700
Message-ID: <200805010927.m419R9Jo030393@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755660AbYEAJ15 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:27:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: de_thread: simplify the ->child_reaper switching
has been removed from the -mm tree.  Its filename was
     signals-de_thread-simplify-the-child_reaper-switching.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: de_thread: simplify the ->child_reaper switching
From: Oleg Nesterov <oleg@tv-sign.ru>

Now that we rely on SIGNAL_UNKILLABLE flag, de_thread() doesn't need the nasty
hack to kill the old ->child_reaper during the mt-exec.

This also means we can avoid taking tasklist_lock around zap_other_threads().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff -puN fs/exec.c~signals-de_thread-simplify-the-child_reaper-switching fs/exec.c
--- a/fs/exec.c~signals-de_thread-simplify-the-child_reaper-switching
+++ a/fs/exec.c
@@ -766,9 +766,7 @@ static int de_thread(struct task_struct 
 
 	/*
 	 * Kill all other threads in the thread group.
-	 * We must hold tasklist_lock to call zap_other_threads.
 	 */
-	read_lock(&tasklist_lock);
 	spin_lock_irq(lock);
 	if (signal_group_exit(sig)) {
 		/*
@@ -776,21 +774,10 @@ static int de_thread(struct task_struct 
 		 * return so that the signal is processed.
 		 */
 		spin_unlock_irq(lock);
-		read_unlock(&tasklist_lock);
 		return -EAGAIN;
 	}
-
-	/*
-	 * child_reaper ignores SIGKILL, change it now.
-	 * Reparenting needs write_lock on tasklist_lock,
-	 * so it is safe to do it under read_lock.
-	 */
-	if (unlikely(tsk->group_leader == task_child_reaper(tsk)))
-		task_active_pid_ns(tsk)->child_reaper = tsk;
