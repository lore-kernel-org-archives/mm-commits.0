From: akpm@linux-foundation.org
Subject: + ipc-sem-rework-task-wakeups-fix.patch added to -mm tree
Date: Tue, 22 Nov 2016 16:35:16 -0800
Message-ID: <5834e444.UuA6gILND+rLSzH2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37776 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752822AbcKWAfq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2016 19:35:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem: merge fix for WAKE_Q to DEFINE_WAKE_Q rename
has been added to the -mm tree.  Its filename is
     ipc-sem-rework-task-wakeups-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-sem-rework-task-wakeups-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-sem-rework-task-wakeups-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: ipc/sem: merge fix for WAKE_Q to DEFINE_WAKE_Q rename

Link: http://lkml.kernel.org/r/20161122210410.5eca9fc2@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN ipc/sem.c~ipc-sem-rework-task-wakeups-fix ipc/sem.c
--- a/ipc/sem.c~ipc-sem-rework-task-wakeups-fix
+++ a/ipc/sem.c
@@ -1059,7 +1059,7 @@ static void freeary(struct ipc_namespace
 	struct sem_queue *q, *tq;
 	struct sem_array *sma = container_of(ipcp, struct sem_array, sem_perm);
 	int i;
-	WAKE_Q(wake_q);
+	DEFINE_WAKE_Q(wake_q);
 
 	/* Free the existing undo structures for this semaphore set.  */
 	ipc_assert_locked_object(&sma->sem_perm);
@@ -1239,7 +1239,7 @@ static int semctl_setval(struct ipc_name
 	struct sem_array *sma;
 	struct sem *curr;
 	int err, val;
-	WAKE_Q(wake_q);
+	DEFINE_WAKE_Q(wake_q);
 
 #if defined(CONFIG_64BIT) && defined(__BIG_ENDIAN)
 	/* big-endian 64bit */
@@ -1309,7 +1309,7 @@ static int semctl_main(struct ipc_namesp
 	int err, nsems;
 	ushort fast_sem_io[SEMMSL_FAST];
 	ushort *sem_io = fast_sem_io;
-	WAKE_Q(wake_q);
+	DEFINE_WAKE_Q(wake_q);
 
 	rcu_read_lock();
 	sma = sem_obtain_object_check(ns, semid);
@@ -1848,7 +1848,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 
 	error = perform_atomic_semop(sma, &queue);
 	if (error == 0) { /* non-blocking succesfull path */
-		WAKE_Q(wake_q);
+		DEFINE_WAKE_Q(wake_q);
 
 		/*
 		 * If the operation was successful, then do
@@ -2031,7 +2031,7 @@ void exit_sem(struct task_struct *tsk)
 		struct sem_array *sma;
 		struct sem_undo *un;
 		int semid, i;
-		WAKE_Q(wake_q);
+		DEFINE_WAKE_Q(wake_q);
 
 		cond_resched();
 
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

ipc-sem-rework-task-wakeups-fix.patch
mm-add-locked-parameter-to-get_user_pages_remote-fix.patch

