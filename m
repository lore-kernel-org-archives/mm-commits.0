From: akpm@linux-foundation.org
Subject: [folded-merged] zswap-dynamic-pool-creation-fix.patch removed
 from -mm tree
Date: Tue, 08 Sep 2015 14:46:50 -0700
Message-ID: <55ef574a.M6ZPyzWdqbWI8ldg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53551 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbbIHVqv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 17:46:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ddstreet@ieee.org, sergey.senozhatsky.work@gmail.com, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: zswap-dynamic-pool-creation-fix
has been removed from the -mm tree.  Its filename was
     zswap-dynamic-pool-creation-fix.patch

This patch was dropped because it was folded into zswap-dynamic-pool-creation.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: zswap-dynamic-pool-creation-fix

fix merge snafus

Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN mm/zswap.c~zswap-dynamic-pool-creation-fix mm/zswap.c
--- a/mm/zswap.c~zswap-dynamic-pool-creation-fix
+++ a/mm/zswap.c
@@ -173,6 +173,10 @@ static int zswap_writeback_entry(struct
 static int zswap_pool_get(struct zswap_pool *pool);
 static void zswap_pool_put(struct zswap_pool *pool);
 
+static const struct zpool_ops zswap_zpool_ops = {
+	.evict = zswap_writeback_entry
+};
+
 static bool zswap_is_full(void)
 {
 	return totalram_pages * zswap_max_pool_percent / 100 <
@@ -657,8 +661,6 @@ static void zswap_pool_put(struct zswap_
 	kref_put(&pool->kref, __zswap_pool_empty);
 }
 
-}
-
 /*********************************
 * writeback code
 **********************************/
@@ -1030,10 +1032,6 @@ static void zswap_frontswap_invalidate_a
 	zswap_trees[type] = NULL;
 }
 
-static const struct zpool_ops zswap_zpool_ops = {
-	.evict = zswap_writeback_entry
-};
