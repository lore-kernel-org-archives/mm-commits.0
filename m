From: akpm@linux-foundation.org
Subject: + char-cyclades-move-spin_lock-to-one-place.patch added to -mm tree
Date: Mon, 30 Jul 2007 16:40:11 -0700
Message-ID: <200707302340.l6UNeBe3004451@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53718 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761858AbXG3XkT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 19:40:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: cyclades, move spin_lock to one place
has been added to the -mm tree.  Its filename is
     char-cyclades-move-spin_lock-to-one-place.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: cyclades, move spin_lock to one place
From: Jiri Slaby <jirislaby@gmail.com>

Lock whole processing in isr, avoid error-prone locking/unlocking in rx/tx
esp.  On fail paths (there was a bug in the past yet).

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff -puN drivers/char/cyclades.c~char-cyclades-move-spin_lock-to-one-place drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~char-cyclades-move-spin_lock-to-one-place
+++ a/drivers/char/cyclades.c
@@ -994,7 +994,6 @@ static void cyy_chip_rx(struct cyclades_
 	printk(KERN_DEBUG "cyy_interrupt: rcvd intr, chip %d\n", chip);
 #endif
 	/* determine the channel & change to that context */
-	spin_lock(&cinfo->card_lock);
 	save_xir = (u_char) readb(base_addr + (CyRIR << index));
 	channel = (u_short) (save_xir & CyIRChannel);
 	info = &cinfo->ports[channel + chip * 4];
@@ -1031,7 +1030,6 @@ static void cyy_chip_rx(struct cyclades_
 
 		if (data & info->ignore_status_mask) {
 			info->icount.rx++;
-			spin_unlock(&cinfo->card_lock);
 			return;
 		}
 		if (tty_buffer_request_room(tty, 1)) {
@@ -1116,7 +1114,6 @@ end:
 	/* end of service */
 	cy_writeb(base_addr + (CyRIR << index), save_xir & 0x3f);
 	cy_writeb(base_addr + (CyCAR << index), save_car);
-	spin_unlock(&cinfo->card_lock);
 }
 
 static void cyy_chip_tx(struct cyclades_card *cinfo, int chip,
@@ -1135,7 +1132,6 @@ static void cyy_chip_tx(struct cyclades_
 #endif
 
 	/* determine the channel & change to that context */
-	spin_lock(&cinfo->card_lock);
 	save_xir = (u_char) readb(base_addr + (CyTIR << index));
 	channel = (u_short) (save_xir & CyIRChannel);
 	save_car = readb(base_addr + (CyCAR << index));
@@ -1240,7 +1236,6 @@ end:
 	/* end of service */
 	cy_writeb(base_addr + (CyTIR << index), save_xir & 0x3f);
 	cy_writeb(base_addr + (CyCAR << index), save_car);
-	spin_unlock(&cinfo->card_lock);
 }
 
 static void cyy_chip_modem(struct cyclades_card *cinfo, int chip,
@@ -1251,7 +1246,6 @@ static void cyy_chip_modem(struct cyclad
 	int save_xir, channel, save_car, index = cinfo->bus_index;
 
 	/* determine the channel & change to that context */
-	spin_lock(&cinfo->card_lock);
 	save_xir = (u_char) readb(base_addr + (CyMIR << index));
 	channel = (u_short) (save_xir & CyIRChannel);
 	info = &cinfo->ports[channel + chip * 4];
@@ -1315,7 +1309,6 @@ end:
 	/* end of service */
 	cy_writeb(base_addr + (CyMIR << index), save_xir & 0x3f);
 	cy_writeb(base_addr + (CyCAR << index), save_car);
-	spin_unlock(&cinfo->card_lock);
 }
 
 /* The real interrupt service routine is called
@@ -1367,12 +1360,14 @@ static irqreturn_t cyy_interrupt(int irq
 			 */
 				if (1000 < too_many++)
 					break;
+				spin_lock(&cinfo->card_lock);
 				if (status & CySRReceive) /* rx intr */
 					cyy_chip_rx(cinfo, chip, base_addr);
 				if (status & CySRTransmit) /* tx intr */
 					cyy_chip_tx(cinfo, chip, base_addr);
 				if (status & CySRModem) /* modem intr */
 					cyy_chip_modem(cinfo, chip, base_addr);
+				spin_unlock(&cinfo->card_lock);
 			}
 		}
 	} while (had_work);
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
epcac-reformat-comments-and-coding-style-improvements.patch
char-moxa-fix-and-optimise-empty-timer.patch
char-cyclades-remove-bottom-half-processing.patch
char-cyclades-make-the-isr-code-readable.patch
char-cyclades-move-spin_lock-to-one-place.patch
char-cyclades-fix-some-w-warnings.patch
shrink_slab-handle-bad-shrinkers.patch
