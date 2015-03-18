From: akpm@linux-foundation.org
Subject: +
 hung_task-change-hung_taskc-to-use-for_each_process_thread.patch added to
 -mm tree
Date: Wed, 18 Mar 2015 15:09:37 -0700
Message-ID: <5509f7a1.syug1D0LLBFLDL9f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39368 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076AbbCRWJi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Mar 2015 18:09:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: atomlin@redhat.com, dwysocha@redhat.com, oleg@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/hung_task.c: change hung_task.c to use for_each_process_thread()
has been added to the -mm tree.  Its filename is
     hung_task-change-hung_taskc-to-use-for_each_process_thread.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hung_task-change-hung_taskc-to-use-for_each_process_thread.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hung_task-change-hung_taskc-to-use-for_each_process_thread.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

hung_task-change-hung_taskc-to-use-for_each_process_thread.patch

