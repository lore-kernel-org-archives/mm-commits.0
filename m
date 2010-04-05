From: akpm@linux-foundation.org
Subject: + fbdev-section-cleanup-in-hgafb.patch added to -mm tree
Date: Mon, 05 Apr 2010 12:30:11 -0700
Message-ID: <201004051930.o35JUB8T004496@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756104Ab0DETap (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Apr 2010 15:30:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: henne@nachtwindheim.de, stable@kernel.org, u.kleine-koenig@pengutronix.de


The patch titled
     fbdev: section cleanup in hgafb
has been added to the -mm tree.  Its filename is
     fbdev-section-cleanup-in-hgafb.patch

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
Subject: fbdev: section cleanup in hgafb
=46rom: Henrik Kretzschmar <henne@nachtwindheim.de>

=46ix up the sections in the hgafb driver, by

* moving hga_default_var and hga_fix from .init.data to .devinit.data

* moving hga_detect() from .init.text to .devinit.text

* moving hga_fb_remove() from .text to .devexit.text

This fixes the following warnings issued by modpost:

WARNING: drivers/video/hgafb.o(.devinit.text+0x18): Section mismatch in=
 referenc
e from the function hgafb_probe() to the function .init.text:hga_card_d=
etect()
The function __devinit hgafb_probe() references
a function __init hga_card_detect().
If hga_card_detect is only used by hgafb_probe then
annotate hga_card_detect with a matching annotation.

WARNING: drivers/video/hgafb.o(.devinit.text+0xfe): Section mismatch in=
 referenc
e from the function hgafb_probe() to the variable .init.data:hga_fix
The function __devinit hgafb_probe() references
a variable __initdata hga_fix.
If hga_fix is only used by hgafb_probe then
annotate hga_fix with a matching annotation.

WARNING: drivers/video/hgafb.o(.devinit.text+0x105): Section mismatch i=
n reference from the function hgafb_probe() to the variable .init.data:=
hga_default_var
The function __devinit hgafb_probe() references
a variable __initdata hga_default_var.
If hga_default_var is only used by hgafb_probe then
annotate hga_default_var with a matching annotation.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Acked-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: <stable@kernel.org>	[if "platform-drivers: move probe to .devinit.t=
ext in drivers/video" was merged]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/hgafb.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/video/hgafb.c~fbdev-section-cleanup-in-hgafb drivers/=
video/hgafb.c
--- a/drivers/video/hgafb.c~fbdev-section-cleanup-in-hgafb
+++ a/drivers/video/hgafb.c
@@ -106,7 +106,7 @@ static DEFINE_SPINLOCK(hga_reg_lock);
=20
 /* Framebuffer driver structures */
=20
-static struct fb_var_screeninfo __initdata hga_default_var =3D {
+static struct fb_var_screeninfo hga_default_var __devinitdata =3D {
 	.xres		=3D 720,
 	.yres 		=3D 348,
 	.xres_virtual 	=3D 720,
@@ -120,7 +120,7 @@ static struct fb_var_screeninfo __initda
 	.width 		=3D -1,
 };
=20
-static struct fb_fix_screeninfo __initdata hga_fix =3D {
+static struct fb_fix_screeninfo hga_fix __devinitdata =3D {
 	.id 		=3D "HGA",
 	.type 		=3D FB_TYPE_PACKED_PIXELS,	/* (not sure) */
 	.visual 	=3D FB_VISUAL_MONO10,
@@ -276,7 +276,7 @@ static void hga_blank(int blank_mode)
 	spin_unlock_irqrestore(&hga_reg_lock, flags);
 }
=20
-static int __init hga_card_detect(void)
+static int __devinit hga_card_detect(void)
 {
 	int count =3D 0;
 	void __iomem *p, *q;
@@ -596,7 +596,7 @@ static int __devinit hgafb_probe(struct=20
 	return 0;
 }
=20
-static int hgafb_remove(struct platform_device *pdev)
+static int __devexit hgafb_remove(struct platform_device *pdev)
 {
 	struct fb_info *info =3D platform_get_drvdata(pdev);
=20
@@ -621,7 +621,7 @@ static int hgafb_remove(struct platform_
=20
 static struct platform_driver hgafb_driver =3D {
 	.probe =3D hgafb_probe,
-	.remove =3D hgafb_remove,
+	.remove =3D __devexit_p(hgafb_remove),
 	.driver =3D {
 		.name =3D "hgafb",
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
