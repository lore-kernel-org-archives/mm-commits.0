From: akpm@linux-foundation.org
Subject: + avr32-s-irq_chip-irq_data-in-various-places.patch added to -mm tree
Date: Mon, 11 Apr 2011 16:22:08 -0700
Message-ID: <201104112322.p3BNM8g6010291@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753012Ab1DKXWU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Apr 2011 19:22:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wanlong.gao@gmail.com, hans-christian.egtvedt@atmel.com, tglx@linutronix.de


The patch titled
     avr32: s/irq_chip/irq_data/ in various places
has been added to the -mm tree.  Its filename is
     avr32-s-irq_chip-irq_data-in-various-places.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: avr32: s/irq_chip/irq_data/ in various places
From: Wanlong Gao <wanlong.gao@gmail.com>

The functions of eic_chip's memebers use the wrong argument.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/mach-at32ap/extint.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN arch/avr32/mach-at32ap/extint.c~avr32-s-irq_chip-irq_data-in-various-places arch/avr32/mach-at32ap/extint.c
--- a/arch/avr32/mach-at32ap/extint.c~avr32-s-irq_chip-irq_data-in-various-places
+++ a/arch/avr32/mach-at32ap/extint.c
@@ -61,34 +61,34 @@ struct eic {
 static struct eic *nmi_eic;
 static bool nmi_enabled;
 
-static void eic_ack_irq(struct irq_chip *d)
+static void eic_ack_irq(struct irq_data *d)
 {
-	struct eic *eic = irq_data_get_irq_chip_data(data);
+	struct eic *eic = irq_data_get_irq_chip_data(d);
 	eic_writel(eic, ICR, 1 << (d->irq - eic->first_irq));
 }
 
-static void eic_mask_irq(struct irq_chip *d)
+static void eic_mask_irq(struct irq_data *d)
 {
-	struct eic *eic = irq_data_get_irq_chip_data(data);
+	struct eic *eic = irq_data_get_irq_chip_data(d);
 	eic_writel(eic, IDR, 1 << (d->irq - eic->first_irq));
 }
 
-static void eic_mask_ack_irq(struct irq_chip *d)
+static void eic_mask_ack_irq(struct irq_data *d)
 {
-	struct eic *eic = irq_data_get_irq_chip_data(data);
+	struct eic *eic = irq_data_get_irq_chip_data(d);
 	eic_writel(eic, ICR, 1 << (d->irq - eic->first_irq));
 	eic_writel(eic, IDR, 1 << (d->irq - eic->first_irq));
 }
 
-static void eic_unmask_irq(struct irq_chip *d)
+static void eic_unmask_irq(struct irq_data *d)
 {
-	struct eic *eic = irq_data_get_irq_chip_data(data);
+	struct eic *eic = irq_data_get_irq_chip_data(d);
 	eic_writel(eic, IER, 1 << (d->irq - eic->first_irq));
 }
 
-static int eic_set_irq_type(struct irq_chip *d, unsigned int flow_type)
+static int eic_set_irq_type(struct irq_data *d, unsigned int flow_type)
 {
-	struct eic *eic = irq_data_get_irq_chip_data(data);
+	struct eic *eic = irq_data_get_irq_chip_data(d);
 	unsigned int irq = d->irq;
 	unsigned int i = irq - eic->first_irq;
 	u32 mode, edge, level;
_

Patches currently in -mm which might be from wanlong.gao@gmail.com are

xtensa-s-irq_chip-irq_data-in-various-places.patch
avr32-s-irq_chip-irq_data-in-various-places.patch

