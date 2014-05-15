From: akpm@linux-foundation.org
Subject: [withdrawn] ipcmsg-loosen-check-for-full-queue.patch removed from -mm tree
Date: Thu, 15 May 2014 15:13:11 -0700
Message-ID: <53753bf7.7B4JlrYU8nsl0r3q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38828 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276AbaEOWNM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 May 2014 18:13:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, manfred@colorfullife.com, aswin@hp.com, davidlohr@hp.com

Subject: [withdrawn] ipcmsg-loosen-check-for-full-queue.patch removed from -mm tree
To: davidlohr@hp.com,aswin@hp.com,manfred@colorfullife.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 15 May 2014 15:13:11 -0700


The patch titled
     Subject: ipc,msg: loosen check for full queue
has been removed from the -mm tree.  Its filename was
     ipcmsg-loosen-check-for-full-queue.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: ipc,msg: loosen check for full queue

When sending a message, we must guarantee that there will be enough room
in the queue to add it, otherwise wait until space becomes available --
which requires blocking the calling task.  Currently, this relies meeting
both of the following conditions:

(i)  The new msg size + current size is lower than the queue's max size. 

(ii) The current amount of messages in the queue + 1 (this msg) is
     lower than the queue's max size.

While (i) is obvious and well documented in the msgsnd(2) manpage, the
second one is far more ambiguous and does not serve the purpose, as we do
not control the amount of messages in the queue (unlike posix queues do). 
Thus remove (ii) and loosen how we check for space.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN ipc/msg.c~ipcmsg-loosen-check-for-full-queue ipc/msg.c
--- a/ipc/msg.c~ipcmsg-loosen-check-for-full-queue
+++ a/ipc/msg.c
@@ -658,10 +658,8 @@ long do_msgsnd(int msqid, long mtype, vo
 		if (err)
 			goto out_unlock0;
 
-		if (msgsz + msq->q_cbytes <= msq->q_qbytes &&
-				1 + msq->q_qnum <= msq->q_qbytes) {
-			break;
-		}
+		if (msgsz + msq->q_cbytes <= msq->q_qbytes)
+			break; /* there is space in the queue for this msg */
 
 		/* queue full, wait: */
 		if (msgflg & IPC_NOWAIT) {
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
linux-next.patch
blackfin-ptrace-call-find_vma-with-the-mmap_sem-held.patch
rwsem-support-optimistic-spinning.patch
rwsem-support-optimistic-spinning-checkpatch-fixes.patch

