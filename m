From: akpm@linux-foundation.org
Subject: - link_watch-eliminate-potential-delay-on-wrap-around.patch removed from -mm tree
Date: Wed, 09 May 2007 14:55:22 -0700
Message-ID: <200705092155.l49LtMMf003264@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759551AbXEIV4O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:56:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: herbert@gondor.apana.org.au, mm-commits@vger.kernel.org


The patch titled
     link_watch: Eliminate potential delay on wrap-around
has been removed from the -mm tree.  Its filename was
     link_watch-eliminate-potential-delay-on-wrap-around.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: link_watch: Eliminate potential delay on wrap-around
From: Herbert Xu <herbert@gondor.apana.org.au>

When the jiffies wrap around or when the system boots up for the first
time, down events can be delayed indefinitely since we no longer update
linkwatch_nextevent when only urgent events are processed.

This patch fixes this by setting linkwatch_nextevent when a wrap-around
occurs.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/link_watch.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN net/core/link_watch.c~link_watch-eliminate-potential-delay-on-wrap-around net/core/link_watch.c
--- a/net/core/link_watch.c~link_watch-eliminate-potential-delay-on-wrap-around
+++ a/net/core/link_watch.c
@@ -110,8 +110,10 @@ static void linkwatch_schedule_work(int 
 	}
 
 	/* If we wrap around we'll delay it by at most HZ. */
-	if (delay > HZ)
+	if (delay > HZ) {
+		linkwatch_nextevent = jiffies;
 		delay = 0;
+	}
 
 	/*
 	 * This is true if we've scheduled it immeditately or if we don't
_

Patches currently in -mm which might be from herbert@gondor.apana.org.au are

origin.patch
git-net.patch
git-wireless.patch
use-menuconfig-objects-crypto.patch
