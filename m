From: akpm@linux-foundation.org
Subject: + platform-drivers-move-probe-to-devinittext-in-drivers-video.patch added to -mm tree
Date: Fri, 05 Feb 2010 12:14:21 -0800
Message-ID: <201002052014.o15KELWs018651@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754051Ab0BEUPM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2010 15:15:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, arnaud.patard@rtp-net.org, greg@kroah.com, jsimmons@infradead.org, lethal@linux-sh.org, ralf@linux-mips.org


The patch titled
     platform-drivers: move probe to .devinit.text in drivers/video
has been added to the -mm tree.  Its filename is
     platform-drivers-move-probe-to-devinittext-in-drivers-video.patch

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
Subject: platform-drivers: move probe to .devinit.text in drivers/video
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

A pointer to a probe callback is passed to the core via
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
Cc: Greg KH <greg@kroah.com>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Arnaud Patard <arnaud.patard@rtp-net.org>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/acornfb.c          |    2 +-
 drivers/video/arcfb.c            |    2 +-
 drivers/video/cobalt_lcdfb.c     |    2 +-
 drivers/video/efifb.c            |    2 +-
 drivers/video/epson1355fb.c      |    2 +-
 drivers/video/gbefb.c            |    2 +-
 drivers/video/hgafb.c            |    2 +-
 drivers/video/hitfb.c            |    2 +-
 drivers/video/q40fb.c            |    2 +-
 drivers/video/s3c2410fb.c        |    4 ++--
 drivers/video/sa1100fb.c         |    2 +-
 drivers/video/sgivwfb.c          |    2 +-
 drivers/video/sh_mobile_lcdcfb.c |    2 +-
 drivers/video/vesafb.c           |    2 +-
 drivers/video/vfb.c              |    2 +-
 drivers/video/vga16fb.c          |    2 +-
 drivers/video/w100fb.c           |    2 +-
 17 files changed, 18 insertions(+), 18 deletions(-)

diff -puN drivers/video/acornfb.c~platform-drivers-move-probe-to-devini=
ttext-in-drivers-video drivers/video/acornfb.c
--- a/drivers/video/acornfb.c~platform-drivers-move-probe-to-devinittex=
t-in-drivers-video
+++ a/drivers/video/acornfb.c
@@ -1221,7 +1221,7 @@ free_unused_pages(unsigned int virtual_s
 	printk("acornfb: freed %dK memory\n", mb_freed);
 }
=20
-static int __init acornfb_probe(struct platform_device *dev)
+static int __devinit acornfb_probe(struct platform_device *dev)
 {
 	unsigned long size;
 	u_int h_sync, v_sync;
diff -puN drivers/video/arcfb.c~platform-drivers-move-probe-to-devinitt=
ext-in-drivers-video drivers/video/arcfb.c
--- a/drivers/video/arcfb.c~platform-drivers-move-probe-to-devinittext-=
in-drivers-video
+++ a/drivers/video/arcfb.c
@@ -504,7 +504,7 @@ static struct fb_ops arcfb_ops =3D {
 	.fb_ioctl 	=3D arcfb_ioctl,
 };
=20
-static int __init arcfb_probe(struct platform_device *dev)
+static int __devinit arcfb_probe(struct platform_device *dev)
 {
 	struct fb_info *info;
 	int retval =3D -ENOMEM;
diff -puN drivers/video/cobalt_lcdfb.c~platform-drivers-move-probe-to-d=
evinittext-in-drivers-video drivers/video/cobalt_lcdfb.c
--- a/drivers/video/cobalt_lcdfb.c~platform-drivers-move-probe-to-devin=
ittext-in-drivers-video
+++ a/drivers/video/cobalt_lcdfb.c
@@ -287,7 +287,7 @@ static struct fb_ops cobalt_lcd_fbops =3D=20
 	.fb_cursor	=3D cobalt_lcdfb_cursor,
 };
=20
-static int __init cobalt_lcdfb_probe(struct platform_device *dev)
+static int __devinit cobalt_lcdfb_probe(struct platform_device *dev)
 {
 	struct fb_info *info;
 	struct resource *res;
diff -puN drivers/video/efifb.c~platform-drivers-move-probe-to-devinitt=
ext-in-drivers-video drivers/video/efifb.c
--- a/drivers/video/efifb.c~platform-drivers-move-probe-to-devinittext-=
in-drivers-video
+++ a/drivers/video/efifb.c
@@ -201,7 +201,7 @@ static int __init efifb_setup(char *opti
 	return 0;
 }
=20
-static int __init efifb_probe(struct platform_device *dev)
+static int __devinit efifb_probe(struct platform_device *dev)
 {
 	struct fb_info *info;
 	int err;
diff -puN drivers/video/epson1355fb.c~platform-drivers-move-probe-to-de=
vinittext-in-drivers-video drivers/video/epson1355fb.c
--- a/drivers/video/epson1355fb.c~platform-drivers-move-probe-to-devini=
ttext-in-drivers-video
+++ a/drivers/video/epson1355fb.c
@@ -602,7 +602,7 @@ static int epson1355fb_remove(struct pla
 	return 0;
 }
=20
-int __init epson1355fb_probe(struct platform_device *dev)
+int __devinit epson1355fb_probe(struct platform_device *dev)
 {
 	struct epson1355_par *default_par;
 	struct fb_info *info;
diff -puN drivers/video/gbefb.c~platform-drivers-move-probe-to-devinitt=
ext-in-drivers-video drivers/video/gbefb.c
--- a/drivers/video/gbefb.c~platform-drivers-move-probe-to-devinittext-=
in-drivers-video
+++ a/drivers/video/gbefb.c
@@ -1128,7 +1128,7 @@ static int __init gbefb_setup(char *opti
 	return 0;
 }
=20
-static int __init gbefb_probe(struct platform_device *p_dev)
+static int __devinit gbefb_probe(struct platform_device *p_dev)
 {
 	int i, ret =3D 0;
 	struct fb_info *info;
diff -puN drivers/video/hgafb.c~platform-drivers-move-probe-to-devinitt=
ext-in-drivers-video drivers/video/hgafb.c
--- a/drivers/video/hgafb.c~platform-drivers-move-probe-to-devinittext-=
in-drivers-video
+++ a/drivers/video/hgafb.c
@@ -551,7 +551,7 @@ static struct fb_ops hgafb_ops =3D {
 	 *  Initialization
 	 */
=20
-static int __init hgafb_probe(struct platform_device *pdev)
+static int __devinit hgafb_probe(struct platform_device *pdev)
 {
 	struct fb_info *info;
=20
diff -puN drivers/video/hitfb.c~platform-drivers-move-probe-to-devinitt=
ext-in-drivers-video drivers/video/hitfb.c
--- a/drivers/video/hitfb.c~platform-drivers-move-probe-to-devinittext-=
in-drivers-video
+++ a/drivers/video/hitfb.c
@@ -325,7 +325,7 @@ static struct fb_ops hitfb_ops =3D {
 	.fb_imageblit	=3D cfb_imageblit,
 };
=20
-static int __init hitfb_probe(struct platform_device *dev)
+static int __devinit hitfb_probe(struct platform_device *dev)
 {
 	unsigned short lcdclor, ldr3, ldvndr;
 	struct fb_info *info;
diff -puN drivers/video/q40fb.c~platform-drivers-move-probe-to-devinitt=
ext-in-drivers-video drivers/video/q40fb.c
--- a/drivers/video/q40fb.c~platform-drivers-move-probe-to-devinittext-=
in-drivers-video
+++ a/drivers/video/q40fb.c
@@ -85,7 +85,7 @@ static struct fb_ops q40fb_ops =3D {
 	.fb_imageblit	=3D cfb_imageblit,
 };
=20
-static int __init q40fb_probe(struct platform_device *dev)
+static int __devinit q40fb_probe(struct platform_device *dev)
 {
 	struct fb_info *info;
=20
diff -puN drivers/video/s3c2410fb.c~platform-drivers-move-probe-to-devi=
nittext-in-drivers-video drivers/video/s3c2410fb.c
--- a/drivers/video/s3c2410fb.c~platform-drivers-move-probe-to-devinitt=
ext-in-drivers-video
+++ a/drivers/video/s3c2410fb.c
@@ -1004,12 +1004,12 @@ dealloc_fb:
 	return ret;
 }
=20
-static int __init s3c2410fb_probe(struct platform_device *pdev)
+static int __devinit s3c2410fb_probe(struct platform_device *pdev)
 {
 	return s3c24xxfb_probe(pdev, DRV_S3C2410);
 }
=20
-static int __init s3c2412fb_probe(struct platform_device *pdev)
+static int __devinit s3c2412fb_probe(struct platform_device *pdev)
 {
 	return s3c24xxfb_probe(pdev, DRV_S3C2412);
 }
diff -puN drivers/video/sa1100fb.c~platform-drivers-move-probe-to-devin=
ittext-in-drivers-video drivers/video/sa1100fb.c
--- a/drivers/video/sa1100fb.c~platform-drivers-move-probe-to-devinitte=
xt-in-drivers-video
+++ a/drivers/video/sa1100fb.c
@@ -1435,7 +1435,7 @@ static struct sa1100fb_info * __init sa1
 	return fbi;
 }
=20
-static int __init sa1100fb_probe(struct platform_device *pdev)
+static int __devinit sa1100fb_probe(struct platform_device *pdev)
 {
 	struct sa1100fb_info *fbi;
 	int ret, irq;
diff -puN drivers/video/sgivwfb.c~platform-drivers-move-probe-to-devini=
ttext-in-drivers-video drivers/video/sgivwfb.c
--- a/drivers/video/sgivwfb.c~platform-drivers-move-probe-to-devinittex=
t-in-drivers-video
+++ a/drivers/video/sgivwfb.c
@@ -745,7 +745,7 @@ int __init sgivwfb_setup(char *options)
 /*
  *  Initialisation
  */
-static int __init sgivwfb_probe(struct platform_device *dev)
+static int __devinit sgivwfb_probe(struct platform_device *dev)
 {
 	struct sgivw_par *par;
 	struct fb_info *info;
diff -puN drivers/video/sh_mobile_lcdcfb.c~platform-drivers-move-probe-=
to-devinittext-in-drivers-video drivers/video/sh_mobile_lcdcfb.c
--- a/drivers/video/sh_mobile_lcdcfb.c~platform-drivers-move-probe-to-d=
evinittext-in-drivers-video
+++ a/drivers/video/sh_mobile_lcdcfb.c
@@ -907,7 +907,7 @@ static const struct dev_pm_ops sh_mobile
=20
 static int sh_mobile_lcdc_remove(struct platform_device *pdev);
=20
-static int __init sh_mobile_lcdc_probe(struct platform_device *pdev)
+static int __devinit sh_mobile_lcdc_probe(struct platform_device *pdev=
)
 {
 	struct fb_info *info;
 	struct sh_mobile_lcdc_priv *priv;
diff -puN drivers/video/vesafb.c~platform-drivers-move-probe-to-devinit=
text-in-drivers-video drivers/video/vesafb.c
--- a/drivers/video/vesafb.c~platform-drivers-move-probe-to-devinittext=
-in-drivers-video
+++ a/drivers/video/vesafb.c
@@ -226,7 +226,7 @@ static int __init vesafb_setup(char *opt
 	return 0;
 }
=20
-static int __init vesafb_probe(struct platform_device *dev)
+static int __devinit vesafb_probe(struct platform_device *dev)
 {
 	struct fb_info *info;
 	int i, err;
diff -puN drivers/video/vfb.c~platform-drivers-move-probe-to-devinittex=
t-in-drivers-video drivers/video/vfb.c
--- a/drivers/video/vfb.c~platform-drivers-move-probe-to-devinittext-in=
-drivers-video
+++ a/drivers/video/vfb.c
@@ -479,7 +479,7 @@ static int __init vfb_setup(char *option
      *  Initialisation
      */
=20
-static int __init vfb_probe(struct platform_device *dev)
+static int __devinit vfb_probe(struct platform_device *dev)
 {
 	struct fb_info *info;
 	int retval =3D -ENOMEM;
diff -puN drivers/video/vga16fb.c~platform-drivers-move-probe-to-devini=
ttext-in-drivers-video drivers/video/vga16fb.c
--- a/drivers/video/vga16fb.c~platform-drivers-move-probe-to-devinittex=
t-in-drivers-video
+++ a/drivers/video/vga16fb.c
@@ -1293,7 +1293,7 @@ static int vga16fb_setup(char *options)
 }
 #endif
=20
-static int __init vga16fb_probe(struct platform_device *dev)
+static int __devinit vga16fb_probe(struct platform_device *dev)
 {
 	struct fb_info *info;
 	struct vga16fb_par *par;
diff -puN drivers/video/w100fb.c~platform-drivers-move-probe-to-devinit=
text-in-drivers-video drivers/video/w100fb.c
--- a/drivers/video/w100fb.c~platform-drivers-move-probe-to-devinittext=
-in-drivers-video
+++ a/drivers/video/w100fb.c
@@ -628,7 +628,7 @@ static int w100fb_resume(struct platform
 #endif
=20
=20
-int __init w100fb_probe(struct platform_device *pdev)
+int __devinit w100fb_probe(struct platform_device *pdev)
 {
 	int err =3D -EIO;
 	struct w100fb_mach_info *inf;
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
