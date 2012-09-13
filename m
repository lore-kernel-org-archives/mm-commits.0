From: akpm@linux-foundation.org
Subject: + genalloc-make-it-possible-to-use-a-custom-allocation-algorithm.patch added to -mm tree
Date: Thu, 13 Sep 2012 14:19:57 -0700
Message-ID: <20120913211958.37ABF5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:41983 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab2IMVUA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Sep 2012 17:20:00 -0400
Received: by eaac1 with SMTP id c1so216366eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 14:19:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benjamin.gaignard@linaro.org, benjamin.gaignard@stericsson.com, ying.huang@intel.com


The patch titled
     Subject: genalloc: make it possible to use a custom allocation algorithm
has been added to the -mm tree.  Its filename is
     genalloc-make-it-possible-to-use-a-custom-allocation-algorithm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: genalloc: make it possible to use a custom allocation algorithm

Premit use of another algorithm than the default first-fit one.  For
example a custom algorithm could be used to manage alignment requirements.

As I can't predict all the possible requirements/needs for all allocation
uses cases, I add a "free" field 'void *data' to pass any needed
information to the allocation function.  For example 'data' could be used
to handle a structure where you store the alignment, the expected memory
bank, the requester device, or any information that could influence the
allocation algorithm.

An usage example may look like this:
struct my_pool_constraints {
	int align;
	int bank;
	...
};

unsigned long my_custom_algo(unsigned long *map, unsigned long size,
		unsigned long start, unsigned int nr, void *data)
{
	struct my_pool_constraints *constraints = data;
	...
	deal with allocation contraints
	...
	return the index in bitmap where perform the allocation
}

void create_my_pool()
{
	struct my_pool_constraints c;
	struct gen_pool *pool = gen_pool_create(...);
	gen_pool_add(pool, ...);
	gen_pool_set_algo(pool, my_custom_algo, &c);
}

Add of best-fit algorithm function:
most of the time best-fit is slower then first-fit but memory fragmentation
is lower. The random buffer allocation/free tests don't show any arithmetic
relation between the allocation time and fragmentation but the
best-fit algorithm
is sometime able to perform the allocation when the first-fit can't.

This new algorithm help to remove static allocations on ESRAM, a small but
fast on-chip RAM of few KB, used for high-performance uses cases like DMA
linked lists, graphic accelerators, encoders/decoders. On the Ux500
(in the ARM tree) we have define 5 ESRAM banks of 128 KB each and use of
static allocations becomes unmaintainable:
cd arch/arm/mach-ux500 && grep -r ESRAM .
./include/mach/db8500-regs.h:/* Base address and bank offsets for ESRAM */
./include/mach/db8500-regs.h:#define U8500_ESRAM_BASE   0x40000000
./include/mach/db8500-regs.h:#define U8500_ESRAM_BANK_SIZE      0x00020000
./include/mach/db8500-regs.h:#define U8500_ESRAM_BANK0  U8500_ESRAM_BASE
./include/mach/db8500-regs.h:#define U8500_ESRAM_BANK1       (U8500_ESRAM_BASE + U8500_ESRAM_BANK_SIZE)
./include/mach/db8500-regs.h:#define U8500_ESRAM_BANK2       (U8500_ESRAM_BANK1 + U8500_ESRAM_BANK_SIZE)
./include/mach/db8500-regs.h:#define U8500_ESRAM_BANK3       (U8500_ESRAM_BANK2 + U8500_ESRAM_BANK_SIZE)
./include/mach/db8500-regs.h:#define U8500_ESRAM_BANK4       (U8500_ESRAM_BANK3 + U8500_ESRAM_BANK_SIZE)
./include/mach/db8500-regs.h:#define U8500_ESRAM_DMA_LCPA_OFFSET     0x10000
./include/mach/db8500-regs.h:#define U8500_DMA_LCPA_BASE
(U8500_ESRAM_BANK0 + U8500_ESRAM_DMA_LCPA_OFFSET)
./include/mach/db8500-regs.h:#define U8500_DMA_LCLA_BASE U8500_ESRAM_BANK4

I want to use genalloc to do dynamic allocations but I need to be able to
fine tune the allocation algorithm. I my case best-fit algorithm give
better results than first-fit, but it will not be true for every use case.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@stericsson.com>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/genalloc.h |   27 +++++++++++
 lib/genalloc.c           |   88 +++++++++++++++++++++++++++++++++++--
 2 files changed, 111 insertions(+), 4 deletions(-)

diff -puN include/linux/genalloc.h~genalloc-make-it-possible-to-use-a-custom-allocation-algorithm include/linux/genalloc.h
--- a/include/linux/genalloc.h~genalloc-make-it-possible-to-use-a-custom-allocation-algorithm
+++ a/include/linux/genalloc.h
@@ -29,6 +29,20 @@
 
 #ifndef __GENALLOC_H__
 #define __GENALLOC_H__
+/**
+ * Allocation callback function type definition
+ * @map: Pointer to bitmap
+ * @size: The bitmap size in bits
+ * @start: The bitnumber to start searching at
+ * @nr: The number of zeroed bits we're looking for
+ * @data: optional additional data used by @genpool_algo_t
+ */
+typedef unsigned long (*genpool_algo_t)(unsigned long *map,
+			unsigned long size,
+			unsigned long start,
+			unsigned int nr,
+			void *data);
+
 /*
  *  General purpose special memory pool descriptor.
  */
@@ -36,6 +50,9 @@ struct gen_pool {
 	spinlock_t lock;
 	struct list_head chunks;	/* list of chunks in this pool */
 	int min_alloc_order;		/* minimum allocation order */
+
+	genpool_algo_t algo;		/* allocation function */
+	void *data;
 };
 
 /*
@@ -78,4 +95,14 @@ extern void gen_pool_for_each_chunk(stru
 	void (*)(struct gen_pool *, struct gen_pool_chunk *, void *), void *);
 extern size_t gen_pool_avail(struct gen_pool *);
 extern size_t gen_pool_size(struct gen_pool *);
+
+extern void gen_pool_set_algo(struct gen_pool *pool, genpool_algo_t algo,
+		void *data);
+
+extern unsigned long gen_pool_first_fit(unsigned long *map, unsigned long size,
+		unsigned long start, unsigned int nr, void *data);
+
+extern unsigned long gen_pool_best_fit(unsigned long *map, unsigned long size,
+		unsigned long start, unsigned int nr, void *data);
+
 #endif /* __GENALLOC_H__ */
diff -puN lib/genalloc.c~genalloc-make-it-possible-to-use-a-custom-allocation-algorithm lib/genalloc.c
--- a/lib/genalloc.c~genalloc-make-it-possible-to-use-a-custom-allocation-algorithm
+++ a/lib/genalloc.c
@@ -152,6 +152,8 @@ struct gen_pool *gen_pool_create(int min
 		spin_lock_init(&pool->lock);
 		INIT_LIST_HEAD(&pool->chunks);
 		pool->min_alloc_order = min_alloc_order;
+		pool->algo = gen_pool_first_fit;
+		pool->data = NULL;
 	}
 	return pool;
 }
@@ -255,8 +257,9 @@ EXPORT_SYMBOL(gen_pool_destroy);
  * @size: number of bytes to allocate from the pool
  *
  * Allocate the requested number of bytes from the specified pool.
- * Uses a first-fit algorithm. Can not be used in NMI handler on
- * architectures without NMI-safe cmpxchg implementation.
+ * Uses the pool allocation function (with first-fit algorithm by default).
+ * Can not be used in NMI handler on architectures without
+ * NMI-safe cmpxchg implementation.
  */
 unsigned long gen_pool_alloc(struct gen_pool *pool, size_t size)
 {
@@ -280,8 +283,8 @@ unsigned long gen_pool_alloc(struct gen_
 
 		end_bit = (chunk->end_addr - chunk->start_addr) >> order;
 retry:
-		start_bit = bitmap_find_next_zero_area(chunk->bits, end_bit,
-						       start_bit, nbits, 0);
+		start_bit = pool->algo(chunk->bits, end_bit, start_bit, nbits,
+				pool->data);
 		if (start_bit >= end_bit)
 			continue;
 		remain = bitmap_set_ll(chunk->bits, start_bit, nbits);
@@ -400,3 +403,80 @@ size_t gen_pool_size(struct gen_pool *po
 	return size;
 }
 EXPORT_SYMBOL_GPL(gen_pool_size);
+
+/**
+ * gen_pool_set_algo - set the allocation algorithm
+ * @pool: pool to change allocation algorithm
+ * @algo: custom algorithm function
+ * @data: additional data used by @algo
+ *
+ * Call @algo for each memory allocation in the pool.
+ * If @algo is NULL use gen_pool_first_fit as default
+ * memory allocation function.
+ */
+void gen_pool_set_algo(struct gen_pool *pool, genpool_algo_t algo, void *data)
+{
+	rcu_read_lock();
+
+	pool->algo = algo;
+	if (!pool->algo)
+		pool->algo = gen_pool_first_fit;
+
+	pool->data = data;
+
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(gen_pool_set_algo);
+
+/**
+ * gen_pool_first_fit - find the first available region
+ * of memory matching the size requirement (no alignment constraint)
+ * @map: The address to base the search on
+ * @size: The bitmap size in bits
+ * @start: The bitnumber to start searching at
+ * @nr: The number of zeroed bits we're looking for
+ * @data: additional data - unused
+ */
+unsigned long gen_pool_first_fit(unsigned long *map, unsigned long size,
+		unsigned long start, unsigned int nr, void *data)
+{
+	return bitmap_find_next_zero_area(map, size, start, nr, 0);
+}
+EXPORT_SYMBOL(gen_pool_first_fit);
+
+/**
+ * gen_pool_best_fit - find the best fitting region of memory
+ * macthing the size requirement (no alignment constraint)
+ * @map: The address to base the search on
+ * @size: The bitmap size in bits
+ * @start: The bitnumber to start searching at
+ * @nr: The number of zeroed bits we're looking for
+ * @data: additional data - unused
+ *
+ * Iterate over the bitmap to find the smallest free region
+ * which we can allocate the memory.
+ */
+unsigned long gen_pool_best_fit(unsigned long *map, unsigned long size,
+		unsigned long start, unsigned int nr, void *data)
+{
+	unsigned long start_bit = size;
+	unsigned long len = size + 1;
+	unsigned long index;
+
+	index = bitmap_find_next_zero_area(map, size, start, nr, 0);
+
+	while (index < size) {
+		int next_bit = find_next_bit(map, size, index + nr);
+		if ((next_bit - index) < len) {
+			len = next_bit - index;
+			start_bit = index;
+			if (len == nr)
+				return start_bit;
+		}
+		index = bitmap_find_next_zero_area(map, size,
+						   next_bit + 1, nr, 0);
+	}
+
+	return start_bit;
+}
+EXPORT_SYMBOL(gen_pool_best_fit);
_

Patches currently in -mm which might be from benjamin.gaignard@linaro.org are

genalloc-make-it-possible-to-use-a-custom-allocation-algorithm.patch

