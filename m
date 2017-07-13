From: akpm@linux-foundation.org
Subject: [merged]
 include-linux-semh-correctly-document-sem_ctime.patch removed from -mm tree
Date: Thu, 13 Jul 2017 13:41:18 -0700
Message-ID: <20170713204118.GVvAryoSp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59160 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753095AbdGMUlT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:41:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 1vier1@web.de, dave@stgolabs.net, fabf@skynet.be, keescook@chromium.org, manfred@colorfullife.com, mingo@kernel.org, mm-commits@vger.kernel.org, peterz@infradead.org


The patch titled
     Subject: include/linux/sem.h: correctly document sem_ctime
has been removed from the -mm tree.  Its filename was
     include-linux-semh-correctly-document-sem_ctime.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: include/linux/sem.h: correctly document sem_ctime

sem_ctime is initialized to the semget() time and then updated at every
semctl() that changes the array.
Thus it does not represent the time of the last change.

Especially, semop() calls are only stored in sem_otime, not in sem_ctime.

This is already described in ipc/sem.c, I just overlooked that there is
a comment in include/linux/sem.h and man semctl(2) as well.

So: Correct wrong comments.

Link: http://lkml.kernel.org/r/20170515171912.6298-4-manfred@colorfullife.com
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: <1vier1@web.de>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sem.h      |    2 +-
 include/uapi/linux/sem.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/sem.h~include-linux-semh-correctly-document-sem_ctime include/linux/sem.h
--- a/include/linux/sem.h~include-linux-semh-correctly-document-sem_ctime
+++ a/include/linux/sem.h
@@ -30,7 +30,7 @@ struct sem {
 /* One sem_array data structure for each set of semaphores in the system. */
 struct sem_array {
 	struct kern_ipc_perm	sem_perm;	/* permissions .. see ipc.h */
-	time_t			sem_ctime;	/* last change time */
+	time_t			sem_ctime;	/* create/last semctl() time */
 	struct list_head	pending_alter;	/* pending operations */
 						/* that alter the array */
 	struct list_head	pending_const;	/* pending complex operations */
diff -puN include/uapi/linux/sem.h~include-linux-semh-correctly-document-sem_ctime include/uapi/linux/sem.h
--- a/include/uapi/linux/sem.h~include-linux-semh-correctly-document-sem_ctime
+++ a/include/uapi/linux/sem.h
@@ -23,7 +23,7 @@
 struct semid_ds {
 	struct ipc_perm	sem_perm;		/* permissions .. see ipc.h */
 	__kernel_time_t	sem_otime;		/* last semop time */
-	__kernel_time_t	sem_ctime;		/* last change time */
+	__kernel_time_t	sem_ctime;		/* create/last semctl() time */
 	struct sem	*sem_base;		/* ptr to first semaphore in array */
 	struct sem_queue *sem_pending;		/* pending operations to be processed */
 	struct sem_queue **sem_pending_last;	/* last pending operation */
_

Patches currently in -mm which might be from manfred@colorfullife.com are


