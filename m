From: akpm@linux-foundation.org
Subject: [nacked]
 mm-zsmalloc-avoid-duplicate-assignment-of-prev_class.patch removed from -mm tree
Date: Mon, 24 Nov 2014 13:54:05 -0800
Message-ID: <5473a8fd.aU7c4C0KMRATXw6F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaKXVxn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Nov 2014 16:53:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: opensource.ganesh@gmail.com, ddstreet@ieee.org, iamjoonsoo.kim@lge.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: avoid duplicate assignment of prev_class
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-avoid-duplicate-assignment-of-prev_class.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Mahendran Ganesh <opensource.ganesh@gmail.com>
Subject: mm/zsmalloc: avoid duplicate assignment of prev_class

In zs_create_pool(), prev_class is assigned (ZS_SIZE_CLASSES - 1) times. 
And the prev_class only references to the previous size_class.  So we do
not need unnecessary assignement.

This patch assigns *prev_class* when a new size_class structure is
allocated and uses prev_class to check whether the first class has been
allocated.

Signed-off-by: Mahendran Ganesh <opensource.ganesh@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-avoid-duplicate-assignment-of-prev_class mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-avoid-duplicate-assignment-of-prev_class
+++ a/mm/zsmalloc.c
@@ -980,7 +980,7 @@ struct zs_pool *zs_create_pool(gfp_t fla
 		int size;
 		int pages_per_zspage;
 		struct size_class *class;
-		struct size_class *prev_class;
+		struct size_class *prev_class = NULL;
 
 		size = ZS_MIN_ALLOC_SIZE + i * ZS_SIZE_CLASS_DELTA;
 		if (size > ZS_MAX_ALLOC_SIZE)
@@ -996,8 +996,7 @@ struct zs_pool *zs_create_pool(gfp_t fla
 		 * characteristics. So, we makes size_class point to
 		 * previous size_class if possible.
 		 */
-		if (i < ZS_SIZE_CLASSES - 1) {
-			prev_class = pool->size_class[i + 1];
+		if (prev_class) {
 			if (can_merge(prev_class, size, pages_per_zspage)) {
 				pool->size_class[i] = prev_class;
 				continue;
@@ -1013,6 +1012,8 @@ struct zs_pool *zs_create_pool(gfp_t fla
 		class->pages_per_zspage = pages_per_zspage;
 		spin_lock_init(&class->lock);
 		pool->size_class[i] = class;
+
+		prev_class = class;
 	}
 
 	pool->flags = flags;
_

Patches currently in -mm which might be from opensource.ganesh@gmail.com are

zsmalloc-fix-zs_init-cpu-notifier-error-handling.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix-2.patch
zsmalloc-fix-zs_init-cpu-notifier-error-handling-fix.patch
mm-zram-correct-zram_zero-flag-bit-position.patch
mm-zswap-add-__init-to-some-functions-in-zswap.patch

