From: akpm@linux-foundation.org
Subject: + fbdev-section-cleanup-in-vfb.patch added to -mm tree
Date: Mon, 05 Apr 2010 12:30:13 -0700
Message-ID: <201004051930.o35JUECg004503@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756104Ab0DETaq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Apr 2010 15:30:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: henne@nachtwindheim.de, stable@kernel.org, u.kleine-koenig@pengutronix.de


The patch titled
     fbdev: section cleanup in vfb
has been added to the -mm tree.  Its filename is
     fbdev-section-cleanup-in-vfb.patch

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
Subject: fbdev: section cleanup in vfb
=46rom: Henrik Kretzschmar <henne@nachtwindheim.de>

=46ix up the section in the vfb driver, by moving the variables vfb_def=
ault
and vfb_fix from .init.data to .devinit.data

This fixes the following warnings issued by modpost:

WARNING: drivers/video/vfb.o(.devinit.text+0xf8): Section mismatch in r=
eference from the function vfb_probe() to the variable .init.data:vfb_d=
efault
The function __devinit vfb_probe() references
a variable __initdata vfb_default.
If vfb_default is only used by vfb_probe then
annotate vfb_default with a matching annotation.

WARNING: drivers/video/vfb.o(.devinit.text+0x114): Section mismatch in =
reference from the function vfb_probe() to the variable .init.data:vfb_=
fix
The function __devinit vfb_probe() references
a variable __initdata vfb_fix.
If vfb_fix is only used by vfb_probe then
annotate vfb_fix with a matching annotation.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Acked-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: <stable@kernel.org>	[if "platform-drivers: move probe to .devinit.t=
ext in drivers/video" was merged]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/vfb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/vfb.c~fbdev-section-cleanup-in-vfb drivers/vide=
o/vfb.c
--- a/drivers/video/vfb.c~fbdev-section-cleanup-in-vfb
+++ a/drivers/video/vfb.c
@@ -78,7 +78,7 @@ static void rvfree(void *mem, unsigned l
 	vfree(mem);
 }
=20
-static struct fb_var_screeninfo vfb_default __initdata =3D {
+static struct fb_var_screeninfo vfb_default __devinitdata =3D {
 	.xres =3D		640,
 	.yres =3D		480,
 	.xres_virtual =3D	640,
@@ -100,7 +100,7 @@ static struct fb_var_screeninfo vfb_defa
       	.vmode =3D	FB_VMODE_NONINTERLACED,
 };
=20
-static struct fb_fix_screeninfo vfb_fix __initdata =3D {
+static struct fb_fix_screeninfo vfb_fix __devinitdata =3D {
 	.id =3D		"Virtual FB",
 	.type =3D		FB_TYPE_PACKED_PIXELS,
 	.visual =3D	FB_VISUAL_PSEUDOCOLOR,
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
