From: akpm@linux-foundation.org
Subject: + ipcmsg-provide-barrier-pairings-for-lockless-receive.patch
 added to -mm tree
Date: Tue, 09 Jun 2015 15:24:21 -0700
Message-ID: <55776795.Czm5xsA7IXuSUvCD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35790 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbbFIWYW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2015 18:24:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc,msg: provide barrier pairings for lockless receive
has been added to the -mm tree.  Its filename is
     ipcmsg-provide-barrier-pairings-for-lockless-receive.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipcmsg-provide-barrier-pairings-for-lockless-receive.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipcmsg-provide-barrier-pairings-for-lockless-receive.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 ipc/msg.c |   48 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 38 insertions(+), 10 deletions(-)

diff -puN ipc/msg.c~ipcmsg-provide-barrier-pairings-for-lockless-receive ipc/msg.c
--- a/ipc/msg.c~ipcmsg-provide-barrier-pairings-for-lockless-receive
+++ a/ipc/msg.c
@@ -196,7 +196,7 @@ static void expunge_all(struct msg_queue
 		 * or dealing with -EAGAIN cases. See lockless receive part 1
 		 * and 2 in do_msgrcv().
 		 */
-		smp_mb();
+		smp_wmb(); /* barrier (B) */
 		msr->r_msg = ERR_PTR(res);
 	}
 }
@@ -580,7 +580,8 @@ static inline int pipelined_send(struct
 				/* initialize pipelined send ordering */
 				msr->r_msg = NULL;
 				wake_up_process(msr->r_tsk);
-				smp_mb(); /* see barrier comment below */
+				/* barrier (B) see barrier comment below */
+				smp_wmb();
 				msr->r_msg = ERR_PTR(-E2BIG);
 			} else {
 				msr->r_msg = NULL;
@@ -589,11 +590,12 @@ static inline int pipelined_send(struct
 				wake_up_process(msr->r_tsk);
 				/*
 				 * Ensure that the wakeup is visible before
-				 * setting r_msg, as the receiving end depends
-				 * on it. See lockless receive part 1 and 2 in
-				 * do_msgrcv().
+				 * setting r_msg, as the receiving can otherwise
+				 * exit - once r_msg is set, the receiver can
+				 * continue. See lockless receive part 1 and 2
+				 * in do_msgrcv(). Barrier (B).
 				 */
-				smp_mb();
+				smp_wmb();
 				msr->r_msg = msg;
 
 				return 1;
@@ -932,12 +934,38 @@ long do_msgrcv(int msqid, void __user *b
 		/* Lockless receive, part 2:
 		 * Wait until pipelined_send or expunge_all are outside of
 		 * wake_up_process(). There is a race with exit(), see
-		 * ipc/mqueue.c for the details.
+		 * ipc/mqueue.c for the details. The correct serialization
+		 * ensures that a receiver cannot continue without the wakeup
+		 * being visibible _before_ setting r_msg:
+		 *
+		 * CPU 0                             CPU 1
+		 * <loop receiver>
+		 *   smp_rmb(); (A) <-- pair -.      <waker thread>
+		 *   <load ->r_msg>           |        msr->r_msg = NULL;
+		 *                            |        wake_up_process();
+		 * <continue>                 `------> smp_wmb(); (B)
+		 *                                     msr->r_msg = msg;
+		 *
+		 * Where (A) orders the message value read and where (B) orders
+		 * the write to the r_msg -- done in both pipelined_send and
+		 * expunge_all.
 		 */
-		msg = (struct msg_msg *)msr_d.r_msg;
-		while (msg == NULL) {
-			cpu_relax();
+		for (;;) {
+			/*
+			 * Pairs with writer barrier in pipelined_send
+			 * or expunge_all.
+			 */
+			smp_rmb(); /* barrier (A) */
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
ipcshm-move-bug_on-check-into-shm_lock.patch
ipcmsg-provide-barrier-pairings-for-lockless-receive.patch
ipc-rename-ipc_obtain_object.patch
ipcsysv-make-return-eidrm-when-racing-with-rmid-consistent.patch
ipcsysv-return-einval-upon-incorrect-id-seqnum.patch
linux-next.patch

