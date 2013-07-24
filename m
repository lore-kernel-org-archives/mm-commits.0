From: akpm@linux-foundation.org
Subject: + ipc-shm-guard-against-non-existant-vma-in-shmdt2.patch added to -mm tree
Date: Wed, 24 Jul 2013 13:23:27 -0700
Message-ID: <51f037bf.SZMpQ0yYb99mByE+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54422 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3GXUX2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jul 2013 16:23:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sedat.dilek@gmail.com, riel@redhat.com, manfred@colorfullife.com, davidlohr.bueso@hp.com

Subject: + ipc-shm-guard-against-non-existant-vma-in-shmdt2.patch added to -mm tree
To: davidlohr.bueso@hp.com,manfred@colorfullife.com,riel@redhat.com,sedat.dilek@gmail.com
From: akpm@linux-foundation.org
Date: Wed, 24 Jul 2013 13:23:27 -0700


The patch titled
     Subject: ipc, shm: guard against non-existant vma in shmdt(2)
has been added to the -mm tree.  Its filename is
     ipc-shm-guard-against-non-existant-vma-in-shmdt2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-shm-guard-against-non-existant-vma-in-shmdt2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-shm-guard-against-non-existant-vma-in-shmdt2.patch

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
Subject: ipc, shm: guard against non-existant vma in shmdt(2)

When !CONFIG_MMU there's a chance we can derefence a NULL pointer when the
VM area isn't found - check the return value of find_vma().

Also, remove the redundant -EINVAL return: retval is set to the proper
return code and *only* changed to 0, when we actually unmap the segments.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN ipc/shm.c~ipc-shm-guard-against-non-existant-vma-in-shmdt2 ipc/shm.c
--- a/ipc/shm.c~ipc-shm-guard-against-non-existant-vma-in-shmdt2
+++ a/ipc/shm.c
@@ -1288,8 +1288,7 @@ SYSCALL_DEFINE1(shmdt, char __user *, sh
 #else /* CONFIG_MMU */
 	/* under NOMMU conditions, the exact address to be destroyed must be
 	 * given */
-	retval = -EINVAL;
-	if (vma->vm_start == addr && vma->vm_ops == &shm_vm_ops) {
+	if (vma && vma->vm_start == addr && vma->vm_ops == &shm_vm_ops) {
 		do_munmap(mm, vma->vm_start, vma->vm_end - vma->vm_start);
 		retval = 0;
 	}
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

