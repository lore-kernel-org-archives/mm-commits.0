From: akpm@linux-foundation.org
Subject: + char-specialix-remove-busy-waiting.patch added to -mm tree
Date: Thu, 24 May 2007 16:59:59 -0700
Message-ID: <200705242359.l4ONxxlQ006716@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51547 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750757AbXEYAAG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 May 2007 20:00:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, R.E.Wolff@BitWizard.nl


The patch titled
     Char: specialix, remove busy waiting
has been added to the -mm tree.  Its filename is
     char-specialix-remove-busy-waiting.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: specialix, remove busy waiting
From: Jiri Slaby <jirislaby@gmail.com>

use msleep instead, because not in atomic

Cc: Roger Wolff <R.E.Wolff@BitWizard.nl>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/specialix.c |   16 ++--------------
 1 files changed, 2 insertions(+), 14 deletions(-)

diff -puN drivers/char/specialix.c~char-specialix-remove-busy-waiting drivers/char/specialix.c
--- a/drivers/char/specialix.c~char-specialix-remove-busy-waiting
+++ a/drivers/char/specialix.c
@@ -345,18 +345,6 @@ static inline void sx_release_io_range(s
 }
 
 
-/* Must be called with enabled interrupts */
-/* Ugly. Very ugly. Don't use this for anything else than initialization
-   code */
-static inline void sx_long_delay(unsigned long delay)
-{
-	unsigned long i;
-
-	for (i = jiffies + delay; time_after(i, jiffies); ) ;
-}
-
-
-
 /* Set the IRQ using the RTS lines that run to the PAL on the board.... */
 static int sx_set_irq ( struct specialix_board *bp)
 {
@@ -397,7 +385,7 @@ static int sx_init_CD186x(struct special
 	spin_lock_irqsave(&bp->lock, flags);
 	sx_out_off(bp, CD186x_CCR, CCR_HARDRESET);      /* Reset CD186x chip          */
 	spin_unlock_irqrestore(&bp->lock, flags);
-	sx_long_delay(HZ/20);                      /* Delay 0.05 sec            */
+	msleep(50);					/* Delay 0.05 sec            */
 	spin_lock_irqsave(&bp->lock, flags);
 	sx_out_off(bp, CD186x_GIVR, SX_ID);             /* Set ID for this chip      */
 	sx_out_off(bp, CD186x_GICR, 0);                 /* Clear all bits            */
@@ -533,7 +521,7 @@ static int sx_probe(struct specialix_boa
 		sx_wait_CCR(bp);
 		sx_out(bp, CD186x_CCR, CCR_TXEN);        /* Enable transmitter     */
 		sx_out(bp, CD186x_IER, IER_TXRDY);       /* Enable tx empty intr   */
-		sx_long_delay(HZ/20);
+		msleep(50);
 		irqs = probe_irq_off(irqs);
 
 		dprintk (SX_DEBUG_INIT, "SRSR = %02x, ", sx_in(bp, CD186x_SRSR));
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
