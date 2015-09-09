From: akpm@linux-foundation.org
Subject: [merged]
 zsmalloc-remove-null-check-from-destroy_handle_cache.patch removed from -mm tree
Date: Wed, 09 Sep 2015 12:54:15 -0700
Message-ID: <55f08e67.leTlTUsVumyb4AHY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41485 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbbIITyP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:54:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: remove null check from destroy_handle_cache()
has been removed from the -mm tree.  Its filename was
     zsmalloc-remove-null-check-from-destroy_handle_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zsmalloc: remove null check from destroy_handle_cache()

We can pass a NULL cache pointer to kmem_cache_destroy(), because it
NULL-checks its argument now.  Remove redundant test from
destroy_handle_cache().

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-remove-null-check-from-destroy_handle_cache mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-remove-null-check-from-destroy_handle_cache
+++ a/mm/zsmalloc.c
@@ -288,8 +288,7 @@ static int create_handle_cache(struct zs
 
 static void destroy_handle_cache(struct zs_pool *pool)
 {
-	if (pool->handle_cachep)
-		kmem_cache_destroy(pool->handle_cachep);
+	kmem_cache_destroy(pool->handle_cachep);
 }
 
 static unsigned long alloc_handle(struct zs_pool *pool)
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are


