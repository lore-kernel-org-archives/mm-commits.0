From: akpm@linux-foundation.org
Subject: [patch 064/101] mm/zsmalloc: use obj_index to keep consistent
 with others
Date: Thu, 28 Jul 2016 15:47:43 -0700
Message-ID: <579a8b8f.v71O4o+Pa9BknF13%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbcG1Wro (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:47:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, opensource.ganesh@gmail.com, minchan@kernel.org, sergey.senozhatsky@gmail.com

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
@@ -1776,7 +1776,7 @@ struct zs_compact_control {
 	struct page *d_page;
 	 /* Starting object index within @s_page which used for live object
 	  * in the subpage. */
-	int index;
+	int obj_idx;
 };
 
 static int migrate_zspage(struct zs_pool *pool, struct size_class *class,
@@ -1786,16 +1786,16 @@ static int migrate_zspage(struct zs_pool
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
 
@@ -1809,7 +1809,7 @@ static int migrate_zspage(struct zs_pool
 		used_obj = handle_to_obj(handle);
 		free_obj = obj_malloc(class, get_zspage(d_page), handle);
 		zs_object_copy(class, free_obj, used_obj);
-		index++;
+		obj_idx++;
 		/*
 		 * record_obj updates handle's value to free_obj and it will
 		 * invalidate lock bit(ie, HANDLE_PIN_BIT) of handle, which
@@ -1824,7 +1824,7 @@ static int migrate_zspage(struct zs_pool
 
 	/* Remember last position in this iteration */
 	cc->s_page = s_page;
-	cc->index = index;
+	cc->obj_idx = obj_idx;
 
 	return ret;
 }
@@ -2279,7 +2279,7 @@ static void __zs_compact(struct zs_pool
 		if (!zs_can_compact(class))
 			break;
 
-		cc.index = 0;
+		cc.obj_idx = 0;
 		cc.s_page = get_first_page(src_zspage);
 
 		while ((dst_zspage = isolate_zspage(class, false))) {
_
