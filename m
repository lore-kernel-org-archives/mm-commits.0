From: akpm@osdl.org
Subject: + ieee80211softmac-fix-errors-related-to-the-work_struct-changes.patch added to -mm tree
Date: Sun, 10 Dec 2006 11:10:45 -0800
Message-ID: <200612101910.kBAJAjOW000385@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51455 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761798AbWLJTLv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 14:11:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kune@deine-taler.de, dhowells@redhat.com, linville@tuxdriver.com, mb@bu3sch.de


The patch titled
     ieee80211softmac: fix errors related to the work_struct changes
has been added to the -mm tree.  Its filename is
     ieee80211softmac-fix-errors-related-to-the-work_struct-changes.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ieee80211softmac: fix errors related to the work_struct changes
From: Ulrich Kunitz <kune@deine-taler.de>

The signature of work functions changed recently from a context pointer to
the work structure pointer.  This caused a problem in the ieee80211softmac
code, because the ieee80211softmac_assoc_work function has been called
directly with a parameter explicitly casted to (void*).  This compiled
correctly but resulted in a softlock, because mutex_lock was called with
the wrong memory address.

The patch fixes the problem.  Softmac works again and this fixes the problem I
mentioned earlier in the zd1211rw rx tasklet patch.

Signed-off-by: Ulrich Kunitz <kune@deine-taler.de>
Acked-by: Michael Buesch <mb@bu3sch.de>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 net/ieee80211/softmac/ieee80211softmac_assoc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN net/ieee80211/softmac/ieee80211softmac_assoc.c~ieee80211softmac-fix-errors-related-to-the-work_struct-changes net/ieee80211/softmac/ieee80211softmac_assoc.c
--- a/net/ieee80211/softmac/ieee80211softmac_assoc.c~ieee80211softmac-fix-errors-related-to-the-work_struct-changes
+++ a/net/ieee80211/softmac/ieee80211softmac_assoc.c
@@ -167,7 +167,7 @@ static void
 ieee80211softmac_assoc_notify_scan(struct net_device *dev, int event_type, void *context)
 {
 	struct ieee80211softmac_device *mac = ieee80211_priv(dev);
-	ieee80211softmac_assoc_work((void*)mac);
+	ieee80211softmac_assoc_work(&mac->associnfo.work.work);
 }
 
 static void
@@ -177,7 +177,7 @@ ieee80211softmac_assoc_notify_auth(struc
 
 	switch (event_type) {
 	case IEEE80211SOFTMAC_EVENT_AUTHENTICATED:
-		ieee80211softmac_assoc_work((void*)mac);
+		ieee80211softmac_assoc_work(&mac->associnfo.work.work);
 		break;
 	case IEEE80211SOFTMAC_EVENT_AUTH_FAILED:
 	case IEEE80211SOFTMAC_EVENT_AUTH_TIMEOUT:
_

Patches currently in -mm which might be from kune@deine-taler.de are

origin.patch
ieee80211softmac-fix-errors-related-to-the-work_struct-changes.patch

