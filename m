From: akpm@linux-foundation.org
Subject: [merged]
 sysvipc-duplicate-lock-comments-wrt-ipc_addid.patch removed from -mm tree
Date: Mon, 20 Nov 2017 13:26:48 -0800
Message-ID: <20171120212648.yxb6H73hb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40978 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752725AbdKTV0t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:26:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sysvipc: duplicate lock comments wrt ipc_addid()
has been removed from the -mm tree.  Its filename was
     sysvipc-duplicate-lock-comments-wrt-ipc_addid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -515,6 +515,7 @@ static int newary(struct ipc_namespace *
 	sma->sem_nsems = nsems;
 	sma->sem_ctime = ktime_get_real_seconds();
 
+	/* ipc_addid() locks sma upon success. */
 	retval = ipc_addid(&sem_ids(ns), &sma->sem_perm, ns->sc_semmni);
 	if (retval < 0) {
 		call_rcu(&sma->sem_perm.rcu, sem_rcu_free);
diff -puN ipc/shm.c~sysvipc-duplicate-lock-comments-wrt-ipc_addid ipc/shm.c
--- a/ipc/shm.c~sysvipc-duplicate-lock-comments-wrt-ipc_addid
+++ a/ipc/shm.c
@@ -601,6 +601,7 @@ static int newseg(struct ipc_namespace *
 	shp->shm_file = file;
 	shp->shm_creator = current;
 
+	/* ipc_addid() locks shp upon success. */
 	error = ipc_addid(&shm_ids(ns), &shp->shm_perm, ns->shm_ctlmni);
 	if (error < 0)
 		goto no_id;
_

Patches currently in -mm which might be from dave@stgolabs.net are


