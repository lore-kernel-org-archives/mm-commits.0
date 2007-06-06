From: akpm@linux-foundation.org
Subject: + sane-irq-initialization-in-sedlbauer-hisax.patch added to -mm tree
Date: Tue, 05 Jun 2007 23:40:55 -0700
Message-ID: <200706060640.l566etTA011106@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36388 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964836AbXFFGlJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2007 02:41:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tv@lio96.de, bastian@bastian-friedrich.de, kkeil@suse.de


The patch titled
     sane irq initialization in sedlbauer/hisax
has been added to the -mm tree.  Its filename is
     sane-irq-initialization-in-sedlbauer-hisax.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sane irq initialization in sedlbauer/hisax
From: Thomas Voegtle <tv@lio96.de>

Thomas Voegtle wrote:
[...]
> <06>2007 May 30 14:21:40 cbs kern: Sedlbauer: PCI base adr 0xa800
> <03>2007 May 30 14:21:40 cbs kern: irq 11: nobody cared (try booting with the \"irqpoll\" option)
[...]
> <03>2007 May 30 14:21:40 cbs kern: handlers:
> <03>2007 May 30 14:21:40 cbs kern: [<c030899d>] (usb_hcd_irq+0x0/0x4f)
> <00>2007 May 30 14:21:40 cbs kern: Disabling IRQ #11

As described, the interrupt handler is registered too late, so early
incoming interrupts lead to the original problem.  The patch first disables
the interrupts (byteout(..., 0)), then registers the irq, and finally
enables the irqs again (byteout(..., 2) as was done at the first point
before).

Please note that the patch was developed without access to technical
specifications; the /exact/ meaning of the constants being written to the
registers are unknown.

Signed-off-by: Bastian Friedrich <bastian@bastian-friedrich.de>
Signed-off-by: Thomas Voegtle <tv@lio96.de>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hisax/config.c    |    2 ++
 drivers/isdn/hisax/sedlbauer.c |   16 +++++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff -puN drivers/isdn/hisax/config.c~sane-irq-initialization-in-sedlbauer-hisax drivers/isdn/hisax/config.c
--- a/drivers/isdn/hisax/config.c~sane-irq-initialization-in-sedlbauer-hisax
+++ a/drivers/isdn/hisax/config.c
@@ -511,6 +511,7 @@ extern int setup_TeleInt(struct IsdnCard
 
 #if CARD_SEDLBAUER
 extern int setup_sedlbauer(struct IsdnCard *card);
+extern void sedlbauer_enable_interrupts(struct IsdnCardState *cs);
 #endif
 
 #if CARD_SPORTSTER
@@ -822,6 +823,7 @@ static int init_card(struct IsdnCardStat
 		       cs->irq);
 		return 1;
 	}
+	sedlbauer_enable_interrupts(cs);
 	while (cnt) {
 		cs->cardmsg(cs, CARD_INIT, NULL);
 		/* Timeout 10ms */
diff -puN drivers/isdn/hisax/sedlbauer.c~sane-irq-initialization-in-sedlbauer-hisax drivers/isdn/hisax/sedlbauer.c
--- a/drivers/isdn/hisax/sedlbauer.c~sane-irq-initialization-in-sedlbauer-hisax
+++ a/drivers/isdn/hisax/sedlbauer.c
@@ -529,6 +529,19 @@ static struct isapnp_device_id *ipid __d
 static struct pnp_card *pnp_c __devinitdata = NULL;
 #endif
 
+int
+sedlbauer_enable_interrupts(struct IsdnCardState *cs)
+{
+#ifdef CONFIG_PCI
+	if ((cs->typ == ISDN_CTYPE_SEDLBAUER) ||
+	   (cs->typ == ISDN_CTYPE_SEDLBAUER_FAX)) {
+		byteout(cs->hw.sedl.cfg_reg+ 5, 0x02);
+	}
+#endif
+	return 0;
+}
+
+
 int __devinit
 setup_sedlbauer(struct IsdnCard *card)
 {
@@ -667,7 +680,8 @@ setup_sedlbauer(struct IsdnCard *card)
 		byteout(cs->hw.sedl.cfg_reg, 0xff);
 		byteout(cs->hw.sedl.cfg_reg, 0x00);
 		byteout(cs->hw.sedl.cfg_reg+ 2, 0xdd);
-		byteout(cs->hw.sedl.cfg_reg+ 5, 0x02);
+		byteout(cs->hw.sedl.cfg_reg+ 5, 0x00);
+			 /* 0 seems to be "disable". Enable (-> 0x02) later! */
 		byteout(cs->hw.sedl.cfg_reg +3, cs->hw.sedl.reset_on);
 		mdelay(2);
 		byteout(cs->hw.sedl.cfg_reg +3, cs->hw.sedl.reset_off);
_

Patches currently in -mm which might be from tv@lio96.de are

sane-irq-initialization-in-sedlbauer-hisax.patch
