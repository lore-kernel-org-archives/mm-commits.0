From: akpm@linux-foundation.org
Subject: - 3c501-further-coding-style-fixes.patch removed from -mm tree
Date: Mon, 17 Mar 2008 14:00:21 -0700
Message-ID: <200803172100.m2HL0LTm030853@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752362AbYCQVDU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 17:03:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     3c501: further coding style fixes
has been removed from the -mm tree.  Its filename was
     3c501-further-coding-style-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: 3c501: further coding style fixes
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/3c501.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN drivers/net/3c501.c~3c501-further-coding-style-fixes drivers/net/3c501.c
--- a/drivers/net/3c501.c~3c501-further-coding-style-fixes
+++ a/drivers/net/3c501.c
@@ -485,9 +485,7 @@ static int el_start_xmit(struct sk_buff 
 			printk(KERN_DEBUG "%s: burped during tx load.\n",
 				dev->name);
 		spin_lock_irqsave(&lp->lock, flags);
-	}
-	while (1);
-
+	} while (1);
 }
 
 /**
@@ -612,7 +610,8 @@ static irqreturn_t el_interrupt(int irq,
 			dev->stats.tx_packets++;
 			if (el_debug > 6)
 				printk(KERN_DEBUG " Tx succeeded %s\n",
-					(txsr & TX_RDY) ? "." : "but tx is busy!");
+					(txsr & TX_RDY) ? "." :
+							"but tx is busy!");
 			/*
 			 *	This is safe the interrupt is atomic WRT itself.
 			 */
@@ -693,7 +692,8 @@ static void el_receive(struct net_device
 
 	if (pkt_len < 60 || pkt_len > 1536) {
 		if (el_debug)
-			printk(KERN_DEBUG "%s: bogus packet, length=%d\n", dev->name, pkt_len);
+			printk(KERN_DEBUG "%s: bogus packet, length=%d\n",
+						dev->name, pkt_len);
 		dev->stats.rx_over_errors++;
 		return;
 	}
@@ -711,7 +711,8 @@ static void el_receive(struct net_device
 
 	outw(0x00, GP_LOW);
 	if (skb == NULL) {
-		printk(KERN_INFO "%s: Memory squeeze, dropping packet.\n", dev->name);
+		printk(KERN_INFO "%s: Memory squeeze, dropping packet.\n",
+								dev->name);
 		dev->stats.rx_dropped++;
 		return;
 	} else {
@@ -748,7 +749,8 @@ static void  el_reset(struct net_device 
 	if (el_debug > 2)
 		printk(KERN_INFO "3c501 reset...");
 	outb(AX_RESET, AX_CMD);		/* Reset the chip */
-	outb(AX_LOOP, AX_CMD);		/* Aux control, irq and loopback enabled */
+	/* Aux control, irq and loopback enabled */
+	outb(AX_LOOP, AX_CMD);
 	{
 		int i;
 		for (i = 0; i < 6; i++)	/* Set the station address. */
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
libata-isolate-and-rework-cable-logic.patch
devres-implement-pcim_iomap_regions_request_all.patch
devres-implement-pcim_iomap_regions_request_all-fix.patch
devres-implement-pcim_iomap_regions_request_all-fix-fix.patch
pata_amd-fix-sparse-warning.patch
git-net.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core-fix.patch
parisc-new-termios-definitions.patch
crisv10-prepare-for-bkl-push-down.patch
fix-tty-speed-handling-on-8250.patch
uart_get_baud_rate-stop-mangling-termios.patch
do_task_stat-dont-take-rcu_read_lock.patch
amiserial-prepare-for-locking-relaxation-in-caller.patch
cyclades-prepare-for-relaxed-locking-in-callers.patch
epca-lock_kernel-push-down.patch
esp-lock_kernel-push-down.patch
isicom-prepare-for-lock_kernel-push-down.patch
isicom-istallion-prepare-for-lock_kernel-pushdown.patch
mxser-prepare-for-bkl-pushdown.patch
riscom8-prepare-for-bkl-pushdown.patch
rocket-prepare-for-bkl-pushdown.patch
serial167-prepare-to-push-bkl-down-into-drivers.patch
specialix-prepare-for-bkl-pushdown.patch
stallion-prepare-for-bkl-push-down.patch
sx-prepare-for-bkl-pushdown.patch
synclink-series-prepare-for-bkl-pushdown.patch
viocons-bkl-locking.patch
vt_ioctl-prepare-for-bkl-push-down.patch
isdn_tty-prepare-for-bkl-push-down.patch
68360serial-note-that-there-isnt-any-info-mcr-locking.patch
serial_core-prepare-for-bkl-push-down.patch
tty-bkl-pushdown.patch
tty-bkl-pushdown-fix1.patch
redo-locking-of-tty-pgrp.patch
resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline.patch
tty_io-fix-remaining-pid-struct-locking.patch
tty_io-fix-remaining-pid-struct-locking-small-cleanup.patch
tty_ioctl-locking-for-tty_wait_until_sent.patch
tty_ioctl-soft-carrier-handling.patch
istallion-tiocg-ssoftcar-handling-removal.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

