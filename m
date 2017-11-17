From: akpm@linux-foundation.org
Subject: [patch 84/94] sysvipc: duplicate lock comments wrt
 ipc_addid()
Date: Fri, 17 Nov 2017 15:31:11 -0800
Message-ID: <20171117233111.1VwK-xbjB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56152 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966968AbdKQXbN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:31:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
