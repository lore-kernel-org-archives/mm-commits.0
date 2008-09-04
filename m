From: akpm@linux-foundation.org
Subject: + async_tx-fix-the-bug-in-async_tx_run_dependencies.patch added to -mm tree
Date: Thu, 04 Sep 2008 14:17:03 -0700
Message-ID: <200809042117.m84LH3RS031565@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754046AbYIDVTO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Sep 2008 17:19:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yur@emcraft.com, dan.j.williams@intel.com, herbert@gondor.apana.org.au, lizf@cn.fujitsu.com


The patch titled
     async_tx: fix a bug in async_tx_run_dependencies
has been added to the -mm tree.  Its filename is
     async_tx-fix-the-bug-in-async_tx_run_dependencies.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: async_tx: fix a bug in async_tx_run_dependencies
From: Yuri Tikhonov <yur@emcraft.com>

Should clear the next pointer of the TX if we are sure that the next TX
(say NXT) will be submitted to the channel too.  Overwise, we break the
chain of descriptors, because we lose the information about the next
descriptor to run.  So next time, when invoke async_tx_run_dependencies()
with TX, it's TX->next will be NULL, and NXT will be never submitted.

Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/async_tx/async_tx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN crypto/async_tx/async_tx.c~async_tx-fix-the-bug-in-async_tx_run_dependencies crypto/async_tx/async_tx.c
--- a/crypto/async_tx/async_tx.c~async_tx-fix-the-bug-in-async_tx_run_dependencies
+++ a/crypto/async_tx/async_tx.c
@@ -137,7 +137,8 @@ async_tx_run_dependencies(struct dma_asy
 		spin_lock_bh(&next->lock);
 		next->parent = NULL;
 		_next = next->next;
-		next->next = NULL;
+		if (_next && _next->chan == chan)
+			next->next = NULL;
 		spin_unlock_bh(&next->lock);
 
 		next->tx_submit(next);
_

Patches currently in -mm which might be from yur@emcraft.com are

async_tx-fix-the-bug-in-async_tx_run_dependencies.patch

