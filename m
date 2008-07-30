From: akpm@linux-foundation.org
Subject: - ath5k-fix-beacon-update-deadlock.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:17:52 -0700
Message-ID: <200807301917.m6UJHqQL011250@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55011 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753153AbYG3TUG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:20:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, johannes@sipsolutions.net, linville@tuxdriver.com, mcgrof@gmail.com, me@bobcopeland.com, mickflemm@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ath5k: fix beacon-update deadlock
has been removed from the -mm tree.  Its filename was
     ath5k-fix-beacon-update-deadlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ath5k: fix beacon-update deadlock
From: Jiri Slaby <jirislaby@gmail.com>

Commit 9d139c810a2aa17365cc548d0cd2a189d8433c65 introduced AA deadlock --
ath5k_config_interface(); holds sc->lock and it calls
ath5k_beacon_update(); which tries to grab the lock again.

Don't grab the lock in beacon update, since only caller is config iface
for now.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
Cc: "Bob Copeland" <me@bobcopeland.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ath5k/base.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/net/wireless/ath5k/base.c~ath5k-fix-beacon-update-deadlock drivers/net/wireless/ath5k/base.c
--- a/drivers/net/wireless/ath5k/base.c~ath5k-fix-beacon-update-deadlock
+++ a/drivers/net/wireless/ath5k/base.c
@@ -3065,8 +3065,6 @@ ath5k_beacon_update(struct ieee80211_hw 
 
 	ath5k_debug_dump_skb(sc, skb, "BC  ", 1);
 
-	mutex_lock(&sc->lock);
-
 	if (sc->opmode != IEEE80211_IF_TYPE_IBSS) {
 		ret = -EIO;
 		goto end;
@@ -3081,9 +3079,7 @@ ath5k_beacon_update(struct ieee80211_hw 
 		ath5k_beacon_config(sc);
 		mmiowb();
 	}
