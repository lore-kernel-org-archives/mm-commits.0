From: akpm@linux-foundation.org
Subject: + fbdev-section-cleanup-in-vga16fb.patch added to -mm tree
Date: Mon, 05 Apr 2010 12:30:16 -0700
Message-ID: <201004051930.o35JUG5p004516@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756104Ab0DETat (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Apr 2010 15:30:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: henne@nachtwindheim.de, stable@kernel.org, u.kleine-koenig@pengutronix.de


The patch titled
     fbdev: section cleanup in vga16fb
has been added to the -mm tree.  Its filename is
     fbdev-section-cleanup-in-vga16fb.patch

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
Subject: fbdev: section cleanup in vga16fb
=46rom: Henrik Kretzschmar <henne@nachtwindheim.de>

=46ix up the sections in the vga16fb driver, by moving:

*	the variables vga16_defined and vga16fb
	from .init.data to .devinit.data

*	vga16fb_setup() from .text to .init.text

*	vga16fb_remove() from .text. to .devexit.text

This fixes the following warnings issued by modpost:

WARNING: drivers/video/built-in.o(.devinit.text+0x1a420): Section misma=
tch in re
ference from the function vga16fb_probe() to the (unknown reference) .i=
nit.data:
(unknown)
The function __devinit vga16fb_probe() references
a (unknown reference) __initdata (unknown).
If (unknown) is only used by vga16fb_probe then
annotate (unknown) with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x1a437): Section misma=
tch in reference from the function vga16fb_probe() to the variable .ini=
t.data:vga16fb_defined
The function __devinit vga16fb_probe() references
a variable __initdata vga16fb_defined.
If vga16fb_defined is only used by vga16fb_probe then
annotate vga16fb_defined with a matching annotation.

WARNING: drivers/video/built-in.o(.devinit.text+0x1a457): Section misma=
tch in reference from the function vga16fb_probe() to the variable .ini=
t.data:vga16fb_fix
The function __devinit vga16fb_probe() references
a variable __initdata vga16fb_fix.
If vga16fb_fix is only used by vga16fb_probe then
annotate vga16fb_fix with a matching annotation.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Acked-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: <stable@kernel.org>	[if "platform-drivers: move probe to .devinit.t=
ext in drivers/video" was merged]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/vga16fb.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/video/vga16fb.c~fbdev-section-cleanup-in-vga16fb driv=
ers/video/vga16fb.c
--- a/drivers/video/vga16fb.c~fbdev-section-cleanup-in-vga16fb
+++ a/drivers/video/vga16fb.c
@@ -65,7 +65,7 @@ struct vga16fb_par {
=20
 /* -------------------------------------------------------------------=
-- */
=20
-static struct fb_var_screeninfo vga16fb_defined __initdata =3D {
+static struct fb_var_screeninfo vga16fb_defined __devinitdata =3D {
 	.xres		=3D 640,
 	.yres		=3D 480,
 	.xres_virtual	=3D 640,
@@ -85,7 +85,7 @@ static struct fb_var_screeninfo vga16fb_
 };
=20
 /* name should not depend on EGA/VGA */
-static struct fb_fix_screeninfo vga16fb_fix __initdata =3D {
+static struct fb_fix_screeninfo vga16fb_fix __devinitdata =3D {
 	.id		=3D "VGA16 VGA",
 	.smem_start	=3D VGA_FB_PHYS,
 	.smem_len	=3D VGA_FB_PHYS_LEN,
@@ -1278,7 +1278,7 @@ static struct fb_ops vga16fb_ops =3D {
 };
=20
 #ifndef MODULE
-static int vga16fb_setup(char *options)
+static int __init vga16fb_setup(char *options)
 {
 	char *this_opt;
 =09
@@ -1376,7 +1376,7 @@ static int __devinit vga16fb_probe(struc
 	return ret;
 }
=20
-static int vga16fb_remove(struct platform_device *dev)
+static int __devexit vga16fb_remove(struct platform_device *dev)
 {
 	struct fb_info *info =3D platform_get_drvdata(dev);
=20
@@ -1393,7 +1393,7 @@ static int vga16fb_remove(struct platfor
=20
 static struct platform_driver vga16fb_driver =3D {
 	.probe =3D vga16fb_probe,
-	.remove =3D vga16fb_remove,
+	.remove =3D __devexit_p(vga16fb_remove),
 	.driver =3D {
 		.name =3D "vga16fb",
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
