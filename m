From: akpm@linux-foundation.org
Subject: - alsa-fix-section-for-sa11xx-uda1341-platform-driver.patch removed from -mm tree
Date: Sat, 13 Sep 2008 00:45:35 -0700
Message-ID: <200809130745.m8D7jZTG026779@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753282AbYIMHqE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 13 Sep 2008 03:46:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ukleinek@informatik.uni-freiburg.de, b.avery@hp.com, rmk+kernel@arm.linux.org.uk, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     alsa: fix section for sa11xx-uda1341 platform driver
has been removed from the -mm tree.  Its filename was
     alsa-fix-section-for-sa11xx-uda1341-platform-driver.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: alsa: fix section for sa11xx-uda1341 platform driver
=46rom: Uwe Kleine-K=F6nig <ukleinek@informatik.uni-freiburg.de>

Don't use __init but __devinit to define probe function.  A pointer to
sa11xx_uda1341_probe is passed to the core via platform_driver_register
and so the function must not disappear after the module is loaded.  Usi=
ng
__init and having HOTPLUG=3Dy and SND_SA11XX_UDA1341=3Dm the following
probably oopses:

	echo -n sa11xx_uda1341.1 > /sys/bus/platform/driver/sa11xx_uda1341/unb=
ind
	echo -n sa11xx_uda1341.1 > /sys/bus/platform/driver/sa11xx_uda1341/bin=
d

Signed-off-by: Uwe Kleine-K=F6nig <ukleinek@informatik.uni-freiburg.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Brian Avery <b.avery@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/arm/sa11xx-uda1341.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN sound/arm/sa11xx-uda1341.c~alsa-fix-section-for-sa11xx-uda134=
1-platform-driver sound/arm/sa11xx-uda1341.c
--- a/sound/arm/sa11xx-uda1341.c~alsa-fix-section-for-sa11xx-uda1341-pl=
atform-driver
+++ a/sound/arm/sa11xx-uda1341.c
@@ -880,7 +880,7 @@ void snd_sa11xx_uda1341_free(struct snd_
 	audio_dma_free(&chip->s[SNDRV_PCM_STREAM_CAPTURE]);
 }
=20
-static int __init sa11xx_uda1341_probe(struct platform_device *devptr)
+static int __devinit sa11xx_uda1341_probe(struct platform_device *devp=
tr)
 {
 	int err;
 	struct snd_card *card;
_

Patches currently in -mm which might be from ukleinek@informatik.uni-fr=
eiburg.de are

linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
