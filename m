From: akpm@linux-foundation.org
Subject: - char-riscom8-eliminate-busy-loop.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:06:26 -0700
Message-ID: <200707172306.l6HN6QSe012013@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54089 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765325AbXGQXPM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: riscom8, eliminate busy loop
has been removed from the -mm tree.  Its filename was
     char-riscom8-eliminate-busy-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: riscom8, eliminate busy loop
From: Jiri Slaby <jirislaby@gmail.com>

riscom8, eliminate busy loop

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/riscom8.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

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
some-kmalloc-memset-kzalloc-tree-wide.patch
shrink_slab-handle-bad-shrinkers.patch
