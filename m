From: akpm@linux-foundation.org
Subject: + alsa-cs5535audio-fix-prd-register-save-restore-power-management-race.patch added to -mm tree
Date: Fri, 31 Aug 2007 12:39:05 -0700
Message-ID: <200708311939.l7VJd5Kq023333@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52560 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751941AbXHaTjt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 15:39:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, dilinger@debian.org, jayakumar.alsa@gmail.com, jordan.crouse@amd.com, perex@suse.cz, tiwai@suse.de


The patch titled
     ALSA: cs5535audio: fix PRD register save/restore power management race
has been added to the -mm tree.  Its filename is
     alsa-cs5535audio-fix-prd-register-save-restore-power-management-race.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ALSA: cs5535audio: fix PRD register save/restore power management race
From: Andres Salomon <dilinger@queued.net>

In the suspend path, we currently save the PRD registers and then disable DMA.
 This is racy; the sound hardware might update the PRD register as it finishes
processing some DMA pages between when we've saved the PRD registers and when
DMA actually gets disabled.  Furthermore, we actively check whether or not DMA
is enabled before saving PRD registers; there's no reason to do that, as the
PRD registers should not update when we twiddle the ACC_BM[x]_CMD register(s).
 Worst case, we save the PRD registers twice; even powering down the ACC
shouldn't mess with the PRD registers (according to the 5536 data sheet,
section 5.3.7.4, power-down procedure).  This patch reworks all that to first
disable DMA, and then save PRD registers.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Jordan Crouse <jordan.crouse@amd.com>
Acked-by: Jaya Kumar <jayakumar.alsa@gmail.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/cs5535audio/cs5535audio.h     |    1 -
 sound/pci/cs5535audio/cs5535audio_pcm.c |    2 --
 sound/pci/cs5535audio/cs5535audio_pm.c  |   14 +++++++-------
 3 files changed, 7 insertions(+), 10 deletions(-)

diff -puN sound/pci/cs5535audio/cs5535audio.h~alsa-cs5535audio-fix-prd-register-save-restore-power-management-race sound/pci/cs5535audio/cs5535audio.h
--- a/sound/pci/cs5535audio/cs5535audio.h~alsa-cs5535audio-fix-prd-register-save-restore-power-management-race
+++ a/sound/pci/cs5535audio/cs5535audio.h
@@ -106,7 +106,6 @@ struct cs5535audio_dma {
 	struct snd_pcm_substream *substream;
 	unsigned int buf_addr, buf_bytes;
 	unsigned int period_bytes, periods;
-	int suspended;
 	u32 saved_prd;
 };
 
diff -puN sound/pci/cs5535audio/cs5535audio_pcm.c~alsa-cs5535audio-fix-prd-register-save-restore-power-management-race sound/pci/cs5535audio/cs5535audio_pcm.c
--- a/sound/pci/cs5535audio/cs5535audio_pcm.c~alsa-cs5535audio-fix-prd-register-save-restore-power-management-race
+++ a/sound/pci/cs5535audio/cs5535audio_pcm.c
@@ -297,14 +297,12 @@ static int snd_cs5535audio_trigger(struc
 		break;
 	case SNDRV_PCM_TRIGGER_RESUME:
 		dma->ops->enable_dma(cs5535au);
-		dma->suspended = 0;
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
 		dma->ops->disable_dma(cs5535au);
 		break;
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 		dma->ops->disable_dma(cs5535au);
-		dma->suspended = 1;
 		break;
 	default:
 		snd_printk(KERN_ERR "unhandled trigger\n");
diff -puN sound/pci/cs5535audio/cs5535audio_pm.c~alsa-cs5535audio-fix-prd-register-save-restore-power-management-race sound/pci/cs5535audio/cs5535audio_pm.c
--- a/sound/pci/cs5535audio/cs5535audio_pm.c~alsa-cs5535audio-fix-prd-register-save-restore-power-management-race
+++ a/sound/pci/cs5535audio/cs5535audio_pm.c
@@ -64,13 +64,13 @@ int snd_cs5535audio_suspend(struct pci_d
 	int i;
 
 	snd_power_change_state(card, SNDRV_CTL_POWER_D3hot);
+	snd_pcm_suspend_all(cs5535au->pcm);
+	snd_ac97_suspend(cs5535au->ac97);
 	for (i = 0; i < NUM_CS5535AUDIO_DMAS; i++) {
 		struct cs5535audio_dma *dma = &cs5535au->dmas[i];
-		if (dma && dma->substream && !dma->suspended) 
+		if (dma && dma->substream)
 			dma->saved_prd = dma->ops->read_prd(cs5535au);
 	}
-	snd_pcm_suspend_all(cs5535au->pcm);
-	snd_ac97_suspend(cs5535au->ac97);
 	/* save important regs, then disable aclink in hw */
 	snd_cs5535audio_stop_hardware(cs5535au);
 
@@ -112,17 +112,17 @@ int snd_cs5535audio_resume(struct pci_de
 	if (!timeout)
 		snd_printk(KERN_ERR "Failure getting AC Link ready\n");
 
-	/* we depend on ac97 to perform the codec power up */
-	snd_ac97_resume(cs5535au->ac97);
 	/* set up rate regs, dma. actual initiation is done in trig */
 	for (i = 0; i < NUM_CS5535AUDIO_DMAS; i++) {
 		struct cs5535audio_dma *dma = &cs5535au->dmas[i];
-		if (dma && dma->substream && dma->suspended) {
+		if (dma && dma->substream) {
 			dma->substream->ops->prepare(dma->substream);
 			dma->ops->setup_prd(cs5535au, dma->saved_prd);
 		}
 	}
-		
+
+	/* we depend on ac97 to perform the codec power up */
+	snd_ac97_resume(cs5535au->ac97);
 	snd_power_change_state(card, SNDRV_CTL_POWER_D0);
 
 	return 0;
_

Patches currently in -mm which might be from dilinger@queued.net are

alsa-cs5535audio-correctly-set-dma-substream.patch
alsa-cs5535audio-fix-prd-register-save-restore-power-management-race.patch
alsa-cs5535audio-update-pci-device-handling-in-suspend-resume.patch
alsa-cs5535audio-fix-acc_bm_cmd-register-handling.patch
alsa-cs5535audio-drop-unused-bus-master-stuff.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
