From: akpm@osdl.org
Subject: + char-isicom-check-card-state-in-isr.patch added to -mm tree
Date: Mon, 18 Dec 2006 15:28:14 -0800
Message-ID: <200612182328.kBINSETF016117@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58124 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772AbWLRX2R (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Dec 2006 18:28:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Char: isicom, check card state in isr
has been added to the -mm tree.  Its filename is
     char-isicom-check-card-state-in-isr.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Char: isicom, check card state in isr
From: Jiri Slaby <jirislaby@gmail.com>

Check if the card really interrupted us by reading its IO space and eventualy
return IRQ_NONE.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/isicom.c |    5 +++++
 1 files changed, 5 insertions(+)

diff -puN drivers/char/isicom.c~char-isicom-check-card-state-in-isr drivers/char/isicom.c
--- a/drivers/char/isicom.c~char-isicom-check-card-state-in-isr
+++ a/drivers/char/isicom.c
@@ -539,6 +539,11 @@ static irqreturn_t isicom_interrupt(int 
 		return IRQ_NONE;
 
 	base = card->base;
+
+	/* did the card interrupt us? */
+	if (!(inw(base + 0x0e) & 0x02))
+		return IRQ_NONE;
+
 	spin_lock(&card->card_lock);
 
 	/*
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

