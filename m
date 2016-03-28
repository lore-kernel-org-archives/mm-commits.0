From: akpm@linux-foundation.org
Subject: + zsmalloc-remove-unused-pool-param-in-obj_free.patch added to
 -mm tree
Date: Mon, 28 Mar 2016 13:22:25 -0700
Message-ID: <56f99281.CXHlmWQvA6DZlll3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53131 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbcC1UW0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2016 16:22:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: remove unused pool param in obj_free
has been added to the -mm tree.  Its filename is
     zsmalloc-remove-unused-pool-param-in-obj_free.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-remove-unused-pool-param-in-obj_free.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-remove-unused-pool-param-in-obj_free.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

zsmalloc-use-first_page-rather-than-page.patch
zsmalloc-clean-up-many-bug_on.patch
zsmalloc-reordering-function-parameter.patch
zsmalloc-remove-unused-pool-param-in-obj_free.patch

