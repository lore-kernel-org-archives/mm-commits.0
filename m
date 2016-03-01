From: akpm@linux-foundation.org
Subject: + ipc-sem-make-semctl-setting-sempid-consistent.patch added to
 -mm tree
Date: Tue, 01 Mar 2016 14:45:09 -0800
Message-ID: <56d61b75.Mo1mX3enWU2cSD9m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbcCAWpK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2016 17:45:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, herton@redhat.com, linux_kernel.20.ick@spamgourmet.com, manfred@colorfullife.com, mtk.manpages@gmail.com, prasannatsmkumar@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem: make semctl setting sempid consistent
has been added to the -mm tree.  Its filename is
     ipc-sem-make-semctl-setting-sempid-consistent.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-sem-make-semctl-setting-sempid-consistent.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-sem-make-semctl-setting-sempid-consistent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: ipc/sem: make semctl setting sempid consistent

As indicated by bug#112271, Linux sets the sempid value upon semctl, and
not only for semop calls.  However, within semctl we only do this for
SETVAL, leaving SETALL without updating the field, and therefore rather
inconsistent behavior when compared to other Unices.

There is really no documentation regarding this and therefore users should
not make assumptions.  With this patch, along with updating semctl.2
manpages, this scenario should become less ambiguous As such, set sempid
on SETALL cmd.

Also update some in-code documentation, specifying where the
sempid is set.

Passes ltp and custom testcase where a child (fork) does SETALL
to the set.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Reported-by: Philip Semanchuk <linux_kernel.20.ick@spamgourmet.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Herton R. Krzesinski <herton@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN ipc/sem.c~ipc-sem-make-semctl-setting-sempid-consistent ipc/sem.c
--- a/ipc/sem.c~ipc-sem-make-semctl-setting-sempid-consistent
+++ a/ipc/sem.c
@@ -92,7 +92,14 @@
 /* One semaphore structure for each semaphore in the system. */
 struct sem {
 	int	semval;		/* current value */
-	int	sempid;		/* pid of last operation */
+	/*
+	 * PID of the process that last modified the semaphore. For
+	 * Linux, specifically these are:
+	 *  - semop
+	 *  - semctl, via SETVAL and SETALL.
+	 *  - at task exit when performing undo adjustments (see exit_sem).
+	 */
+	int	sempid;
 	spinlock_t	lock;	/* spinlock for fine-grained semtimedop */
 	struct list_head pending_alter; /* pending single-sop operations */
 					/* that alter the semaphore */
@@ -1444,8 +1451,10 @@ static int semctl_main(struct ipc_namesp
 			goto out_unlock;
 		}
 
-		for (i = 0; i < nsems; i++)
+		for (i = 0; i < nsems; i++) {
 			sma->sem_base[i].semval = sem_io[i];
+			sma->sem_base[i].sempid = task_tgid_vnr(current);
+		}
 
 		ipc_assert_locked_object(&sma->sem_perm);
 		list_for_each_entry(un, &sma->list_id, list_id) {
_

Patches currently in -mm which might be from dave@stgolabs.net are

ipc-sem-make-semctl-setting-sempid-consistent.patch

