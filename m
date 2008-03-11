From: akpm@linux-foundation.org
Subject: - at73c213-fix-dma-size-at-the-end-of-dma-buffer.patch removed from -mm tree
Date: Tue, 11 Mar 2008 11:42:24 -0700
Message-ID: <200803111842.m2BIgOQX021450@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752082AbYCKSmu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Mar 2008 14:42:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, avictor.za@gmail.com, hcegtvedt@atmel.com, hskinnemoen@atmel.com, perex@perex.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     at73c213: fix DMA size at the end of DMA buffer
has been removed from the -mm tree.  Its filename was
     at73c213-fix-dma-size-at-the-end-of-dma-buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: at73c213: fix DMA size at the end of DMA buffer
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

The interrupt handler always provide runtime->period_size data, but it should
provide additional residual data when the pointer back to zero.

This patch fixes periodic click noise when runtime->buffer_size was not
multiple of runtime->period_size.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Andrew Victor <avictor.za@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/spi/at73c213.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN sound/spi/at73c213.c~at73c213-fix-dma-size-at-the-end-of-dma-buffer sound/spi/at73c213.c
--- a/sound/spi/at73c213.c~at73c213-fix-dma-size-at-the-end-of-dma-buffer
+++ a/sound/spi/at73c213.c
@@ -356,6 +356,7 @@ static irqreturn_t snd_at73c213_interrup
 	u32 status;
 	int offset;
 	int block_size;
+	int size;
 	int next_period;
 	int retval = IRQ_NONE;
 
@@ -373,11 +374,14 @@ static irqreturn_t snd_at73c213_interrup
 			next_period = 0;
 
 		offset = block_size * next_period;
+		size = runtime->period_size * runtime->channels;
+		if (next_period == runtime->periods - 1)
+			size += (runtime->buffer_size % runtime->period_size)
+				* runtime->channels;
 
 		ssc_writel(chip->ssc->regs, PDC_TNPR,
 				(long)runtime->dma_addr + offset);
-		ssc_writel(chip->ssc->regs, PDC_TNCR,
-				runtime->period_size * runtime->channels);
+		ssc_writel(chip->ssc->regs, PDC_TNCR, size);
 		retval = IRQ_HANDLED;
 	}
 
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

git-alsa-tiwai.patch

