From: akpm@linux-foundation.org
Subject: + ipc-shm-drop-shm_lock_check.patch added to -mm tree
Date: Wed, 24 Jul 2013 13:23:29 -0700
Message-ID: <51f037c1.7Ti0djVm4UfR5c8U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54431 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab3GXUXa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jul 2013 16:23:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sedat.dilek@gmail.com, riel@redhat.com, manfred@colorfullife.com, davidlohr.bueso@hp.com

Subject: + ipc-shm-drop-shm_lock_check.patch added to -mm tree
To: davidlohr.bueso@hp.com,manfred@colorfullife.com,riel@redhat.com,sedat.dilek@gmail.com
From: akpm@linux-foundation.org
Date: Wed, 24 Jul 2013 13:23:29 -0700


The patch titled
     Subject: ipc, shm: drop shm_lock_check
has been added to the -mm tree.  Its filename is
     ipc-shm-drop-shm_lock_check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-shm-drop-shm_lock_check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-shm-drop-shm_lock_check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
-
 static inline void shm_rmid(struct ipc_namespace *ns, struct shmid_kernel *s)
 {
 	ipc_rmid(&shm_ids(ns), &s->shm_perm);
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

ipcshm-introduce-lockless-functions-to-obtain-the-ipc-object.patch
ipcshm-shorten-critical-region-in-shmctl_down.patch
ipc-drop-ipcctl_pre_down.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-introduce-shmctl_nolock.patch
ipcshm-make-shmctl_nolock-lockless.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
ipcshm-shorten-critical-region-for-shmctl.patch
ipcshm-cleanup-do_shmat-pasta.patch
ipcshm-shorten-critical-region-for-shmat.patch
ipc-rename-ids-rw_mutex.patch
ipcmsg-drop-msg_unlock.patch
ipc-document-general-ipc-locking-scheme.patch
ipc-shm-guard-against-non-existant-vma-in-shmdt2.patch
ipc-drop-ipc_lock_by_ptr.patch
ipc-shm-drop-shm_lock_check.patch
ipc-drop-ipc_lock_check.patch
linux-next.patch

