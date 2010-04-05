From: akpm@linux-foundation.org
Subject: + fbdev-section-cleanup-in-arcfb.patch added to -mm tree
Date: Mon, 05 Apr 2010 12:30:08 -0700
Message-ID: <201004051930.o35JU8mJ004492@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756104Ab0DETak (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Apr 2010 15:30:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: henne@nachtwindheim.de, stable@kernel.org, u.kleine-koenig@pengutronix.de


The patch titled
     fbdev: section cleanup in arcfb
has been added to the -mm tree.  Its filename is
     fbdev-section-cleanup-in-arcfb.patch

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
Subject: fbdev: section cleanup in arcfb
=46rom: Henrik Kretzschmar <henne@nachtwindheim.de>

=46ix the sections in the arcfb driver, by moving:

*	the variables arcfb_fix and arcfb_var from .init.data to .devinit.dat=
a

*	arcfb_remove() from .text to .devexit.text

This fixes the following warnings issued by modpost:

WARNING: drivers/video/built-in.o(.devinit.text+0x543): Section mismatc=
h in reference from the function arcfb_probe() to the variable .init.da=
ta:arcfb_var
The function __devinit arcfb_probe() references
a variable __initdata arcfb_var.
If arcfb_var is only used by arcfb_probe then
annotate arcfb_var with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x558): Section mismatc=
h in reference from the function arcfb_probe() to the variable .init.da=
ta:arcfb_fix
The function __devinit arcfb_probe() references
a variable __initdata arcfb_fix.
If arcfb_fix is only used by arcfb_probe then
annotate arcfb_fix with a matching annotation.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Acked-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: <stable@kernel.org>	[if "platform-drivers: move probe to .devinit.t=
ext in drivers/video" was merged]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/arcfb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/video/arcfb.c~fbdev-section-cleanup-in-arcfb drivers/=
video/arcfb.c
--- a/drivers/video/arcfb.c~fbdev-section-cleanup-in-arcfb
+++ a/drivers/video/arcfb.c
@@ -80,7 +80,7 @@ struct arcfb_par {
 	spinlock_t lock;
 };
=20
-static struct fb_fix_screeninfo arcfb_fix __initdata =3D {
+static struct fb_fix_screeninfo arcfb_fix __devinitdata =3D {
 	.id =3D		"arcfb",
 	.type =3D		FB_TYPE_PACKED_PIXELS,
 	.visual =3D	FB_VISUAL_MONO01,
@@ -90,7 +90,7 @@ static struct fb_fix_screeninfo arcfb_fi
 	.accel =3D	FB_ACCEL_NONE,
 };
=20
-static struct fb_var_screeninfo arcfb_var __initdata =3D {
+static struct fb_var_screeninfo arcfb_var __devinitdata =3D {
 	.xres		=3D 128,
 	.yres		=3D 64,
 	.xres_virtual	=3D 128,
@@ -588,7 +588,7 @@ err:
 	return retval;
 }
=20
-static int arcfb_remove(struct platform_device *dev)
+static int __devexit arcfb_remove(struct platform_device *dev)
 {
 	struct fb_info *info =3D platform_get_drvdata(dev);
=20
@@ -602,7 +602,7 @@ static int arcfb_remove(struct platform_
=20
 static struct platform_driver arcfb_driver =3D {
 	.probe	=3D arcfb_probe,
-	.remove =3D arcfb_remove,
+	.remove =3D __devexit_p(arcfb_remove),
 	.driver	=3D {
 		.name	=3D "arcfb",
 	},
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
