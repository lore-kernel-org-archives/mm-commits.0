From: akpm@linux-foundation.org
Subject: + mm-zsmalloc-use-obj_index-to-keep-consistent-with-others.patch
 added to -mm tree
Date: Fri, 08 Jul 2016 14:16:35 -0700
Message-ID: <57801833.P+sogMvLOqh6Wg6J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43477 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604AbcGHVQg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2016 17:16:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: opensource.ganesh@gmail.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: use obj_index to keep consistent with others
has been added to the -mm tree.  Its filename is
     mm-zsmalloc-use-obj_index-to-keep-consistent-with-others.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zsmalloc-use-obj_index-to-keep-consistent-with-others.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zsmalloc-use-obj_index-to-keep-consistent-with-others.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ganesh Mahendran <opensource.ganesh@gmail.com>
Subject: mm/zsmalloc: use obj_index to keep consistent with others

This is a cleanup patch. Change "index" to "obj_index" to keep
consistent with others in zsmalloc.

Link: http://lkml.kernel.org/r/1467882338-4300-1-git-send-email-opensource.ganesh@gmail.com
Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-use-obj_index-to-keep-consistent-with-others mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-use-obj_index-to-keep-consistent-with-others
+++ a/mm/zsmalloc.c
@@ -1779,7 +1779,7 @@ struct zs_compact_control {
 	struct page *d_page;
 	 /* Starting object index within @s_page which used for live object
 	  * in the subpage. */
-	int index;
+	int obj_idx;
 };
 
 static int migrate_zspage(struct zs_pool *pool, struct size_class *class,
@@ -1789,16 +1789,16 @@ static int migrate_zspage(struct zs_pool
 	unsigned long handle;
 	struct page *s_page = cc->s_page;
 	struct page *d_page = cc->d_page;
-	unsigned long index = cc->index;
+	int obj_idx = cc->obj_idx;
 	int ret = 0;
 
 	while (1) {
-		handle = find_alloced_obj(class, s_page, index);
+		handle = find_alloced_obj(class, s_page, obj_idx);
 		if (!handle) {
 			s_page = get_next_page(s_page);
 			if (!s_page)
 				break;
-			index = 0;
+			obj_idx = 0;
 			continue;
 		}
 
@@ -1812,7 +1812,7 @@ static int migrate_zspage(struct zs_pool
 		used_obj = handle_to_obj(handle);
 		free_obj = obj_malloc(class, get_zspage(d_page), handle);
 		zs_object_copy(class, free_obj, used_obj);
-		index++;
+		obj_idx++;
 		/*
 		 * record_obj updates handle's value to free_obj and it will
 		 * invalidate lock bit(ie, HANDLE_PIN_BIT) of handle, which
@@ -1827,7 +1827,7 @@ static int migrate_zspage(struct zs_pool
 
 	/* Remember last position in this iteration */
 	cc->s_page = s_page;
-	cc->index = index;
+	cc->obj_idx = obj_idx;
 
 	return ret;
 }
@@ -2282,7 +2282,7 @@ static void __zs_compact(struct zs_pool
 		if (!zs_can_compact(class))
 			break;
 
-		cc.index = 0;
+		cc.obj_idx = 0;
 		cc.s_page = get_first_page(src_zspage);
 
 		while ((dst_zspage = isolate_zspage(class, false))) {
_

Patches currently in -mm which might be from opensource.ganesh@gmail.com are

mm-migrate-support-non-lru-movable-page-migration-fix.patch
mm-zsmalloc-add-trace-events-for-zs_compact.patch
mm-compaction-remove-unnecessary-order-check-in-try_to_compact_pages.patch
mm-zsmalloc-use-obj_index-to-keep-consistent-with-others.patch
mm-zsmalloc-take-obj-index-back-from-find_alloced_obj.patch
mm-zsmalloc-use-class-objs_per_zspage-to-get-num-of-max-objects.patch
mm-zsmalloc-avoid-calculate-max-objects-of-zspage-twice.patch
mm-zsmalloc-keep-comments-consistent-with-code.patch
mm-zsmalloc-add-__init__exit-attribute.patch
mm-zsmalloc-use-helper-to-clear-page-flags-bit.patch
mm-zsmalloc-add-per-class-compact-trace-event.patch

