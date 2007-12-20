From: akpm@linux-foundation.org
Subject: - ieee80211_rate-missed-unlock.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:38:30 -0800
Message-ID: <200712202338.lBKNcUos018979@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57878 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757125AbXLTXtE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:49:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, flamingice@sourmilk.net, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     ieee80211_rate: missed unlock
has been removed from the -mm tree.  Its filename was
     ieee80211_rate-missed-unlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ieee80211_rate: missed unlock
From: Cyrill Gorcunov <gorcunov@gmail.com>

Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/ieee80211_rate.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN net/mac80211/ieee80211_rate.c~ieee80211_rate-missed-unlock net/mac80211/ieee80211_rate.c
--- a/net/mac80211/ieee80211_rate.c~ieee80211_rate-missed-unlock
+++ a/net/mac80211/ieee80211_rate.c
@@ -33,6 +33,7 @@ int ieee80211_rate_control_register(stru
 		if (!strcmp(alg->ops->name, ops->name)) {
 			/* don't register an algorithm twice */
 			WARN_ON(1);
+			mutex_unlock(&rate_ctrl_mutex);
 			return -EALREADY;
 		}
 	}
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
git-powerpc.patch
ppc-fix-missed-increment-on-device-interface-counter.patch
net-mac80211-fix-inappropriate-memory-freeing.patch
git-x86.patch
