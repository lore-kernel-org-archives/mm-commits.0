From: akpm@linux-foundation.org
Subject: + mm-zswap-check-all-pool-pages-instead-of-one-pools-pages.patch
 added to -mm tree
Date: Mon, 13 Jan 2014 14:32:09 -0800
Message-ID: <52d46969.j/B8aEiWaqhgIrfI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53002 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaAMWcK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jan 2014 17:32:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sjenning@linux.vnet.ibm.com, minchan@kernel.org, bob.liu@oracle.com, cai.liu@samsung.com

Subject: + mm-zswap-check-all-pool-pages-instead-of-one-pools-pages.patch added to -mm tree
To: cai.liu@samsung.com,bob.liu@oracle.com,minchan@kernel.org,sjenning@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Mon, 13 Jan 2014 14:32:09 -0800


The patch titled
     Subject: mm/zswap: check all pool pages instead of one pool's pages
has been added to the -mm tree.  Its filename is
     mm-zswap-check-all-pool-pages-instead-of-one-pools-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zswap-check-all-pool-pages-instead-of-one-pools-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zswap-check-all-pool-pages-instead-of-one-pools-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-zswap-check-all-pool-pages-instead-of-one-pools-pages.patch

