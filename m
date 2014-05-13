From: akpm@linux-foundation.org
Subject: + ipcmsg-use-current-state-helpers.patch added to -mm tree
Date: Tue, 13 May 2014 13:39:26 -0700
Message-ID: <537282fe.PBieQcvXwEoi9Qcu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbaEMUj1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 May 2014 16:39:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, manfred@colorfullife.com, aswin@hp.com, davidlohr@hp.com

Subject: + ipcmsg-use-current-state-helpers.patch added to -mm tree
To: davidlohr@hp.com,aswin@hp.com,manfred@colorfullife.com
From: akpm@linux-foundation.org
Date: Tue, 13 May 2014 13:39:26 -0700


The patch titled
     Subject: ipc,msg: use current->state helpers
has been added to the -mm tree.  Its filename is
     ipcmsg-use-current-state-helpers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipcmsg-use-current-state-helpers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipcmsg-use-current-state-helpers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: ipc,msg: use current->state helpers

Call __set_current_state() instead of assigning the new state directly.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN ipc/msg.c~ipcmsg-use-current-state-helpers ipc/msg.c
--- a/ipc/msg.c~ipcmsg-use-current-state-helpers
+++ a/ipc/msg.c
@@ -227,7 +227,7 @@ static int newque(struct ipc_namespace *
 static inline void ss_add(struct msg_queue *msq, struct msg_sender *mss)
 {
 	mss->tsk = current;
-	current->state = TASK_INTERRUPTIBLE;
+	__set_current_state(TASK_INTERRUPTIBLE);
 	list_add_tail(&mss->list, &msq->q_senders);
 }
 
@@ -976,7 +976,7 @@ long do_msgrcv(int msqid, void __user *b
 		else
 			msr_d.r_maxsize = bufsz;
 		msr_d.r_msg = ERR_PTR(-EAGAIN);
-		current->state = TASK_INTERRUPTIBLE;
+		__set_current_state(TASK_INTERRUPTIBLE);
 
 		ipc_unlock_object(&msq->q_perm);
 		rcu_read_unlock();
_

Patches currently in -mm which might be from davidlohr@hp.com are

mmvmacache-add-debug-data.patch
mmvmacache-optimize-overflow-system-wide-flushing.patch
mm-pass-vm_bug_on-reason-to-dump_page.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush.patch
mips-call-find_vma-with-the-mmap_sem-held.patch
arc-call-find_vma-with-the-mmap_sem-held.patch
arc-call-find_vma-with-the-mmap_sem-held-fix.patch
drm-exynos-call-find_vma-with-the-mmap_sem-held.patch
ipc-constify-ipc_ops.patch
ipc-shmc-check-for-ulong-overflows-in-shmat.patch
ipc-shmc-check-for-overflows-of-shm_tot.patch
ipc-shmc-check-for-integer-overflow-during-shmget.patch
ipc-shmc-increase-the-defaults-for-shmall-shmmax.patch
ipcshm-document-new-limits-in-the-uapi-header.patch
ipcshm-document-new-limits-in-the-uapi-header-v2.patch
ipcmsg-use-current-state-helpers.patch
ipcmsg-move-some-msgq-ns-code-around.patch
ipcmsg-always-respect-msg_noerror.patch
ipcmsg-document-volatile-r_msg.patch
ipcmsg-loosen-check-for-full-queue.patch
linux-next.patch
blackfin-ptrace-call-find_vma-with-the-mmap_sem-held.patch

