From: akpm@linux-foundation.org
Subject: [merged] sunrpc-align-cache_clean-works-timer.patch removed from -mm tree
Date: Fri, 12 Jun 2009 11:22:19 -0700
Message-ID: <200906121822.n5CIMJU6031100@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757815AbZFLS0B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jun 2009 14:26:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton@samba.org, davem@davemloft.net, neilb@suse.de, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     sunrpc: align cache_clean work's timer
has been removed from the -mm tree.  Its filename was
     sunrpc-align-cache_clean-works-timer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sunrpc: align cache_clean work's timer
From: Anton Blanchard <anton@samba.org>

Align cache_clean work.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: Neil Brown <neilb@suse.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/cache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/sunrpc/cache.c~sunrpc-align-cache_clean-works-timer net/sunrpc/cache.c
--- a/net/sunrpc/cache.c~sunrpc-align-cache_clean-works-timer
+++ a/net/sunrpc/cache.c
@@ -488,7 +488,7 @@ static void do_cache_clean(struct work_s
 {
 	int delay = 5;
 	if (cache_clean() == -1)
-		delay = 30*HZ;
+		delay = round_jiffies_relative(30*HZ);
 
 	if (list_empty(&cache_list))
 		delay = 0;
_

Patches currently in -mm which might be from anton@samba.org are

origin.patch
linux-next.patch
drivers-hvc-add-missing-__devexit_p.patch

