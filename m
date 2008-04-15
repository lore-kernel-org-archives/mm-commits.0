From: akpm@linux-foundation.org
Subject: - es1968-fix-jitter-on-some-maestro-cards.patch removed from -mm tree
Date: Tue, 15 Apr 2008 02:10:24 -0700
Message-ID: <200804150910.m3F9AOgQ020621@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756514AbYDOJLP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 05:11:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreas@stapelspeicher.org, perex@suse.cz, rene.herman@keyaccess.nl, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     es1968: fix jitter on some maestro cards
has been removed from the -mm tree.  Its filename was
     es1968-fix-jitter-on-some-maestro-cards.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: es1968: fix jitter on some maestro cards
From: Andreas Mueller <andreas@stapelspeicher.org>

This patch suppresses jitter on several Maestro cards in stereo mode (ALSA of
course).

The patch is also incorporated in the *BSD drivers where I "ported" it from. 

Without this patch most of the stereo audio gets out of sync and really
distorted (oss-emulation with mplayer at 48000khz worked somehow).

Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/es1968.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff -puN sound/pci/es1968.c~es1968-fix-jitter-on-some-maestro-cards sound/pci/es1968.c
--- a/sound/pci/es1968.c~es1968-fix-jitter-on-some-maestro-cards
+++ a/sound/pci/es1968.c
@@ -1827,6 +1827,23 @@ snd_es1968_pcm(struct es1968 *chip, int 
 
 	return 0;
 }
+/*
+ * suppress jitter on some maestros when playing stereo
+ */
+static void snd_es1968_suppress_jitter(struct es1968 *chip, struct esschan *es)
+{
+	unsigned int cp1;
+	unsigned int cp2;
+	unsigned int diff;
+
+	cp1 = __apu_get_register(chip, 0, 5);
+	cp2 = __apu_get_register(chip, 1, 5);
+	diff = (cp1 > cp2 ? cp1 - cp2 : cp2 - cp1);
+
+	if (diff > 1) {
+		__maestro_write(chip, IDR0_DATA_PORT, cp1);
+	}
+}
 
 /*
  * update pointer
@@ -1948,8 +1965,11 @@ static irqreturn_t snd_es1968_interrupt(
 		struct esschan *es;
 		spin_lock(&chip->substream_lock);
 		list_for_each_entry(es, &chip->substream_list, list) {
-			if (es->running)
+			if (es->running) {
 				snd_es1968_update_pcm(chip, es);
+				if (es->fmt & ESS_FMT_STEREO)
+					snd_es1968_suppress_jitter(chip, es);
+			}
 		}
 		spin_unlock(&chip->substream_lock);
 		if (chip->in_measurement) {
_

Patches currently in -mm which might be from andreas@stapelspeicher.org are

git-alsa-tiwai.patch

