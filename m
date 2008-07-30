From: akpm@linux-foundation.org
Subject: - drivers-net-wireless-b43legacy-mainc-release-mutex-in-error-handling-code.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:18:02 -0700
Message-ID: <200807301918.m6UJI28c011268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753189AbYG3Tei (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:34:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, Larry.Finger@lwfinger.net, johannes@sipsolutions.net, linville@tuxdriver.com, mb@bu3sch.de, stefano.brivio@polimi.it, mm-commits@vger.kernel.org


The patch titled
     drivers/net/wireless/b43legacy/main.c: release mutex in error handling code
has been removed from the -mm tree.  Its filename was
     drivers-net-wireless-b43legacy-mainc-release-mutex-in-error-handling-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/wireless/b43legacy/main.c: release mutex in error handling code
From: Julia Lawall <julia@diku.dk>

The mutex is released on a successful return, so it would seem that it
should be released on an error return as well.

The semantic patch finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression l;
@@

mutex_lock(l);
... when != mutex_unlock(l)
    when any
    when strict
(
if (...) { ... when != mutex_unlock(l)
+   mutex_unlock(l);
    return ...;
}
|
mutex_unlock(l);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/b43legacy/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wireless/b43legacy/main.c~drivers-net-wireless-b43legacy-mainc-release-mutex-in-error-handling-code drivers/net/wireless/b43legacy/main.c
--- a/drivers/net/wireless/b43legacy/main.c~drivers-net-wireless-b43legacy-mainc-release-mutex-in-error-handling-code
+++ a/drivers/net/wireless/b43legacy/main.c
@@ -3846,10 +3846,10 @@ static int b43legacy_resume(struct ssb_d
 			goto out;
 		}
 	}
-	mutex_unlock(&wl->mutex);
 
 	b43legacydbg(wl, "Device resumed.\n");
 out:
+	mutex_unlock(&wl->mutex);
 	return err;
 }
 
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
git-infiniband.patch
drivers-net-ehea-ehea_mainc-release-mutex-in-error-handling-code.patch
net-ieee80211-adjust-error-handling.patch

