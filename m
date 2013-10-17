From: akpm@linux-foundation.org
Subject: [merged] mm-zswap-bugfix-memory-leak-when-re-swapon.patch removed from -mm tree
Date: Thu, 17 Oct 2013 11:13:09 -0700
Message-ID: <526028b5.jBf0BGWLkCC+nXpZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44341 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759035Ab3JQSNK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Oct 2013 14:13:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, sjenning@linux.vnet.ibm.com, minchan@kernel.org, bob.liu@oracle.com, weijie.yang@samsung.com

Subject: [merged] mm-zswap-bugfix-memory-leak-when-re-swapon.patch removed from -mm tree
To: weijie.yang@samsung.com,bob.liu@oracle.com,minchan@kernel.org,sjenning@linux.vnet.ibm.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 17 Oct 2013 11:13:09 -0700


The patch titled
     Subject: mm/zswap: bugfix: memory leak when re-swapon
has been removed from the -mm tree.  Its filename was
     mm-zswap-bugfix-memory-leak-when-re-swapon.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Weijie Yang <weijie.yang@samsung.com>
Subject: mm/zswap: bugfix: memory leak when re-swapon

zswap_tree is not freed when swapoff, and it got re-kmalloced in swapon,
so a memory leak occurs.

Free the memory of zswap_tree in zswap_frontswap_invalidate_area().

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Reviewed-by: Bob Liu <bob.liu@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
From: Weijie Yang <weijie.yang@samsung.com>
Subject: mm/zswap: bugfix: memory leak when invalidate and reclaim occur concurrently

Consider the following scenario:
thread 0: reclaim entry x (get refcount, but not call zswap_get_swap_cache_page)
thread 1: call zswap_frontswap_invalidate_page to invalidate entry x.
	finished, entry x and its zbud is not freed as its refcount != 0
	now, the swap_map[x] = 0
thread 0: now call zswap_get_swap_cache_page
	swapcache_prepare return -ENOENT because entry x is not used any more
	zswap_get_swap_cache_page return ZSWAP_SWAPCACHE_NOMEM
	zswap_writeback_entry do nothing except put refcount
Now, the memory of zswap_entry x and its zpage leak.

Modify:
 - check the refcount in fail path, free memory if it is not referenced.

 - use ZSWAP_SWAPCACHE_FAIL instead of ZSWAP_SWAPCACHE_NOMEM as the fail path
   can be not only caused by nomem but also by invalidate.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Reviewed-by: Bob Liu <bob.liu@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/zswap.c~mm-zswap-bugfix-memory-leak-when-re-swapon mm/zswap.c
--- a/mm/zswap.c~mm-zswap-bugfix-memory-leak-when-re-swapon
+++ a/mm/zswap.c
@@ -804,6 +804,10 @@ static void zswap_frontswap_invalidate_a
 	}
 	tree->rbroot = RB_ROOT;
 	spin_unlock(&tree->lock);
+
+	zbud_destroy_pool(tree->pool);
+	kfree(tree);
+	zswap_trees[type] = NULL;
 }
 
 static struct zbud_ops zswap_zbud_ops = {
_

Patches currently in -mm which might be from weijie.yang@samsung.com are

origin.patch
mm-zswap-avoid-unnecessary-page-scanning.patch

