From: akpm@osdl.org
Subject: + char-isicom-fix-locking-in-isr.patch added to -mm tree
Date: Mon, 18 Dec 2006 15:28:08 -0800
Message-ID: <200612182328.kBINS8Nq016105@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58108 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772AbWLRX2M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Dec 2006 18:28:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: isicom, fix locking in isr
has been added to the -mm tree.  Its filename is
     char-isicom-fix-locking-in-isr.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: isicom, fix locking in isr
From: Jiri Slaby <jirislaby@gmail.com>

2 spin_unlocks are omitted in the interrupt handler.  Put them there to fix up
deadlocking on UP.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/isicom.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/char/isicom.c~char-isicom-fix-locking-in-isr drivers/char/isicom.c
--- a/drivers/char/isicom.c~char-isicom-fix-locking-in-isr
+++ a/drivers/char/isicom.c
@@ -563,6 +563,7 @@ static irqreturn_t isicom_interrupt(int 
 	port = card->ports + channel;
 	if (!(port->flags & ASYNC_INITIALIZED)) {
 		outw(0x0000, base+0x04); /* enable interrupts */
+		spin_unlock(&card->card_lock);
 		return IRQ_HANDLED;
 	}
 
@@ -677,6 +678,7 @@ static irqreturn_t isicom_interrupt(int 
 		tty_flip_buffer_push(tty);
 	}
 	outw(0x0000, base+0x04); /* enable interrupts */
+	spin_unlock(&card->card_lock);
 
 	return IRQ_HANDLED;
 }
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-isicom-remove-tty_hangwakeup-bottomhalves.patch
mxser-remove-ambiguous-redefinition-of-init_work.patch
char-isicom-fix-locking-in-isr.patch
char-isicom-fix-probe-race.patch
char-isicom-augment-card_reset.patch
char-isicom-check-card-state-in-isr.patch
char-isicom-support-higher-rates.patch
shrink_slab-handle-bad-shrinkers.patch

