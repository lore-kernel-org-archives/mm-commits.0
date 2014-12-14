From: akpm@linux-foundation.org
Subject: [merged]
 mm-zsmalloc-avoid-duplicate-assignment-of-prev_class.patch removed from -mm tree
Date: Sat, 13 Dec 2014 20:08:56 -0800
Message-ID: <548d0d58.C936PrNcasUwXFc2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47778 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaLNEIt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:08:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: opensource.ganesh@gmail.com, ddstreet@ieee.org, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: avoid duplicate assignment of prev_class
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-avoid-duplicate-assignment-of-prev_class.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ganesh Mahendran <opensource.ganesh@gmail.com>
Subject: mm/zsmalloc: avoid duplicate assignment of prev_class

In zs_create_pool(), prev_class is assigned (ZS_SIZE_CLASSES - 1) times. 
And the prev_class only references to the previous size_class.  So we do
not need unnecessary assignement.

This patch assigns *prev_class* when a new size_class structure is
allocated and uses prev_class to check whether the first class has been
allocated.

[akpm@linux-foundation.org: remove now-unused ZS_SIZE_CLASSES]
Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Reviewed-by: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-avoid-duplicate-assignment-of-prev_class mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-avoid-duplicate-assignment-of-prev_class
+++ a/mm/zsmalloc.c
@@ -155,8 +155,6 @@
  *  (reason above)
  */
 #define ZS_SIZE_CLASS_DELTA	(PAGE_SIZE >> 8)
-#define ZS_SIZE_CLASSES		((ZS_MAX_ALLOC_SIZE - ZS_MIN_ALLOC_SIZE) / \
-					ZS_SIZE_CLASS_DELTA + 1)
 
 /*
  * We do not maintain any list for completely empty or full pages
@@ -983,6 +981,7 @@ struct zs_pool *zs_create_pool(gfp_t fla
 {
 	int i, ovhd_size;
 	struct zs_pool *pool;
+	struct size_class *prev_class = NULL;
 
 	ovhd_size = roundup(sizeof(*pool), PAGE_SIZE);
 	pool = kzalloc(ovhd_size, GFP_KERNEL);
@@ -1004,7 +1003,6 @@ struct zs_pool *zs_create_pool(gfp_t fla
 		int size;
 		int pages_per_zspage;
 		struct size_class *class;
-		struct size_class *prev_class;
 
 		size = ZS_MIN_ALLOC_SIZE + i * ZS_SIZE_CLASS_DELTA;
 		if (size > ZS_MAX_ALLOC_SIZE)
@@ -1020,8 +1018,7 @@ struct zs_pool *zs_create_pool(gfp_t fla
 		 * characteristics. So, we makes size_class point to
 		 * previous size_class if possible.
 		 */
-		if (i < ZS_SIZE_CLASSES - 1) {
-			prev_class = pool->size_class[i + 1];
+		if (prev_class) {
 			if (can_merge(prev_class, size, pages_per_zspage)) {
 				pool->size_class[i] = prev_class;
 				continue;
@@ -1037,6 +1034,8 @@ struct zs_pool *zs_create_pool(gfp_t fla
 		class->pages_per_zspage = pages_per_zspage;
 		spin_lock_init(&class->lock);
 		pool->size_class[i] = class;
+
+		prev_class = class;
 	}
 
 	pool->flags = flags;
_

Patches currently in -mm which might be from opensource.ganesh@gmail.com are

origin.patch

