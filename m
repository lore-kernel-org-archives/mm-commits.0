From: akpm@linux-foundation.org
Subject: [merged] zsmalloc-separate-free_zspage-from-putback_zspage.patch
 removed from -mm tree
Date: Wed, 27 Jul 2016 12:00:34 -0700
Message-ID: <579904d2.fsE+vjQRvmDFAftz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758038AbcG0TAf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 15:00:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, sergey.senozhatsky@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: separate free_zspage from putback_zspage
has been removed from the -mm tree.  Its filename was
     zsmalloc-separate-free_zspage-from-putback_zspage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: separate free_zspage from putback_zspage

Currently, putback_zspage does free zspage under class->lock if fullness
become ZS_EMPTY but it makes trouble to implement locking scheme for new
zspage migration.  So, this patch is to separate free_zspage from
putback_zspage and free zspage out of class->lock which is preparation for
zspage migration.

Link: http://lkml.kernel.org/r/1464736881-24886-10-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-separate-free_zspage-from-putback_zspage mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-separate-free_zspage-from-putback_zspage
+++ a/mm/zsmalloc.c
@@ -1687,14 +1687,12 @@ static struct zspage *isolate_zspage(str
 
 /*
  * putback_zspage - add @zspage into right class's fullness list
- * @pool: target pool
  * @class: destination class
  * @zspage: target page
  *
  * Return @zspage's fullness_group
  */
-static enum fullness_group putback_zspage(struct zs_pool *pool,
-			struct size_class *class,
+static enum fullness_group putback_zspage(struct size_class *class,
 			struct zspage *zspage)
 {
 	enum fullness_group fullness;
@@ -1703,15 +1701,6 @@ static enum fullness_group putback_zspag
 	insert_zspage(class, zspage, fullness);
 	set_zspage_mapping(zspage, class->index, fullness);
 
-	if (fullness == ZS_EMPTY) {
-		zs_stat_dec(class, OBJ_ALLOCATED, get_maxobj_per_zspage(
-			class->size, class->pages_per_zspage));
-		atomic_long_sub(class->pages_per_zspage,
-				&pool->pages_allocated);
-
-		free_zspage(pool, zspage);
-	}
-
 	return fullness;
 }
 
@@ -1760,23 +1749,29 @@ static void __zs_compact(struct zs_pool
 			if (!migrate_zspage(pool, class, &cc))
 				break;
 
-			putback_zspage(pool, class, dst_zspage);
+			putback_zspage(class, dst_zspage);
 		}
 
 		/* Stop if we couldn't find slot */
 		if (dst_zspage == NULL)
 			break;
 
-		putback_zspage(pool, class, dst_zspage);
-		if (putback_zspage(pool, class, src_zspage) == ZS_EMPTY)
+		putback_zspage(class, dst_zspage);
+		if (putback_zspage(class, src_zspage) == ZS_EMPTY) {
+			zs_stat_dec(class, OBJ_ALLOCATED, get_maxobj_per_zspage(
+					class->size, class->pages_per_zspage));
+			atomic_long_sub(class->pages_per_zspage,
+					&pool->pages_allocated);
+			free_zspage(pool, src_zspage);
 			pool->stats.pages_compacted += class->pages_per_zspage;
+		}
 		spin_unlock(&class->lock);
 		cond_resched();
 		spin_lock(&class->lock);
 	}
 
 	if (src_zspage)
-		putback_zspage(pool, class, src_zspage);
+		putback_zspage(class, src_zspage);
 
 	spin_unlock(&class->lock);
 }
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-page_alloc-fix-dirtyable-highmem-calculation.patch
mm-show-node_pages_scanned-per-node-not-zone.patch
mm-show-node_pages_scanned-per-node-not-zone-fix.patch
mm-add-per-zone-lru-list-stat.patch
mm-bail-out-in-shrin_inactive_list.patch

