From: akpm@linux-foundation.org
Subject: [merged] ipcsem-use-current-state-helpers.patch removed from -mm
 tree
Date: Wed, 18 Feb 2015 11:44:51 -0800
Message-ID: <54e4ebb3.1rLGYv/AJQ4OHD8l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46305 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbbBRTow (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:44:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc,sem: use current->state helpers
has been removed from the -mm tree.  Its filename was
     ipcsem-use-current-state-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: ipc,sem: use current->state helpers

Call __set_current_state() instead of assigning the new state directly. 
These interfaces also aid CONFIG_DEBUG_ATOMIC_SLEEP environments, keeping
track of who changed the state.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/sem.c~ipcsem-use-current-state-helpers ipc/sem.c
--- a/ipc/sem.c~ipcsem-use-current-state-helpers
+++ a/ipc/sem.c
@@ -1941,7 +1941,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 	queue.sleeper = current;
 
 sleep_again:
-	current->state = TASK_INTERRUPTIBLE;
+	__set_current_state(TASK_INTERRUPTIBLE);
 	sem_unlock(sma, locknum);
 	rcu_read_unlock();
 
_

Patches currently in -mm which might be from dave@stgolabs.net are

origin.patch

