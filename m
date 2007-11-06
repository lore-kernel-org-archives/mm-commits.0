From: akpm@linux-foundation.org
Subject: - generic-ac97-mixer-modem-oss-use-list_for_each_entry.patch removed from -mm tree
Date: Tue, 06 Nov 2007 02:12:55 -0800
Message-ID: <200711061012.lA6ACtwS018065@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41907 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750951AbXKFKNi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 05:13:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     Generic AC97 mixer/modem (OSS): use list_for_each_entry
has been removed from the -mm tree.  Its filename was
     generic-ac97-mixer-modem-oss-use-list_for_each_entry.patch

This patch was dropped because it conflicts with scheduled-oss-driver-removal.patc

------------------------------------------------------
Subject: Generic AC97 mixer/modem (OSS): use list_for_each_entry
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

Generic AC97 mixer/modem (OSS): Use list_for_each_entry instead of
list_for_each

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/oss/ac97_codec.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN sound/oss/ac97_codec.c~generic-ac97-mixer-modem-oss-use-list_for_each_entry sound/oss/ac97_codec.c
--- a/sound/oss/ac97_codec.c~generic-ac97-mixer-modem-oss-use-list_for_each_entry
+++ a/sound/oss/ac97_codec.c
@@ -815,7 +815,6 @@ int ac97_probe_codec(struct ac97_codec *
 	int i;
 	char cidbuf[CODEC_ID_BUFSZ];
 	u16 f;
-	struct list_head *l;
 	struct ac97_driver *d;
 	
 	/* wait for codec-ready state */
@@ -891,8 +890,7 @@ int ac97_probe_codec(struct ac97_codec *
 	mutex_lock(&codec_mutex);
 	list_add(&codec->list, &codecs);
 
-	list_for_each(l, &codec_drivers) {
-		d = list_entry(l, struct ac97_driver, list);
+	list_for_each_entry(d, &codec_drivers, list) {
 		if ((codec->model ^ d->codec_id) & d->codec_mask)
 			continue;
 		if(d->probe(codec, d) == 0)
@@ -1400,14 +1398,12 @@ EXPORT_SYMBOL(ac97_set_adc_rate);
 
 static int swap_headphone(int remove_master)
 {
-	struct list_head *l;
 	struct ac97_codec *c;
 	
 	if (remove_master) {
 		mutex_lock(&codec_mutex);
-		list_for_each(l, &codecs)
+		list_for_each_entry(c, &codecs, list)
 		{
-			c = list_entry(l, struct ac97_codec, list);
 			if (supported_mixer(c, SOUND_MIXER_PHONEOUT))
 				c->supported_mixers &= ~SOUND_MASK_PHONEOUT;
 		}
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
generic-ac97-mixer-modem-oss-use-list_for_each_entry.patch
git-hwmon.patch
megaraid-sas-convert-aen_mutex-to-the-mutex-api.patch
prism54-convert-mgmt_sem-to-the-mutex-api.patch
parallel-port-convert-port_mutex-to-the-mutex-api.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
mbcs-convert-algolock-to-mutex.patch
mbcs-convert-dmawritelock-to-mutex.patch
mbcs-convert-dmareadlock-to-mutex.patch
