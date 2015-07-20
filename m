From: akpm@linux-foundation.org
Subject: [merged] mm-cma_debug-correct-size-input-to-bitmap-function.patch removed from -mm tree
Date: Mon, 20 Jul 2015 11:50:39 -0700
Message-ID: <55ad42ff.Jd3ubs7rfPMc2QIN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34559 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbbGTSuk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Jul 2015 14:50:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, iamjoonsoo.kim@lge.com, mina86@mina86.com, sasha.levin@oracle.com, stefan.strogin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma_debug: correct size input to bitmap function
has been removed from the -mm tree.  Its filename was
     mm-cma_debug-correct-size-input-to-bitmap-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm/cma_debug: correct size input to bitmap function

In CMA, 1 bit in bitmap means 1 << order_per_bits pages so
size of bitmap is cma->count >> order_per_bits rather than
just cma->count. This patch fixes it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Stefan Strogin <stefan.strogin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma_debug.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/cma_debug.c~mm-cma_debug-correct-size-input-to-bitmap-function mm/cma_debug.c
--- a/mm/cma_debug.c~mm-cma_debug-correct-size-input-to-bitmap-function
+++ a/mm/cma_debug.c
@@ -39,7 +39,7 @@ static int cma_used_get(void *data, u64
 
 	mutex_lock(&cma->lock);
 	/* pages counter is smaller than sizeof(int) */
-	used = bitmap_weight(cma->bitmap, (int)cma->count);
+	used = bitmap_weight(cma->bitmap, (int)cma_bitmap_maxno(cma));
 	mutex_unlock(&cma->lock);
 	*val = (u64)used << cma->order_per_bit;
 
@@ -52,13 +52,14 @@ static int cma_maxchunk_get(void *data,
 	struct cma *cma = data;
 	unsigned long maxchunk = 0;
 	unsigned long start, end = 0;
+	unsigned long bitmap_maxno = cma_bitmap_maxno(cma);
 
 	mutex_lock(&cma->lock);
 	for (;;) {
-		start = find_next_zero_bit(cma->bitmap, cma->count, end);
+		start = find_next_zero_bit(cma->bitmap, bitmap_maxno, end);
 		if (start >= cma->count)
 			break;
-		end = find_next_bit(cma->bitmap, cma->count, start);
+		end = find_next_bit(cma->bitmap, bitmap_maxno, start);
 		maxchunk = max(end - start, maxchunk);
 	}
 	mutex_unlock(&cma->lock);
_

Patches currently in -mm which might be from js1304@gmail.com are


