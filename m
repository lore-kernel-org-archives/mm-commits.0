From: akpm@linux-foundation.org
Subject: - coda-block-signals-during-upcall-processing.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:03:11 -0700
Message-ID: <200707192003.l6JK3BGn019835@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45041 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759791AbXGSUQa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaharkes@cs.cmu.edu, mm-commits@vger.kernel.org


The patch titled
     coda: block signals during upcall processing
has been removed from the -mm tree.  Its filename was
     coda-block-signals-during-upcall-processing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: coda: block signals during upcall processing
From: Jan Harkes <jaharkes@cs.cmu.edu>

We ignore signals for about 30 seconds to give userspace a chance to see the
upcall.  As we did not block signals we ended up in a busy loop for the
remainder of the period when a signal is received.

Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coda/upcall.c           |   81 +++++++++++++++++++++++++----------
 include/linux/coda_psdev.h |    1 
 2 files changed, 60 insertions(+), 22 deletions(-)

diff -puN fs/coda/upcall.c~coda-block-signals-during-upcall-processing fs/coda/upcall.c
--- a/fs/coda/upcall.c~coda-block-signals-during-upcall-processing
+++ a/fs/coda/upcall.c
@@ -638,42 +638,83 @@ int venus_statfs(struct dentry *dentry, 
 
 /*
  * coda_upcall and coda_downcall routines.
- * 
  */
+static void block_signals(sigset_t *old)
+{
+	spin_lock_irq(&current->sighand->siglock);
+	*old = current->blocked;
+
+	sigfillset(&current->blocked);
+	sigdelset(&current->blocked, SIGKILL);
+	sigdelset(&current->blocked, SIGSTOP);
+	sigdelset(&current->blocked, SIGINT);
+
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
+}
+
+static void unblock_signals(sigset_t *old)
+{
+	spin_lock_irq(&current->sighand->siglock);
+	current->blocked = *old;
+	recalc_sigpending();
+	spin_unlock_irq(&current->sighand->siglock);
+}
+
+/* Don't allow signals to interrupt the following upcalls before venus
+ * has seen them,
+ * - CODA_CLOSE or CODA_RELEASE upcall  (to avoid reference count problems)
+ * - CODA_STORE				(to avoid data loss)
+ */
+#define CODA_INTERRUPTIBLE(r) (!coda_hard && \
+			       (((r)->uc_opcode != CODA_CLOSE && \
+				 (r)->uc_opcode != CODA_STORE && \
+				 (r)->uc_opcode != CODA_RELEASE) || \
+				(r)->uc_flags & REQ_READ))
 
-static inline void coda_waitfor_upcall(struct upc_req *vmp)
+static inline void coda_waitfor_upcall(struct upc_req *req)
 {
 	DECLARE_WAITQUEUE(wait, current);
+	unsigned long timeout = jiffies + coda_timeout * HZ;
+	sigset_t old;
+	int blocked;
 
-	vmp->uc_posttime = jiffies;
+	block_signals(&old);
+	blocked = 1;
 
-	add_wait_queue(&vmp->uc_sleep, &wait);
+	add_wait_queue(&req->uc_sleep, &wait);
 	for (;;) {
-		if ( !coda_hard && vmp->uc_opcode != CODA_CLOSE ) 
+		if (CODA_INTERRUPTIBLE(req))
 			set_current_state(TASK_INTERRUPTIBLE);
 		else
 			set_current_state(TASK_UNINTERRUPTIBLE);
 
 		/* got a reply */
-		if ( vmp->uc_flags & ( REQ_WRITE | REQ_ABORT ) )
+		if (req->uc_flags & (REQ_WRITE | REQ_ABORT))
 			break;
 
-		if ( !coda_hard && vmp->uc_opcode != CODA_CLOSE && signal_pending(current) ) {
-			/* if this process really wants to die, let it go */
-			if ( sigismember(&(current->pending.signal), SIGKILL) ||
-			     sigismember(&(current->pending.signal), SIGINT) )
-				break;
-			/* signal is present: after timeout always return 
-			   really smart idea, probably useless ... */
-			if ( jiffies - vmp->uc_posttime > coda_timeout * HZ )
-				break; 
+		if (blocked && time_after(jiffies, timeout) &&
+		    CODA_INTERRUPTIBLE(req))
+		{
+			unblock_signals(&old);
+			blocked = 0;
 		}
-		schedule();
+
+		if (signal_pending(current)) {
+			list_del(&req->uc_chain);
+			break;
+		}
+
+		if (blocked)
+			schedule_timeout(HZ);
+		else
+			schedule();
 	}
-	remove_wait_queue(&vmp->uc_sleep, &wait);
-	set_current_state(TASK_RUNNING);
+	if (blocked)
+		unblock_signals(&old);
 
-	return;
+	remove_wait_queue(&req->uc_sleep, &wait);
+	set_current_state(TASK_RUNNING);
 }
 
 
@@ -750,8 +791,6 @@ static int coda_upcall(struct coda_sb_in
 		goto exit;
 	}
 
-	list_del(&(req->uc_chain));
-
 	/* Interrupted before venus read it. */
 	if (!(req->uc_flags & REQ_READ))
 		goto exit;
diff -puN include/linux/coda_psdev.h~coda-block-signals-during-upcall-processing include/linux/coda_psdev.h
--- a/include/linux/coda_psdev.h~coda-block-signals-during-upcall-processing
+++ a/include/linux/coda_psdev.h
@@ -85,7 +85,6 @@ struct upc_req {
 	u_short	            uc_opcode;  /* copied from data to save lookup */
 	int		    uc_unique;
 	wait_queue_head_t   uc_sleep;   /* process' wait queue */
-	unsigned long       uc_posttime;
 };
 
 #define REQ_ASYNC  0x1
_

Patches currently in -mm which might be from jaharkes@cs.cmu.edu are

origin.patch
