From: akpm@linux-foundation.org
Subject: - k_getrusage-dont-take-rcu_read_lock.patch removed from -mm tree
Date: Thu, 01 May 2008 02:25:58 -0700
Message-ID: <200805010925.m419PwV3030258@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44358 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756870AbYEAJ1H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:27:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ebiederm@xmission.com, paulmck@linux.vnet.ibm.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     k_getrusage: don't take rcu_read_lock()
has been removed from the -mm tree.  Its filename was
     k_getrusage-dont-take-rcu_read_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: k_getrusage: don't take rcu_read_lock()
From: Oleg Nesterov <oleg@tv-sign.ru>

Just a trivial example, more to come.

k_getrusage() holds rcu_read_lock() because it was previously required by
lock_task_sighand().  Unneeded now.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN kernel/sys.c~k_getrusage-dont-take-rcu_read_lock kernel/sys.c
--- a/kernel/sys.c~k_getrusage-dont-take-rcu_read_lock
+++ a/kernel/sys.c
@@ -1572,11 +1572,8 @@ static void k_getrusage(struct task_stru
 		goto out;
 	}
 
-	rcu_read_lock();
-	if (!lock_task_sighand(p, &flags)) {
-		rcu_read_unlock();
+	if (!lock_task_sighand(p, &flags))
 		return;
-	}
 
 	switch (who) {
 		case RUSAGE_BOTH:
@@ -1612,9 +1609,7 @@ static void k_getrusage(struct task_stru
 		default:
 			BUG();
 	}
