From: akpm@linux-foundation.org
Subject: - char-isicom-check-card-state-in-isr.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:50:41 -0800
Message-ID: <200702112250.l1BMof6f015878@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60033 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932739AbXBKWun (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:50:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: isicom, check card state in isr
has been removed from the -mm tree.  Its filename was
     char-isicom-check-card-state-in-isr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: isicom, check card state in isr
From: Jiri Slaby <jirislaby@gmail.com>

Check if the card really interrupted us by reading its IO space and eventualy
return IRQ_NONE.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/isicom.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/char/isicom.c~char-isicom-check-card-state-in-isr drivers/char/isicom.c
--- a/drivers/char/isicom.c~char-isicom-check-card-state-in-isr
+++ a/drivers/char/isicom.c
@@ -540,6 +540,11 @@ static irqreturn_t isicom_interrupt(int 
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
