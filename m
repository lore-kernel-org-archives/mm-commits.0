From: akpm@linux-foundation.org
Subject: + generic-ac97-mixer-modem-oss-use-list_for_each_entry.patch added to -mm tree
Date: Fri, 14 Sep 2007 04:27:50 -0700
Message-ID: <200709141127.l8EBRoFv002510@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35553 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753955AbXINL2d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 07:28:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: matthias.kaehlcke@gmail.com, perex@suse.cz, tiwai@suse.de


The patch titled
     Generic AC97 mixer/modem (OSS): use list_for_each_entry
has been added to the -mm tree.  Its filename is
     generic-ac97-mixer-modem-oss-use-list_for_each_entry.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

generic-ac97-mixer-modem-oss-use-list_for_each_entry.patch
ess-maestro-1-2-2e-sound-card-use-list_for_each_entry.patch
routines-for-effect-processor-fx8010-use-list_for_each_entry.patch
git-dvb.patch
git-mtd.patch
git-netdev-all.patch
use-mutex-instead-of-semaphore-in-the-onstream-scsi-tape-driver.patch
use-mutex-instead-of-semaphore-in-isdn-subsystem-common-functions.patch
fs-file_tablec-use-list_for_each_entry-instead-of-list_for_each.patch
fs-eventpollc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
fs-locksc-use-list_for_each_entry-instead-of-list_for_each.patch
kernel-exitc-use-list_for_each_entry_safe-instead-of-list_for_each_safe.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
mm-oom_killc-use-list_for_each_entry-instead-of-list_for_each.patch
kernel-userc-use-list_for_each_entry-instead-of-list_for_each.patch
