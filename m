From: akpm@linux-foundation.org
Subject: - async_tx-fix-the-bug-in-async_tx_run_dependencies.patch removed from -mm tree
Date: Mon, 08 Sep 2008 12:07:23 -0700
Message-ID: <200809081907.m88J7Nnk005552@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753802AbYIHTIi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Sep 2008 15:08:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yur@emcraft.com, dan.j.williams@intel.com, herbert@gondor.apana.org.au, lizf@cn.fujitsu.com, yanok@emcraft.com, mm-commits@vger.kernel.org


The patch titled
     async_tx: fix a bug in async_tx_run_dependencies
has been removed from the -mm tree.  Its filename was
     async_tx-fix-the-bug-in-async_tx_run_dependencies.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

