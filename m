From: akpm@linux-foundation.org
Subject: + zsmalloc-account-the-number-of-compacted-pages.patch added to
 -mm tree
Date: Wed, 08 Jul 2015 15:38:00 -0700
Message-ID: <559da648.nR+yHLkqxgrnbWES%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46007 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869AbbGHWiB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jul 2015 18:38:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: account the number of compacted pages
has been added to the -mm tree.  Its filename is
     zsmalloc-account-the-number-of-compacted-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-account-the-number-of-compacted-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-account-the-number-of-compacted-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zsmalloc: account the number of compacted pages

Compaction returns back to zram the number of migrated objects, which is
quite uninformative -- we have objects of different sizes so user space
cannot obtain any valuable data from that number.  Change compaction to
operate in terms of pages and return back to compaction issuer the number
of pages that were freed during compaction.  So from now on we will export
more meaningful value in zram<id>/mm_stat -- the number of freed
(compacted) pages.

This requires:
(a) a rename of `num_migrated' to 'pages_compacted'
(b) a internal API change -- return first_page's fullness_group
from putback_zspage(), so we know when putback_zspage() did
free_zspage(). It helps us to account compaction stats correctly.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/blockdev/zram.txt |    3 ++-
 drivers/block/zram/zram_drv.c   |    2 +-
 include/linux/zsmalloc.h        |    4 ++--
 mm/zsmalloc.c                   |   27 +++++++++++++++++----------
 4 files changed, 22 insertions(+), 14 deletions(-)

diff -puN Documentation/blockdev/zram.txt~zsmalloc-account-the-number-of-compacted-pages Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zsmalloc-account-the-number-of-compacted-pages
+++ a/Documentation/blockdev/zram.txt
@@ -144,7 +144,8 @@ mem_used_max      RW    the maximum amou
                         store compressed data
 mem_limit         RW    the maximum amount of memory ZRAM can use to store
                         the compressed data
-num_migrated      RO    the number of objects migrated migrated by compaction
+pages_compacted   RO    the number of pages freed during compaction
+                        (available only via zram<id>/mm_stat node)
 compact           WO    trigger memory compaction
 
 WARNING
diff -puN drivers/block/zram/zram_drv.c~zsmalloc-account-the-number-of-compacted-pages drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zsmalloc-account-the-number-of-compacted-pages
+++ a/drivers/block/zram/zram_drv.c
@@ -450,7 +450,7 @@ static ssize_t mm_stat_show(struct devic
 			zram->limit_pages << PAGE_SHIFT,
 			max_used << PAGE_SHIFT,
 			(u64)atomic64_read(&zram->stats.zero_pages),
-			pool_stats.num_migrated);
+			pool_stats.pages_compacted);
 	up_read(&zram->init_lock);
 
 	return ret;
diff -puN include/linux/zsmalloc.h~zsmalloc-account-the-number-of-compacted-pages include/linux/zsmalloc.h
--- a/include/linux/zsmalloc.h~zsmalloc-account-the-number-of-compacted-pages
+++ a/include/linux/zsmalloc.h
@@ -35,8 +35,8 @@ enum zs_mapmode {
 };
 
 struct zs_pool_stats {
-	/* How many objects were migrated */
-	unsigned long num_migrated;
+	/* How many pages were migrated (freed) */
+	unsigned long pages_compacted;
 };
 
 struct zs_pool;
diff -puN mm/zsmalloc.c~zsmalloc-account-the-number-of-compacted-pages mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-account-the-number-of-compacted-pages
+++ a/mm/zsmalloc.c
@@ -1579,8 +1579,6 @@ struct zs_compact_control {
 	 /* Starting object index within @s_page which used for live object
 	  * in the subpage. */
 	int index;
-	/* How many of objects were migrated */
-	int nr_migrated;
 };
 
 static int migrate_zspage(struct zs_pool *pool, struct size_class *class,
@@ -1617,7 +1615,6 @@ static int migrate_zspage(struct zs_pool
 		record_obj(handle, free_obj);
 		unpin_tag(handle);
 		obj_free(pool, class, used_obj);
-		cc->nr_migrated++;
 	}
 
 	/* Remember last position in this iteration */
@@ -1643,8 +1640,17 @@ static struct page *isolate_target_page(
 	return page;
 }
 
-static void putback_zspage(struct zs_pool *pool, struct size_class *class,
-				struct page *first_page)
+/*
+ * putback_zspage - add @first_page into right class's fullness list
+ * @pool: target pool
+ * @class: destination class
+ * @first_page: target page
+ *
+ * Return @fist_page's fullness_group
+ */
+static enum fullness_group putback_zspage(struct zs_pool *pool,
+			struct size_class *class,
+			struct page *first_page)
 {
 	enum fullness_group fullness;
 
@@ -1662,6 +1668,8 @@ static void putback_zspage(struct zs_poo
 
 		free_zspage(first_page);
 	}
+
+	return fullness;
 }
 
 static struct page *isolate_source_page(struct size_class *class)
@@ -1704,7 +1712,6 @@ static void __zs_compact(struct zs_pool
 	struct page *src_page;
 	struct page *dst_page = NULL;
 
-	cc.nr_migrated = 0;
 	spin_lock(&class->lock);
 	while ((src_page = isolate_source_page(class))) {
 
@@ -1733,7 +1740,9 @@ static void __zs_compact(struct zs_pool
 			break;
 
 		putback_zspage(pool, class, dst_page);
-		putback_zspage(pool, class, src_page);
+		if (putback_zspage(pool, class, src_page) == ZS_EMPTY)
+			pool->stats.pages_compacted +=
+				get_pages_per_zspage(class->size);
 		spin_unlock(&class->lock);
 		cond_resched();
 		spin_lock(&class->lock);
@@ -1742,8 +1751,6 @@ static void __zs_compact(struct zs_pool
 	if (src_page)
 		putback_zspage(pool, class, src_page);
 
-	pool->stats.num_migrated += cc.nr_migrated;
