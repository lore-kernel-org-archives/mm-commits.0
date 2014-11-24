From: akpm@linux-foundation.org
Subject: +
 ipc-semc-fully-initialize-sem_array-before-making-it-visible.patch added to -mm tree
Date: Mon, 24 Nov 2014 12:49:12 -0800
Message-ID: <547399c8.qnl5x1Fb1WSP5TaJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55669 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaKXUsu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Nov 2014 15:48:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, aquini@redhat.com, dave@stgolabs.net, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem.c: fully initialize sem_array before making it visible
has been added to the -mm tree.  Its filename is
     ipc-semc-fully-initialize-sem_array-before-making-it-visible.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-semc-fully-initialize-sem_array-before-making-it-visible.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/ipc-semc-fully-initialize-sem_array-before-making-it-visible.patch

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
Subject: ipc/sem.c: fully initialize sem_array before making it visible

ipc_addid() makes a new ipc identifier visible to everyone.  New objects
start as locked, so that the caller can complete the initialization after
the call.  Within struct sem_array, at least sma->sem_base and
sma->sem_nsems are accessed without any locks, therefore this approach
doesn't work.

Thus: Move the ipc_addid() to the end of the initialization.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Reported-by: Rik van Riel <riel@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Acked-by: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN ipc/sem.c~ipc-semc-fully-initialize-sem_array-before-making-it-visible ipc/sem.c
--- a/ipc/sem.c~ipc-semc-fully-initialize-sem_array-before-making-it-visible
+++ a/ipc/sem.c
@@ -507,13 +507,6 @@ static int newary(struct ipc_namespace *
 		return retval;
 	}
 
-	id = ipc_addid(&sem_ids(ns), &sma->sem_perm, ns->sc_semmni);
-	if (id < 0) {
-		ipc_rcu_putref(sma, sem_rcu_free);
-		return id;
-	}
-	ns->used_sems += nsems;
-
 	sma->sem_base = (struct sem *) &sma[1];
 
 	for (i = 0; i < nsems; i++) {
@@ -528,6 +521,14 @@ static int newary(struct ipc_namespace *
 	INIT_LIST_HEAD(&sma->list_id);
 	sma->sem_nsems = nsems;
 	sma->sem_ctime = get_seconds();
+
+	id = ipc_addid(&sem_ids(ns), &sma->sem_perm, ns->sc_semmni);
+	if (id < 0) {
+		ipc_rcu_putref(sma, sem_rcu_free);
+		return id;
+	}
+	ns->used_sems += nsems;
+
 	sem_unlock(sma, -1);
 	rcu_read_unlock();
 
_

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-semc-fully-initialize-sem_array-before-making-it-visible.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-semc-increase-semmsl-semmni-semopm.patch
ipc-msg-increase-msgmni-remove-scaling.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
mm-fix-overly-aggressive-shmdt-when-calls-span-multiple-segments.patch
shmdt-use-i_size_read-instead-of-i_size.patch
slab-leaks3-default-y.patch

