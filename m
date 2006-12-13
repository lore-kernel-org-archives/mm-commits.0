From: akpm@osdl.org
Subject: - ieee80211softmac-fix-mutex_lock-at-exit-of-ieee80211_softmac_get_genie.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:56:51 -0800
Message-ID: <200612130656.kBD6upSM030764@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58232 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965070AbWLMHA5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 02:00:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kune@deine-taler.de, linville@tuxdriver.com, mb@bu3sch.de, stable@kernle.org, mm-commits@vger.kernel.org


The patch titled
     ieee80211softmac: Fix mutex_lock at exit of ieee80211_softmac_get_genie
has been removed from the -mm tree.  Its filename was
     ieee80211softmac-fix-mutex_lock-at-exit-of-ieee80211_softmac_get_genie.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ieee80211softmac: Fix mutex_lock at exit of ieee80211_softmac_get_genie
From: Ulrich Kunitz <kune@deine-taler.de>

ieee80211softmac_wx_get_genie locks the associnfo mutex at function exit.

Signed-off-by: Ulrich Kunitz <kune@deine-taler.de>
Acked-by: Michael Buesch <mb@bu3sch.de>
Cc: <stable@kernle.org>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 net/ieee80211/softmac/ieee80211softmac_wx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/ieee80211/softmac/ieee80211softmac_wx.c~ieee80211softmac-fix-mutex_lock-at-exit-of-ieee80211_softmac_get_genie net/ieee80211/softmac/ieee80211softmac_wx.c
--- a/net/ieee80211/softmac/ieee80211softmac_wx.c~ieee80211softmac-fix-mutex_lock-at-exit-of-ieee80211_softmac_get_genie
+++ a/net/ieee80211/softmac/ieee80211softmac_wx.c
@@ -463,7 +463,7 @@ ieee80211softmac_wx_get_genie(struct net
 			err = -E2BIG;
 	}
 	spin_unlock_irqrestore(&mac->lock, flags);
-	mutex_lock(&mac->associnfo.mutex);
+	mutex_unlock(&mac->associnfo.mutex);
 
 	return err;
 }
_

Patches currently in -mm which might be from kune@deine-taler.de are

origin.patch
git-wireless.patch

