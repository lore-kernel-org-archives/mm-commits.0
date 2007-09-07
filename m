From: akpm@linux-foundation.org
Subject: - alsa-cs5535audio-correctly-set-dma-substream.patch removed from -mm tree
Date: Thu, 06 Sep 2007 17:42:05 -0700
Message-ID: <200709070042.l870g5mp016011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42448 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964850AbXIGAm6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Sep 2007 20:42:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, dilinger@debian.org, jayakumar.alsa@gmail.com, jordan.crouse@amd.com, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     ALSA: cs5535audio: correctly set dma->substream
has been removed from the -mm tree.  Its filename was
     alsa-cs5535audio-correctly-set-dma-substream.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ALSA: cs5535audio: correctly set dma->substream
From: Andres Salomon <dilinger@queued.net>

We're never actually setting dma->substream to the current substream; that
means the dma->substream checks that we do in the suspend/resume path are
never satisfied, and the PRD registers are never correctly managed.  This
changes it so that we set the substream when constructing the specific bus
master DMA, and unsetting it when we tear down the BM's DMA.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Jordan Crouse <jordan.crouse@amd.com>
Acked-by: Jaya Kumar <jayakumar.alsa@gmail.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/cs5535audio/cs5535audio_pcm.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN sound/pci/cs5535audio/cs5535audio_pcm.c~alsa-cs5535audio-correctly-set-dma-substream sound/pci/cs5535audio/cs5535audio_pcm.c
--- a/sound/pci/cs5535audio/cs5535audio_pcm.c~alsa-cs5535audio-correctly-set-dma-substream
+++ a/sound/pci/cs5535audio/cs5535audio_pcm.c
@@ -161,6 +161,7 @@ static int cs5535audio_build_dma_packets
 	jmpprd_addr = cpu_to_le32(lastdesc->addr +
 				  (sizeof(struct cs5535audio_dma_desc)*periods));
 
+	dma->substream = substream;
 	dma->period_bytes = period_bytes;
 	dma->periods = periods;
 	spin_lock_irq(&cs5535au->reg_lock);
@@ -238,6 +239,7 @@ static void cs5535audio_clear_dma_packet
 {
 	snd_dma_free_pages(&dma->desc_buf);
 	dma->desc_buf.area = NULL;
+	dma->substream = NULL;
 }
 
 static int snd_cs5535audio_hw_params(struct snd_pcm_substream *substream,
_

Patches currently in -mm which might be from dilinger@queued.net are

geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
