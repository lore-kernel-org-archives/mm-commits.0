From: akpm@linux-foundation.org
Subject: - pnp-introduce-pnp_irq_mask_t-typedef.patch removed from -mm tree
Date: Mon, 23 Jun 2008 14:03:25 -0700
Message-ID: <200806232103.m5NL3P3A016157@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33287 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757076AbYFWVEF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 17:04:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, abelay@mit.edu, castet.matthieu@free.fr, lenb@kernel.org, perex@perex.cz, rene.herman@gmail.com, shaohua.li@intel.com, tiwai@suse.de, trenn@suse.de, mm-commits@v


The patch titled
     pnp: introduce pnp_irq_mask_t typedef
has been removed from the -mm tree.  Its filename was
     pnp-introduce-pnp_irq_mask_t-typedef.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp: introduce pnp_irq_mask_t typedef
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

This adds a typedef for the IRQ bitmap, which should cause no functional
change, but will make it easier to pass a pointer to a bitmap to
pnp_register_irq_resource().

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Acked-by: Rene Herman <rene.herman@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Adam M Belay <abelay@mit.edu>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/base.h             |    4 +++-
 drivers/pnp/interface.c        |    4 ++--
 drivers/pnp/isapnp/core.c      |    2 +-
 drivers/pnp/manager.c          |    6 +++---
 drivers/pnp/pnpacpi/rsparser.c |    4 ++--
 drivers/pnp/pnpbios/rsparser.c |    2 +-
 drivers/pnp/quirks.c           |    4 ++--
 drivers/pnp/resource.c         |    6 +++---
 8 files changed, 17 insertions(+), 15 deletions(-)

diff -puN drivers/pnp/base.h~pnp-introduce-pnp_irq_mask_t-typedef drivers/pnp/base.h
--- a/drivers/pnp/base.h~pnp-introduce-pnp_irq_mask_t-typedef
+++ a/drivers/pnp/base.h
@@ -30,8 +30,10 @@ struct pnp_port {
 };
 
 #define PNP_IRQ_NR 256
+typedef struct { DECLARE_BITMAP(bits, PNP_IRQ_NR); } pnp_irq_mask_t;
+
 struct pnp_irq {
-	DECLARE_BITMAP(map, PNP_IRQ_NR);	/* bitmask for IRQ lines */
+	pnp_irq_mask_t map;	/* bitmap for IRQ lines */
 	unsigned char flags;	/* IRQ flags */
 	unsigned char pad;	/* pad */
 	struct pnp_irq *next;	/* next IRQ */
diff -puN drivers/pnp/interface.c~pnp-introduce-pnp_irq_mask_t-typedef drivers/pnp/interface.c
--- a/drivers/pnp/interface.c~pnp-introduce-pnp_irq_mask_t-typedef
+++ a/drivers/pnp/interface.c
@@ -67,7 +67,7 @@ static void pnp_print_irq(pnp_info_buffe
 
 	pnp_printf(buffer, "%sirq ", space);
 	for (i = 0; i < PNP_IRQ_NR; i++)
-		if (test_bit(i, irq->map)) {
+		if (test_bit(i, irq->map.bits)) {
 			if (!first) {
 				pnp_printf(buffer, ",");
 			} else {
@@ -78,7 +78,7 @@ static void pnp_print_irq(pnp_info_buffe
 			else
 				pnp_printf(buffer, "%i", i);
 		}
-	if (bitmap_empty(irq->map, PNP_IRQ_NR))
+	if (bitmap_empty(irq->map.bits, PNP_IRQ_NR))
 		pnp_printf(buffer, "<none>");
 	if (irq->flags & IORESOURCE_IRQ_HIGHEDGE)
 		pnp_printf(buffer, " High-Edge");
diff -puN drivers/pnp/isapnp/core.c~pnp-introduce-pnp_irq_mask_t-typedef drivers/pnp/isapnp/core.c
--- a/drivers/pnp/isapnp/core.c~pnp-introduce-pnp_irq_mask_t-typedef
+++ a/drivers/pnp/isapnp/core.c
@@ -441,7 +441,7 @@ static void __init isapnp_parse_irq_reso
 	if (!irq)
 		return;
 	bits = (tmp[1] << 8) | tmp[0];
-	bitmap_copy(irq->map, &bits, 16);
+	bitmap_copy(irq->map.bits, &bits, 16);
 	if (size > 2)
 		irq->flags = tmp[2];
 	else
diff -puN drivers/pnp/manager.c~pnp-introduce-pnp_irq_mask_t-typedef drivers/pnp/manager.c
--- a/drivers/pnp/manager.c~pnp-introduce-pnp_irq_mask_t-typedef
+++ a/drivers/pnp/manager.c
@@ -128,20 +128,20 @@ static int pnp_assign_irq(struct pnp_dev
 	res->start = -1;
 	res->end = -1;
 
-	if (bitmap_empty(rule->map, PNP_IRQ_NR)) {
+	if (bitmap_empty(rule->map.bits, PNP_IRQ_NR)) {
 		res->flags |= IORESOURCE_DISABLED;
 		dev_dbg(&dev->dev, "  irq %d disabled\n", idx);
 		goto __add;
 	}
 
 	/* TBD: need check for >16 IRQ */
-	res->start = find_next_bit(rule->map, PNP_IRQ_NR, 16);
+	res->start = find_next_bit(rule->map.bits, PNP_IRQ_NR, 16);
 	if (res->start < PNP_IRQ_NR) {
 		res->end = res->start;
 		goto __add;
 	}
 	for (i = 0; i < 16; i++) {
-		if (test_bit(xtab[i], rule->map)) {
+		if (test_bit(xtab[i], rule->map.bits)) {
 			res->start = res->end = xtab[i];
 			if (pnp_check_irq(dev, res))
 				goto __add;
diff -puN drivers/pnp/pnpacpi/rsparser.c~pnp-introduce-pnp_irq_mask_t-typedef drivers/pnp/pnpacpi/rsparser.c
--- a/drivers/pnp/pnpacpi/rsparser.c~pnp-introduce-pnp_irq_mask_t-typedef
+++ a/drivers/pnp/pnpacpi/rsparser.c
@@ -408,7 +408,7 @@ static __init void pnpacpi_parse_irq_opt
 
 	for (i = 0; i < p->interrupt_count; i++)
 		if (p->interrupts[i])
-			__set_bit(p->interrupts[i], irq->map);
+			__set_bit(p->interrupts[i], irq->map.bits);
 	irq->flags = irq_flags(p->triggering, p->polarity, p->sharable);
 
 	pnp_register_irq_resource(dev, option, irq);
@@ -429,7 +429,7 @@ static __init void pnpacpi_parse_ext_irq
 
 	for (i = 0; i < p->interrupt_count; i++)
 		if (p->interrupts[i])
-			__set_bit(p->interrupts[i], irq->map);
+			__set_bit(p->interrupts[i], irq->map.bits);
 	irq->flags = irq_flags(p->triggering, p->polarity, p->sharable);
 
 	pnp_register_irq_resource(dev, option, irq);
diff -puN drivers/pnp/pnpbios/rsparser.c~pnp-introduce-pnp_irq_mask_t-typedef drivers/pnp/pnpbios/rsparser.c
--- a/drivers/pnp/pnpbios/rsparser.c~pnp-introduce-pnp_irq_mask_t-typedef
+++ a/drivers/pnp/pnpbios/rsparser.c
@@ -275,7 +275,7 @@ static __init void pnpbios_parse_irq_opt
 	if (!irq)
 		return;
 	bits = (p[2] << 8) | p[1];
-	bitmap_copy(irq->map, &bits, 16);
+	bitmap_copy(irq->map.bits, &bits, 16);
 	if (size > 2)
 		irq->flags = p[3];
 	else
diff -puN drivers/pnp/quirks.c~pnp-introduce-pnp_irq_mask_t-typedef drivers/pnp/quirks.c
--- a/drivers/pnp/quirks.c~pnp-introduce-pnp_irq_mask_t-typedef
+++ a/drivers/pnp/quirks.c
@@ -68,7 +68,7 @@ static void quirk_cmi8330_resources(stru
 
 		for (irq = res->irq; irq; irq = irq->next) {	// Valid irqs are 5, 7, 10
 			tmp = 0x04A0;
-			bitmap_copy(irq->map, &tmp, 16);	// 0000 0100 1010 0000
+			bitmap_copy(irq->map.bits, &tmp, 16);	// 0000 0100 1010 0000
 		}
 
 		for (dma = res->dma; dma; dma = dma->next)	// Valid 8bit dma channels are 1,3
@@ -187,7 +187,7 @@ static void quirk_ad1815_mpu_resources(s
 		if (!copy)
 			break;
 
-		memcpy(copy->map, irq->map, sizeof copy->map);
+		bitmap_copy(copy->map.bits, irq->map.bits, PNP_IRQ_NR);
 		copy->flags = irq->flags;
 
 		copy->next = res->irq; /* Yes, this is NULL */
diff -puN drivers/pnp/resource.c~pnp-introduce-pnp_irq_mask_t-typedef drivers/pnp/resource.c
--- a/drivers/pnp/resource.c~pnp-introduce-pnp_irq_mask_t-typedef
+++ a/drivers/pnp/resource.c
@@ -98,13 +98,13 @@ int pnp_register_irq_resource(struct pnp
 		int i;
 
 		for (i = 0; i < 16; i++)
-			if (test_bit(i, data->map))
+			if (test_bit(i, data->map.bits))
 				pcibios_penalize_isa_irq(i, 0);
 	}
 #endif
 
 #ifdef DEBUG
-	bitmap_scnprintf(buf, sizeof(buf), data->map, PNP_IRQ_NR);
+	bitmap_scnprintf(buf, sizeof(buf), data->map.bits, PNP_IRQ_NR);
 	dev_dbg(&dev->dev, "  irq bitmask %s flags %#x\n", buf,
 		data->flags);
 #endif
@@ -653,7 +653,7 @@ static int pnp_possible_option(struct pn
 		case IORESOURCE_IRQ:
 			for (irq = tmp->irq; irq; irq = irq->next) {
 				if (start < PNP_IRQ_NR &&
-				    test_bit(start, irq->map))
+				    test_bit(start, irq->map.bits))
 					return 1;
 			}
 			break;
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

linux-next.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch
make-pnp_add_card_id-static.patch

