From: akpm@linux-foundation.org
Subject: - net-mac80211-fix-inappropriate-memory-freeing.patch removed from -mm tree
Date: Sat, 22 Dec 2007 15:26:17 -0800
Message-ID: <200712222326.lBMNQHCd024661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39689 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754040AbXLVX02 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Dec 2007 18:26:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, flamingice@sourmilk.net, mm-commits@vger.kernel.org


The patch titled
     NET: mac80211: fix inappropriate memory freeing
has been removed from the -mm tree.  Its filename was
     net-mac80211-fix-inappropriate-memory-freeing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: NET: mac80211: fix inappropriate memory freeing
From: Cyrill Gorcunov <gorcunov@gmail.com>

Fix inappropriate memory freeing in case of requested rate_control_ops was
not found.  In this case the list head entity is going to be accidentally
wasted.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Acked-by: Michael Wu <flamingice@sourmilk.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/ieee80211_rate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/mac80211/ieee80211_rate.c~net-mac80211-fix-inappropriate-memory-freeing net/mac80211/ieee80211_rate.c
--- a/net/mac80211/ieee80211_rate.c~net-mac80211-fix-inappropriate-memory-freeing
+++ a/net/mac80211/ieee80211_rate.c
@@ -59,11 +59,11 @@ void ieee80211_rate_control_unregister(s
 	list_for_each_entry(alg, &rate_ctrl_algs, list) {
 		if (alg->ops == ops) {
 			list_del(&alg->list);
+			kfree(alg);
 			break;
 		}
 	}
 	mutex_unlock(&rate_ctrl_mutex);
-	kfree(alg);
 }
 EXPORT_SYMBOL(ieee80211_rate_control_unregister);
 
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
git-powerpc.patch
git-x86.patch
