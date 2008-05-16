From: akpm@linux-foundation.org
Subject: - hysdn-remove-cli-sti-calls.patch removed from -mm tree
Date: Fri, 16 May 2008 15:53:59 -0700
Message-ID: <200805162253.m4GMrxfg003188@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50278 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757509AbYEPWyD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 May 2008 18:54:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mark.asselstine@windriver.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     hysdn: remove cli()/sti() calls
has been removed from the -mm tree.  Its filename was
     hysdn-remove-cli-sti-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hysdn: remove cli()/sti() calls
From: Mark Asselstine <mark.asselstine@windriver.com>

The use of cli()/sti() within the do/while was a way to ensure interrupts were
only disabled for short periods of time while the bulk of the time interrupts
were free to occur.  The use of the spin lock has eliminated the need to play
with interrupts in this way while still allowing for IO to be protected.

The remaining 3 sti() calls seem unneeded now that at no other point in the
driver is there a call to cli().

Signed-off-by: Mark Asselstine <mark.asselstine@windriver.com>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hysdn/boardergo.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff -puN drivers/isdn/hysdn/boardergo.c~hysdn-remove-cli-sti-calls drivers/isdn/hysdn/boardergo.c
--- a/drivers/isdn/hysdn/boardergo.c~hysdn-remove-cli-sti-calls
+++ a/drivers/isdn/hysdn/boardergo.c
@@ -64,10 +64,11 @@ ergo_interrupt(int intno, void *dev_id)
 }				/* ergo_interrupt */
 
 /******************************************************************************/
-/* ergo_irq_bh is the function called by the immediate kernel task list after */
-/* being activated with queue_task and no interrupts active. This task is the */
-/* only one handling data transfer from or to the card after booting. The task */
-/* may be queued from everywhere (interrupts included).                       */
+/* ergo_irq_bh will be called as part of the kernel clearing its shared work  */
+/* queue sometime after a call to schedule_work has been made passing our     */
+/* work_struct. This task is the only one handling data transfer from or to   */
+/* the card after booting. The task may be queued from everywhere             */
+/* (interrupts included).                                                     */
 /******************************************************************************/
 static void
 ergo_irq_bh(struct work_struct *ugli_api)
@@ -90,7 +91,6 @@ ergo_irq_bh(struct work_struct *ugli_api
 	card->hw_lock = 1;	/* we now lock the hardware */
 
 	do {
-		sti();		/* reenable other ints */
 		again = 0;	/* assume loop not to be repeated */
 
 		if (!dpr->ToHyFlag) {
@@ -110,7 +110,6 @@ ergo_irq_bh(struct work_struct *ugli_api
 				again = 1;	/* restart loop */
 			}
 		}		/* a message has arrived for us */
-		cli();		/* no further ints */
 		if (again) {
 			dpr->ToHyInt = 1;
 			dpr->ToPcInt = 1;	/* interrupt to E1 for all cards */
@@ -242,7 +241,6 @@ ergo_writebootimg(struct HYSDN_CARD *car
 		byteout(card->iobase + PCI9050_USER_IO, PCI9050_E1_RUN);	/* start E1 processor */
 		/* the interrupts are still masked */
 
-		sti();
 		msleep_interruptible(20);		/* Timeout 20ms */
 
 		if (((tDpramBootSpooler *) card->dpram)->Len != DPRAM_SPOOLER_DATA_SIZE) {
@@ -276,7 +274,6 @@ ergo_writebootseq(struct HYSDN_CARD *car
 	dst = sp->Data;		/* point to data in spool structure */
 	buflen = sp->Len;	/* maximum len of spooled data */
 	wr_mirror = sp->WrPtr;	/* only once read */
-	sti();
 
 	/* try until all bytes written or error */
 	i = 0x1000;		/* timeout value */
@@ -380,7 +377,6 @@ ergo_waitpofready(struct HYSDN_CARD *car
 #endif /* CONFIG_HYSDN_CAPI */
 			return (0);	/* success */
 		}		/* data has arrived */
-		sti();
 		msleep_interruptible(50);		/* Timeout 50ms */
 	}			/* wait until timeout */
 
_

Patches currently in -mm which might be from mark.asselstine@windriver.com are

linux-next.patch

