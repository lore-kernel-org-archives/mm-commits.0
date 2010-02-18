From: akpm@linux-foundation.org
Subject: [merged] media-move-omap24xxcams-probe-function-to-devinittext.patch removed from -mm tree
Date: Thu, 18 Feb 2010 12:45:51 -0800
Message-ID: <201002182045.o1IKjpS7002766@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755850Ab0BRUuQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Feb 2010 15:50:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, greg@kroah.com, hverkuil@xs4all.nl, mchehab@redhat.com, sakari.ailus@maxwell.research.nokia.com, soni.trilok@gmail.com, mm-commits@vger.kernel.org


The patch titled
     media: move omap24xxcam's probe function to .devinit.text
has been removed from the -mm tree.  Its filename was
     media-move-omap24xxcams-probe-function-to-devinittext.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: media: move omap24xxcam's probe function to .devinit.text
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

A pointer to omap24xxcam_probe is passed to the core via
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
Acked-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Acked-by: Trilok Soni <soni.trilok@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/omap24xxcam.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/omap24xxcam.c~media-move-omap24xxcams-pro=
be-function-to-devinittext drivers/media/video/omap24xxcam.c
--- a/drivers/media/video/omap24xxcam.c~media-move-omap24xxcams-probe-f=
unction-to-devinittext
+++ a/drivers/media/video/omap24xxcam.c
@@ -1735,7 +1735,7 @@ static struct v4l2_int_device omap24xxca
  *
  */
=20
-static int __init omap24xxcam_probe(struct platform_device *pdev)
+static int __devinit omap24xxcam_probe(struct platform_device *pdev)
 {
 	struct omap24xxcam_device *cam;
 	struct resource *mem;
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
