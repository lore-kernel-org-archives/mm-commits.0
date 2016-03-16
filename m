From: akpm@linux-foundation.org
Subject: [merged] mm-slab-avoid-returning-values-by-reference.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:54:53 -0700
Message-ID: <56e9ba0d.ogMU9Uqzs8tBr6sM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38587 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933996AbcCPTyy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:54:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: avoid returning values by reference
has been removed from the -mm tree.  Its filename was
     mm-slab-avoid-returning-values-by-reference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: avoid returning values by reference

Returing values by reference is bad practice.  Instead, just use function
return value.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Suggested-by: Christoph Lameter <cl@linux.com>
Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN mm/slab.c~mm-slab-avoid-returning-values-by-reference mm/slab.c
--- a/mm/slab.c~mm-slab-avoid-returning-values-by-reference
+++ a/mm/slab.c
@@ -460,9 +460,10 @@ static inline struct array_cache *cpu_ca
 /*
  * Calculate the number of objects and left-over bytes for a given buffer size.
  */
-static void cache_estimate(unsigned long gfporder, size_t buffer_size,
-		unsigned long flags, size_t *left_over, unsigned int *num)
+static unsigned int cache_estimate(unsigned long gfporder, size_t buffer_size,
+		unsigned long flags, size_t *left_over)
 {
+	unsigned int num;
 	size_t slab_size = PAGE_SIZE << gfporder;
 
 	/*
@@ -483,13 +484,15 @@ static void cache_estimate(unsigned long
 	 * correct alignment when allocated.
 	 */
 	if (flags & (CFLGS_OBJFREELIST_SLAB | CFLGS_OFF_SLAB)) {
-		*num = slab_size / buffer_size;
+		num = slab_size / buffer_size;
 		*left_over = slab_size % buffer_size;
 	} else {
-		*num = slab_size / (buffer_size + sizeof(freelist_idx_t));
+		num = slab_size / (buffer_size + sizeof(freelist_idx_t));
 		*left_over = slab_size %
 			(buffer_size + sizeof(freelist_idx_t));
 	}
+
+	return num;
 }
 
 #if DEBUG
@@ -1893,7 +1896,7 @@ static size_t calculate_slab_order(struc
 		unsigned int num;
 		size_t remainder;
 
-		cache_estimate(gfporder, size, flags, &remainder, &num);
+		num = cache_estimate(gfporder, size, flags, &remainder);
 		if (!num)
 			continue;
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-vmalloc-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting-v2.patch
sound-query-dynamic-debug_pagealloc-setting.patch
powerpc-query-dynamic-debug_pagealloc-setting.patch
tile-query-dynamic-debug_pagealloc-setting.patch
mm-introduce-page-reference-manipulation-functions.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3.patch

