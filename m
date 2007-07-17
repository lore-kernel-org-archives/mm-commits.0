From: akpm@linux-foundation.org
Subject: - sane-irq-initialization-in-sedlbauer-hisax.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:03:37 -0700
Message-ID: <200707172303.l6HN3b22011704@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44222 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934794AbXGQXQX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kkeil@suse.de, bastian@bastian-friedrich.de, tv@lio96.de, mm-commits@vger.kernel.org


The patch titled
     sane irq initialization in sedlbauer hisax
has been removed from the -mm tree.  Its filename was
     sane-irq-initialization-in-sedlbauer-hisax.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sane irq initialization in sedlbauer hisax
From: Karsten Keil <kkeil@suse.de>

The interrupts schould be disabled until the driver
is ready and the IRQ function was registered.

Thanks to Bastian Friedrich  and Thomas Voegtle for spotting this.

Signed-off-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Bastian Friedrich <bastian@bastian-friedrich.de>
Signed-off-by: Thomas Voegtle <tv@lio96.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hisax/sedlbauer.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/isdn/hisax/sedlbauer.c~sane-irq-initialization-in-sedlbauer-hisax drivers/isdn/hisax/sedlbauer.c
--- a/drivers/isdn/hisax/sedlbauer.c~sane-irq-initialization-in-sedlbauer-hisax
+++ a/drivers/isdn/hisax/sedlbauer.c
@@ -451,6 +451,9 @@ Sedl_card_msg(struct IsdnCardState *cs, 
 			spin_unlock_irqrestore(&cs->lock, flags);
 			return(0);
 		case CARD_RELEASE:
+			if (cs->hw.sedl.bus == SEDL_BUS_PCI)
+				/* disable all IRQ */
+				byteout(cs->hw.sedl.cfg_reg+ 5, 0);
 			if (cs->hw.sedl.chip == SEDL_CHIP_ISAC_ISAR) {
 				spin_lock_irqsave(&cs->lock, flags);
 				writereg(cs->hw.sedl.adr, cs->hw.sedl.hscx,
@@ -468,6 +471,9 @@ Sedl_card_msg(struct IsdnCardState *cs, 
 			return(0);
 		case CARD_INIT:
 			spin_lock_irqsave(&cs->lock, flags);
+			if (cs->hw.sedl.bus == SEDL_BUS_PCI)
+				/* enable all IRQ */
+				byteout(cs->hw.sedl.cfg_reg+ 5, 0x02);
 			reset_sedlbauer(cs);
 			if (cs->hw.sedl.chip == SEDL_CHIP_ISAC_ISAR) {
 				clear_pending_isac_ints(cs);
@@ -667,7 +673,7 @@ setup_sedlbauer(struct IsdnCard *card)
 		byteout(cs->hw.sedl.cfg_reg, 0xff);
 		byteout(cs->hw.sedl.cfg_reg, 0x00);
 		byteout(cs->hw.sedl.cfg_reg+ 2, 0xdd);
-		byteout(cs->hw.sedl.cfg_reg+ 5, 0x02);
+		byteout(cs->hw.sedl.cfg_reg+ 5, 0); /* disable all IRQ */
 		byteout(cs->hw.sedl.cfg_reg +3, cs->hw.sedl.reset_on);
 		mdelay(2);
 		byteout(cs->hw.sedl.cfg_reg +3, cs->hw.sedl.reset_off);
_

Patches currently in -mm which might be from kkeil@suse.de are

origin.patch
