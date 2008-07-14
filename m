From: akpm@linux-foundation.org
Subject: - alsa-correct-kcalloc-usage.patch removed from -mm tree
Date: Mon, 14 Jul 2008 12:35:21 -0700
Message-ID: <200807141935.m6EJZLZ4023903@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57586 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757163AbYGNTgD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 15:36:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miltonm@bga.com, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     alsa: correct kcalloc usage
has been removed from the -mm tree.  Its filename was
     alsa-correct-kcalloc-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
kcalloc-remove-runtime-division.patch

