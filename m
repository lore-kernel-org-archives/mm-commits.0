From: akpm@linux-foundation.org
Subject: + char-riscom8-eliminate-busy-loop.patch added to -mm tree
Date: Thu, 24 May 2007 17:00:01 -0700
Message-ID: <200705250000.l4P002JD006748@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56240 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753479AbXEYAAF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 May 2007 20:00:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: riscom8, eliminate busy loop
has been added to the -mm tree.  Its filename is
     char-riscom8-eliminate-busy-loop.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: riscom8, eliminate busy loop
From: Jiri Slaby <jirislaby@gmail.com>

riscom8, eliminate busy loop

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/riscom8.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff -puN drivers/char/riscom8.c~char-riscom8-eliminate-busy-loop drivers/char/riscom8.c
--- a/drivers/char/riscom8.c~char-riscom8-eliminate-busy-loop
+++ a/drivers/char/riscom8.c
@@ -213,14 +213,6 @@ static inline void rc_release_io_range(s
 		release_region(RC_TO_ISA(rc_ioport[i]) + bp->base, 1);
 }
 	
-/* Must be called with enabled interrupts */
-static inline void rc_long_delay(unsigned long delay)
-{
-	unsigned long i;
-	
-	for (i = jiffies + delay; time_after(i,jiffies); ) ;
-}
-
 /* Reset and setup CD180 chip */
 static void __init rc_init_CD180(struct riscom_board const * bp)
 {
@@ -231,7 +223,7 @@ static void __init rc_init_CD180(struct 
 	rc_wait_CCR(bp);			   /* Wait for CCR ready        */
 	rc_out(bp, CD180_CCR, CCR_HARDRESET);      /* Reset CD180 chip          */
 	sti();
-	rc_long_delay(HZ/20);                      /* Delay 0.05 sec            */
+	msleep(50);				   /* Delay 0.05 sec            */
 	cli();
 	rc_out(bp, CD180_GIVR, RC_ID);             /* Set ID for this chip      */
 	rc_out(bp, CD180_GICR, 0);                 /* Clear all bits            */
@@ -280,7 +272,7 @@ static int __init rc_probe(struct riscom
 		rc_wait_CCR(bp);
 		rc_out(bp, CD180_CCR, CCR_TXEN);        /* Enable transmitter     */
 		rc_out(bp, CD180_IER, IER_TXRDY);       /* Enable tx empty intr   */
-		rc_long_delay(HZ/20);	       		
+		msleep(50);
 		irqs = probe_irq_off(irqs);
 		val1 = rc_in(bp, RC_BSR);		/* Get Board Status reg   */
 		val2 = rc_in(bp, RC_ACK_TINT);          /* ACK interrupt          */
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
char-cyclades-fix-deadlock.patch
misc-phantom-move-to-unlocked_ioctl.patch
misc-phantom-take-care-of-pci-posting.patch
cinergyt2-fix-file-release-handler.patch
rocketc-fix-unchecked-mutex_lock_interruptible.patch
char-cyclades-add-firmware-loading.patch
char-cyclades-fix-sparse-warning.patch
char-isicom-cleanup-locking.patch
char-isicom-del_timer-at-exit.patch
char-isicom-proper-variables-types.patch
char-moxa-eliminate-busy-waiting.patch
char-specialix-remove-busy-waiting.patch
char-riscom8-eliminate-busy-loop.patch
shrink_slab-handle-bad-shrinkers.patch
