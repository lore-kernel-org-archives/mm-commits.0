From: akpm@linux-foundation.org
Subject: [to-be-updated] ipcshm-move-bug_on-check-into-shm_lock.patch
 removed from -mm tree
Date: Tue, 09 Jun 2015 15:22:04 -0700
Message-ID: <5577670c.ocfFeT0SuJ1vcOGm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35768 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbbFIWWF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2015 18:22:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc,shm: move BUG_ON check into shm_lock
has been removed from the -mm tree.  Its filename was
     ipcshm-move-bug_on-check-into-shm_lock.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: ipc,shm: move BUG_ON check into shm_lock

Upon every shm_lock call, we BUG_ON if an error was returned, indicating
racing either in idr or in RMID.  Move this logic into the locking.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN ipc/shm.c~ipcshm-move-bug_on-check-into-shm_lock ipc/shm.c
--- a/ipc/shm.c~ipcshm-move-bug_on-check-into-shm_lock
+++ a/ipc/shm.c
@@ -155,8 +155,14 @@ static inline struct shmid_kernel *shm_l
 {
 	struct kern_ipc_perm *ipcp = ipc_lock(&shm_ids(ns), id);
 
-	if (IS_ERR(ipcp))
+	if (IS_ERR(ipcp)) {
+		/*
+		 * We raced in the idr lookup or with RMID,
+		 * either way, the ID is busted.
+		 */
+		BUG_ON(1);
 		return (struct shmid_kernel *)ipcp;
+	}
 
 	return container_of(ipcp, struct shmid_kernel, shm_perm);
 }
@@ -191,7 +197,6 @@ static void shm_open(struct vm_area_stru
 	struct shmid_kernel *shp;
 
 	shp = shm_lock(sfd->ns, sfd->id);
-	BUG_ON(IS_ERR(shp));
 	shp->shm_atim = get_seconds();
 	shp->shm_lprid = task_tgid_vnr(current);
 	shp->shm_nattch++;
@@ -258,7 +263,6 @@ static void shm_close(struct vm_area_str
 	down_write(&shm_ids(ns).rwsem);
 	/* remove from the list of attaches of the shm segment */
 	shp = shm_lock(ns, sfd->id);
-	BUG_ON(IS_ERR(shp));
 	shp->shm_lprid = task_tgid_vnr(current);
 	shp->shm_dtim = get_seconds();
 	shp->shm_nattch--;
@@ -1191,7 +1195,6 @@ out_fput:
 out_nattch:
 	down_write(&shm_ids(ns).rwsem);
 	shp = shm_lock(ns, shmid);
-	BUG_ON(IS_ERR(shp));
 	shp->shm_nattch--;
 	if (shm_may_destroy(ns, shp))
 		shm_destroy(ns, shp);
_

Patches currently in -mm which might be from dave@stgolabs.net are

mm-hugetlb-document-the-reserve-map-region-tracking-routines.patch
mm-hugetlb-compute-return-the-number-of-regions-added-by-region_add.patch
mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages.patch
mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages-v4.patch
ipcshm-move-bug_on-check-into-shm_lock-fix-2.patch
ipcshm-move-bug_on-check-into-shm_lock-fix.patch
ipcmsg-provide-barrier-pairings-for-lockless-receive.patch
linux-next.patch

