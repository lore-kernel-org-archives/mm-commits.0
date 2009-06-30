From: akpm@linux-foundation.org
Subject: + wireless-nl80211-fix-lock-imbalance.patch added to -mm tree
Date: Tue, 30 Jun 2009 12:24:58 -0700
Message-ID: <200906301924.n5UJOw9T016623@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752257AbZF3T0T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jun 2009 15:26:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, johannes@sipsolutions.net, linville@tuxdriver.com


The patch titled
     wireless: nl80211, fix lock imbalance
has been added to the -mm tree.  Its filename is
     wireless-nl80211-fix-lock-imbalance.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
floppy-fix-lock-imbalance.patch
linux-next.patch
icom-converting-space-to-tabs.patch
wireless-nl80211-fix-lock-imbalance.patch
reiser4.patch

