From: akpm@osdl.org
Subject: + ieee80211softmac-fix-mutex_lock-at-exit-of-ieee80211_softmac_get_genie.patch added to -mm tree
Date: Sun, 10 Dec 2006 11:24:27 -0800
Message-ID: <200612101924.kBAJORqn000736@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52887 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762457AbWLJTZc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 14:25:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kune@deine-taler.de, linville@tuxdriver.com, mb@bu3sch.de, stable@kernle.org


The patch titled
     ieee80211softmac: Fix mutex_lock at exit of ieee80211_softmac_get_genie
has been added to the -mm tree.  Its filename is
     ieee80211softmac-fix-mutex_lock-at-exit-of-ieee80211_softmac_get_genie.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
ieee80211softmac-fix-errors-related-to-the-work_struct-changes.patch
zd1211rw-call-ieee80211_rx-in-tasklet.patch
ieee80211softmac-fix-mutex_lock-at-exit-of-ieee80211_softmac_get_genie.patch

