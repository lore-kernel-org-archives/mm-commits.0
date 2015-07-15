From: akpm@linux-foundation.org
Subject: + mm-cma_debug-correct-size-input-to-bitmap-function.patch added
 to -mm tree
Date: Wed, 15 Jul 2015 14:18:08 -0700
Message-ID: <55a6ce10.9x3BpBgW1zf/AE3z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56509 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbbGOVSJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jul 2015 17:18:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, iamjoonsoo.kim@lge.com, mina86@mina86.com, sasha.levin@oracle.com, stefan.strogin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma_debug: correct size input to bitmap function
has been added to the -mm tree.  Its filename is
     mm-cma_debug-correct-size-input-to-bitmap-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma_debug-correct-size-input-to-bitmap-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma_debug-correct-size-input-to-bitmap-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-page_owner-fix-possible-access-violation.patch
mm-page_owner-set-correct-gfp_mask-on-page_owner.patch
mm-cma_debug-fix-debugging-alloc-free-interface.patch
mm-cma_debug-correct-size-input-to-bitmap-function.patch

