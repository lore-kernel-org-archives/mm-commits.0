From: akpm@linux-foundation.org
Subject: - at73c213-monaural-support.patch removed from -mm tree
Date: Tue, 11 Mar 2008 11:42:22 -0700
Message-ID: <200803111842.m2BIgMmv021447@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751893AbYCKSmg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Mar 2008 14:42:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, avictor.za@gmail.com, hcegtvedt@atmel.com, hskinnemoen@atmel.com, perex@perex.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     at73c213: monaural support
has been removed from the -mm tree.  Its filename was
     at73c213-monaural-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: at73c213: monaural support
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Add support for monaural playback to at73c213 driver.  The sound will appear
on L-channel.  Tested on AT91SAM9260-EK.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Takashi Iwai <tiwai@suse.de>
Acked-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Tested-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Andrew Victor <avictor.za@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/spi/at73c213.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff -puN sound/spi/at73c213.c~at73c213-monaural-support sound/spi/at73c213.c
--- a/sound/spi/at73c213.c~at73c213-monaural-support
+++ a/sound/spi/at73c213.c
@@ -118,7 +118,7 @@ static struct snd_pcm_hardware snd_at73c
 	.rates		= SNDRV_PCM_RATE_CONTINUOUS,
 	.rate_min	= 8000,  /* Replaced by chip->bitrate later. */
 	.rate_max	= 50000, /* Replaced by chip->bitrate later. */
-	.channels_min	= 2,
+	.channels_min	= 1,
 	.channels_max	= 2,
 	.buffer_bytes_max = 64 * 1024 - 1,
 	.period_bytes_min = 512,
@@ -229,6 +229,14 @@ static int snd_at73c213_pcm_close(struct
 static int snd_at73c213_pcm_hw_params(struct snd_pcm_substream *substream,
 				 struct snd_pcm_hw_params *hw_params)
 {
+	struct snd_at73c213 *chip = snd_pcm_substream_chip(substream);
+	int channels = params_channels(hw_params);
+	int val;
+
+	val = ssc_readl(chip->ssc->regs, TFMR);
+	val = SSC_BFINS(TFMR_DATNB, channels - 1, val);
+	ssc_writel(chip->ssc->regs, TFMR, val);
+
 	return snd_pcm_lib_malloc_pages(substream,
 					params_buffer_bytes(hw_params));
 }
@@ -250,10 +258,12 @@ static int snd_at73c213_pcm_prepare(stru
 
 	ssc_writel(chip->ssc->regs, PDC_TPR,
 			(long)runtime->dma_addr);
-	ssc_writel(chip->ssc->regs, PDC_TCR, runtime->period_size * 2);
+	ssc_writel(chip->ssc->regs, PDC_TCR,
+			runtime->period_size * runtime->channels);
 	ssc_writel(chip->ssc->regs, PDC_TNPR,
 			(long)runtime->dma_addr + block_size);
-	ssc_writel(chip->ssc->regs, PDC_TNCR, runtime->period_size * 2);
+	ssc_writel(chip->ssc->regs, PDC_TNCR,
+			runtime->period_size * runtime->channels);
 
 	return 0;
 }
@@ -366,7 +376,8 @@ static irqreturn_t snd_at73c213_interrup
 
 		ssc_writel(chip->ssc->regs, PDC_TNPR,
 				(long)runtime->dma_addr + offset);
-		ssc_writel(chip->ssc->regs, PDC_TNCR, runtime->period_size * 2);
+		ssc_writel(chip->ssc->regs, PDC_TNCR,
+				runtime->period_size * runtime->channels);
 		retval = IRQ_HANDLED;
 	}
 
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

git-alsa-tiwai.patch

