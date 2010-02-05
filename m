From: akpm@linux-foundation.org
Subject: + w1-move-omap_hdqs-probe-function-to-devinittext.patch added to -mm tree
Date: Fri, 05 Feb 2010 12:14:29 -0800
Message-ID: <201002052014.o15KEU3B018660@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754051Ab0BEURh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2010 15:17:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, felipe.balbi@nokia.com, greg@kroah.com, madhu.cr@ti.com, stanley.miao@windriver.com, zbr@ioremap.net


The patch titled
     w1: move omap_hdq's probe function to .devinit.text
has been added to the -mm tree.  Its filename is
     w1-move-omap_hdqs-probe-function-to-devinittext.patch

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
Subject: w1: move omap_hdq's probe function to .devinit.text
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

A pointer to omap_hdq_probe is passed to the core via
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
Cc: Stanley.Miao <stanley.miao@windriver.com>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Madhusudhan Chikkature <madhu.cr@ti.com>
Cc: Felipe Balbi <felipe.balbi@nokia.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/omap_hdq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/w1/masters/omap_hdq.c~w1-move-omap_hdqs-probe-functio=
n-to-devinittext drivers/w1/masters/omap_hdq.c
--- a/drivers/w1/masters/omap_hdq.c~w1-move-omap_hdqs-probe-function-to=
-devinittext
+++ a/drivers/w1/masters/omap_hdq.c
@@ -72,7 +72,7 @@ struct hdq_data {
 	int			init_trans;
 };
=20
-static int __init omap_hdq_probe(struct platform_device *pdev);
+static int __devinit omap_hdq_probe(struct platform_device *pdev);
 static int omap_hdq_remove(struct platform_device *pdev);
=20
 static struct platform_driver omap_hdq_driver =3D {
@@ -558,7 +558,7 @@ static void omap_w1_write_byte(void *_hd
 	return;
 }
=20
-static int __init omap_hdq_probe(struct platform_device *pdev)
+static int __devinit omap_hdq_probe(struct platform_device *pdev)
 {
 	struct hdq_data *hdq_data;
 	struct resource *res;
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

origin.patch
linux-next.patch
mtd-nand-fix-build-failure-caused-by-typo.patch
mx1-mx2-einval-overwritten-in-second-iteration-in-mxc_gpio_setup_multip=
le_pins.patch
hrtimer-correct-a-few-numbers-in-comments.patch
clockevents-ensure-taht-min_delta_ns-is-increased-in-error-path.patch
genirq-warn-about-irqf_sharedirqf_disabled-at-the-right-place.patch
rtc-pcf2123-move-pcf2123_remove-to-devexittext.patch
platform-drivers-move-probe-to-devinittext-in-arch-arm.patch
platform-drivers-move-probe-to-devinittext-in-drivers-scsi.patch
platform-drivers-move-probe-to-devinittext-in-drivers-video.patch
x86-move-hp-wmis-probe-function-to-devinittext.patch
i2c-move-i2c_omaps-probe-function-to-devinittext.patch
w1-move-omap_hdqs-probe-function-to-devinittext.patch
media-move-omap24xxcams-probe-function-to-devinittext.patch
auxdisplay-move-cfag12864bfbs-probe-function-to-devinittext.patch
net-move-am79c961s-probe-function-to-devinittext.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
