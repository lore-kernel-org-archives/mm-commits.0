From: akpm@linux-foundation.org
Subject: [patch 050/126] zsmalloc: separate free_zspage from
 putback_zspage
Date: Tue, 26 Jul 2016 15:23:26 -0700
Message-ID: <5797e2de.cjrWA1THj9kv6Tnw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56737 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161AbcGZWX1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:23:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, minchan@kernel.org, sergey.senozhatsky@gmail.com, vbabka@suse.cz

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
