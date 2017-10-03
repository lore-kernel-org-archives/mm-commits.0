From: akpm@linux-foundation.org
Subject: + sysvipc-duplicate-lock-comments-wrt-ipc_addid.patch added to
 -mm tree
Date: Tue, 03 Oct 2017 14:59:50 -0700
Message-ID: <59d40856.rJB+P02mtMAH61Xb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53736 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751172AbdJCV7v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 17:59:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sysvipc: duplicate lock comments wrt ipc_addid()
has been added to the -mm tree.  Its filename is
     sysvipc-duplicate-lock-comments-wrt-ipc_addid.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sysvipc-duplicate-lock-comments-wrt-ipc_addid.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sysvipc-duplicate-lock-comments-wrt-ipc_addid.patch

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
Subject: sysvipc: duplicate lock comments wrt ipc_addid()

The comment in msgqueues when using ipc_addid() is quite useful imo. 
Duplicate it for shm and semaphores.

Link: http://lkml.kernel.org/r/20170831172049.14576-3-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    1 +
 ipc/shm.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN ipc/sem.c~sysvipc-duplicate-lock-comments-wrt-ipc_addid ipc/sem.c
--- a/ipc/sem.c~sysvipc-duplicate-lock-comments-wrt-ipc_addid
+++ a/ipc/sem.c
@@ -514,6 +514,7 @@ static int newary(struct ipc_namespace *
 	sma->sem_nsems = nsems;
 	sma->sem_ctime = ktime_get_real_seconds();
 
+	/* ipc_addid() locks sma upon success. */
 	retval = ipc_addid(&sem_ids(ns), &sma->sem_perm, ns->sc_semmni);
 	if (retval < 0) {
 		call_rcu(&sma->sem_perm.rcu, sem_rcu_free);
diff -puN ipc/shm.c~sysvipc-duplicate-lock-comments-wrt-ipc_addid ipc/shm.c
--- a/ipc/shm.c~sysvipc-duplicate-lock-comments-wrt-ipc_addid
+++ a/ipc/shm.c
@@ -600,6 +600,7 @@ static int newseg(struct ipc_namespace *
 	shp->shm_file = file;
 	shp->shm_creator = current;
 
+	/* ipc_addid() locks shp upon success. */
 	error = ipc_addid(&shm_ids(ns), &shp->shm_perm, ns->shm_ctlmni);
 	if (error < 0)
 		goto no_id;
_

Patches currently in -mm which might be from dave@stgolabs.net are

mmcompaction-serialize-waitqueue_active-checks-for-real.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore.patch
sysvipc-duplicate-lock-comments-wrt-ipc_addid.patch
sysvipc-properly-name-ipc_addid-limit-parameter.patch
sysvipc-make-get_maxid-o1-again.patch

