From: akpm@linux-foundation.org
Subject: [obsolete] ipcmsg-always-respect-msg_noerror.patch removed from
 -mm tree
Date: Mon, 19 May 2014 13:22:57 -0700
Message-ID: <537a6821.2quD++dv3X1YDcDb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48629 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478AbaESUW6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 May 2014 16:22:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, manfred@colorfullife.com, aswin@hp.com, davidlohr@hp.com

Subject: [obsolete] ipcmsg-always-respect-msg_noerror.patch removed from -mm tree
To: davidlohr@hp.com,aswin@hp.com,manfred@colorfullife.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 19 May 2014 13:22:57 -0700


The patch titled
     Subject: ipc,msg: always respect MSG_NOERROR
has been removed from the -mm tree.  Its filename was
     ipcmsg-always-respect-msg_noerror.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: ipc,msg: always respect MSG_NOERROR

When specifying the MSG_NOERROR flag, receivers can avoid returning error
(E2BIG) and just truncate the message text, if it is too large.

Currently, this logic is only respected when there are already pending
messages in the queue.  Fix this for the case when there are only
receivers waiting for a msg to be sent.  In order for this to work, save
the flags in the msg_receiver struct as it must be used later when doing
the pipeline send.

Also do some pipeline_send() cleanups while at it.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |   63 ++++++++++++++++++++++++++++------------------------
 1 file changed, 35 insertions(+), 28 deletions(-)

diff -puN ipc/msg.c~ipcmsg-always-respect-msg_noerror ipc/msg.c
--- a/ipc/msg.c~ipcmsg-always-respect-msg_noerror
+++ a/ipc/msg.c
@@ -50,6 +50,7 @@ struct msg_receiver {
 	struct task_struct	*r_tsk;
 
 	int			r_mode;
+	int                     r_msgflg;
 	long			r_msgtype;
 	long			r_maxsize;
 
@@ -562,42 +563,47 @@ static int testmsg(struct msg_msg *msg,
 	return 0;
 }
 
-static inline int pipelined_send(struct msg_queue *msq, struct msg_msg *msg)
+static inline bool pipelined_send(struct msg_queue *msq, struct msg_msg *msg)
 {
 	struct msg_receiver *msr, *t;
 
 	list_for_each_entry_safe(msr, t, &msq->q_receivers, r_list) {
-		if (testmsg(msg, msr->r_msgtype, msr->r_mode) &&
-		    !security_msg_queue_msgrcv(msq, msg, msr->r_tsk,
-					       msr->r_msgtype, msr->r_mode)) {
-
-			list_del(&msr->r_list);
-			if (msr->r_maxsize < msg->m_ts) {
-				/* initialize pipelined send ordering */
-				msr->r_msg = NULL;
-				wake_up_process(msr->r_tsk);
-				smp_mb(); /* see barrier comment below */
-				msr->r_msg = ERR_PTR(-E2BIG);
-			} else {
-				msr->r_msg = NULL;
-				msq->q_lrpid = task_pid_vnr(msr->r_tsk);
-				msq->q_rtime = get_seconds();
-				wake_up_process(msr->r_tsk);
-				/*
-				 * Ensure that the wakeup is visible before
-				 * setting r_msg, as the receiving end depends
-				 * on it. See lockless receive part 1 and 2 in
-				 * do_msgrcv().
-				 */
-				smp_mb();
-				msr->r_msg = msg;
+		if (!testmsg(msg, msr->r_msgtype, msr->r_mode))
+			continue;
+		if (security_msg_queue_msgrcv(msq, msg, msr->r_tsk,
+					      msr->r_msgtype, msr->r_mode))
+			continue;
+
+		/* found a suitable receiver, time to dequeue and wake */
+		list_del(&msr->r_list);
+
+		/* initialize pipelined send ordering */
+		msr->r_msg = NULL;
+
+		if (msr->r_maxsize < msg->m_ts &&
+		    !(msr->r_msgflg & MSG_NOERROR)) {
+			wake_up_process(msr->r_tsk);
+			smp_mb(); /* see barrier comment below */
+			msr->r_msg = ERR_PTR(-E2BIG);
+		} else {
+			msq->q_lrpid = task_pid_vnr(msr->r_tsk);
+			msq->q_rtime = get_seconds();
+			wake_up_process(msr->r_tsk);
 
-				return 1;
-			}
+			/*
+			 * Ensure that the wakeup is visible before
+			 * setting r_msg, as the receiving end depends
+			 * on it. See lockless receive part 1 and 2 in
+			 * do_msgrcv().
+			 */
+			smp_mb();
+			msr->r_msg = msg;
+
+			return true;
 		}
 	}
 
-	return 0;
+	return false; /* no receivers on the other side */
 }
 
 long do_msgsnd(int msqid, long mtype, void __user *mtext,
@@ -901,6 +907,7 @@ long do_msgrcv(int msqid, void __user *b
 		list_add_tail(&msr_d.r_list, &msq->q_receivers);
 		msr_d.r_tsk = current;
 		msr_d.r_msgtype = msgtyp;
+		msr_d.r_msgflg = msgflg;
 		msr_d.r_mode = mode;
 		if (msgflg & MSG_NOERROR)
 			msr_d.r_maxsize = INT_MAX;
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
mm-hugetlb-move-the-error-handle-logic-out-of-normal-code-path.patch
ipc-constify-ipc_ops.patch
ipc-shmc-check-for-ulong-overflows-in-shmat.patch
ipc-shmc-check-for-overflows-of-shm_tot.patch
ipc-shmc-check-for-integer-overflow-during-shmget.patch
ipc-shmc-increase-the-defaults-for-shmall-shmmax.patch
ipcshm-document-new-limits-in-the-uapi-header.patch
ipcshm-document-new-limits-in-the-uapi-header-v2.patch
ipcshm-document-new-limits-in-the-uapi-header-v3.patch
ipcmsg-use-current-state-helpers.patch
ipcmsg-move-some-msgq-ns-code-around.patch
ipcmsg-document-volatile-r_msg.patch
linux-next.patch
blackfin-ptrace-call-find_vma-with-the-mmap_sem-held.patch
rwsem-support-optimistic-spinning.patch
rwsem-support-optimistic-spinning-checkpatch-fixes.patch
rwsem-support-optimistic-spinning-fix.patch

