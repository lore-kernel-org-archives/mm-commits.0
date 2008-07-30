From: akpm@linux-foundation.org
Subject: - mac80211-tx-use-dev_kfree_skb_any-for-beacon_get.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:17:55 -0700
Message-ID: <200807301917.m6UJHtU7011253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753278AbYG3T3n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:29:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, flamingice@sourmilk.net, johannes@sipsolutions.net, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     mac80211: tx, use dev_kfree_skb_any for beacon_get
has been removed from the -mm tree.  Its filename was
     mac80211-tx-use-dev_kfree_skb_any-for-beacon_get.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mac80211: tx, use dev_kfree_skb_any for beacon_get
From: Jiri Slaby <jirislaby@gmail.com>

Use dev_kfree_skb_any(); instead of dev_kfree_skb();, since
ieee80211_beacon_get function might be called from atomic.  (It's in a
fail path.)

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Wu <flamingice@sourmilk.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/mac80211/tx.c~mac80211-tx-use-dev_kfree_skb_any-for-beacon_get net/mac80211/tx.c
--- a/net/mac80211/tx.c~mac80211-tx-use-dev_kfree_skb_any-for-beacon_get
+++ a/net/mac80211/tx.c
@@ -1931,7 +1931,7 @@ struct sk_buff *ieee80211_beacon_get(str
 			       "no rate found\n",
 			       wiphy_name(local->hw.wiphy));
 		}
-		dev_kfree_skb(skb);
+		dev_kfree_skb_any(skb);
 		skb = NULL;
 		goto out;
 	}
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
ath5k-mask-out-unneeded-interrupts.patch
ath5k-unify-resets.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
char-merge-ip2main-and-ip2base.patch
char-ip2-cleanup-globals.patch
char-ip2-fix-sparse-warnings.patch
char-ip2-init-deinit-cleanup.patch
ip2-avoid-add_timer-with-pending-timer.patch
char-ds1286-eliminate-busy-waiting.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

