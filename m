From: akpm@linux-foundation.org
Subject: + imxfb-correct-location-of-callbacks-in-suspend-and-resume.patch added to -mm tree
Date: Wed, 27 Jan 2010 15:48:00 -0800
Message-ID: <201001272348.o0RNm0Rn007594@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753852Ab0A0Xsp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jan 2010 18:48:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, kernel@pengutronix.de


The patch titled
     imxfb: correct location of callbacks in suspend and resume
has been added to the -mm tree.  Its filename is
     imxfb-correct-location-of-callbacks-in-suspend-and-resume.patch

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
Subject: imxfb: correct location of callbacks in suspend and resume
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

The probe function passes a pointer to a struct fb_info to
platform_set_drvdata(), so don't interpret the return value of
platform_get_drvdata() as a pointer to struct imxfb_info.

Signed-off-by: Uwe Kleine-K=F6nig  <u.kleine-koenig@pengutronix.de>
Acked-by: Sascha Hauer <kernel@pengutronix.de>
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
imxfb-correct-location-of-callbacks-in-suspend-and-resume.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
