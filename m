From: akpm@linux-foundation.org
Subject: + mm-zsmalloc-keep-comments-consistent-with-code.patch added to
 -mm tree
Date: Fri, 08 Jul 2016 14:16:43 -0700
Message-ID: <5780183b.XXmpInDpz4sqoOcp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43487 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbcGHVQo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2016 17:16:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: opensource.ganesh@gmail.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: keep comments consistent with code
has been added to the -mm tree.  Its filename is
     mm-zsmalloc-keep-comments-consistent-with-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zsmalloc-keep-comments-consistent-with-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zsmalloc-keep-comments-consistent-with-code.patch

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
Subject: mm/zsmalloc: keep comments consistent with code

some minor change of comments:
1). update zs_malloc(),zs_create_pool() function header
2). update "Usage of struct page fields"

Link: http://lkml.kernel.org/r/1467882338-4300-5-git-send-email-opensource.ganesh@gmail.com
Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-keep-comments-consistent-with-code mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-keep-comments-consistent-with-code
+++ a/mm/zsmalloc.c
@@ -20,6 +20,7 @@
  *	page->freelist(index): links together all component pages of a zspage
  *		For the huge page, this is always 0, so we use this field
  *		to store handle.
+ *	page->units: first object offset in a subpage of zspage
  *
  * Usage of struct page flags:
  *	PG_private: identifies the first component page
@@ -140,9 +141,6 @@
  */
 #define ZS_SIZE_CLASS_DELTA	(PAGE_SIZE >> CLASS_BITS)
 
-/*
- * We do not maintain any list for completely empty or full pages
- */
 enum fullness_group {
 	ZS_EMPTY,
 	ZS_ALMOST_EMPTY,
@@ -1535,6 +1533,7 @@ static unsigned long obj_malloc(struct s
  * zs_malloc - Allocate block of given size from pool.
  * @pool: pool to allocate from
  * @size: size of block to allocate
+ * @gfp: gfp flags when allocating object
  *
  * On success, handle to the allocated object is returned,
  * otherwise 0.
@@ -2401,7 +2400,7 @@ static int zs_register_shrinker(struct z
 
 /**
  * zs_create_pool - Creates an allocation pool to work from.
- * @flags: allocation flags used to allocate pool metadata
+ * @name: pool name to be created
  *
  * This function must be called before anything when using
  * the zsmalloc allocator.
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

