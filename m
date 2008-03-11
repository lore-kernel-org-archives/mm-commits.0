From: akpm@linux-foundation.org
Subject: - at73c213-remove-redundant-private_free-routine.patch removed from -mm tree
Date: Tue, 11 Mar 2008 11:42:16 -0700
Message-ID: <200803111842.m2BIgGof021438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751794AbYCKSma (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Mar 2008 14:42:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, hcegtvedt@atmel.com, perex@perex.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     at73c213: remove redundant private_free routine
has been removed from the -mm tree.  Its filename was
     at73c213-remove-redundant-private_free-routine.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
