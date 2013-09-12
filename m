From: akpm@linux-foundation.org
Subject: [merged] ipc-shm-drop-shm_lock_check.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:51:05 -0700
Message-ID: <52321b29.VsHi7P0rn93bKLlX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58813 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab3ILTvV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:51:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sedat.dilek@gmail.com, riel@redhat.com, manfred@colorfullife.com, davidlohr.bueso@hp.com

Subject: [merged] ipc-shm-drop-shm_lock_check.patch removed from -mm tree
To: davidlohr.bueso@hp.com,manfred@colorfullife.com,riel@redhat.com,sedat.dilek@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:51:05 -0700


The patch titled
     Subject: ipc, shm: drop shm_lock_check
has been removed from the -mm tree.  Its filename was
     ipc-shm-drop-shm_lock_check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: ipc, shm: drop shm_lock_check

This function was replaced by a the lockless shm_obtain_object_check(),
and no longer has any users.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN ipc/shm.c~ipc-shm-drop-shm_lock_check ipc/shm.c
--- a/ipc/shm.c~ipc-shm-drop-shm_lock_check
+++ a/ipc/shm.c
@@ -167,17 +167,6 @@ static inline void shm_lock_by_ptr(struc
 	ipc_lock_object(&ipcp->shm_perm);
 }
 
-static inline struct shmid_kernel *shm_lock_check(struct ipc_namespace *ns,
-						int id)
-{
-	struct kern_ipc_perm *ipcp = ipc_lock_check(&shm_ids(ns), id);
-
-	if (IS_ERR(ipcp))
-		return (struct shmid_kernel *)ipcp;
-
-	return container_of(ipcp, struct shmid_kernel, shm_perm);
-}
