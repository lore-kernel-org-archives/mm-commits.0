From: akpm@linux-foundation.org
Subject: - at73c213-fix-error-checking-for-clk-api.patch removed from -mm tree
Date: Tue, 11 Mar 2008 11:42:20 -0700
Message-ID: <200803111842.m2BIgKc9021444@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751834AbYCKSme (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Mar 2008 14:42:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, avictor.za@gmail.com, hcegtvedt@atmel.com, hskinnemoen@atmel.com, perex@perex.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     at73c213: fix error checking for clk API
has been removed from the -mm tree.  Its filename was
     at73c213-fix-error-checking-for-clk-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: at73c213: fix error checking for clk API
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

The clk_round_rate() and clk_set_rate() will return int, so not store thier
return value to unsigned long variable.  This bug hides real error on these
API.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Andrew Victor <avictor.za@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/spi/at73c213.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN sound/spi/at73c213.c~at73c213-fix-error-checking-for-clk-api sound/spi/at73c213.c
--- a/sound/spi/at73c213.c~at73c213-fix-error-checking-for-clk-api
+++ a/sound/spi/at73c213.c
@@ -133,7 +133,8 @@ static struct snd_pcm_hardware snd_at73c
 static int snd_at73c213_set_bitrate(struct snd_at73c213 *chip)
 {
 	unsigned long ssc_rate = clk_get_rate(chip->ssc->clk);
-	unsigned long dac_rate_new, ssc_div, status;
+	unsigned long dac_rate_new, ssc_div;
+	int status;
 	unsigned long ssc_div_max, ssc_div_min;
 	int max_tries;
 
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

git-alsa-tiwai.patch

