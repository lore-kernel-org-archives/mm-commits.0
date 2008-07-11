From: akpm@linux-foundation.org
Subject: + alsa-correct-kcalloc-usage.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:37:15 -0700
Message-ID: <200807111842.m6BIguAG030690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754144AbYGKSnR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:43:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: miltonm@bga.com, tiwai@suse.de


The patch titled
     alsa: correct kcalloc usage
has been added to the -mm tree.  Its filename is
     alsa-correct-kcalloc-usage.patch

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
Subject: alsa: correct kcalloc usage
From: Milton Miller <miltonm@bga.com>

kcalloc is supposed to be called with the count as its first argument and the
element size as the second.

Both arguments are size_t so does not affect correctness.  This callsite is
during module_init and therefore not performance critical.  Another patch will
optimize the case when the count is variable but the size is fixed.

Signed-off-by: Milton Miller <miltonm@bga.com>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/nm256/nm256.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN sound/pci/nm256/nm256.c~alsa-correct-kcalloc-usage sound/pci/nm256/nm256.c
--- a/sound/pci/nm256/nm256.c~alsa-correct-kcalloc-usage
+++ a/sound/pci/nm256/nm256.c
@@ -1302,8 +1302,8 @@ snd_nm256_mixer(struct nm256 *chip)
 		.read = snd_nm256_ac97_read,
 	};
 
-	chip->ac97_regs = kcalloc(sizeof(short),
-				  ARRAY_SIZE(nm256_ac97_init_val), GFP_KERNEL);
+	chip->ac97_regs = kcalloc(ARRAY_SIZE(nm256_ac97_init_val),
+				  sizeof(short), GFP_KERNEL);
 	if (! chip->ac97_regs)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from miltonm@bga.com are

alsa-correct-kcalloc-usage.patch
pci-dynidsuse_driver_data-considered-harmful.patch
kcalloc-remove-runtime-division.patch

