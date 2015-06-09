From: akpm@linux-foundation.org
Subject: [to-be-updated]
 ipcmsg-provide-barrier-pairings-for-lockless-receive.patch removed from -mm tree
Date: Tue, 09 Jun 2015 15:22:11 -0700
Message-ID: <55776713.xGkBIB3rbyMLB4Hw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35781 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbbFIWWM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2015 18:22:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc,msg: provide barrier pairings for lockless receive
has been removed from the -mm tree.  Its filename was
     ipcmsg-provide-barrier-pairings-for-lockless-receive.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: ipc,msg: provide barrier pairings for lockless receive

We currently use a full barrier on the sender side to to avoid receiver
tasks disappearing on us while still performing on the sender side wakeup.
 We lack however, the proper CPU-CPU interactions pairing on the receiver
side which busy-waits for the message.  Similarly, we do not need a full
smp_mb, and can relax the semantics for the writer and reader sides of the
message.  This is safe as we are only ordering loads and stores to r_msg. 
And in both smp_wmb and smp_rmb, there are no stores after the calls
_anyway_.

This obviously applies for pipelined_send and expunge_all, for EIRDM when
destroying a queue.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |   31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff -puN ipc/msg.c~ipcmsg-provide-barrier-pairings-for-lockless-receive ipc/msg.c
--- a/ipc/msg.c~ipcmsg-provide-barrier-pairings-for-lockless-receive
+++ a/ipc/msg.c
@@ -196,7 +196,7 @@ static void expunge_all(struct msg_queue
 		 * or dealing with -EAGAIN cases. See lockless receive part 1
 		 * and 2 in do_msgrcv().
 		 */
-		smp_mb();
+		smp_wmb();
 		msr->r_msg = ERR_PTR(res);
 	}
 }
@@ -580,7 +580,7 @@ static inline int pipelined_send(struct
 				/* initialize pipelined send ordering */
 				msr->r_msg = NULL;
 				wake_up_process(msr->r_tsk);
-				smp_mb(); /* see barrier comment below */
+				smp_wmb(); /* see barrier comment below */
 				msr->r_msg = ERR_PTR(-E2BIG);
 			} else {
 				msr->r_msg = NULL;
@@ -589,11 +589,12 @@ static inline int pipelined_send(struct
 				wake_up_process(msr->r_tsk);
 				/*
 				 * Ensure that the wakeup is visible before
-				 * setting r_msg, as the receiving end depends
-				 * on it. See lockless receive part 1 and 2 in
-				 * do_msgrcv().
+				 * setting r_msg, as the receiving can otherwise
+				 * exit - once r_msg is set, the receiver can
+				 * continue. See lockless receive part 1 and 2
+				 * in do_msgrcv().
 				 */
-				smp_mb();
+				smp_wmb();
 				msr->r_msg = msg;
 
 				return 1;
@@ -934,10 +935,22 @@ long do_msgrcv(int msqid, void __user *b
 		 * wake_up_process(). There is a race with exit(), see
 		 * ipc/mqueue.c for the details.
 		 */
-		msg = (struct msg_msg *)msr_d.r_msg;
-		while (msg == NULL) {
-			cpu_relax();
+		for (;;) {
+			/*
+			 * Pairs with writer barrier in pipelined_send
+			 * or expunge_all
+			 */
+			smp_rmb();
 			msg = (struct msg_msg *)msr_d.r_msg;
+			if (msg)
+				break;
+
+			/*
+			 * The cpu_relax() call is a compiler barrier
+			 * which forces everything in this loop to be
+			 * re-loaded.
+			 */
+			cpu_relax();
 		}
 
 		/* Lockless receive, part 3:
_

Patches currently in -mm which might be from dave@stgolabs.net are

mm-hugetlb-document-the-reserve-map-region-tracking-routines.patch
mm-hugetlb-compute-return-the-number-of-regions-added-by-region_add.patch
mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages.patch
mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages-v4.patch
linux-next.patch

