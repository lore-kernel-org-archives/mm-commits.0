From: akpm@linux-foundation.org
Subject: - mac80211-return-correct-error-return-from-ieee80211_wep_init.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:17:58 -0700
Message-ID: <200807301917.m6UJHwpw011256@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46285 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753210AbYG3Tca (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:32:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, flamingice@sourmilk.net, jirislaby@gmail.com, johannes@sipsolutions.net, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     mac80211: return correct error return from ieee80211_wep_init
has been removed from the -mm tree.  Its filename was
     mac80211-return-correct-error-return-from-ieee80211_wep_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mac80211: return correct error return from ieee80211_wep_init
From: Jeremy Fitzhardinge <jeremy@goop.org>

Return the proper error code rather than a hard-coded ENOMEM from
ieee80211_wep_init.  Also, print the error code on failure.

Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Wu <flamingice@sourmilk.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/main.c |    4 ++--
 net/mac80211/wep.c  |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN net/mac80211/main.c~mac80211-return-correct-error-return-from-ieee80211_wep_init net/mac80211/main.c
--- a/net/mac80211/main.c~mac80211-return-correct-error-return-from-ieee80211_wep_init
+++ a/net/mac80211/main.c
@@ -1731,8 +1731,8 @@ int ieee80211_register_hw(struct ieee802
 	result = ieee80211_wep_init(local);
 
 	if (result < 0) {
-		printk(KERN_DEBUG "%s: Failed to initialize wep\n",
-		       wiphy_name(local->hw.wiphy));
+		printk(KERN_DEBUG "%s: Failed to initialize wep: %d\n",
+		       wiphy_name(local->hw.wiphy), result);
 		goto fail_wep;
 	}
 
diff -puN net/mac80211/wep.c~mac80211-return-correct-error-return-from-ieee80211_wep_init net/mac80211/wep.c
--- a/net/mac80211/wep.c~mac80211-return-correct-error-return-from-ieee80211_wep_init
+++ a/net/mac80211/wep.c
@@ -31,13 +31,13 @@ int ieee80211_wep_init(struct ieee80211_
 	local->wep_tx_tfm = crypto_alloc_blkcipher("ecb(arc4)", 0,
 						CRYPTO_ALG_ASYNC);
 	if (IS_ERR(local->wep_tx_tfm))
-		return -ENOMEM;
+		return PTR_ERR(local->wep_tx_tfm);
 
 	local->wep_rx_tfm = crypto_alloc_blkcipher("ecb(arc4)", 0,
 						CRYPTO_ALG_ASYNC);
 	if (IS_ERR(local->wep_rx_tfm)) {
 		crypto_free_blkcipher(local->wep_tx_tfm);
-		return -ENOMEM;
+		return PTR_ERR(local->wep_rx_tfm);
 	}
 
 	return 0;
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
linux-next.patch

