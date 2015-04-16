From: akpm@linux-foundation.org
Subject: [merged] mm-cma-add-functions-to-get-region-pages-counters.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 09:52:56 -0700
Message-ID: <552fe8e8.UbBmTZp/VD2iTiws%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42849 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbbDPQr1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:47:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: d.safonov@partner.samsung.com, a.mateosian@samsung.com, iamjoonsoo.kim@lge.com, laurent.pinchart+renesas@ideasonboard.com, m.szyprowski@samsung.com, mina86@mina86.com, pintu.k@samsung.com, stefan.strogin@gmail.com, v.tyrtov@samsung.com, weijie.yang@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: add functions to get region pages counters
has been removed from the -mm tree.  Its filename was
     mm-cma-add-functions-to-get-region-pages-counters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Safonov <d.safonov@partner.samsung.com>
Subject: mm: cma: add functions to get region pages counters

Here are two functions that provide interface to compute/get used size and
size of biggest free chunk in cma region.  Add that information to
debugfs.

[akpm@linux-foundation.org: move debug code from cma.c into cma_debug.c]
[stefan.strogin@gmail.com: move code from cma_get_used() and cma_get_maxchunk() to cma_used_get() and cma_maxchunk_get()]
Signed-off-by: Dmitry Safonov <d.safonov@partner.samsung.com>
Signed-off-by: Stefan Strogin <stefan.strogin@gmail.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pintu Kumar <pintu.k@samsung.com>
Cc: Weijie Yang <weijie.yang@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Cc: Aleksei Mateosian <a.mateosian@samsung.com>
Signed-off-by: Stefan Strogin <stefan.strogin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma_debug.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff -puN mm/cma_debug.c~mm-cma-add-functions-to-get-region-pages-counters mm/cma_debug.c
--- a/mm/cma_debug.c~mm-cma-add-functions-to-get-region-pages-counters
+++ a/mm/cma_debug.c
@@ -33,6 +33,44 @@ static int cma_debugfs_get(void *data, u
 
 DEFINE_SIMPLE_ATTRIBUTE(cma_debugfs_fops, cma_debugfs_get, NULL, "%llu\n");
 
+static int cma_used_get(void *data, u64 *val)
+{
+	struct cma *cma = data;
+	unsigned long used;
+
+	mutex_lock(&cma->lock);
+	/* pages counter is smaller than sizeof(int) */
+	used = bitmap_weight(cma->bitmap, (int)cma->count);
+	mutex_unlock(&cma->lock);
+	*val = (u64)used << cma->order_per_bit;
+
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(cma_used_fops, cma_used_get, NULL, "%llu\n");
+
+static int cma_maxchunk_get(void *data, u64 *val)
+{
+	struct cma *cma = data;
+	unsigned long maxchunk = 0;
+	unsigned long start, end = 0;
+
+	mutex_lock(&cma->lock);
+	for (;;) {
+		start = find_next_zero_bit(cma->bitmap, cma->count, end);
+		if (start >= cma->count)
+			break;
+		end = find_next_bit(cma->bitmap, cma->count, start);
+		maxchunk = max(end - start, maxchunk);
+	}
+	mutex_unlock(&cma->lock);
+	*val = (u64)maxchunk << cma->order_per_bit;
+
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(cma_maxchunk_fops, cma_maxchunk_get, NULL, "%llu\n");
+
 static void cma_add_to_cma_mem_list(struct cma *cma, struct cma_mem *mem)
 {
 	spin_lock(&cma->mem_head_lock);
@@ -149,6 +187,8 @@ static void cma_debugfs_add_one(struct c
 				&cma->count, &cma_debugfs_fops);
 	debugfs_create_file("order_per_bit", S_IRUGO, tmp,
 				&cma->order_per_bit, &cma_debugfs_fops);
+	debugfs_create_file("used", S_IRUGO, tmp, cma, &cma_used_fops);
+	debugfs_create_file("maxchunk", S_IRUGO, tmp, cma, &cma_maxchunk_fops);
 
 	u32s = DIV_ROUND_UP(cma_bitmap_maxno(cma), BITS_PER_BYTE * sizeof(u32));
 	debugfs_create_u32_array("bitmap", S_IRUGO, tmp, (u32*)cma->bitmap, u32s);
_

Patches currently in -mm which might be from d.safonov@partner.samsung.com are

origin.patch

