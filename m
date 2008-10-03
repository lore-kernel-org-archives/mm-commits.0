From: akpm@linux-foundation.org
Subject: + fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver.patch added to -mm tree
Date: Thu, 02 Oct 2008 23:50:43 -0700
Message-ID: <200810030650.m936ohGJ015220@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753821AbYJCGwX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Oct 2008 02:52:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kristoffer.ericson@gmail.com, Kristoffer.Ericson@gmail.com, geert@linux-m68k.org, krzysztof.h1@poczta.fm, varenet@parisc-linux.org


The patch titled
     fbdev: allow more chip revisions in Epson s1d13... video driver
has been added to the -mm tree.  Its filename is
     fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: fbdev: allow more chip revisions in Epson s1d13... video drive=
r
=46rom: Kristoffer Ericson <kristoffer.ericson@gmail.com>

The Epson s1d13xxx hardware is common in many handhelds, but our driver=
 is
currently locked to a single chip revision.  This patch adds an array o=
f
known to work revisions (which can be extended).

Signed-off-by: Kristoffer Ericson <Kristoffer.Ericson@gmail.com>
Acked-by: Thibaut Var=E8ne <varenet@parisc-linux.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s1d13xxxfb.c |   23 +++++++++++++++++++----
 include/video/s1d13xxxfb.h |    3 ++-
 2 files changed, 21 insertions(+), 5 deletions(-)

diff -puN drivers/video/s1d13xxxfb.c~fbdev-allow-more-chip-revisions-in=
-epson-s1d13-video-driver drivers/video/s1d13xxxfb.c
--- a/drivers/video/s1d13xxxfb.c~fbdev-allow-more-chip-revisions-in-eps=
on-s1d13-video-driver
+++ a/drivers/video/s1d13xxxfb.c
@@ -50,6 +50,11 @@
 #define dbg(fmt, args...) do { } while (0)
 #endif
=20
+static const int __devinitconst s1d13xxxfb_revisions[] =3D {
+	S1D13506_CHIP_REV,/* Rev.4 on HP Jornada 7xx S1D13506 */
+	S1D13806_CHIP_REV /* Rev.7 on .. */
+};
+
 /*
  * Here we define the default struct fb_fix_screeninfo
  */
@@ -538,6 +543,7 @@ s1d13xxxfb_probe(struct platform_device=20
 	struct fb_info *info;
 	struct s1d13xxxfb_pdata *pdata =3D NULL;
 	int ret =3D 0;
+	int i;
 	u8 revision;
=20
 	dbg("probe called: device is %p\n", pdev);
@@ -607,10 +613,19 @@ s1d13xxxfb_probe(struct platform_device=20
 		goto bail;
 	}
=20
-	revision =3D s1d13xxxfb_readreg(default_par, S1DREG_REV_CODE);
-	if ((revision >> 2) !=3D S1D_CHIP_REV) {
-		printk(KERN_INFO PFX "chip not found: %i\n", (revision >> 2));
-		ret =3D -ENODEV;
+	revision =3D s1d13xxxfb_readreg(default_par, S1DREG_REV_CODE) >> 2;
+
+	ret =3D -ENODEV;
+
+	for (i =3D 0; i < ARRAY_SIZE(s1d13xxxfb_revisions); i++) {
+		if (revision =3D=3D s1d13xxxfb_revisions[i])
+			ret =3D 0;
+	}
+
+	if (!ret)
+		printk(KERN_INFO PFX "chip revision %i\n", (revision));
+	else {
+		printk(KERN_INFO PFX "unknown chip revision %i\n", (revision));
 		goto bail;
 	}
=20
diff -puN include/video/s1d13xxxfb.h~fbdev-allow-more-chip-revisions-in=
-epson-s1d13-video-driver include/video/s1d13xxxfb.h
--- a/include/video/s1d13xxxfb.h~fbdev-allow-more-chip-revisions-in-eps=
on-s1d13-video-driver
+++ a/include/video/s1d13xxxfb.h
@@ -14,7 +14,8 @@
 #define	S1D13XXXFB_H
=20
 #define S1D_PALETTE_SIZE		256
-#define S1D_CHIP_REV			7	/* expected chip revision number for s1d13806=
 */
+#define S1D13506_CHIP_REV		4	/* expected chip revision number for s1d1=
3506 */
+#define S1D13806_CHIP_REV		7	/* expected chip revision number for s1d1=
3806 */
 #define S1D_FBID			"S1D13806"
 #define S1D_DEVICENAME			"s1d13806fb"
=20
_

Patches currently in -mm which might be from kristoffer.ericson@gmail.c=
om are

fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
