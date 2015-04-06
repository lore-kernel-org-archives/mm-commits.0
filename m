From: akpm@linux-foundation.org
Subject: + mm-cma-add-functions-to-get-region-pages-counters-fix-2.patch
 added to -mm tree
Date: Mon, 06 Apr 2015 14:37:20 -0700
Message-ID: <5522fc90.8qgquaihj/4wiA1/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42004 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbbDFVhV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2015 17:37:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefan.strogin@gmail.com, a.mateosian@samsung.com, d.safonov@partner.samsung.com, iamjoonsoo.kim@lge.com, laurent.pinchart+renesas@ideasonboard.com, m.szyprowski@samsung.com, mina86@mina86.com, pintu.k@samsung.com, v.tyrtov@samsung.com, weijie.yang@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-cma-add-functions-to-get-region-pages-counters-fix-2
has been added to the -mm tree.  Its filename is
     mm-cma-add-functions-to-get-region-pages-counters-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-add-functions-to-get-region-pages-counters-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-add-functions-to-get-region-pages-counters-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stefan Strogin <stefan.strogin@gmail.com>
Subject: mm-cma-add-functions-to-get-region-pages-counters-fix-2

Move the code from cma_get_used() and cma_get_maxchunk() to cma_used_get()
and cma_maxchunk_get(), because cma_get_*() aren't used anywhere else, and
because of their confusing similar names.

Signed-off-by: Stefan Strogin <stefan.strogin@gmail.com>
Cc: Dmitry Safonov <d.safonov@partner.samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pintu Kumar <pintu.k@samsung.com>
Cc: Weijie Yang <weijie.yang@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Cc: Aleksei Mateosian <a.mateosian@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma_debug.c |   51 ++++++++++++++++-------------------------------
 1 file changed, 18 insertions(+), 33 deletions(-)

diff -puN mm/cma_debug.c~mm-cma-add-functions-to-get-region-pages-counters-fix-2 mm/cma_debug.c
--- a/mm/cma_debug.c~mm-cma-add-functions-to-get-region-pages-counters-fix-2
+++ a/mm/cma_debug.c
@@ -22,37 +22,6 @@ struct cma_mem {
 
 static struct dentry *cma_debugfs_root;
 
-static unsigned long cma_get_used(struct cma *cma)
-{
-	unsigned long ret = 0;
-
-	mutex_lock(&cma->lock);
-	/* pages counter is smaller than sizeof(int) */
-	ret = bitmap_weight(cma->bitmap, (int)cma->count);
-	mutex_unlock(&cma->lock);
-
-	return ret << cma->order_per_bit;
-}
-
-static unsigned long cma_get_maxchunk(struct cma *cma)
-{
-	unsigned long maxchunk = 0;
-	unsigned long start, end = 0;
-
-	mutex_lock(&cma->lock);
-	for (;;) {
-		start = find_next_zero_bit(cma->bitmap, cma->count, end);
-		if (start >= cma->count)
-			break;
-		end = find_next_bit(cma->bitmap, cma->count, start);
-		maxchunk = max(end - start, maxchunk);
-	}
-	mutex_unlock(&cma->lock);
-
-	return maxchunk << cma->order_per_bit;
-}
-
-
 static int cma_debugfs_get(void *data, u64 *val)
 {
 	unsigned long *p = data;
@@ -67,8 +36,13 @@ DEFINE_SIMPLE_ATTRIBUTE(cma_debugfs_fops
 static int cma_used_get(void *data, u64 *val)
 {
 	struct cma *cma = data;
+	unsigned long used;
 
-	*val = cma_get_used(cma);
+	mutex_lock(&cma->lock);
+	/* pages counter is smaller than sizeof(int) */
+	used = bitmap_weight(cma->bitmap, (int)cma->count);
+	mutex_unlock(&cma->lock);
+	*val = used << cma->order_per_bit;
 
 	return 0;
 }
@@ -78,8 +52,19 @@ DEFINE_SIMPLE_ATTRIBUTE(cma_used_fops, c
 static int cma_maxchunk_get(void *data, u64 *val)
 {
 	struct cma *cma = data;
+	unsigned long maxchunk = 0;
+	unsigned long start, end = 0;
 
-	*val = cma_get_maxchunk(cma);
+	mutex_lock(&cma->lock);
+	for (;;) {
+		start = find_next_zero_bit(cma->bitmap, cma->count, end);
+		if (start >= cma->count)
+			break;
+		end = find_next_bit(cma->bitmap, cma->count, start);
+		maxchunk = max(end - start, maxchunk);
+	}
+	mutex_unlock(&cma->lock);
+	*val = maxchunk << cma->order_per_bit;
 
 	return 0;
 }
_

Patches currently in -mm which might be from stefan.strogin@gmail.com are

mm-cma-add-trace-events-for-cma-allocations-and-freeings.patch
mm-cma-add-trace-events-for-cma-allocations-and-freeings-fix.patch
mm-cma-add-functions-to-get-region-pages-counters.patch
mm-cma-add-functions-to-get-region-pages-counters-fix.patch
mm-cma-add-functions-to-get-region-pages-counters-fix-2.patch
mm-cma_debugc-remove-blank-lines-before-define_simple_attribute.patch

