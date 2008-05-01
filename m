From: akpm@linux-foundation.org
Subject: - signals-send_sigqueue-dont-take-rcu-lock.patch removed from -mm tree
Date: Thu, 01 May 2008 02:26:25 -0700
Message-ID: <200805010926.m419QPZ9030297@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755986AbYEAJlz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:41:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: send_sigqueue: don't take rcu lock
has been removed from the -mm tree.  Its filename was
     signals-send_sigqueue-dont-take-rcu-lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: send_sigqueue: don't take rcu lock
From: Oleg Nesterov <oleg@tv-sign.ru>

lock_task_sighand() was changed, send_sigqueue() doesn't need rcu_read_lock()
any longer.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN kernel/signal.c~signals-send_sigqueue-dont-take-rcu-lock kernel/signal.c
--- a/kernel/signal.c~signals-send_sigqueue-dont-take-rcu-lock
+++ a/kernel/signal.c
@@ -1311,8 +1311,6 @@ int send_sigqueue(int sig, struct sigque
 	 * We return -1, when the task is marked exiting, so
 	 * posix_timer_event can redirect it to the group leader
 	 */
-	rcu_read_lock();
-
 	if (!likely(lock_task_sighand(p, &flags)))
 		goto out_err;
 
@@ -1323,8 +1321,6 @@ int send_sigqueue(int sig, struct sigque
 
 	unlock_task_sighand(p, &flags);
 out_err:
-	rcu_read_unlock();
