From: akpm@linux-foundation.org
Subject: [merged] ipcshm-move-bug_on-check-into-shm_lock.patch removed
 from -mm tree
Date: Mon, 06 Jul 2015 12:47:22 -0700
Message-ID: <559adb4a.YbNFDsPEqBsqopDR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59574 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686AbbGFTrW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 15:47:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc,shm: move BUG_ON check into shm_lock
has been removed from the -mm tree.  Its filename was
     ipcshm-move-bug_on-check-into-shm_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: ipc,shm: move BUG_ON check into shm_lock

Upon every shm_lock call, we BUG_ON if an error was returned, indicating
racing either in idr or in shm_destroy.  Move this logic into the locking.

[akpm@linux-foundation.org: simplify code]
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN ipc/shm.c~ipcshm-move-bug_on-check-into-shm_lock ipc/shm.c
--- a/ipc/shm.c~ipcshm-move-bug_on-check-into-shm_lock
+++ a/ipc/shm.c
@@ -155,8 +155,11 @@ static inline struct shmid_kernel *shm_l
 {
 	struct kern_ipc_perm *ipcp = ipc_lock(&shm_ids(ns), id);
 
-	if (IS_ERR(ipcp))
-		return (struct shmid_kernel *)ipcp;
+	/*
+	 * We raced in the idr lookup or with shm_destroy().  Either way, the
+	 * ID is busted.
+	 */
+	BUG_ON(IS_ERR(ipcp));
 
 	return container_of(ipcp, struct shmid_kernel, shm_perm);
 }
@@ -191,7 +194,6 @@ static void shm_open(struct vm_area_stru
 	struct shmid_kernel *shp;
 
 	shp = shm_lock(sfd->ns, sfd->id);
-	BUG_ON(IS_ERR(shp));
 	shp->shm_atim = get_seconds();
 	shp->shm_lprid = task_tgid_vnr(current);
 	shp->shm_nattch++;
@@ -258,7 +260,6 @@ static void shm_close(struct vm_area_str
 	down_write(&shm_ids(ns).rwsem);
 	/* remove from the list of attaches of the shm segment */
 	shp = shm_lock(ns, sfd->id);
-	BUG_ON(IS_ERR(shp));
 	shp->shm_lprid = task_tgid_vnr(current);
 	shp->shm_dtim = get_seconds();
 	shp->shm_nattch--;
@@ -1191,7 +1192,6 @@ out_fput:
 out_nattch:
 	down_write(&shm_ids(ns).rwsem);
 	shp = shm_lock(ns, shmid);
-	BUG_ON(IS_ERR(shp));
 	shp->shm_nattch--;
 	if (shm_may_destroy(ns, shp))
 		shm_destroy(ns, shp);
_

Patches currently in -mm which might be from dave@stgolabs.net are


