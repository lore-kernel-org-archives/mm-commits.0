From: akpm@linux-foundation.org
Subject: + auxdisplay-move-cfag12864bfbs-probe-function-to-devinittext.patch added to -mm tree
Date: Fri, 05 Feb 2010 12:14:35 -0800
Message-ID: <201002052014.o15KEaJ4018666@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34034 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753561Ab0BEUOr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2010 15:14:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, avuton@gmail.com, greg@kroah.com, miguel.ojeda.sandonis@gmail.com


The patch titled
     auxdisplay: move cfag12864bfb's probe function to .devinit.text
has been added to the -mm tree.  Its filename is
     auxdisplay-move-cfag12864bfbs-probe-function-to-devinittext.patch

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
Subject: auxdisplay: move cfag12864bfb's probe function to .devinit.tex=
t
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

A pointer to cfag12864bfb_probe is passed to the core via
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
Acked-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Avuton Olrich <avuton@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/auxdisplay/cfag12864bfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/auxdisplay/cfag12864bfb.c~auxdisplay-move-cfag12864bf=
bs-probe-function-to-devinittext drivers/auxdisplay/cfag12864bfb.c
--- a/drivers/auxdisplay/cfag12864bfb.c~auxdisplay-move-cfag12864bfbs-p=
robe-function-to-devinittext
+++ a/drivers/auxdisplay/cfag12864bfb.c
@@ -81,7 +81,7 @@ static struct fb_ops cfag12864bfb_ops =3D=20
 	.fb_mmap =3D cfag12864bfb_mmap,
 };
=20
-static int __init cfag12864bfb_probe(struct platform_device *device)
+static int __devinit cfag12864bfb_probe(struct platform_device *device=
)
 {
 	int ret =3D -EINVAL;
  	struct fb_info *info =3D framebuffer_alloc(0, &device->dev);
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
