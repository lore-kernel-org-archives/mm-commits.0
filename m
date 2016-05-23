From: akpm@linux-foundation.org
Subject: [merged] zsmalloc-remove-unused-pool-param-in-obj_free.patch
 removed from -mm tree
Date: Mon, 23 May 2016 12:47:44 -0700
Message-ID: <57435e60.kDzJ1rXCfaWIVlLx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37536 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310AbcEWTrp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:47:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: remove unused pool param in obj_free
has been removed from the -mm tree.  Its filename was
     zsmalloc-remove-unused-pool-param-in-obj_free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: remove unused pool param in obj_free

Let's remove unused pool param in obj_free

Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-remove-unused-pool-param-in-obj_free mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-remove-unused-pool-param-in-obj_free
+++ a/mm/zsmalloc.c
@@ -1438,8 +1438,7 @@ unsigned long zs_malloc(struct zs_pool *
 }
 EXPORT_SYMBOL_GPL(zs_malloc);
 
-static void obj_free(struct zs_pool *pool, struct size_class *class,
-			unsigned long obj)
+static void obj_free(struct size_class *class, unsigned long obj)
 {
 	struct link_free *link;
 	struct page *first_page, *f_page;
@@ -1485,7 +1484,7 @@ void zs_free(struct zs_pool *pool, unsig
 	class = pool->size_class[class_idx];
 
 	spin_lock(&class->lock);
-	obj_free(pool, class, obj);
+	obj_free(class, obj);
 	fullness = fix_fullness_group(class, first_page);
 	if (fullness == ZS_EMPTY) {
 		zs_stat_dec(class, OBJ_ALLOCATED, get_maxobj_per_zspage(
@@ -1648,7 +1647,7 @@ static int migrate_zspage(struct zs_pool
 		free_obj |= BIT(HANDLE_PIN_BIT);
 		record_obj(handle, free_obj);
 		unpin_tag(handle);
-		obj_free(pool, class, used_obj);
+		obj_free(class, used_obj);
 	}
 
 	/* Remember last position in this iteration */
_

Patches currently in -mm which might be from minchan@kernel.org are


