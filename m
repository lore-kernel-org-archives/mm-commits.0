From: akpm@linux-foundation.org
Subject: + sound-oss-tridentc-fix-incorrect-test-in-trident_ac97_set.patch added to -mm tree
Date: Fri, 09 Nov 2007 14:00:07 -0800
Message-ID: <200711092200.lA9M07H5001428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55341 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751385AbXKIWAd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 17:00:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: 12o3l@tiscali.nl, muli@il.ibm.com, ray-lk@madrabbit.org


The patch titled
     sound/oss/trident.c: fix incorrect test in trident_ac97_set()
has been added to the -mm tree.  Its filename is
     sound-oss-tridentc-fix-incorrect-test-in-trident_ac97_set.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

unlock-when-ssp-tries-to-close-an-invalid-port.patch
git-dvb.patch
git-ia64.patch
git-mips.patch
lmc_ioctl-dont-return-with-locks-held-fix.patch
git-netdev-all.patch
git-ocfs2.patch
cris-gpio-undo-locks-before-returning.patch
mips-undo-locking-on-error-path-returns.patch
mips-undo-locking-on-error-path-returns-checkpatch-fixes.patch
cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
sound-oss-tridentc-fix-incorrect-test-in-trident_ac97_set.patch
