From: akpm@linux-foundation.org
Subject: [folded-merged] kthread-kthread-worker-api-cleanup-fix.patch
 removed from -mm tree
Date: Tue, 11 Oct 2016 13:39:26 -0700
Message-ID: <57fd4dfe.SN2FtN5hRvs1guJW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37618 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752861AbcJKUkW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:40:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, pmladek@suse.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: crypto: engine: fix linux-next merge conflict
has been removed from the -mm tree.  Its filename was
     kthread-kthread-worker-api-cleanup-fix.patch

This patch was dropped because it was folded into kthread-kthread-worker-api-cleanup.patch

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: crypto: engine: fix linux-next merge conflict

A merge conflict between the akpm-current tree and the crypto tree
caused a build failure in ARM allmodconfig today:

crypto/crypto_engine.c: In function 'crypto_transfer_hash_request':
crypto/crypto_engine.c:234:3: error: implicit declaration of function 'queue_kthread_work' [-Werror=implicit-function-declaration]

This adapts the crypto code to the API change.

Fixes: 4cba7cf025f3 ("crypto: engine - permit to enqueue ashash_request")
Fixes: 8ca76638a2d0 ("kthread: kthread worker API cleanup")
Link: http://lkml.kernel.org/r/20160908135724.1311726-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/crypto_engine.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN crypto/crypto_engine.c~kthread-kthread-worker-api-cleanup-fix crypto/crypto_engine.c
--- a/crypto/crypto_engine.c~kthread-kthread-worker-api-cleanup-fix
+++ a/crypto/crypto_engine.c
@@ -231,7 +231,7 @@ int crypto_transfer_hash_request(struct
 	ret = ahash_enqueue_request(&engine->queue, req);
 
 	if (!engine->busy && need_pump)
-		queue_kthread_work(&engine->kworker, &engine->pump_requests);
+		kthread_queue_work(&engine->kworker, &engine->pump_requests);
 
 	spin_unlock_irqrestore(&engine->queue_lock, flags);
 	return ret;
@@ -321,7 +321,7 @@ void crypto_finalize_hash_request(struct
 
 	req->base.complete(&req->base, err);
 
-	queue_kthread_work(&engine->kworker, &engine->pump_requests);
+	kthread_queue_work(&engine->kworker, &engine->pump_requests);
 }
 EXPORT_SYMBOL_GPL(crypto_finalize_hash_request);
 
_

Patches currently in -mm which might be from arnd@arndb.de are

kthread-kthread-worker-api-cleanup.patch

