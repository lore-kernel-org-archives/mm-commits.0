From: akpm@linux-foundation.org
Subject: + mfd-mc13783-new-function-reading-irq-mask-and-status-register.patch added to -mm tree
Date: Tue, 02 Mar 2010 15:58:10 -0800
Message-ID: <201003022358.o22NwBVW005574@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753457Ab0CBX7Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Mar 2010 18:59:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, a.zummo@towertech.it, dmitry.torokhov@gmail.com, l.fu@pengutronix.de, p_gortmaker@yahoo.com, s.hauer@pengutronix.de, sameo@linux.intel.com, valentin.longchamp@epfl.ch


The patch titled
     mfd/mc13783: new function reading irq mask and status register
has been added to the -mm tree.  Its filename is
     mfd-mc13783-new-function-reading-irq-mask-and-status-register.patc=
h

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: mfd/mc13783: new function reading irq mask and status register
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

The driver for the mc13783 rtc needs to know if the TODA irq is pending=
=2E

Instead of tracking in the rtc driver if the irq is enabled provide tha=
t
information, too.

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

 drivers/mfd/mc13783-core.c  |   35 ++++++++++++++++++++++++++++++++++
 include/linux/mfd/mc13783.h |    2 +
 2 files changed, 37 insertions(+)

diff -puN drivers/mfd/mc13783-core.c~mfd-mc13783-new-function-reading-i=
rq-mask-and-status-register drivers/mfd/mc13783-core.c
--- a/drivers/mfd/mc13783-core.c~mfd-mc13783-new-function-reading-irq-m=
ask-and-status-register
+++ a/drivers/mfd/mc13783-core.c
@@ -269,6 +269,41 @@ int mc13783_irq_unmask(struct mc13783 *m
 }
 EXPORT_SYMBOL(mc13783_irq_unmask);
=20
+int mc13783_irq_status(struct mc13783 *mc13783, int irq,
+		int *enabled, int *pending)
+{
+	int ret;
+	unsigned int offmask =3D irq < 24 ? MC13783_IRQMASK0 : MC13783_IRQMAS=
K1;
+	unsigned int offstat =3D irq < 24 ? MC13783_IRQSTAT0 : MC13783_IRQSTA=
T1;
+	u32 irqbit =3D 1 << (irq < 24 ? irq : irq - 24);
+
+	if (irq < 0 || irq >=3D MC13783_NUM_IRQ)
+		return -EINVAL;
+
+	if (enabled) {
+		u32 mask;
+
+		ret =3D mc13783_reg_read(mc13783, offmask, &mask);
+		if (ret)
+			return ret;
+
+		*enabled =3D mask & irqbit;
+	}
+
+	if (pending) {
+		u32 stat;
+
+		ret =3D mc13783_reg_read(mc13783, offstat, &stat);
+		if (ret)
+			return ret;
+
+		*pending =3D stat & irqbit;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(mc13783_irq_status);
+
 int mc13783_irq_ack(struct mc13783 *mc13783, int irq)
 {
 	unsigned int offstat =3D irq < 24 ? MC13783_IRQSTAT0 : MC13783_IRQSTA=
T1;
diff -puN include/linux/mfd/mc13783.h~mfd-mc13783-new-function-reading-=
irq-mask-and-status-register include/linux/mfd/mc13783.h
--- a/include/linux/mfd/mc13783.h~mfd-mc13783-new-function-reading-irq-=
mask-and-status-register
+++ a/include/linux/mfd/mc13783.h
@@ -29,6 +29,8 @@ int mc13783_irq_free(struct mc13783 *mc1
=20
 int mc13783_irq_mask(struct mc13783 *mc13783, int irq);
 int mc13783_irq_unmask(struct mc13783 *mc13783, int irq);
+int mc13783_irq_status(struct mc13783 *mc13783, int irq,
+		int *enabled, int *pending);
 int mc13783_irq_ack(struct mc13783 *mc13783, int irq);
=20
 static inline int mc13783_mask(struct mc13783 *mc13783, int irq) __dep=
recated;
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

origin.patch
linux-next.patch
hrtimer-correct-a-few-numbers-in-comments.patch
clockevents-ensure-taht-min_delta_ns-is-increased-in-error-path.patch
timer-print-function-name-for-timer-callbacks-modifying-preemption-coun=
t.patch
genirq-warn-about-irqf_sharedirqf_disabled-at-the-right-place.patch
rtc-pcf2123-move-pcf2123_remove-to-devexittext.patch
rtc-hctosys-only-claim-the-rtc-provided-the-system-time-if-it-did.patch
mc13783-rename-mc13783_unmaskack_irq-to-have-a-mc13783_irq-prefix.patch
input-mc13783-ts-dont-use-deprecated-mc13783-api-calls.patch
rtc-mc13783-dont-use-deprecated-mc13783-api-calls.patch
mfd-mc13783-new-function-reading-irq-mask-and-status-register.patch
rtc-mc13783-protect-rtc-unregistration-by-mc13783-lock.patch
rtc-mc13783-implement-alarm.patch
w1-mxc_w1-move-probe-and-remove-to-the-dev-text-area.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
