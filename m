From: akpm@linux-foundation.org
Subject: [merged] ipcmsg-use-current-state-helpers.patch removed from -mm
 tree
Date: Mon, 09 Jun 2014 12:37:37 -0700
Message-ID: <53960d01.q4gzy1UOrxAMJ5Jn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54241 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaFIThi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:37:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, manfred@colorfullif.com, aswin@hp.com, davidlohr@hp.com

Subject: [merged] ipcmsg-use-current-state-helpers.patch removed from -mm tree
To: davidlohr@hp.com,aswin@hp.com,manfred@colorfullif.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:37:37 -0700


The patch titled
     Subject: ipc,msg: use current->state helpers
has been removed from the -mm tree.  Its filename was
     ipcmsg-use-current-state-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: ipc,msg: use current->state helpers

Call __set_current_state() instead of assigning the new state directly.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Manfred Spraul <manfred@colorfullif.com>
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

origin.patch
m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush.patch
linux-next.patch

