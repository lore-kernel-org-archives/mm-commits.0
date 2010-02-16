From: akpm@linux-foundation.org
Subject: [merged] net-move-am79c961s-probe-function-to-devinittext.patch removed from -mm tree
Date: Tue, 16 Feb 2010 10:35:05 -0800
Message-ID: <201002161835.o1GIZ5Fk030407@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757051Ab0BPSgz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Feb 2010 13:36:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, 12o3l@tiscali.nl, greg@kroah.com, rmk+kernel@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     net: move am79c961's probe function to .devinit.text
has been removed from the -mm tree.  Its filename was
     net-move-am79c961s-probe-function-to-devinittext.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: net: move am79c961's probe function to .devinit.text
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

A pointer to am79c961_probe is passed to the core via
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
Cc: Roel Kluin <12o3l@tiscali.nl>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/arm/am79c961a.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/arm/am79c961a.c~net-move-am79c961s-probe-function=
-to-devinittext drivers/net/arm/am79c961a.c
--- a/drivers/net/arm/am79c961a.c~net-move-am79c961s-probe-function-to-=
devinittext
+++ a/drivers/net/arm/am79c961a.c
@@ -680,7 +680,7 @@ static const struct net_device_ops am79c
 #endif
 };
=20
-static int __init am79c961_probe(struct platform_device *pdev)
+static int __devinit am79c961_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	struct net_device *dev;
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

linux-next.patch
x86-move-hp-wmis-probe-function-to-devinittext.patch
platform-drivers-move-probe-to-devinittext-in-arch-arm.patch
media-move-omap24xxcams-probe-function-to-devinittext.patch
i2c-move-i2c_omaps-probe-function-to-devinittext.patch
hrtimer-correct-a-few-numbers-in-comments.patch
clockevents-ensure-taht-min_delta_ns-is-increased-in-error-path.patch
genirq-warn-about-irqf_sharedirqf_disabled-at-the-right-place.patch
platform-drivers-move-probe-to-devinittext-in-drivers-scsi.patch
rtc-pcf2123-move-pcf2123_remove-to-devexittext.patch
rtc-hctosys-only-claim-the-rtc-provided-the-system-time-if-it-did.patch
platform-drivers-move-probe-to-devinittext-in-drivers-video.patch
auxdisplay-move-cfag12864bfbs-probe-function-to-devinittext.patch
w1-move-omap_hdqs-probe-function-to-devinittext.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
