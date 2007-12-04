From: akpm@linux-foundation.org
Subject: + net-mac80211-fix-inappropriate-memory-freeing.patch added to -mm tree
Date: Mon, 03 Dec 2007 22:04:42 -0800
Message-ID: <200712040604.lB464g7w003707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34486 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751519AbXLDGFV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 01:05:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, flamingice@sourmilk.net


The patch titled
     NET: mac80211: fix inappropriate memory freeing
has been added to the -mm tree.  Its filename is
     net-mac80211-fix-inappropriate-memory-freeing.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
ppc-fix-missed-increment-on-device-interface-counter.patch
ppc-chrp-fix-possible-null-pointer-dereference.patch
ppc-chrp-fix-possible-null-pointer-dereference-checkpatch-fixes.patch
git-sparc64.patch
net-mac80211-fix-inappropriate-memory-freeing.patch
git-x86.patch
ieee80211_rate-missed-unlock.patch
