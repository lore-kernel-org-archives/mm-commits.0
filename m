From: akpm@linux-foundation.org
Subject: [merged]
 hung_task-change-hung_taskc-to-use-for_each_process_thread.patch removed
 from -mm tree
Date: Thu, 16 Apr 2015 09:54:26 -0700
Message-ID: <552fe942.WOmL5y35S9CzPPgZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbbDPQs5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:48:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: atomlin@redhat.com, dwysocha@redhat.com, oleg@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/hung_task.c: change hung_task.c to use for_each_process_thread()
has been removed from the -mm tree.  Its filename was
     hung_task-change-hung_taskc-to-use-for_each_process_thread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Aaron Tomlin <atomlin@redhat.com>
Subject: kernel/hung_task.c: change hung_task.c to use for_each_process_thread()

In check_hung_uninterruptible_tasks() avoid the use of deprecated
while_each_thread().

The "max_count" logic will prevent a livelock - see commit 0c740d0a
("introduce for_each_thread() to replace the buggy while_each_thread()"). 
Having said this let's use for_each_process_thread().

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dave Wysochanski <dwysocha@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hung_task.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/hung_task.c~hung_task-change-hung_taskc-to-use-for_each_process_thread kernel/hung_task.c
--- a/kernel/hung_task.c~hung_task-change-hung_taskc-to-use-for_each_process_thread
+++ a/kernel/hung_task.c
@@ -169,7 +169,7 @@ static void check_hung_uninterruptible_t
 		return;
 
 	rcu_read_lock();
-	do_each_thread(g, t) {
+	for_each_process_thread(g, t) {
 		if (!max_count--)
 			goto unlock;
 		if (!--batch_count) {
@@ -180,7 +180,7 @@ static void check_hung_uninterruptible_t
 		/* use "==" to skip the TASK_KILLABLE tasks waiting on NFS */
 		if (t->state == TASK_UNINTERRUPTIBLE)
 			check_hung_task(t, timeout);
-	} while_each_thread(g, t);
+	}
  unlock:
 	rcu_read_unlock();
 }
_

Patches currently in -mm which might be from atomlin@redhat.com are

origin.patch

