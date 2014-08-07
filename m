From: akpm@linux-foundation.org
Subject: [merged] mm-zbud-change-zbud_alloc-size-type-to-size_t.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:06:55 -0700
Message-ID: <53e3dc5f.Beil9LBuYGafxgAV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:58645 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaHGUG4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:06:56 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so843385oac.3
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:06:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, minchan@kernel.org, ngupta@vflare.org, sjennings@variantweb.net, weijie.yang@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zbud: change zbud_alloc size type to size_t
has been removed from the -mm tree.  Its filename was
     mm-zbud-change-zbud_alloc-size-type-to-size_t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: mm/zbud: change zbud_alloc size type to size_t

Change the type of the zbud_alloc() size param from unsigned int
to size_t.

Technically, this should not make any difference, as the zbud
implementation already restricts the size to well within either type's
limits; but as zsmalloc (and kmalloc) use size_t, and zpool will use
size_t, this brings the size parameter type in line with zsmalloc/zpool.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Acked-by: Seth Jennings <sjennings@variantweb.net>
Tested-by: Seth Jennings <sjennings@variantweb.net>
Cc: Weijie Yang <weijie.yang@samsung.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/zbud.h |    2 +-
 mm/zbud.c            |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/zbud.h~mm-zbud-change-zbud_alloc-size-type-to-size_t include/linux/zbud.h
--- a/include/linux/zbud.h~mm-zbud-change-zbud_alloc-size-type-to-size_t
+++ a/include/linux/zbud.h
@@ -11,7 +11,7 @@ struct zbud_ops {
 
 struct zbud_pool *zbud_create_pool(gfp_t gfp, struct zbud_ops *ops);
 void zbud_destroy_pool(struct zbud_pool *pool);
-int zbud_alloc(struct zbud_pool *pool, unsigned int size, gfp_t gfp,
+int zbud_alloc(struct zbud_pool *pool, size_t size, gfp_t gfp,
 	unsigned long *handle);
 void zbud_free(struct zbud_pool *pool, unsigned long handle);
 int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries);
diff -puN mm/zbud.c~mm-zbud-change-zbud_alloc-size-type-to-size_t mm/zbud.c
--- a/mm/zbud.c~mm-zbud-change-zbud_alloc-size-type-to-size_t
+++ a/mm/zbud.c
@@ -122,7 +122,7 @@ enum buddy {
 };
 
 /* Converts an allocation size in bytes to size in zbud chunks */
-static int size_to_chunks(int size)
+static int size_to_chunks(size_t size)
 {
 	return (size + CHUNK_SIZE - 1) >> CHUNK_SHIFT;
 }
@@ -247,7 +247,7 @@ void zbud_destroy_pool(struct zbud_pool
  * gfp arguments are invalid or -ENOMEM if the pool was unable to allocate
  * a new page.
  */
-int zbud_alloc(struct zbud_pool *pool, unsigned int size, gfp_t gfp,
+int zbud_alloc(struct zbud_pool *pool, size_t size, gfp_t gfp,
 			unsigned long *handle)
 {
 	int chunks, i, freechunks;
_

Patches currently in -mm which might be from ddstreet@ieee.org are

origin.patch

