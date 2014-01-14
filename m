From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-zswap-check-all-pool-pages-instead-of-one-pools-pages.patch removed from -mm tree
Date: Tue, 14 Jan 2014 14:51:53 -0800
Message-ID: <52d5bf89.R2QfhLi3I+pkfHS0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34667 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaANWvy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jan 2014 17:51:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sjenning@linux.vnet.ibm.com, minchan@kernel.org, bob.liu@oracle.com, cai.liu@samsung.com

Subject: [to-be-updated] mm-zswap-check-all-pool-pages-instead-of-one-pools-pages.patch removed from -mm tree
To: cai.liu@samsung.com,bob.liu@oracle.com,minchan@kernel.org,sjenning@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 14 Jan 2014 14:51:53 -0800


The patch titled
     Subject: mm/zswap: check all pool pages instead of one pool's pages
has been removed from the -mm tree.  Its filename was
     mm-zswap-check-all-pool-pages-instead-of-one-pools-pages.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Cai Liu <cai.liu@samsung.com>
Subject: mm/zswap: check all pool pages instead of one pool's pages

zswap can support multiple swapfiles.  So we need to check all zbud pool
pages in zswap.

Signed-off-by: Cai Liu <cai.liu@samsung.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Bob Liu <bob.liu@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff -puN mm/zswap.c~mm-zswap-check-all-pool-pages-instead-of-one-pool-pages mm/zswap.c
--- a/mm/zswap.c~mm-zswap-check-all-pool-pages-instead-of-one-pool-pages
+++ a/mm/zswap.c
@@ -291,7 +291,6 @@ static void zswap_free_entry(struct zswa
 	zbud_free(tree->pool, entry->handle);
 	zswap_entry_cache_free(entry);
 	atomic_dec(&zswap_stored_pages);
-	zswap_pool_pages = zbud_get_pool_size(tree->pool);
 }
 
 /* caller must hold the tree lock */
@@ -405,10 +404,24 @@ cleanup:
 /*********************************
 * helpers
 **********************************/
+static u64 get_zswap_pool_pages(void)
+{
+	int i;
+	u64 pool_pages = 0;
+
+	for (i = 0; i < MAX_SWAPFILES; i++) {
+		if (zswap_trees[i])
+			pool_pages += zbud_get_pool_size(zswap_trees[i]->pool);
+	}
+	zswap_pool_pages = pool_pages;
+
+	return pool_pages;
+}
+
 static bool zswap_is_full(void)
 {
 	return (totalram_pages * zswap_max_pool_percent / 100 <
-		zswap_pool_pages);
+		get_zswap_pool_pages());
 }
 
 /*********************************
@@ -716,7 +729,6 @@ static int zswap_frontswap_store(unsigne
 
 	/* update stats */
 	atomic_inc(&zswap_stored_pages);
-	zswap_pool_pages = zbud_get_pool_size(tree->pool);
 
 	return 0;
 
_

Patches currently in -mm which might be from cai.liu@samsung.com are


