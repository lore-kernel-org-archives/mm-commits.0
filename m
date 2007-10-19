From: akpm@linux-foundation.org
Subject: - char-cyclades-move-spin_lock-to-one-place.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:44:20 -0700
Message-ID: <200710190344.l9J3iKjV013134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45335 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934443AbXJSDzh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: cyclades, move spin_lock to one place
has been removed from the -mm tree.  Its filename was
     char-cyclades-move-spin_lock-to-one-place.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: cyclades, move spin_lock to one place
From: Jiri Slaby <jirislaby@gmail.com>

Lock whole processing in isr, avoid error-prone locking/unlocking in rx/tx
esp.  On fail paths (there was a bug in the past yet).

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

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
git-dvb.patch
v4l-stk11xx-add-a-new-webcam-driver.patch
v4l-stk11xx-use-array_size-in-another-2-cases.patch
v4l-stk11xx-use-retval-from-stk11xx_check_device.patch
v4l-stk11xx-add-static-to-tables.patch
git-wireless.patch
misc-phantom-synchronize_irq-on-suspend.patch
misc-phantom-add-comment-about-openhaptics.patch
misc-phantom-improved-data-passing.patch
fs-select-remove-unused-macros.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
cyber2000fb-rename-bit-macro.patch
i2c-pxa-rename-bit-macro-to-pxa_bit.patch
s2io-rename-bit-macro.patch
amba-pl011-rename-bit-macro.patch
define-first-set-of-bit-macros.patch
get-rid-of-input-bit-duplicate-defines.patch
define-global-bit-macro.patch
flashpoint-use-bit-instead-of-bitw.patch
remove-bits_to_type-macro.patch
remove-bits_to_type-macro-fix.patch
remove-asm-bitopsh-includes-reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
