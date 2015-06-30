From: akpm@linux-foundation.org
Subject: [folded-merged] ipcshm-move-bug_on-check-into-shm_lock-fix.patch
 removed from -mm tree
Date: Tue, 30 Jun 2015 14:50:30 -0700
Message-ID: <55930f26.vk58n/9gzJ7BH4Ie%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53227 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbbF3Vud (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jun 2015 17:50:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipcshm-move-bug_on-check-into-shm_lock-fix
has been removed from the -mm tree.  Its filename was
     ipcshm-move-bug_on-check-into-shm_lock-fix.patch

This patch was dropped because it was folded into ipcshm-move-bug_on-check-into-shm_lock.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipcshm-move-bug_on-check-into-shm_lock-fix

simplify code

Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN ipc/shm.c~ipcshm-move-bug_on-check-into-shm_lock-fix ipc/shm.c
--- a/ipc/shm.c~ipcshm-move-bug_on-check-into-shm_lock-fix
+++ a/ipc/shm.c
@@ -155,14 +155,11 @@ static inline struct shmid_kernel *shm_l
 {
 	struct kern_ipc_perm *ipcp = ipc_lock(&shm_ids(ns), id);
 
-	if (IS_ERR(ipcp)) {
-		/*
-		 * We raced in the idr lookup or with shm_destroy(),
-		 * either way, the ID is busted.
-		 */
-		BUG();
-		return (struct shmid_kernel *)ipcp;
-	}
+	/*
+	 * We raced in the idr lookup or with shm_destroy().  Either way, the
+	 * ID is busted.
+	 */
+	BUG_ON(IS_ERR(ipcp));
 
 	return container_of(ipcp, struct shmid_kernel, shm_perm);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-meminit-inline-some-helper-functions.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx.patch
ipcshm-move-bug_on-check-into-shm_lock.patch
scsi-resolve-sg-buffer-const-ness-issue-fix.patch
genalloc-rename-dev_get_gen_pool-to-gen_pool_get-fix.patch

