From: akpm@linux-foundation.org
Subject: + at73c213-fix-dma-size-at-the-end-of-dma-buffer.patch added to -mm tree
Date: Mon, 10 Mar 2008 22:48:20 -0700
Message-ID: <200803110548.m2B5mK8I024953@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753224AbYCKFtL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Mar 2008 01:49:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, avictor.za@gmail.com, hcegtvedt@atmel.com, hskinnemoen@atmel.com, perex@perex.cz, tiwai@suse.de


The patch titled
     at73c213: fix DMA size at the end of DMA buffer
has been added to the -mm tree.  Its filename is
     at73c213-fix-dma-size-at-the-end-of-dma-buffer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

at73c213-remove-redundant-private_free-routine.patch
at73c213-fix-error-checking-for-clk-api.patch
at73c213-monaural-support.patch
at73c213-fix-dma-size-at-the-end-of-dma-buffer.patch

