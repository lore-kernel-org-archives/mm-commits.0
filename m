From: akpm@linux-foundation.org
Subject: + fbdev-section-cleanup-in-w100fb.patch added to -mm tree
Date: Mon, 05 Apr 2010 12:30:19 -0700
Message-ID: <201004051930.o35JUJeU004521@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756104Ab0DETav (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Apr 2010 15:30:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: henne@nachtwindheim.de, stable@kernel.org, u.kleine-koenig@pengutronix.de


The patch titled
     fbdev: section cleanup in w100fb
has been added to the -mm tree.  Its filename is
     fbdev-section-cleanup-in-w100fb.patch

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
Subject: fbdev: section cleanup in w100fb
=46rom: Henrik Kretzschmar <henne@nachtwindheim.de>

=46ix up the section in the w100fb driver, by moving:

*	w100fb_remove() from .text to .devexit.text

*	w100_get_xtal_table() from .text to .devinit.text

*	w100fb_init() from .devinit.text to .init.text

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Acked-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: <stable@kernel.org>	[if "platform-drivers: move probe to .devinit.t=
ext in drivers/video" was merged]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/w100fb.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/video/w100fb.c~fbdev-section-cleanup-in-w100fb driver=
s/video/w100fb.c
--- a/drivers/video/w100fb.c~fbdev-section-cleanup-in-w100fb
+++ a/drivers/video/w100fb.c
@@ -53,7 +53,7 @@ static void w100_update_enable(void);
 static void w100_update_disable(void);
 static void calc_hsync(struct w100fb_par *par);
 static void w100_init_graphic_engine(struct w100fb_par *par);
-struct w100_pll_info *w100_get_xtal_table(unsigned int freq);
+struct w100_pll_info *w100_get_xtal_table(unsigned int freq) __devinit=
;
=20
 /* Pseudo palette size */
 #define MAX_PALETTES      16
@@ -782,7 +782,7 @@ out:
 }
=20
=20
-static int w100fb_remove(struct platform_device *pdev)
+static int __devexit w100fb_remove(struct platform_device *pdev)
 {
 	struct fb_info *info =3D platform_get_drvdata(pdev);
 	struct w100fb_par *par=3Dinfo->par;
@@ -1020,7 +1020,7 @@ static struct pll_entries {
 	{ 0 },
 };
=20
-struct w100_pll_info *w100_get_xtal_table(unsigned int freq)
+struct w100_pll_info __devinit *w100_get_xtal_table(unsigned int freq)
 {
 	struct pll_entries *pll_entry =3D w100_pll_tables;
=20
@@ -1611,7 +1611,7 @@ static void w100_vsync(void)
=20
 static struct platform_driver w100fb_driver =3D {
 	.probe		=3D w100fb_probe,
-	.remove		=3D w100fb_remove,
+	.remove		=3D __devexit_p(w100fb_remove),
 	.suspend	=3D w100fb_suspend,
 	.resume		=3D w100fb_resume,
 	.driver		=3D {
@@ -1619,7 +1619,7 @@ static struct platform_driver w100fb_dri
 	},
 };
=20
-int __devinit w100fb_init(void)
+int __init w100fb_init(void)
 {
 	return platform_driver_register(&w100fb_driver);
 }
_

Patches currently in -mm which might be from henne@nachtwindheim.de are

linux-next.patch
fbdev-section-cleanup-in-arcfb.patch
fbdev-section-cleanup-in-hgafb.patch
fbdev-section-cleanup-in-vfb.patch
fbdev-section-cleanup-in-vga16fb.patch
fbdev-section-cleanup-in-w100fb.patch
auxdisplay-section-cleanup-in-cfag12864bfb-driver.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
