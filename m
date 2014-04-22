From: akpm@linux-foundation.org
Subject: + ida-in-place-ida-allocation.patch added to -mm tree
Date: Tue, 22 Apr 2014 12:44:55 -0700
Message-ID: <5356c6b7.+yD3fyT8ltNlQwuM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48900 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbaDVTo4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Apr 2014 15:44:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, laijs@cn.fujitsu.com

Subject: + ida-in-place-ida-allocation.patch added to -mm tree
To: laijs@cn.fujitsu.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 22 Apr 2014 12:44:55 -0700


The patch titled
     Subject: ida: in-place ida allocation
has been added to the -mm tree.  Its filename is
     ida-in-place-ida-allocation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ida-in-place-ida-allocation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ida-in-place-ida-allocation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: ida: in-place ida allocation

There are two stages of ida allocation/free, idr_layers and ida_bitmap. 
They add unneeded foot print and memory waste.

When a single ID is first allocated from an ida, this ida requires two big
chunks of memory.  One idr_layer and one ida_bitmap.

To reduce the footprint and memory, we reduce the ida_bitmap to a single
"unsigned long" and place it in its own idr-slot and avoid allocating the
ida_bitmap.

It also means ida bitmap is located on its corresponding idr-slot which
has the same size as "unsigned long".  Each ida bitmap(idr-slot) contains
BITS_PER_LONG ida-slots.

The struct ida_bitmap is not needed any more, we use "unsigned long"
directly and remove all the code of alloc/free struct ida_bitmap.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |   15 -------
 lib/idr.c           |   85 ++++++++++--------------------------------
 2 files changed, 23 insertions(+), 77 deletions(-)

diff -puN include/linux/idr.h~ida-in-place-ida-allocation include/linux/idr.h
--- a/include/linux/idr.h~ida-in-place-ida-allocation
+++ a/include/linux/idr.h
@@ -135,25 +135,12 @@ static inline void *idr_find(struct idr
 /*
  * IDA - IDR based id allocator, use when translation from id to
  * pointer isn't necessary.
- *
- * IDA_BITMAP_LONGS is calculated to be one less to accommodate
- * ida_bitmap->nr_busy so that the whole struct fits in 128 bytes.
  */
-#define IDA_CHUNK_SIZE		128	/* 128 bytes per chunk */
-#define IDA_BITMAP_LONGS	(IDA_CHUNK_SIZE / sizeof(long) - 1)
-#define IDA_BITMAP_BITS 	(IDA_BITMAP_LONGS * sizeof(long) * 8)
-
-struct ida_bitmap {
-	long			nr_busy;
-	unsigned long		bitmap[IDA_BITMAP_LONGS];
-};
-
 struct ida {
 	struct idr		idr;
-	struct ida_bitmap	*free_bitmap;
 };
 
-#define IDA_INIT(name)		{ .idr = IDR_INIT((name).idr), .free_bitmap = NULL, }
+#define IDA_INIT(name)		{ .idr = IDR_INIT((name).idr), }
 #define DEFINE_IDA(name)	struct ida name = IDA_INIT(name)
 
 int ida_pre_get(struct ida *ida, gfp_t gfp_mask);
diff -puN lib/idr.c~ida-in-place-ida-allocation lib/idr.c
--- a/lib/idr.c~ida-in-place-ida-allocation
+++ a/lib/idr.c
@@ -861,27 +861,15 @@ EXPORT_SYMBOL(idr_is_empty);
  *
  * This is id allocator without id -> pointer translation.  Memory
  * usage is much lower than full blown idr because each id only
- * occupies a bit.  ida uses a custom leaf node which contains
- * IDA_BITMAP_BITS slots.
+ * occupies a bit.  ida uses the leaf idr-slot which contains
+ * IDA_BITMAP_BITS(BITS_PER_LONG) ida-slots.
  *
  * 2007-04-25  written by Tejun Heo <htejun@gmail.com>
  */
 
-static void free_bitmap(struct ida *ida, struct ida_bitmap *bitmap)
-{
-	unsigned long flags;
-
-	if (!ida->free_bitmap) {
-		spin_lock_irqsave(&ida->idr.lock, flags);
-		if (!ida->free_bitmap) {
-			ida->free_bitmap = bitmap;
-			bitmap = NULL;
-		}
-		spin_unlock_irqrestore(&ida->idr.lock, flags);
-	}
-
-	kfree(bitmap);
-}
+#define IDA_BITMAP_BITS 	BITS_PER_LONG
+#define IDA_BITMAP_EMPTY	0UL
+#define IDA_BITMAP_FULL		(~0UL)
 
 /**
  * ida_pre_get - reserve resources for ida allocation
@@ -898,21 +886,7 @@ static void free_bitmap(struct ida *ida,
 int ida_pre_get(struct ida *ida, gfp_t gfp_mask)
 {
 	/* allocate idr_layers */
-	if (!__idr_pre_get(&ida->idr, gfp_mask))
-		return 0;
-
-	/* allocate free_bitmap */
-	if (!ida->free_bitmap) {
-		struct ida_bitmap *bitmap;
-
-		bitmap = kmalloc(sizeof(struct ida_bitmap), gfp_mask);
-		if (!bitmap)
-			return 0;
-
-		free_bitmap(ida, bitmap);
-	}
-
-	return 1;
+	return __idr_pre_get(&ida->idr, gfp_mask);
 }
 EXPORT_SYMBOL(ida_pre_get);
 
@@ -934,8 +908,7 @@ EXPORT_SYMBOL(ida_pre_get);
 int ida_get_new_above(struct ida *ida, int starting_id, int *p_id)
 {
 	struct idr_layer *pa[MAX_IDR_LEVEL + 1];
-	struct ida_bitmap *bitmap;
-	unsigned long flags;
+	unsigned long *bitmap;
 	int idr_id = starting_id / IDA_BITMAP_BITS;
 	int offset = starting_id % IDA_BITMAP_BITS;
 	int t, id;
@@ -953,25 +926,11 @@ int ida_get_new_above(struct ida *ida, i
 		offset = 0;
 	idr_id = t;
 
-	/* if bitmap isn't there, create a new one */
-	bitmap = (void *)pa[0]->ary[idr_id & IDR_MASK];
-	if (!bitmap) {
-		spin_lock_irqsave(&ida->idr.lock, flags);
-		bitmap = ida->free_bitmap;
-		ida->free_bitmap = NULL;
-		spin_unlock_irqrestore(&ida->idr.lock, flags);
-
-		if (!bitmap)
-			return -EAGAIN;
-
-		memset(bitmap, 0, sizeof(struct ida_bitmap));
-		rcu_assign_pointer(pa[0]->ary[idr_id & IDR_MASK],
-				(void *)bitmap);
-		pa[0]->count++;
-	}
+	/* the lelf idr-slot is the bitmap for ida slots */
+	bitmap = (void *)&pa[0]->ary[idr_id & IDR_MASK];
 
 	/* lookup for empty slot */
-	t = find_next_zero_bit(bitmap->bitmap, IDA_BITMAP_BITS, offset);
+	t = find_next_zero_bit(bitmap, IDA_BITMAP_BITS, offset);
 	if (t == IDA_BITMAP_BITS) {
 		/* no empty slot after offset, continue to the next chunk */
 		idr_id++;
@@ -983,18 +942,21 @@ int ida_get_new_above(struct ida *ida, i
 	if (id >= MAX_IDR_BIT)
 		return -ENOSPC;
 
-	__set_bit(t, bitmap->bitmap);
-	if (++bitmap->nr_busy == IDA_BITMAP_BITS)
+	if (*bitmap == IDA_BITMAP_EMPTY)
+		pa[0]->count++;
+
+	__set_bit(t, bitmap);
+	if (*bitmap == IDA_BITMAP_FULL)
 		idr_mark_full(pa, idr_id);
 
 	*p_id = id;
 
-	/* Each leaf node can handle nearly a thousand slots and the
+	/* Each leaf idr_layer can handle nearly a thousand slots and the
 	 * whole idea of ida is to have small memory foot print.
 	 * Throw away extra resources one by one after each successful
 	 * allocation.
 	 */
-	if (ida->idr.id_free_cnt || ida->free_bitmap) {
+	if (ida->idr.id_free_cnt) {
 		struct idr_layer *p = get_from_free_list(&ida->idr);
 		if (p)
 			kmem_cache_free(idr_layer_cache, p);
@@ -1016,7 +978,7 @@ void ida_remove(struct ida *ida, int id)
 	int idr_id = id / IDA_BITMAP_BITS;
 	int offset = id % IDA_BITMAP_BITS;
 	int n;
-	struct ida_bitmap *bitmap;
+	unsigned long *bitmap;
 
 	if (id < 0 || idr_id > idr_max(ida->idr.layers))
 		goto err;
@@ -1035,16 +997,15 @@ void ida_remove(struct ida *ida, int id)
 	n = idr_id & IDR_MASK;
 	__clear_bit(n, p->bitmap);
 
-	bitmap = (void *)p->ary[n];
-	if (!bitmap || !test_bit(offset, bitmap->bitmap))
+	bitmap = (void *)&p->ary[n];
+	if (!test_bit(offset, bitmap))
 		goto err;
 
 	/* update bitmap and remove it if empty */
-	__clear_bit(offset, bitmap->bitmap);
-	if (--bitmap->nr_busy == 0) {
+	__clear_bit(offset, bitmap);
+	if (*bitmap == IDA_BITMAP_EMPTY) {
 		__set_bit(n, p->bitmap);	/* to please idr_remove() */
 		idr_remove(&ida->idr, idr_id);
-		free_bitmap(ida, bitmap);
 	}
 
 	return;
@@ -1061,7 +1022,6 @@ EXPORT_SYMBOL(ida_remove);
 void ida_destroy(struct ida *ida)
 {
 	idr_destroy(&ida->idr);
-	kfree(ida->free_bitmap);
 }
 EXPORT_SYMBOL(ida_destroy);
 
@@ -1144,7 +1104,6 @@ EXPORT_SYMBOL(ida_simple_remove);
  */
 void ida_init(struct ida *ida)
 {
-	memset(ida, 0, sizeof(struct ida));
 	idr_init(&ida->idr);
 
 }
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

mem-hotplug-implement-get-put_online_mems.patch
slab-get_online_mems-for-kmem_cache_createdestroyshrink.patch
idr-fix-overflow-bug-during-maximum-id-calculation-at-maximum-height.patch
idr-fix-unexpected-id-removal-when-idr_removeunallocated_id.patch
idr-fix-null-pointer-dereference-when-ida_removeunallocated_id.patch
idr-fix-idr_replaces-returned-error-code.patch
idr-dont-need-to-shink-the-free-list-when-idr_remove.patch
idr-reduce-the-unneeded-check-in-free_layer.patch
idr-proper-invalid-argument-handling.patch
idr-reduce-the-number-of-max_idr_free.patch
ida-in-place-ida-allocation.patch
idr-reorder-the-fields.patch
linux-next.patch

