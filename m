From: akpm@linux-foundation.org
Subject: + ieee80211_rate-missed-unlock.patch added to -mm tree
Date: Mon, 03 Dec 2007 15:29:12 -0800
Message-ID: <200712032329.lB3NTC7j023051@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60417 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751455AbXLCXft (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Dec 2007 18:35:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, linville@tuxdriver.com


The patch titled
     ieee80211_rate: missed unlock
has been added to the -mm tree.  Its filename is
     ieee80211_rate-missed-unlock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
ppc-fix-missed-increment-on-device-interface-counter.patch
ppc-chrp-fix-possible-null-pointer-dereference.patch
ppc-chrp-fix-possible-null-pointer-dereference-checkpatch-fixes.patch
git-sparc64.patch
git-x86.patch
ieee80211_rate-missed-unlock.patch
