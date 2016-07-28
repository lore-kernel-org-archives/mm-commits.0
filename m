From: akpm@linux-foundation.org
Subject: [patch 068/101] mm/zsmalloc: keep comments consistent with code
Date: Thu, 28 Jul 2016 15:47:54 -0700
Message-ID: <579a8b9a.S+qA6WLrk8pJ0nWI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57119 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbcG1Wrz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2016 18:47:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, opensource.ganesh@gmail.com, minchan@kernel.org, sergey.senozhatsky@gmail.com

From: Ganesh Mahendran <opensource.ganesh@gmail.com>
Subject: mm/zsmalloc: keep comments consistent with code

Some minor commebnt changes:

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
@@ -137,9 +138,6 @@
  */
 #define ZS_SIZE_CLASS_DELTA	(PAGE_SIZE >> CLASS_BITS)
 
-/*
- * We do not maintain any list for completely empty or full pages
- */
 enum fullness_group {
 	ZS_EMPTY,
 	ZS_ALMOST_EMPTY,
@@ -1532,6 +1530,7 @@ static unsigned long obj_malloc(struct s
  * zs_malloc - Allocate block of given size from pool.
  * @pool: pool to allocate from
  * @size: size of block to allocate
+ * @gfp: gfp flags when allocating object
  *
  * On success, handle to the allocated object is returned,
  * otherwise 0.
@@ -2391,7 +2390,7 @@ static int zs_register_shrinker(struct z
 
 /**
  * zs_create_pool - Creates an allocation pool to work from.
- * @flags: allocation flags used to allocate pool metadata
+ * @name: pool name to be created
  *
  * This function must be called before anything when using
  * the zsmalloc allocator.
_
