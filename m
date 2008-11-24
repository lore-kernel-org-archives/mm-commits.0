From: akpm@linux-foundation.org
Subject: - drivers-net-wireless-ath9k-rcc-use-array_size.patch removed from -mm tree
Date: Mon, 24 Nov 2008 11:29:44 -0800
Message-ID: <200811241929.mAOJTiq7027840@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752092AbYKXTbS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Nov 2008 14:31:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, Sujith.Manoharan@atheros.com, johannes@sipsolutions.net, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     drivers/net/wireless/ath9k/rc.c: use ARRAY_SIZE
has been removed from the -mm tree.  Its filename was
     drivers-net-wireless-ath9k-rcc-use-array_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/wireless/ath9k/rc.c: use ARRAY_SIZE
From: Julia Lawall <julia@diku.dk>

ARRAY_SIZE is more concise to use when the size of an array is divided by
the size of its type or the size of its first element.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@i@
@@

#include <linux/kernel.h>

@depends on i using "paren.iso"@
type T;
T[] E;
@@

- (sizeof(E)/sizeof(E[...]))
+ ARRAY_SIZE(E)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Sujith <Sujith.Manoharan@atheros.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ath9k/rc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/net/wireless/ath9k/rc.c~drivers-net-wireless-ath9k-rcc-use-array_size drivers/net/wireless/ath9k/rc.c
--- a/drivers/net/wireless/ath9k/rc.c~drivers-net-wireless-ath9k-rcc-use-array_size
+++ a/drivers/net/wireless/ath9k/rc.c
@@ -1272,8 +1272,7 @@ static void ath_rc_update_ht(struct ath_
 				rate_ctrl->state[tx_rate].per = 100;
 		} else {
 			/* xretries == 2 */
-			count = sizeof(nretry_to_per_lookup) /
-				sizeof(nretry_to_per_lookup[0]);
+			count = ARRAY_SIZE(nretry_to_per_lookup);
 			if (retries >= count)
 				retries = count - 1;
 			/* new_PER = 7/8*old_PER + 1/8*(currentPER) */
@@ -1291,8 +1290,7 @@ static void ath_rc_update_ht(struct ath_
 	} else {	/* xretries == 0 */
 		/* Update the PER. */
 		/* Make sure it doesn't index out of array's bounds. */
-		count = sizeof(nretry_to_per_lookup) /
-			sizeof(nretry_to_per_lookup[0]);
+		count = ARRAY_SIZE(nretry_to_per_lookup);
 		if (retries >= count)
 			retries = count - 1;
 		if (info_priv->n_bad_frames) {
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
drivers-mtd-maps-nettelc-use-array_size.patch
net-tipc-bcasth-use-array_size.patch
drivers-isdn-misdn-use-array_size.patch
drivers-message-fusion-use-array_size.patch
fs-namespacec-drop-code-after-return.patch

