From: akpm@linux-foundation.org
Subject: + sunrpc-align-cache_clean-works-timer.patch added to -mm tree
Date: Wed, 01 Apr 2009 12:45:36 -0700
Message-ID: <200904011945.n31Jjaeo028161@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934022AbZDATtU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:49:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton@samba.org, davem@davemloft.net, neilb@suse.de, trond.myklebust@fys.uio.no


The patch titled
     sunrpc: align cache_clean work's timer
has been added to the -mm tree.  Its filename is
     sunrpc-align-cache_clean-works-timer.patch

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
mm-align-vmstat_works-timer.patch
random-align-rekey_works-timer.patch
sunrpc-align-cache_clean-works-timer.patch

