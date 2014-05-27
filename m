From: akpm@linux-foundation.org
Subject: + ipc-semc-add-a-printk_once-for-semctlgetncnt-getzcnt.patch
 added to -mm tree
Date: Tue, 27 May 2014 15:53:26 -0700
Message-ID: <53851766.aH9YdXKcl3OC/mWG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55769 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbaE0Wx1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 May 2014 18:53:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mtk.manpages@gmail.com, joe@perches.com, davidlohr@hp.com, manfred@colorfullife.com

Subject: + ipc-semc-add-a-printk_once-for-semctlgetncnt-getzcnt.patch added to -mm tree
To: manfred@colorfullife.com,davidlohr@hp.com,joe@perches.com,mtk.manpages@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 27 May 2014 15:53:26 -0700


The patch titled
     Subject: ipc/sem.c: add a printk_once for semctl(GETNCNT/GETZCNT)
has been added to the -mm tree.  Its filename is
     ipc-semc-add-a-printk_once-for-semctlgetncnt-getzcnt.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-semc-add-a-printk_once-for-semctlgetncnt-getzcnt.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-semc-add-a-printk_once-for-semctlgetncnt-getzcnt.patch

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
Subject: ipc/sem.c: add a printk_once for semctl(GETNCNT/GETZCNT)

The actual Linux implementation for semctl(GETNCNT) and semctl(GETZCNT)
always (since 0.99.10) reported a thread as sleeping on all semaphores
that are listed in the semop() call.

The documented behavior (both in the Linux man page and in the Single Unix
Specification) is that a task should be reported on exactly one semaphore:
The semaphore that caused the thread to got to sleep.

This patch adds a pr_info_once() that is triggered if a thread hits
the relevant case.

The code triggers slightly too often, otherwise it would be necessary to
replicate the old code.  As there are no known users of GETNCNT or
GETZCNT, this is done to prevent unnecessary bloat.

The task that triggered is reported with name (tsk->comm) and pid.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Acked-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN ipc/sem.c~ipc-semc-add-a-printk_once-for-semctlgetncnt-getzcnt ipc/sem.c
--- a/ipc/sem.c~ipc-semc-add-a-printk_once-for-semctlgetncnt-getzcnt
+++ a/ipc/sem.c
@@ -1000,6 +1000,17 @@ static int check_qop(struct sem_array *s
 {
 	struct sembuf *sop = q->blocking;
 
+	/*
+	 * Linux always (since 0.99.10) reported a task as sleeping on all
+	 * semaphores. This violates SUS, therefore it was changed to the
+	 * standard compliant behavior.
+	 * Give the administrators a chance to notice that an application
+	 * might misbehave because it relies on the Linux behavior.
+	 */
+	pr_info_once("semctl(GETNCNT/GETZCNT) is since 3.16 Single Unix Specification compliant.\n"
+			"The task %s (%d) triggered the difference, watch for misbehavior.\n",
+			current->comm, task_pid_nr(current));
+
 	if (sop->sem_num != semnum)
 		return 0;
 
_

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-constify-ipc_ops.patch
ipc-shmc-check-for-ulong-overflows-in-shmat.patch
ipc-shmc-check-for-overflows-of-shm_tot.patch
ipc-shmc-check-for-integer-overflow-during-shmget.patch
ipc-shmc-increase-the-defaults-for-shmall-shmmax.patch
ipcshm-document-new-limits-in-the-uapi-header.patch
ipcshm-document-new-limits-in-the-uapi-header-v2.patch
ipcshm-document-new-limits-in-the-uapi-header-v3.patch
ipcmsg-move-some-msgq-ns-code-around.patch
ipcmsg-document-volatile-r_msg.patch
ipc-semc-bugfix-for-semctlgetzcnt.patch
ipc-semc-remove-code-duplication.patch
ipc-semc-change-perform_atomic_semop-parameters.patch
ipc-semc-store-which-operation-blocks-in-perform_atomic_semop.patch
ipc-semc-make-semctlgetncntgetzcnt-standard-compliant.patch
ipc-semc-add-a-printk_once-for-semctlgetncnt-getzcnt.patch
slab-leaks3-default-y.patch

