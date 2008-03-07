From: akpm@linux-foundation.org
Subject: + at73c213-fix-error-checking-for-clk-api.patch added to -mm tree
Date: Fri, 07 Mar 2008 12:43:36 -0800
Message-ID: <200803072043.m27KhcEa016343@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765296AbYCGUoc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 15:44:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, avictor.za@gmail.com, hcegtvedt@atmel.com, hskinnemoen@atmel.com, perex@perex.cz, tiwai@suse.de


The patch titled
     at73c213: fix error checking for clk API
has been added to the -mm tree.  Its filename is
     at73c213-fix-error-checking-for-clk-api.patch

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

at73c213-fix-error-checking-for-clk-api.patch
at73c213-monaural-support.patch

