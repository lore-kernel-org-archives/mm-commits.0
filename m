From: akpm@linux-foundation.org
Subject: + zsmalloc-cosmetic-compaction-code-adjustments.patch added to
 -mm tree
Date: Wed, 08 Jul 2015 15:37:56 -0700
Message-ID: <559da644.O7ZEN8v13ZpgdQOW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46001 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869AbbGHWh5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jul 2015 18:37:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: cosmetic compaction code adjustments
has been added to the -mm tree.  Its filename is
     zsmalloc-cosmetic-compaction-code-adjustments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-cosmetic-compaction-code-adjustments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-cosmetic-compaction-code-adjustments.patch

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
Subject: zsmalloc: cosmetic compaction code adjustments

Change zs_object_copy() argument order to be (DST, SRC) rather than (SRC,
DST).  copy/move functions usually have (to, from) arguments order.

Rename alloc_target_page() to isolate_target_page().  This function
doesn't allocate anything, it isolates target page, pretty much like
isolate_source_page().

Tweak __zs_compact() comment.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-cosmetic-compaction-code-adjustments mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-cosmetic-compaction-code-adjustments
+++ a/mm/zsmalloc.c
@@ -1471,7 +1471,7 @@ void zs_free(struct zs_pool *pool, unsig
 }
 EXPORT_SYMBOL_GPL(zs_free);
 
-static void zs_object_copy(unsigned long src, unsigned long dst,
+static void zs_object_copy(unsigned long dst, unsigned long src,
 				struct size_class *class)
 {
 	struct page *s_page, *d_page;
@@ -1612,7 +1612,7 @@ static int migrate_zspage(struct zs_pool
 
 		used_obj = handle_to_obj(handle);
 		free_obj = obj_malloc(d_page, class, handle);
-		zs_object_copy(used_obj, free_obj, class);
+		zs_object_copy(free_obj, used_obj, class);
 		index++;
 		record_obj(handle, free_obj);
 		unpin_tag(handle);
@@ -1628,7 +1628,7 @@ static int migrate_zspage(struct zs_pool
 	return ret;
 }
 
-static struct page *alloc_target_page(struct size_class *class)
+static struct page *isolate_target_page(struct size_class *class)
 {
 	int i;
 	struct page *page;
@@ -1718,11 +1718,11 @@ static unsigned long __zs_compact(struct
 		cc.index = 0;
 		cc.s_page = src_page;
 
-		while ((dst_page = alloc_target_page(class))) {
+		while ((dst_page = isolate_target_page(class))) {
 			cc.d_page = dst_page;
 			/*
-			 * If there is no more space in dst_page, try to
-			 * allocate another zspage.
+			 * If there is no more space in dst_page, resched
+			 * and see if anyone had allocated another zspage.
 			 */
 			if (!migrate_zspage(pool, class, &cc))
 				break;
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zsmalloc-drop-unused-variable-nr_to_migrate.patch
zsmalloc-always-keep-per-class-stats.patch
zsmalloc-introduce-zs_can_compact-function.patch
zsmalloc-cosmetic-compaction-code-adjustments.patch
zsmalloc-zram-introduce-zs_pool_stats-api.patch
zsmalloc-account-the-number-of-compacted-pages.patch
zsmalloc-use-shrinker-to-trigger-auto-compaction.patch

