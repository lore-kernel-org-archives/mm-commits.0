From: akpm@linux-foundation.org
Subject: [merged] platform-drivers-move-probe-to-devinittext-in-arch-arm.patch removed from -mm tree
Date: Thu, 18 Feb 2010 12:45:43 -0800
Message-ID: <201002182045.o1IKjhWQ002757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755850Ab0BRUr3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Feb 2010 15:47:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, arnaud.patard@rtp-net.org, ben-linux@fluff.org, dbaryshkov@gmail.com, eric.miao@marvell.com, greg@kroah.com, kristoffer.ericson@gmail.com, liam.girdwoo


The patch titled
     platform-drivers: move probe to .devinit.text in arch/arm
has been removed from the -mm tree.  Its filename was
     platform-drivers-move-probe-to-devinittext-in-arch-arm.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: platform-drivers: move probe to .devinit.text in arch/arm
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

A pointer to a probe callback is passed to the core via
platform_driver_register and so the function must not disappear when th=
e
=2Einit sections are discarded.  Otherwise (if also having HOTPLUG=3Dy)
unbinding and binding a device to the driver via sysfs will result in a=
n
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe functio=
n
from the struct platform_driver.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Acked-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Acked-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Acked-by: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Eric Miao <eric.miao@marvell.com>
Cc: Liam Girdwood <liam.girdwood@wolfsonmicro.com>
Cc: Paul Sokolovsky <pmiscml@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-pxa/corgi_ssp.c           |    2 +-
 arch/arm/mach-pxa/sharpsl_pm.c          |    2 +-
 arch/arm/mach-s3c2410/h1940-bluetooth.c |    2 +-
 arch/arm/mach-sa1100/jornada720_ssp.c   |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/arm/mach-pxa/corgi_ssp.c~platform-drivers-move-probe-to-=
devinittext-in-arch-arm arch/arm/mach-pxa/corgi_ssp.c
--- a/arch/arm/mach-pxa/corgi_ssp.c~platform-drivers-move-probe-to-devi=
nittext-in-arch-arm
+++ a/arch/arm/mach-pxa/corgi_ssp.c
@@ -204,7 +204,7 @@ void __init corgi_ssp_set_machinfo(struc
 	ssp_machinfo =3D machinfo;
 }
=20
-static int __init corgi_ssp_probe(struct platform_device *dev)
+static int __devinit corgi_ssp_probe(struct platform_device *dev)
 {
 	int ret;
=20
diff -puN arch/arm/mach-pxa/sharpsl_pm.c~platform-drivers-move-probe-to=
-devinittext-in-arch-arm arch/arm/mach-pxa/sharpsl_pm.c
--- a/arch/arm/mach-pxa/sharpsl_pm.c~platform-drivers-move-probe-to-dev=
inittext-in-arch-arm
+++ a/arch/arm/mach-pxa/sharpsl_pm.c
@@ -900,7 +900,7 @@ static struct platform_suspend_ops sharp
 };
 #endif
=20
-static int __init sharpsl_pm_probe(struct platform_device *pdev)
+static int __devinit sharpsl_pm_probe(struct platform_device *pdev)
 {
 	int ret;
=20
diff -puN arch/arm/mach-s3c2410/h1940-bluetooth.c~platform-drivers-move=
-probe-to-devinittext-in-arch-arm arch/arm/mach-s3c2410/h1940-bluetooth=
=2Ec
--- a/arch/arm/mach-s3c2410/h1940-bluetooth.c~platform-drivers-move-pro=
be-to-devinittext-in-arch-arm
+++ a/arch/arm/mach-s3c2410/h1940-bluetooth.c
@@ -56,7 +56,7 @@ static const struct rfkill_ops h1940bt_r
 	.set_block =3D h1940bt_set_block,
 };
=20
-static int __init h1940bt_probe(struct platform_device *pdev)
+static int __devinit h1940bt_probe(struct platform_device *pdev)
 {
 	struct rfkill *rfk;
 	int ret =3D 0;
diff -puN arch/arm/mach-sa1100/jornada720_ssp.c~platform-drivers-move-p=
robe-to-devinittext-in-arch-arm arch/arm/mach-sa1100/jornada720_ssp.c
--- a/arch/arm/mach-sa1100/jornada720_ssp.c~platform-drivers-move-probe=
-to-devinittext-in-arch-arm
+++ a/arch/arm/mach-sa1100/jornada720_ssp.c
@@ -130,7 +130,7 @@ void jornada_ssp_end(void)
 };
 EXPORT_SYMBOL(jornada_ssp_end);
=20
-static int __init jornada_ssp_probe(struct platform_device *dev)
+static int __devinit jornada_ssp_probe(struct platform_device *dev)
 {
 	int ret;
=20
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

origin.patch
linux-next.patch
hrtimer-correct-a-few-numbers-in-comments.patch
clockevents-ensure-taht-min_delta_ns-is-increased-in-error-path.patch
genirq-warn-about-irqf_sharedirqf_disabled-at-the-right-place.patch
rtc-pcf2123-move-pcf2123_remove-to-devexittext.patch
rtc-hctosys-only-claim-the-rtc-provided-the-system-time-if-it-did.patch
w1-mxc_w1-move-probe-and-remove-to-the-dev-text-area.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
