From: akpm@linux-foundation.org
Subject: - ess-maestro-1-2-2e-sound-card-use-list_for_each_entry.patch removed from -mm tree
Date: Thu, 20 Sep 2007 14:16:09 -0700
Message-ID: <200709202116.l8KLG9mN002989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32898 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752377AbXITV25 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 17:28:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     ESS Maestro 1/2/2E Sound Card: use list_for_each_entry
has been removed from the -mm tree.  Its filename was
     ess-maestro-1-2-2e-sound-card-use-list_for_each_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ESS Maestro 1/2/2E Sound Card: use list_for_each_entry
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

ESS Maestro 1/2/2E Sound Card: Use list_for_each_entry instead of
list_for_each

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/es1968.c |   28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff -puN sound/pci/es1968.c~ess-maestro-1-2-2e-sound-card-use-list_for_each_entry sound/pci/es1968.c
--- a/sound/pci/es1968.c~ess-maestro-1-2-2e-sound-card-use-list_for_each_entry
+++ a/sound/pci/es1968.c
@@ -843,10 +843,9 @@ static void snd_es1968_bob_dec(struct es
 		snd_es1968_bob_stop(chip);
 	else if (chip->bob_freq > ESM_BOB_FREQ) {
 		/* check reduction of timer frequency */
-		struct list_head *p;
 		int max_freq = ESM_BOB_FREQ;
-		list_for_each(p, &chip->substream_list) {
-			struct esschan *es = list_entry(p, struct esschan, list);
+		struct esschan *es;
+		list_for_each_entry(es, &chip->substream_list, list) {
 			if (max_freq < es->bob_freq)
 				max_freq = es->bob_freq;
 		}
@@ -1316,12 +1315,11 @@ static struct snd_pcm_hardware snd_es196
 
 static int calc_available_memory_size(struct es1968 *chip)
 {
-	struct list_head *p;
 	int max_size = 0;
-	
+	struct esm_memory *buf;
+
 	mutex_lock(&chip->memory_mutex);
-	list_for_each(p, &chip->buf_list) {
-		struct esm_memory *buf = list_entry(p, struct esm_memory, list);
+	list_for_each_entry(buf, &chip->buf_list, list) {
 		if (buf->empty && buf->buf.bytes > max_size)
 			max_size = buf->buf.bytes;
 	}
@@ -1335,12 +1333,10 @@ static int calc_available_memory_size(st
 static struct esm_memory *snd_es1968_new_memory(struct es1968 *chip, int size)
 {
 	struct esm_memory *buf;
-	struct list_head *p;
-	
+
 	size = ALIGN(size, ESM_MEM_ALIGN);
 	mutex_lock(&chip->memory_mutex);
-	list_for_each(p, &chip->buf_list) {
-		buf = list_entry(p, struct esm_memory, list);
+	list_for_each_entry(buf, &chip->buf_list, list) {
 		if (buf->empty && buf->buf.bytes >= size)
 			goto __found;
 	}
@@ -1938,10 +1934,9 @@ static irqreturn_t snd_es1968_interrupt(
 	}
 
 	if (event & ESM_SOUND_IRQ) {
-		struct list_head *p;
+		struct esschan *es;
 		spin_lock(&chip->substream_lock);
-		list_for_each(p, &chip->substream_list) {
-			struct esschan *es = list_entry(p, struct esschan, list);
+		list_for_each_entry(es, &chip->substream_list, list) {
 			if (es->running)
 				snd_es1968_update_pcm(chip, es);
 		}
@@ -2345,7 +2340,7 @@ static int es1968_resume(struct pci_dev 
 {
 	struct snd_card *card = pci_get_drvdata(pci);
 	struct es1968 *chip = card->private_data;
-	struct list_head *p;
+	struct esschan *es;
 
 	if (! chip->do_pm)
 		return 0;
@@ -2374,8 +2369,7 @@ static int es1968_resume(struct pci_dev 
 	/* restore ac97 state */
 	snd_ac97_resume(chip->ac97);
 
-	list_for_each(p, &chip->substream_list) {
-		struct esschan *es = list_entry(p, struct esschan, list);
+	list_for_each_entry(es, &chip->substream_list, list) {
 		switch (es->mode) {
 		case ESM_MODE_PLAY:
 			snd_es1968_playback_setup(chip, es, es->substream->runtime);
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

git-alsa.patch
generic-ac97-mixer-modem-oss-use-list_for_each_entry.patch
git-dvb.patch
git-mtd.patch
git-net.patch
git-sched.patch
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
