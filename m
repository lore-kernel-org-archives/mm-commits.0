From: akpm@linux-foundation.org
Subject: + vesafb-use-platform_driver_probe-instead-of-platform_driver_register.patch added to -mm tree
Date: Wed, 31 Mar 2010 14:05:15 -0700
Message-ID: <201003312105.o2VL5F4V008469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758186Ab0CaVF5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Mar 2010 17:05:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JBeulich@novell.com, greg@kroah.com, jbeulich@novell.com, u.kleine-koenig@pengutronix.de


The patch titled
     vesafb: use platform_driver_probe() instead of  platform_driver_re=
gister()
has been added to the -mm tree.  Its filename is
     vesafb-use-platform_driver_probe-instead-of-platform_driver_regist=
er.patch

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
Subject: vesafb: use platform_driver_probe() instead of  platform_drive=
r_register()
=46rom: "Jan Beulich" <JBeulich@novell.com>

Commit c2e13037e6794bd0d9de3f9ecabf5615f15c160b ("platform-drivers: mov=
e
probe to .devinit.text in drivers/video") introduced a huge amount of
section mismatch warnings in vesafb code.  Rather than converting all o=
f
the annotations, do the obvious and revert the __init -> __devinit chan=
ge,
and use the recommended (in that patch) alternative to calling
platform_driver_register(): vesafb depends on information obtained from=
 by
kernel at boot time, cannot be a module, and no post-boot devices can e=
ver
show up.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Greg KH <greg@kroah.com>
Acked-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/vesafb.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN drivers/video/vesafb.c~vesafb-use-platform_driver_probe-inste=
ad-of-platform_driver_register drivers/video/vesafb.c
--- a/drivers/video/vesafb.c~vesafb-use-platform_driver_probe-instead-o=
f-platform_driver_register
+++ a/drivers/video/vesafb.c
@@ -225,7 +225,7 @@ static int __init vesafb_setup(char *opt
 	return 0;
 }
=20
-static int __devinit vesafb_probe(struct platform_device *dev)
+static int __init vesafb_probe(struct platform_device *dev)
 {
 	struct fb_info *info;
 	int i, err;
@@ -476,7 +476,6 @@ err:
 }
=20
 static struct platform_driver vesafb_driver =3D {
-	.probe	=3D vesafb_probe,
 	.driver	=3D {
 		.name	=3D "vesafb",
 	},
@@ -492,20 +491,21 @@ static int __init vesafb_init(void)
 	/* ignore error return of fb_get_options */
 	fb_get_options("vesafb", &option);
 	vesafb_setup(option);
-	ret =3D platform_driver_register(&vesafb_driver);
=20
+	vesafb_device =3D platform_device_alloc("vesafb", 0);
+	if (!vesafb_device)
+		return -ENOMEM;
+
+	ret =3D platform_device_add(vesafb_device);
 	if (!ret) {
-		vesafb_device =3D platform_device_alloc("vesafb", 0);
+		ret =3D platform_driver_probe(&vesafb_driver, vesafb_probe);
+		if (ret)
+			platform_device_del(vesafb_device);
+	}
=20
-		if (vesafb_device)
-			ret =3D platform_device_add(vesafb_device);
-		else
-			ret =3D -ENOMEM;
