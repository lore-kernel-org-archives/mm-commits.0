From: akpm@linux-foundation.org
Subject: [merged] i2c-move-i2c_omaps-probe-function-to-devinittext.patch removed from -mm tree
Date: Thu, 18 Feb 2010 12:45:55 -0800
Message-ID: <201002182045.o1IKjtdM002771@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755850Ab0BRUrL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Feb 2010 15:47:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, ext-kalle.jokiniemi@nokia.com, greg@kroah.com, jarkko.nikula@nokia.com, jason.marini@gmail.com, juha.yrjola@solidboot.com, paul@pwsan.com, r-woodruff2@t


The patch titled
     i2c: move i2c_omap's probe function to .devinit.text
has been removed from the -mm tree.  Its filename was
     i2c-move-i2c_omaps-probe-function-to-devinittext.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: i2c: move i2c_omap's probe function to .devinit.text
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

A pointer to omap_i2c_probe is passed to the core via
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
Cc: Kalle Jokiniemi <ext-kalle.jokiniemi@nokia.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Richard Woodruff <r-woodruff2@ti.com>
Cc: chandra shekhar <x0044955@ti.com>
Cc: Jason P Marini <jason.marini@gmail.com>
Cc: Syed Mohammed Khasim  <x0khasim@ti.com>
Cc: Jarkko Nikula <jarkko.nikula@nokia.com>
Cc: Juha Yrjola <juha.yrjola@solidboot.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-omap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/i2c/busses/i2c-omap.c~i2c-move-i2c_omaps-probe-functi=
on-to-devinittext drivers/i2c/busses/i2c-omap.c
--- a/drivers/i2c/busses/i2c-omap.c~i2c-move-i2c_omaps-probe-function-t=
o-devinittext
+++ a/drivers/i2c/busses/i2c-omap.c
@@ -849,7 +849,7 @@ static const struct i2c_algorithm omap_i
 	.functionality	=3D omap_i2c_func,
 };
=20
-static int __init
+static int __devinit
 omap_i2c_probe(struct platform_device *pdev)
 {
 	struct omap_i2c_dev	*dev;
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
