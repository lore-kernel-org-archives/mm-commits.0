From: akpm@linux-foundation.org
Subject: - snd-aica-platform-driver-fix-section-mismatch.patch removed from -mm tree
Date: Thu, 18 Sep 2008 13:56:28 -0700
Message-ID: <200809182056.m8IKuSbP019192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754883AbYIRU4o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Sep 2008 16:56:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ukleinek@informatik.uni-freiburg.de, adrian@mcmen.demon.co.uk, lethal@linux-sh.org, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     snd-aica platform driver: fix section mismatch
has been removed from the -mm tree.  Its filename was
     snd-aica-platform-driver-fix-section-mismatch.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: snd-aica platform driver: fix section mismatch
=46rom: Uwe Kleine-K=F6nig <ukleinek@informatik.uni-freiburg.de>

Don't use __init but __devinit to define probe function.  A pointer to
snd_aica_probe is passed to the core via platform_driver_register and s=
o the
function must not disappear after the module is loaded.  Using __init
and having HOTPLUG=3Dy and SND_AICA=3Dm the following probably oopses:

	echo -n AICA > /sys/bus/platform/driver/AICA/unbind
	echo -n AICA > /sys/bus/platform/driver/AICA/bind

Strange enough add_aicamixer_controls which is only called by
snd_aica_probe was already using __devinit.

While at it move the remove function to .devexit.text section.

Signed-off-by: Uwe Kleine-K=F6nig <ukleinek@informatik.uni-freiburg.de>
Cc: Adrian McMenamin <adrian@mcmen.demon.co.uk>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/sh/aica.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN sound/sh/aica.c~snd-aica-platform-driver-fix-section-mismatch=
 sound/sh/aica.c
--- a/sound/sh/aica.c~snd-aica-platform-driver-fix-section-mismatch
+++ a/sound/sh/aica.c
@@ -590,7 +590,7 @@ static int __devinit add_aicamixer_contr
 	return 0;
 }
=20
-static int snd_aica_remove(struct platform_device *devptr)
+static int __devexit snd_aica_remove(struct platform_device *devptr)
 {
 	struct snd_card_aica *dreamcastcard;
 	dreamcastcard =3D platform_get_drvdata(devptr);
@@ -602,7 +602,7 @@ static int snd_aica_remove(struct platfo
 	return 0;
 }
=20
-static int __init snd_aica_probe(struct platform_device *devptr)
+static int __devinit snd_aica_probe(struct platform_device *devptr)
 {
 	int err;
 	struct snd_card_aica *dreamcastcard;
@@ -651,7 +651,7 @@ static int __init snd_aica_probe(struct=20
=20
 static struct platform_driver snd_aica_driver =3D {
 	.probe =3D snd_aica_probe,
-	.remove =3D snd_aica_remove,
+	.remove =3D __devexit_p(snd_aica_remove),
 	.driver =3D {
 		   .name =3D SND_AICA_DRIVER},
 };
_

Patches currently in -mm which might be from ukleinek@informatik.uni-fr=
eiburg.de are

origin.patch
linux-next.patch
gpio_free-might-sleep-arm-architecture.patch
gpio_free-might-sleep-mips-architecture.patch
gpio_free-might-sleep-blackfin-architecture.patch
gpio_free-might-sleep-generic-part.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
