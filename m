From: akpm@linux-foundation.org
Subject: - char-isicom-fix-locking-in-isr.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:50:37 -0800
Message-ID: <200702112250.l1BMobas015870@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60024 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932717AbXBKWuj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:50:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: isicom, fix locking in isr
has been removed from the -mm tree.  Its filename was
     char-isicom-fix-locking-in-isr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: isicom, fix locking in isr
From: Jiri Slaby <jirislaby@gmail.com>

2 spin_unlocks are omitted in the interrupt handler.  Put them there to fix up
deadlocking on UP.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/isicom.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/char/isicom.c~char-isicom-fix-locking-in-isr drivers/char/isicom.c
--- a/drivers/char/isicom.c~char-isicom-fix-locking-in-isr
+++ a/drivers/char/isicom.c
@@ -564,6 +564,7 @@ static irqreturn_t isicom_interrupt(int 
 	port = card->ports + channel;
 	if (!(port->flags & ASYNC_INITIALIZED)) {
 		outw(0x0000, base+0x04); /* enable interrupts */
+		spin_unlock(&card->card_lock);
 		return IRQ_HANDLED;
 	}
 
@@ -678,6 +679,7 @@ static irqreturn_t isicom_interrupt(int 
 		tty_flip_buffer_push(tty);
 	}
 	outw(0x0000, base+0x04); /* enable interrupts */
+	spin_unlock(&card->card_lock);
 
 	return IRQ_HANDLED;
 }
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
char-use-more-pci_device-macro.patch
char-cyclades-use-pci_device_id.patch
maintainers-remove-two-dead-e-mail.patch
char-specialix-isr-have-2-params.patch
char-timers-cleanup.patch
fbdev-driver-for-s3-trio-virge-update-2-fix.patch
video-fb-add-true-ref_count-atomicity.patch
video-fb-kzalloc-changes.patch
shrink_slab-handle-bad-shrinkers.patch
