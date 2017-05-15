From: akpm@linux-foundation.org
Subject: + include-linux-semh-correctly-document-sem_ctime.patch added to
 -mm tree
Date: Mon, 15 May 2017 13:10:10 -0700
Message-ID: <591a0b22.qkB1l5kgJNcCe8tx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39340 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966591AbdEOUKL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 May 2017 16:10:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, 1vier1@web.de, dave@stgolabs.net, fabf@skynet.be, keescook@chromium.org, mingo@kernel.org, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/sem.h: correctly document sem_ctime
has been added to the -mm tree.  Its filename is
     include-linux-semh-correctly-document-sem_ctime.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-semh-correctly-document-sem_ctime.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-semh-correctly-document-sem_ctime.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ipc-semc-remove-sem_base-embed-struct-sem.patch
ipc-merge-ipc_rcu-and-kern_ipc_perm.patch
include-linux-semh-correctly-document-sem_ctime.patch

