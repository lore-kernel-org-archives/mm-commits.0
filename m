From: akpm@linux-foundation.org
Subject: + at73c213-remove-redundant-private_free-routine.patch added to -mm tree
Date: Mon, 10 Mar 2008 13:55:57 -0700
Message-ID: <200803102055.m2AKtv6U005038@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751053AbYCJU4U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 16:56:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, hcegtvedt@atmel.com, perex@perex.cz, tiwai@suse.de


The patch titled
     at73c213: remove redundant private_free routine
has been added to the -mm tree.  Its filename is
     at73c213-remove-redundant-private_free-routine.patch

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
Subject: at73c213: remove redundant private_free routine
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

snd_pcm_lib_preallocate_free_for_all() is called from snd_pcm_free() just
after calling the private_free routine.  So there should be no need to call
it in driver's private_free routine.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/spi/at73c213.c |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN sound/spi/at73c213.c~at73c213-remove-redundant-private_free-routine sound/spi/at73c213.c
--- a/sound/spi/at73c213.c~at73c213-remove-redundant-private_free-routine
+++ a/sound/spi/at73c213.c
@@ -314,15 +314,6 @@ static struct snd_pcm_ops at73c213_playb
 	.pointer	= snd_at73c213_pcm_pointer,
 };
 
-static void snd_at73c213_pcm_free(struct snd_pcm *pcm)
-{
-	struct snd_at73c213 *chip = snd_pcm_chip(pcm);
-	if (chip->pcm) {
-		snd_pcm_lib_preallocate_free_for_all(chip->pcm);
-		chip->pcm = NULL;
-	}
-}
