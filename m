From: akpm@linux-foundation.org
Subject: [merged] mc13783-rename-mc13783_unmaskack_irq-to-have-a-mc13783_irq-prefix.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:10:38 -0800
Message-ID: <201003091910.o29JAcup031605@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755969Ab0CITLp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:11:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, a.zummo@towertech.it, dmitry.torokhov@gmail.com, l.fu@pengutronix.de, p_gortmaker@yahoo.com, s.hauer@pengutronix.de, sameo@linux.intel.com, valentin.lo


The patch titled
     mc13783: rename mc13783_{{un,}mask,ack_irq} to have a mc13783_irq =
prefix
has been removed from the -mm tree.  Its filename was
     mc13783-rename-mc13783_unmaskack_irq-to-have-a-mc13783_irq-prefix.=
patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: mc13783: rename mc13783_{{un,}mask,ack_irq} to have a mc13783_=
irq prefix
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

In the source file group these functions together.

The mc13783 header file provides fallback implementations for the old
names to prevent build failures.  When all users of the old names are
fixed to use the new names these can go away.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Valentin Longchamp <valentin.longchamp@epfl.ch>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Luotao Fu <l.fu@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/mc13783-core.c  |   38 +++++++++++++++++-----------------
 include/linux/mfd/mc13783.h |   24 ++++++++++++++++++---
 2 files changed, 40 insertions(+), 22 deletions(-)

diff -puN drivers/mfd/mc13783-core.c~mc13783-rename-mc13783_unmaskack_i=
rq-to-have-a-mc13783_irq-prefix drivers/mfd/mc13783-core.c
--- a/drivers/mfd/mc13783-core.c~mc13783-rename-mc13783_unmaskack_irq-t=
o-have-a-mc13783_irq-prefix
+++ a/drivers/mfd/mc13783-core.c
@@ -225,7 +225,7 @@ int mc13783_reg_rmw(struct mc13783 *mc13
 }
 EXPORT_SYMBOL(mc13783_reg_rmw);
=20
-int mc13783_mask(struct mc13783 *mc13783, int irq)
+int mc13783_irq_mask(struct mc13783 *mc13783, int irq)
 {
 	int ret;
 	unsigned int offmask =3D irq < 24 ? MC13783_IRQMASK0 : MC13783_IRQMAS=
K1;
@@ -245,9 +245,9 @@ int mc13783_mask(struct mc13783 *mc13783
=20
 	return mc13783_reg_write(mc13783, offmask, mask | irqbit);
 }
-EXPORT_SYMBOL(mc13783_mask);
+EXPORT_SYMBOL(mc13783_irq_mask);
=20
-int mc13783_unmask(struct mc13783 *mc13783, int irq)
+int mc13783_irq_unmask(struct mc13783 *mc13783, int irq)
 {
 	int ret;
 	unsigned int offmask =3D irq < 24 ? MC13783_IRQMASK0 : MC13783_IRQMAS=
K1;
@@ -267,7 +267,18 @@ int mc13783_unmask(struct mc13783 *mc137
=20
 	return mc13783_reg_write(mc13783, offmask, mask & ~irqbit);
 }
-EXPORT_SYMBOL(mc13783_unmask);
+EXPORT_SYMBOL(mc13783_irq_unmask);
+
+int mc13783_irq_ack(struct mc13783 *mc13783, int irq)
+{
+	unsigned int offstat =3D irq < 24 ? MC13783_IRQSTAT0 : MC13783_IRQSTA=
T1;
+	unsigned int val =3D 1 << (irq < 24 ? irq : irq - 24);
+
+	BUG_ON(irq < 0 || irq >=3D MC13783_NUM_IRQ);
+
+	return mc13783_reg_write(mc13783, offstat, val);
+}
+EXPORT_SYMBOL(mc13783_irq_ack);
=20
 int mc13783_irq_request_nounmask(struct mc13783 *mc13783, int irq,
 		irq_handler_t handler, const char *name, void *dev)
@@ -297,7 +308,7 @@ int mc13783_irq_request(struct mc13783 *
 	if (ret)
 		return ret;
=20
-	ret =3D mc13783_unmask(mc13783, irq);
+	ret =3D mc13783_irq_unmask(mc13783, irq);
 	if (ret) {
 		mc13783->irqhandler[irq] =3D NULL;
 		mc13783->irqdata[irq] =3D NULL;
@@ -317,7 +328,7 @@ int mc13783_irq_free(struct mc13783 *mc1
 			mc13783->irqdata[irq] !=3D dev)
 		return -EINVAL;
=20
-	ret =3D mc13783_mask(mc13783, irq);
+	ret =3D mc13783_irq_mask(mc13783, irq);
 	if (ret)
 		return ret;
=20
@@ -333,17 +344,6 @@ static inline irqreturn_t mc13783_irqhan
 	return mc13783->irqhandler[irq](irq, mc13783->irqdata[irq]);
 }
=20
-int mc13783_ackirq(struct mc13783 *mc13783, int irq)
-{
-	unsigned int offstat =3D irq < 24 ? MC13783_IRQSTAT0 : MC13783_IRQSTA=
T1;
-	unsigned int val =3D 1 << (irq < 24 ? irq : irq - 24);
-
-	BUG_ON(irq < 0 || irq >=3D MC13783_NUM_IRQ);
-
-	return mc13783_reg_write(mc13783, offstat, val);
-}
-EXPORT_SYMBOL(mc13783_ackirq);
-
 /*
  * returns: number of handled irqs or negative error
  * locking: holds mc13783->lock
@@ -422,7 +422,7 @@ static irqreturn_t mc13783_handler_adcdo
 {
 	struct mc13783_adcdone_data *adcdone_data =3D data;
=20
-	mc13783_ackirq(adcdone_data->mc13783, irq);
+	mc13783_irq_ack(adcdone_data->mc13783, irq);
=20
 	complete_all(&adcdone_data->done);
=20
@@ -486,7 +486,7 @@ int mc13783_adc_do_conversion(struct mc1
 	dev_dbg(&mc13783->spidev->dev, "%s: request irq\n", __func__);
 	mc13783_irq_request(mc13783, MC13783_IRQ_ADCDONE,
 			mc13783_handler_adcdone, __func__, &adcdone_data);
-	mc13783_ackirq(mc13783, MC13783_IRQ_ADCDONE);
+	mc13783_irq_ack(mc13783, MC13783_IRQ_ADCDONE);
=20
 	mc13783_reg_write(mc13783, MC13783_REG_ADC_0, adc0);
 	mc13783_reg_write(mc13783, MC13783_REG_ADC_1, adc1);
diff -puN include/linux/mfd/mc13783.h~mc13783-rename-mc13783_unmaskack_=
irq-to-have-a-mc13783_irq-prefix include/linux/mfd/mc13783.h
--- a/include/linux/mfd/mc13783.h~mc13783-rename-mc13783_unmaskack_irq-=
to-have-a-mc13783_irq-prefix
+++ a/include/linux/mfd/mc13783.h
@@ -26,10 +26,28 @@ int mc13783_irq_request(struct mc13783 *
 int mc13783_irq_request_nounmask(struct mc13783 *mc13783, int irq,
 		irq_handler_t handler, const char *name, void *dev);
 int mc13783_irq_free(struct mc13783 *mc13783, int irq, void *dev);
-int mc13783_ackirq(struct mc13783 *mc13783, int irq);
=20
-int mc13783_mask(struct mc13783 *mc13783, int irq);
-int mc13783_unmask(struct mc13783 *mc13783, int irq);
+int mc13783_irq_mask(struct mc13783 *mc13783, int irq);
+int mc13783_irq_unmask(struct mc13783 *mc13783, int irq);
+int mc13783_irq_ack(struct mc13783 *mc13783, int irq);
+
+static inline int mc13783_mask(struct mc13783 *mc13783, int irq) __dep=
recated;
+static inline int mc13783_mask(struct mc13783 *mc13783, int irq)
+{
+	return mc13783_irq_mask(mc13783, irq);
+}
+
+static inline int mc13783_unmask(struct mc13783 *mc13783, int irq) __d=
eprecated;
+static inline int mc13783_unmask(struct mc13783 *mc13783, int irq)
+{
+	return mc13783_irq_unmask(mc13783, irq);
+}
+
+static inline int mc13783_ackirq(struct mc13783 *mc13783, int irq) __d=
eprecated;
+static inline int mc13783_ackirq(struct mc13783 *mc13783, int irq)
+{
+	return mc13783_irq_ack(mc13783, irq);
+}
=20
 #define MC13783_ADC0		43
 #define MC13783_ADC0_ADREFEN		(1 << 10)
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

linux-next.patch
rtc-hctosys-only-claim-the-rtc-provided-the-system-time-if-it-did.patch
hrtimer-correct-a-few-numbers-in-comments.patch
clockevents-ensure-taht-min_delta_ns-is-increased-in-error-path.patch
timer-print-function-name-for-timer-callbacks-modifying-preemption-coun=
t.patch
genirq-warn-about-irqf_sharedirqf_disabled-at-the-right-place.patch
w1-mxc_w1-move-probe-and-remove-to-the-dev-text-area.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
