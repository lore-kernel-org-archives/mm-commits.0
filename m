From: akpm@linux-foundation.org
Subject: + mm-cma-add-functions-to-get-region-pages-counters.patch added
 to -mm tree
Date: Fri, 03 Apr 2015 14:58:38 -0700
Message-ID: <551f0d0e.JIRWlJtsylpwrUgr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49030 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbbDCV6j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Apr 2015 17:58:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: d.safonov@partner.samsung.com, a.mateosian@samsung.com, iamjoonsoo.kim@lge.com, laurent.pinchart+renesas@ideasonboard.com, m.szyprowski@samsung.com, mina86@mina86.com, pintu.k@samsung.com, stefan.strogin@gmail.com, v.tyrtov@samsung.com, weijie.yang@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: add functions to get region pages counters
has been added to the -mm tree.  Its filename is
     mm-cma-add-functions-to-get-region-pages-counters.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-add-functions-to-get-region-pages-counters.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-add-functions-to-get-region-pages-counters.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dmitry Safonov <d.safonov@partner.samsung.com>
Subject: mm: cma: add functions to get region pages counters

Here are two functions that provide interface to compute/get used size and
size of biggest free chunk in cma region.  Add that information to
debugfs.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cma.h |    2 ++
 mm/cma.c            |   30 ++++++++++++++++++++++++++++++
 mm/cma_debug.c      |   24 ++++++++++++++++++++++++
 3 files changed, 56 insertions(+)

diff -puN include/linux/cma.h~mm-cma-add-functions-to-get-region-pages-counters include/linux/cma.h
--- a/include/linux/cma.h~mm-cma-add-functions-to-get-region-pages-counters
+++ a/include/linux/cma.h
@@ -18,6 +18,8 @@ struct cma;
 extern unsigned long totalcma_pages;
 extern phys_addr_t cma_get_base(const struct cma *cma);
 extern unsigned long cma_get_size(const struct cma *cma);
+extern unsigned long cma_get_used(struct cma *cma);
+extern unsigned long cma_get_maxchunk(struct cma *cma);
 
 extern int __init cma_declare_contiguous(phys_addr_t base,
 			phys_addr_t size, phys_addr_t limit,
diff -puN mm/cma.c~mm-cma-add-functions-to-get-region-pages-counters mm/cma.c
--- a/mm/cma.c~mm-cma-add-functions-to-get-region-pages-counters
+++ a/mm/cma.c
@@ -53,6 +53,36 @@ unsigned long cma_get_size(const struct
 	return cma->count << PAGE_SHIFT;
 }
 
+unsigned long cma_get_used(struct cma *cma)
+{
+	unsigned long ret = 0;
+
+	mutex_lock(&cma->lock);
+	/* pages counter is smaller than sizeof(int) */
+	ret = bitmap_weight(cma->bitmap, (int)cma->count);
+	mutex_unlock(&cma->lock);
+
+	return ret << cma->order_per_bit;
+}
+
+unsigned long cma_get_maxchunk(struct cma *cma)
+{
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
+
+	return maxchunk << cma->order_per_bit;
+}
+
 static unsigned long cma_bitmap_aligned_mask(const struct cma *cma,
 					     int align_order)
 {
diff -puN mm/cma_debug.c~mm-cma-add-functions-to-get-region-pages-counters mm/cma_debug.c
--- a/mm/cma_debug.c~mm-cma-add-functions-to-get-region-pages-counters
+++ a/mm/cma_debug.c
@@ -33,6 +33,28 @@ static int cma_debugfs_get(void *data, u
 
 DEFINE_SIMPLE_ATTRIBUTE(cma_debugfs_fops, cma_debugfs_get, NULL, "%llu\n");
 
+static int cma_used_get(void *data, u64 *val)
+{
+	struct cma *cma = data;
+
+	*val = cma_get_used(cma);
+
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(cma_used_fops, cma_used_get, NULL, "%llu\n");
+
+static int cma_maxchunk_get(void *data, u64 *val)
+{
+	struct cma *cma = data;
+
+	*val = cma_get_maxchunk(cma);
+
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(cma_maxchunk_fops, cma_maxchunk_get, NULL, "%llu\n");
+
 static void cma_add_to_cma_mem_list(struct cma *cma, struct cma_mem *mem)
 {
 	spin_lock(&cma->mem_head_lock);
@@ -149,6 +171,8 @@ static void cma_debugfs_add_one(struct c
 				&cma->count, &cma_debugfs_fops);
 	debugfs_create_file("order_per_bit", S_IRUGO, tmp,
 				&cma->order_per_bit, &cma_debugfs_fops);
+	debugfs_create_file("used", S_IRUGO, tmp, cma, &cma_used_fops);
+	debugfs_create_file("maxchunk", S_IRUGO, tmp, cma, &cma_maxchunk_fops);
 
 	u32s = DIV_ROUND_UP(cma_bitmap_maxno(cma), BITS_PER_BYTE * sizeof(u32));
 	debugfs_create_u32_array("bitmap", S_IRUGO, tmp, (u32*)cma->bitmap, u32s);
_

Patches currently in -mm which might be from d.safonov@partner.samsung.com are

mm-cma-add-functions-to-get-region-pages-counters.patch
mm-cma-add-functions-to-get-region-pages-counters-fix.patch

