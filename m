From: akpm@linux-foundation.org
Subject: [merged] imxfb-correct-location-of-callbacks-in-suspend-and-resume.patch removed from -mm tree
Date: Wed, 03 Feb 2010 09:55:04 -0800
Message-ID: <201002031755.o13Ht4v8008948@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41957 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932761Ab0BCSAF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 13:00:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, kernel@pengutronix.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     imxfb: correct location of callbacks in suspend and resume
has been removed from the -mm tree.  Its filename was
     imxfb-correct-location-of-callbacks-in-suspend-and-resume.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: imxfb: correct location of callbacks in suspend and resume
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

The probe function passes a pointer to a struct fb_info to
platform_set_drvdata(), so don't interpret the return value of
platform_get_drvdata() as a pointer to struct imxfb_info.

The original imxfb_info *fbi backlight_power was NULL but in imxfb_susp=
end
it was 4 resulting in an oops as imxfb_suspend calls
imxfb_disable_controller(fbi) which in turn has

	if (fbi->backlight_power)
			fbi->backlight_power(0);

Signed-off-by: Uwe Kleine-K=F6nig  <u.kleine-koenig@pengutronix.de>
Acked-by: Sascha Hauer <kernel@pengutronix.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/imxfb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/video/imxfb.c~imxfb-correct-location-of-callbacks-in-=
suspend-and-resume drivers/video/imxfb.c
--- a/drivers/video/imxfb.c~imxfb-correct-location-of-callbacks-in-susp=
end-and-resume
+++ a/drivers/video/imxfb.c
@@ -593,7 +593,8 @@ static int imxfb_activate_var(struct fb_
  */
 static int imxfb_suspend(struct platform_device *dev, pm_message_t sta=
te)
 {
-	struct imxfb_info *fbi =3D platform_get_drvdata(dev);
+	struct fb_info *info =3D platform_get_drvdata(dev);
+	struct imxfb_info *fbi =3D info->par;
=20
 	pr_debug("%s\n", __func__);
=20
@@ -603,7 +604,8 @@ static int imxfb_suspend(struct platform
=20
 static int imxfb_resume(struct platform_device *dev)
 {
-	struct imxfb_info *fbi =3D platform_get_drvdata(dev);
+	struct fb_info *info =3D platform_get_drvdata(dev);
+	struct imxfb_info *fbi =3D info->par;
=20
 	pr_debug("%s\n", __func__);
=20
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

origin.patch
linux-next.patch
mtd-nand-fix-build-failure-caused-by-typo.patch
hrtimer-correct-a-few-numbers-in-comments.patch
clockevents-ensure-taht-min_delta_ns-is-increased-in-error-path.patch
genirq-warn-about-irqf_sharedirqf_disabled-at-the-right-place.patch
rtc-pcf2123-move-pcf2123_remove-to-devexittext.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
