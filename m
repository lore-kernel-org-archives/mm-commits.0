From: akpm@linux-foundation.org
Subject: - mac80211-fix-notify_mac-function.patch removed from -mm tree
Date: Thu, 13 Nov 2008 13:28:18 -0800
Message-ID: <200811132128.mADLSIjZ028406@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44653 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753202AbYKMV3N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 16:29:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johannes@sipsolutions.net, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     mac80211: fix notify_mac function
has been removed from the -mm tree.  Its filename was
     mac80211-fix-notify_mac-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mac80211: fix notify_mac function
From: Johannes Berg <johannes@sipsolutions.net>

The ieee80211_notify_mac() function uses ieee80211_sta_req_auth() which in
turn calls ieee80211_set_disassoc() which calls a few functions that need
to be able to sleep, so ieee80211_notify_mac() cannot use RCU locking for
the interface list and must use rtnl locking instead.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/mlme.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN net/mac80211/mlme.c~mac80211-fix-notify_mac-function net/mac80211/mlme.c
--- a/net/mac80211/mlme.c~mac80211-fix-notify_mac-function
+++ a/net/mac80211/mlme.c
@@ -2570,14 +2570,14 @@ void ieee80211_notify_mac(struct ieee802
 
 	switch (notif_type) {
 	case IEEE80211_NOTIFY_RE_ASSOC:
-		rcu_read_lock();
-		list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		rtnl_lock();
+		list_for_each_entry(sdata, &local->interfaces, list) {
 			if (sdata->vif.type != NL80211_IFTYPE_STATION)
 				continue;
 
 			ieee80211_sta_req_auth(sdata, &sdata->u.sta);
 		}
-		rcu_read_unlock();
+		rtnl_unlock();
 		break;
 	}
 }
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

origin.patch
linux-next.patch
drivers-net-wireless-ath9k-rcc-use-array_size.patch

