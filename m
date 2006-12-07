From: akpm@osdl.org
Subject: - lockdep-annotate-bcsp-driver.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:03:36 -0800
Message-ID: <200612072303.kB7N3aPN029973@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51940 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163660AbWLGXDp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:03:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, marcel@holtmann.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     lockdep: annotate bcsp driver
has been removed from the -mm tree.  Its filename was
     lockdep-annotate-bcsp-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockdep: annotate bcsp driver
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

=============================================
[ INFO: possible recursive locking detected ]
2.6.18-1.2699.fc6 #1
---------------------------------------------
swapper/0 is trying to acquire lock:
 (&list->lock#3){+...}, at: [<c05ad307>] skb_dequeue+0x12/0x43

but task is already holding lock:
 (&list->lock#3){+...}, at: [<df98cd79>] bcsp_dequeue+0x6a/0x11e [hci_uart]

Two different list locks nest, annotate so.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/bluetooth/hci_bcsp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/bluetooth/hci_bcsp.c~lockdep-annotate-bcsp-driver drivers/bluetooth/hci_bcsp.c
--- a/drivers/bluetooth/hci_bcsp.c~lockdep-annotate-bcsp-driver
+++ a/drivers/bluetooth/hci_bcsp.c
@@ -330,7 +330,7 @@ static struct sk_buff *bcsp_dequeue(stru
 	   reliable packet if the number of packets sent but not yet ack'ed
 	   is < than the winsize */
 
-	spin_lock_irqsave(&bcsp->unack.lock, flags);
+	spin_lock_irqsave_nested(&bcsp->unack.lock, flags, SINGLE_DEPTH_NESTING);
 
 	if (bcsp->unack.qlen < BCSP_TXWINSIZE && (skb = skb_dequeue(&bcsp->rel)) != NULL) {
 		struct sk_buff *nskb = bcsp_prepare_pkt(bcsp, skb->data, skb->len, bt_cb(skb)->pkt_type);
@@ -696,7 +696,7 @@ static void bcsp_timed_event(unsigned lo
 
 	BT_DBG("hu %p retransmitting %u pkts", hu, bcsp->unack.qlen);
 
-	spin_lock_irqsave(&bcsp->unack.lock, flags);
+	spin_lock_irqsave_nested(&bcsp->unack.lock, flags, SINGLE_DEPTH_NESTING);
 
 	while ((skb = __skb_dequeue_tail(&bcsp->unack)) != NULL) {
 		bcsp->msgq_txseq = (bcsp->msgq_txseq - 1) & 0x07;
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
tty-signal-tty-locking.patch
tty-signal-tty-locking-post-viro-trainwreck.patch
tty-signal-tty-locking-post-viro-trainwreck-fix.patch
tty-signal-tty-locking-post-viro-trainwreck-fix-fix.patch
tty-signal-tty-locking-3270-fix.patch
do_task_stat-dont-take-tty_mutex.patch
do_acct_process-dont-take-tty_mutex.patch
sys_unshare-remove-a-broken-clone_sighand-code.patch
remove-the-old-bd_mutex-lockdep-annotation.patch
new-bd_mutex-lockdep-annotation.patch
remove-lock_key-approach-to-managing-nested-bd_mutex-locks.patch
simplify-some-aspects-of-bd_mutex-nesting.patch
use-mutex_lock_nested-for-bd_mutex-to-avoid-lockdep-warning.patch
avoid-lockdep-warning-in-md.patch
bdev-fix-bd_part_count-leak.patch
lockdep-annotate-nfsd4-recover-code.patch

