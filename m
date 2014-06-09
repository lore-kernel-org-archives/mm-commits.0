From: akpm@linux-foundation.org
Subject: [merged]
 ipc-semc-add-a-printk_once-for-semctlgetncnt-getzcnt.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:38:18 -0700
Message-ID: <53960d2a.x0JHOAZKp5HC0Anv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54273 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaFITiT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:38:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mtk.manpages@gmail.com, joe@perches.com, davidlohr@hp.com, manfred@colorfullife.com

Subject: [merged] ipc-semc-add-a-printk_once-for-semctlgetncnt-getzcnt.patch removed from -mm tree
To: manfred@colorfullife.com,davidlohr@hp.com,joe@perches.com,mtk.manpages@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:38:18 -0700


The patch titled
     Subject: ipc/sem.c: add a printk_once for semctl(GETNCNT/GETZCNT)
has been removed from the -mm tree.  Its filename was
     ipc-semc-add-a-printk_once-for-semctlgetncnt-getzcnt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
slab-leaks3-default-y.patch

