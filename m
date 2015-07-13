From: akpm@linux-foundation.org
Subject: + zsmalloc-factor-out-zs_pages_to_compact.patch added to -mm tree
Date: Mon, 13 Jul 2015 14:50:25 -0700
Message-ID: <55a432a1.tfggynbiU0qb2za7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33818 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbbGMVu0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jul 2015 17:50:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: factor out zs_pages_to_compact()
has been added to the -mm tree.  Its filename is
     zsmalloc-factor-out-zs_pages_to_compact.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-factor-out-zs_pages_to_compact.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-factor-out-zs_pages_to_compact.patch

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
Subject: zsmalloc: factor out zs_pages_to_compact()

Factor out the code that calculates how many pages compaction can free
into zs_pages_to_compact() function and export it as zsmalloc API symbol. 
We still use it in zs_shrinker_count(), just like we did before, and at
the same time we now let zram know this number (and provide it to user
space) so user space can make better assumptions about manual compaction
effectiveness.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zsmalloc.h |    1 
 mm/zsmalloc.c            |   39 +++++++++++++++++++++----------------
 2 files changed, 24 insertions(+), 16 deletions(-)

diff -puN include/linux/zsmalloc.h~zsmalloc-factor-out-zs_pages_to_compact include/linux/zsmalloc.h
--- a/include/linux/zsmalloc.h~zsmalloc-factor-out-zs_pages_to_compact
+++ a/include/linux/zsmalloc.h
@@ -53,6 +53,7 @@ void zs_unmap_object(struct zs_pool *poo
 
 unsigned long zs_get_total_pages(struct zs_pool *pool);
 unsigned long zs_compact(struct zs_pool *pool);
+unsigned long zs_pages_to_compact(struct zs_pool *pool);
 
 void zs_pool_stats(struct zs_pool *pool, struct zs_pool_stats *stats);
 #endif
diff -puN mm/zsmalloc.c~zsmalloc-factor-out-zs_pages_to_compact mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-factor-out-zs_pages_to_compact
+++ a/mm/zsmalloc.c
@@ -1798,6 +1798,28 @@ void zs_pool_stats(struct zs_pool *pool,
 }
 EXPORT_SYMBOL_GPL(zs_pool_stats);
 
+unsigned long zs_pages_to_compact(struct zs_pool *pool)
+{
+	unsigned long pages_to_free = 0;
+	int i;
+	struct size_class *class;
+
+	for (i = zs_size_classes - 1; i >= 0; i--) {
+		class = pool->size_class[i];
+		if (!class)
+			continue;
+		if (class->index != i)
+			continue;
+
+		spin_lock(&class->lock);
+		pages_to_free += zs_can_compact(class);
+		spin_unlock(&class->lock);
+	}
+
+	return pages_to_free;
+}
+EXPORT_SYMBOL_GPL(zs_pages_to_compact);
+
 static unsigned long zs_shrinker_scan(struct shrinker *shrinker,
 		struct shrink_control *sc)
 {
@@ -1819,28 +1841,13 @@ static unsigned long zs_shrinker_scan(st
 static unsigned long zs_shrinker_count(struct shrinker *shrinker,
 		struct shrink_control *sc)
 {
-	int i;
-	struct size_class *class;
-	unsigned long pages_to_free = 0;
 	struct zs_pool *pool = container_of(shrinker, struct zs_pool,
 			shrinker);
 
 	if (!pool->shrinker_enabled)
 		return 0;
 
-	for (i = zs_size_classes - 1; i >= 0; i--) {
-		class = pool->size_class[i];
-		if (!class)
-			continue;
-		if (class->index != i)
-			continue;
-
-		spin_lock(&class->lock);
-		pages_to_free += zs_can_compact(class);
-		spin_unlock(&class->lock);
-	}
