From: akpm@linux-foundation.org
Subject: [merged] wireless-nl80211-fix-lock-imbalance.patch removed from -mm tree
Date: Tue, 14 Jul 2009 13:33:28 -0700
Message-ID: <200907142033.n6EKXSu8013528@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756373AbZGNUeP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jul 2009 16:34:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, johannes@sipsolutions.net, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     wireless: nl80211, fix lock imbalance
has been removed from the -mm tree.  Its filename was
     wireless-nl80211-fix-lock-imbalance.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wireless: nl80211, fix lock imbalance
From: Jiri Slaby <jirislaby@gmail.com>

Don't forget to unlock cfg80211_mutex in one fail path of
nl80211_set_wiphy().

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/wireless/nl80211.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN net/wireless/nl80211.c~wireless-nl80211-fix-lock-imbalance net/wireless/nl80211.c
--- a/net/wireless/nl80211.c~wireless-nl80211-fix-lock-imbalance
+++ a/net/wireless/nl80211.c
@@ -447,6 +447,7 @@ static int nl80211_set_wiphy(struct sk_b
 
 	rdev = __cfg80211_drv_from_info(info);
 	if (IS_ERR(rdev)) {
+		mutex_unlock(&cfg80211_mutex);
 		result = PTR_ERR(rdev);
 		goto unlock;
 	}
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
toshiba_acpi-return-on-a-fail-path.patch
isdn-hisax-fix-lock-imbalance.patch
icom-converting-space-to-tabs.patch
reiser4.patch

