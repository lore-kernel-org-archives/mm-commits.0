From: akpm@linux-foundation.org
Subject: - sound-oss-tridentc-fix-incorrect-test-in-trident_ac97_set.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:22:22 -0800
Message-ID: <200802070022.m170M3mJ006392@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48276 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933186AbYBGAp1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:45:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, muli@il.ibm.com, ray-lk@madrabbit.org, mm-commits@vger.kernel.org


The patch titled
     sound/oss/trident.c: fix incorrect test in trident_ac97_set()
has been removed from the -mm tree.  Its filename was
     sound-oss-tridentc-fix-incorrect-test-in-trident_ac97_set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sound/oss/trident.c: fix incorrect test in trident_ac97_set()
From: Roel Kluin <12o3l@tiscali.nl>

If count reaches zero, the loop ends, but the postfix decrement still
subtracts: testing for 'count == 0' will not work.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Reviewed-by: Ray Lee <ray-lk@madrabbit.org>
Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/oss/trident.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN sound/oss/trident.c~sound-oss-tridentc-fix-incorrect-test-in-trident_ac97_set sound/oss/trident.c
--- a/sound/oss/trident.c~sound-oss-tridentc-fix-incorrect-test-in-trident_ac97_set
+++ a/sound/oss/trident.c
@@ -2935,7 +2935,7 @@ trident_ac97_set(struct ac97_codec *code
 	do {
 		if ((inw(TRID_REG(card, address)) & busy) == 0)
 			break;
-	} while (count--);
+	} while (--count);
 
 	data |= (mask | (reg & AC97_REG_ADDR));
 
@@ -2996,7 +2996,7 @@ trident_ac97_get(struct ac97_codec *code
 		data = inl(TRID_REG(card, address));
 		if ((data & busy) == 0)
 			break;
-	} while (count--);
+	} while (--count);
 	spin_unlock_irqrestore(&card->lock, flags);
 
 	if (count == 0) {
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

origin.patch
git-alsa.patch
git-dvb.patch
git-mtd.patch
git-scsi-misc.patch
