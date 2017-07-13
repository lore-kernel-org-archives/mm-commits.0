From: akpm@linux-foundation.org
Subject: [merged]
 ipc-shmc-avoid-ipc_rcu_putref-for-failed-ipc_addid.patch removed from -mm
 tree
Date: Thu, 13 Jul 2017 13:41:41 -0700
Message-ID: <20170713204141.Tn4-d34OS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59318 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753092AbdGMUlm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 16:41:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, keescook@chromium.org, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/shm.c: avoid ipc_rcu_putref for failed ipc_addid()
has been removed from the -mm tree.  Its filename was
     ipc-shmc-avoid-ipc_rcu_putref-for-failed-ipc_addid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/shm.c: avoid ipc_rcu_putref for failed ipc_addid()

Loosely based on a patch from Kees Cook <keescook@chromium.org>:
- id and error can be merged
- if operations before ipc_addid() fail, then use call_rcu() directly.

The difference is that call_rcu is used for failures after
security_shm_alloc(), to continue to guaranteed an rcu delay for
security_sem_free().

Link: http://lkml.kernel.org/r/20170525185107.12869-15-manfred@colorfullife.com
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN ipc/shm.c~ipc-shmc-avoid-ipc_rcu_putref-for-failed-ipc_addid ipc/shm.c
--- a/ipc/shm.c~ipc-shmc-avoid-ipc_rcu_putref-for-failed-ipc_addid
+++ a/ipc/shm.c
@@ -548,7 +548,6 @@ static int newseg(struct ipc_namespace *
 	size_t numpages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	struct file *file;
 	char name[13];
-	int id;
 	vm_flags_t acctflag = 0;
 
 	if (size < SHMMIN || size > ns->shm_ctlmax)
@@ -617,11 +616,9 @@ static int newseg(struct ipc_namespace *
 	shp->shm_file = file;
 	shp->shm_creator = current;
 
-	id = ipc_addid(&shm_ids(ns), &shp->shm_perm, ns->shm_ctlmni);
-	if (id < 0) {
-		error = id;
+	error = ipc_addid(&shm_ids(ns), &shp->shm_perm, ns->shm_ctlmni);
+	if (error < 0)
 		goto no_id;
-	}
 
 	list_add(&shp->shm_clist, &current->sysvshm.shm_clist);
 
@@ -643,7 +640,7 @@ no_id:
 		user_shm_unlock(size, shp->mlock_user);
 	fput(file);
 no_file:
-	ipc_rcu_putref(&shp->shm_perm, shm_rcu_free);
+	call_rcu(&shp->shm_perm.rcu, shm_rcu_free);
 	return error;
 }
 
_

Patches currently in -mm which might be from manfred@colorfullife.com are


