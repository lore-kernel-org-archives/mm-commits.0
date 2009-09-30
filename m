From: akpm@linux-foundation.org
Subject: + rwsem-fix-rwsem_is_locked-bug.patch added to -mm tree
Date: Wed, 30 Sep 2009 16:08:44 -0700
Message-ID: <200909302308.n8UN8iqB019057@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754319AbZI3XJ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Sep 2009 19:09:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, behlendorf1@llnl.gov, bwoodard@llnl.gov, dhowells@redhat.com, mingo@elte.hu, stable@kernel.org


The patch titled
     rwsem: fix rwsem_is_locked() bug
has been added to the -mm tree.  Its filename is
     rwsem-fix-rwsem_is_locked-bug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rwsem: fix rwsem_is_locked() bug
From: Amerigo Wang <amwang@redhat.com>

rwsem_is_locked() tests ->activity without locks, so we should always keep
->activity consistent.  However, the code in __rwsem_do_wake() breaks this
rule, it updates ->activity after _all_ readers waken up, this may give
some reader a wrong ->activity value, thus cause rwsem_is_locked() behaves
wrong.

Brian has a kernel module to reproduce this, I can include it if any of
you need.  Of course, with Brian's approval.

With this patch applied, I can't trigger that bug any more.


akpm sez:

- we have one or more processes sleeping in down_read(), waiting for
  access.

- we wake one or more processes up without altering ->activity

- they start to run and they do rwsem_is_locked().  This incorrectly
  returns "false", because the waker process is still crunching away in
  __rwsem_do_wake().

- the waker now alters ->activity, but it was too late.

The patch fixes this by updating ->activity prior to waking the sleeping
processes.  So when they run, they'll see a non-zero value of ->activity.


Reported-by: Brian Behlendorf <behlendorf1@llnl.gov>
Cc: Ben Woodard <bwoodard@llnl.gov>
Cc: David Howells <dhowells@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rwsem-spinlock.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN lib/rwsem-spinlock.c~rwsem-fix-rwsem_is_locked-bug lib/rwsem-spinlock.c
--- a/lib/rwsem-spinlock.c~rwsem-fix-rwsem_is_locked-bug
+++ a/lib/rwsem-spinlock.c
@@ -49,7 +49,6 @@ __rwsem_do_wake(struct rw_semaphore *sem
 {
 	struct rwsem_waiter *waiter;
 	struct task_struct *tsk;
-	int woken;
 
 	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
 
@@ -78,24 +77,21 @@ __rwsem_do_wake(struct rw_semaphore *sem
 
 	/* grant an infinite number of read locks to the front of the queue */
  dont_wake_writers:
-	woken = 0;
 	while (waiter->flags & RWSEM_WAITING_FOR_READ) {
 		struct list_head *next = waiter->list.next;
 
+		sem->activity++;
 		list_del(&waiter->list);
 		tsk = waiter->task;
 		smp_mb();
 		waiter->task = NULL;
 		wake_up_process(tsk);
 		put_task_struct(tsk);
-		woken++;
 		if (list_empty(&sem->wait_list))
 			break;
 		waiter = list_entry(next, struct rwsem_waiter, list);
 	}
 
-	sem->activity += woken;
