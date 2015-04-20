From: akpm@linux-foundation.org
Subject: [merged]
 rtc-stmp3xxx-use-optional-crystal-in-low-power-states.patch removed from
 -mm tree
Date: Mon, 20 Apr 2015 12:17:32 -0700
Message-ID: <553550cc.zp3aq9QIieoDeHlz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40150 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbbDTTLL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:11:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: stmp3xxx: use optional crystal in low power states
has been removed from the -mm tree.  Its filename was
     rtc-stmp3xxx-use-optional-crystal-in-low-power-states.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Subject: rtc: stmp3xxx: use optional crystal in low power states

The rtc's status register allows to determine if a 32k crystal is
connected to keep the rtc running in low power states provided the
corresponding fuse bits were blown correctly during production.  (In ca=
se
they were not, the right frequency can be stated in the device tree.) I=
f
there is no such crystal available force the 24 MHz XTAL clock to keep
running to retain the right date and time.  Otherwise use the crystal t=
o
save some power.

It would be nice to only switch to the crystal when the XTAL clock is
about to be disabled and keep the crystal off when unneeded because XTA=
L
is always on while the chip is powered on.  But as sudden power loss is=
n't
detectable this is not save.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devicetree/bindings/rtc/stmp3xxx-rtc.txt |    5=20
 drivers/rtc/rtc-stmp3xxx.c                             |   66 ++++++++=
+-
 2 files changed, 65 insertions(+), 6 deletions(-)

diff -puN Documentation/devicetree/bindings/rtc/stmp3xxx-rtc.txt~rtc-st=
mp3xxx-use-optional-crystal-in-low-power-states Documentation/devicetre=
e/bindings/rtc/stmp3xxx-rtc.txt
--- a/Documentation/devicetree/bindings/rtc/stmp3xxx-rtc.txt~rtc-stmp3x=
xx-use-optional-crystal-in-low-power-states
+++ a/Documentation/devicetree/bindings/rtc/stmp3xxx-rtc.txt
@@ -7,6 +7,11 @@ Required properties:
   region.
 - interrupts: rtc alarm interrupt
=20
+Optional properties:
+- stmp,crystal-freq: override crystal frequency as determined from fus=
e bits.
+  Only <32000> and <32768> are possible for the hardware.  Use <0> for
+  "no crystal".
+
 Example:
=20
 rtc@80056000 {
diff -puN drivers/rtc/rtc-stmp3xxx.c~rtc-stmp3xxx-use-optional-crystal-=
in-low-power-states drivers/rtc/rtc-stmp3xxx.c
--- a/drivers/rtc/rtc-stmp3xxx.c~rtc-stmp3xxx-use-optional-crystal-in-l=
ow-power-states
+++ a/drivers/rtc/rtc-stmp3xxx.c
@@ -42,6 +42,8 @@
 #define STMP3XXX_RTC_STAT			0x10
 #define STMP3XXX_RTC_STAT_STALE_SHIFT		16
 #define STMP3XXX_RTC_STAT_RTC_PRESENT		0x80000000
+#define STMP3XXX_RTC_STAT_XTAL32000_PRESENT	0x10000000
+#define STMP3XXX_RTC_STAT_XTAL32768_PRESENT	0x08000000
=20
 #define STMP3XXX_RTC_SECONDS			0x30
=20
@@ -52,9 +54,13 @@
 #define STMP3XXX_RTC_PERSISTENT0		0x60
 #define STMP3XXX_RTC_PERSISTENT0_SET		0x64
 #define STMP3XXX_RTC_PERSISTENT0_CLR		0x68
-#define STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE_EN	0x00000002
-#define STMP3XXX_RTC_PERSISTENT0_ALARM_EN	0x00000004
-#define STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE	0x00000080
+#define STMP3XXX_RTC_PERSISTENT0_CLOCKSOURCE		(1 << 0)
+#define STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE_EN		(1 << 1)
+#define STMP3XXX_RTC_PERSISTENT0_ALARM_EN		(1 << 2)
+#define STMP3XXX_RTC_PERSISTENT0_XTAL24MHZ_PWRUP	(1 << 4)
+#define STMP3XXX_RTC_PERSISTENT0_XTAL32KHZ_PWRUP	(1 << 5)
+#define STMP3XXX_RTC_PERSISTENT0_XTAL32_FREQ		(1 << 6)
+#define STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE		(1 << 7)
=20
 #define STMP3XXX_RTC_PERSISTENT1		0x70
 /* missing bitmask in headers */
@@ -248,6 +254,9 @@ static int stmp3xxx_rtc_probe(struct pla
 {
 	struct stmp3xxx_rtc_data *rtc_data;
 	struct resource *r;
+	u32 rtc_stat;
+	u32 pers0_set, pers0_clr;
+	u32 crystalfreq =3D 0;
 	int err;
=20
 	rtc_data =3D devm_kzalloc(&pdev->dev, sizeof(*rtc_data), GFP_KERNEL);
@@ -268,8 +277,8 @@ static int stmp3xxx_rtc_probe(struct pla
=20
 	rtc_data->irq_alarm =3D platform_get_irq(pdev, 0);
=20
-	if (!(readl(STMP3XXX_RTC_STAT + rtc_data->io) &
-			STMP3XXX_RTC_STAT_RTC_PRESENT)) {
+	rtc_stat =3D readl(rtc_data->io + STMP3XXX_RTC_STAT);
+	if (!(rtc_stat & STMP3XXX_RTC_STAT_RTC_PRESENT)) {
 		dev_err(&pdev->dev, "no device onboard\n");
 		return -ENODEV;
 	}
@@ -282,9 +291,54 @@ static int stmp3xxx_rtc_probe(struct pla
 		return err;
 	}
=20
+	/*
+	 * Obviously the rtc needs a clock input to be able to run.
+	 * This clock can be provided by an external 32k crystal. If that one=
 is
+	 * missing XTAL must not be disabled in suspend which consumes a
+	 * lot of power. Normally the presence and exact frequency (supported
+	 * are 32000 Hz and 32768 Hz) is detectable from fuses, but as realit=
y
+	 * proves these fuses are not blown correctly on all machines, so the
+	 * frequency can be overridden in the device tree.
+	 */
+	if (rtc_stat & STMP3XXX_RTC_STAT_XTAL32000_PRESENT)
+		crystalfreq =3D 32000;
+	else if (rtc_stat & STMP3XXX_RTC_STAT_XTAL32768_PRESENT)
+		crystalfreq =3D 32768;
+
+	of_property_read_u32(pdev->dev.of_node, "stmp,crystal-freq",
+			     &crystalfreq);
+
+	switch (crystalfreq) {
+	case 32000:
+		/* keep 32kHz crystal running in low-power mode */
+		pers0_set =3D STMP3XXX_RTC_PERSISTENT0_XTAL32_FREQ |
+			STMP3XXX_RTC_PERSISTENT0_XTAL32KHZ_PWRUP |
+			STMP3XXX_RTC_PERSISTENT0_CLOCKSOURCE;
+		pers0_clr =3D STMP3XXX_RTC_PERSISTENT0_XTAL24MHZ_PWRUP;
+		break;
+	case 32768:
+		/* keep 32.768kHz crystal running in low-power mode */
+		pers0_set =3D STMP3XXX_RTC_PERSISTENT0_XTAL32KHZ_PWRUP |
+			STMP3XXX_RTC_PERSISTENT0_CLOCKSOURCE;
+		pers0_clr =3D STMP3XXX_RTC_PERSISTENT0_XTAL24MHZ_PWRUP |
+			STMP3XXX_RTC_PERSISTENT0_XTAL32_FREQ;
+		break;
+	default:
+		dev_warn(&pdev->dev,
+			 "invalid crystal-freq specified in device-tree. Assuming no crysta=
l\n");
+		/* fall-through */
+	case 0:
+		/* keep XTAL on in low-power mode */
+		pers0_set =3D STMP3XXX_RTC_PERSISTENT0_XTAL24MHZ_PWRUP;
+		pers0_clr =3D STMP3XXX_RTC_PERSISTENT0_XTAL32KHZ_PWRUP |
+			STMP3XXX_RTC_PERSISTENT0_CLOCKSOURCE;
+	}
+
+	writel(pers0_set, rtc_data->io + STMP3XXX_RTC_PERSISTENT0_SET);
+
 	writel(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
 			STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE_EN |
-			STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE,
+			STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE | pers0_clr,
 			rtc_data->io + STMP3XXX_RTC_PERSISTENT0_CLR);
=20
 	writel(STMP3XXX_RTC_CTRL_ONEMSEC_IRQ_EN |
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

origin.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
