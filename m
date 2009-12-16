From: akpm@linux-foundation.org
Subject: [merged] genalloc-use-bitmap_find_next_zero_area.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:41:43 -0800
Message-ID: <200912162041.nBGKfhkb013839@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753053AbZLPUlp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:41:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, mm-commits@vger.kernel.org


The patch titled
     genalloc: use bitmap_find_next_zero_area
has been removed from the -mm tree.  Its filename was
     genalloc-use-bitmap_find_next_zero_area.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: genalloc: use bitmap_find_next_zero_area
From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/genalloc.c |   33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff -puN lib/genalloc.c~genalloc-use-bitmap_find_next_zero_area lib/genalloc.c
--- a/lib/genalloc.c~genalloc-use-bitmap_find_next_zero_area
+++ a/lib/genalloc.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/bitmap.h>
 #include <linux/genalloc.h>
 
 
@@ -114,7 +115,7 @@ unsigned long gen_pool_alloc(struct gen_
 	struct gen_pool_chunk *chunk;
 	unsigned long addr, flags;
 	int order = pool->min_alloc_order;
-	int nbits, bit, start_bit, end_bit;
+	int nbits, start_bit, end_bit;
 
 	if (size == 0)
 		return 0;
@@ -129,29 +130,19 @@ unsigned long gen_pool_alloc(struct gen_
 		end_bit -= nbits + 1;
 
 		spin_lock_irqsave(&chunk->lock, flags);
-		bit = -1;
-		while (bit + 1 < end_bit) {
-			bit = find_next_zero_bit(chunk->bits, end_bit, bit + 1);
-			if (bit >= end_bit)
-				break;
-
-			start_bit = bit;
-			if (nbits > 1) {
-				bit = find_next_bit(chunk->bits, bit + nbits,
-							bit + 1);
-				if (bit - start_bit < nbits)
-					continue;
-			}
-
-			addr = chunk->start_addr +
-					    ((unsigned long)start_bit << order);
-			while (nbits--)
-				__set_bit(start_bit++, chunk->bits);
+		start_bit = bitmap_find_next_zero_area(chunk->bits, end_bit, 0,
+						nbits, 0);
+		if (start_bit >= end_bit) {
 			spin_unlock_irqrestore(&chunk->lock, flags);
-			read_unlock(&pool->lock);
-			return addr;
+			continue;
 		}
+
+		addr = chunk->start_addr + ((unsigned long)start_bit << order);
+
+		bitmap_set(chunk->bits, start_bit, nbits);
 		spin_unlock_irqrestore(&chunk->lock, flags);
+		read_unlock(&pool->lock);
+		return addr;
 	}
 	read_unlock(&pool->lock);
 	return 0;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
x86-optimize-hweight32.patch
ntfs-use-bitmap_weight.patch

