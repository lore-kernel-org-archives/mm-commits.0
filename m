From: akpm@linux-foundation.org
Subject: [merged]
 mm-mempool-poison-elements-backed-by-slab-allocator.patch removed from -mm
 tree
Date: Thu, 16 Apr 2015 09:52:18 -0700
Message-ID: <552fe8c2.GScQTVSn9gY0JYzh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42753 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbbDPQqt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:46:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, arnd@arndb.de, catalin.marinas@arm.com, fabio.estevam@freescale.com, hch@lst.de, mpatocka@redhat.com, sebott@linux.vnet.ibm.com, shaggy@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, mempool: poison elements backed by slab allocator
has been removed from the -mm tree.  Its filename was
     mm-mempool-poison-elements-backed-by-slab-allocator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, mempool: poison elements backed by slab allocator

Mempools keep elements in a reserved pool for contexts in which allocation
may not be possible.  When an element is allocated from the reserved pool,
its memory contents is the same as when it was added to the reserved pool.

Because of this, elements lack any free poisoning to detect use-after-free
errors.

This patch adds free poisoning for elements backed by the slab allocator. 
This is possible because the mempool layer knows the object size of each
element.

When an element is added to the reserved pool, it is poisoned with
POISON_FREE.  When it is removed from the reserved pool, the contents are
checked for POISON_FREE.  If there is a mismatch, a warning is emitted to
the kernel log.

This is only effective for configs with CONFIG_DEBUG_SLAB or
CONFIG_SLUB_DEBUG_ON.

[fabio.estevam@freescale.com: use '%zu' for printing 'size_t' variable]
[arnd@arndb.de: add missing include]
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Dave Kleikamp <shaggy@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempool.c |   92 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 90 insertions(+), 2 deletions(-)

diff -puN mm/mempool.c~mm-mempool-poison-elements-backed-by-slab-allocator mm/mempool.c
--- a/mm/mempool.c~mm-mempool-poison-elements-backed-by-slab-allocator
+++ a/mm/mempool.c
@@ -6,10 +6,12 @@
  *  extreme VM load.
  *
  *  started by Ingo Molnar, Copyright (C) 2001
+ *  debugging by David Rientjes, Copyright (C) 2015
  */
 
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <linux/highmem.h>
 #include <linux/kmemleak.h>
 #include <linux/export.h>
 #include <linux/mempool.h>
@@ -17,16 +19,102 @@
 #include <linux/writeback.h>
 #include "slab.h"
 
+#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_SLUB_DEBUG_ON)
+static void poison_error(mempool_t *pool, void *element, size_t size,
+			 size_t byte)
+{
+	const int nr = pool->curr_nr;
+	const int start = max_t(int, byte - (BITS_PER_LONG / 8), 0);
+	const int end = min_t(int, byte + (BITS_PER_LONG / 8), size);
+	int i;
+
+	pr_err("BUG: mempool element poison mismatch\n");
+	pr_err("Mempool %p size %zu\n", pool, size);
+	pr_err(" nr=%d @ %p: %s0x", nr, element, start > 0 ? "... " : "");
+	for (i = start; i < end; i++)
+		pr_cont("%x ", *(u8 *)(element + i));
+	pr_cont("%s\n", end < size ? "..." : "");
+	dump_stack();
+}
+
+static void __check_element(mempool_t *pool, void *element, size_t size)
+{
+	u8 *obj = element;
+	size_t i;
+
+	for (i = 0; i < size; i++) {
+		u8 exp = (i < size - 1) ? POISON_FREE : POISON_END;
+
+		if (obj[i] != exp) {
+			poison_error(pool, element, size, i);
+			return;
+		}
+	}
+	memset(obj, POISON_INUSE, size);
+}
+
+static void check_element(mempool_t *pool, void *element)
+{
+	/* Mempools backed by slab allocator */
+	if (pool->free == mempool_free_slab || pool->free == mempool_kfree)
+		__check_element(pool, element, ksize(element));
+
+	/* Mempools backed by page allocator */
+	if (pool->free == mempool_free_pages) {
+		int order = (int)(long)pool->pool_data;
+		void *addr = kmap_atomic((struct page *)element);
+
+		__check_element(pool, addr, 1UL << (PAGE_SHIFT + order));
+		kunmap_atomic(addr);
+	}
+}
+
+static void __poison_element(void *element, size_t size)
+{
+	u8 *obj = element;
+
+	memset(obj, POISON_FREE, size - 1);
+	obj[size - 1] = POISON_END;
+}
+
+static void poison_element(mempool_t *pool, void *element)
+{
+	/* Mempools backed by slab allocator */
+	if (pool->alloc == mempool_alloc_slab || pool->alloc == mempool_kmalloc)
+		__poison_element(element, ksize(element));
+
+	/* Mempools backed by page allocator */
+	if (pool->alloc == mempool_alloc_pages) {
+		int order = (int)(long)pool->pool_data;
+		void *addr = kmap_atomic((struct page *)element);
+
+		__poison_element(addr, 1UL << (PAGE_SHIFT + order));
+		kunmap_atomic(addr);
+	}
+}
+#else /* CONFIG_DEBUG_SLAB || CONFIG_SLUB_DEBUG_ON */
+static inline void check_element(mempool_t *pool, void *element)
+{
+}
+static inline void poison_element(mempool_t *pool, void *element)
+{
+}
+#endif /* CONFIG_DEBUG_SLAB || CONFIG_SLUB_DEBUG_ON */
+
 static void add_element(mempool_t *pool, void *element)
 {
 	BUG_ON(pool->curr_nr >= pool->min_nr);
+	poison_element(pool, element);
 	pool->elements[pool->curr_nr++] = element;
 }
 
 static void *remove_element(mempool_t *pool)
 {
-	BUG_ON(pool->curr_nr <= 0);
-	return pool->elements[--pool->curr_nr];
+	void *element = pool->elements[--pool->curr_nr];
+
+	BUG_ON(pool->curr_nr < 0);
+	check_element(pool, element);
+	return element;
 }
 
 /**
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3.patch
slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
slub-bulk-allocation-from-per-cpu-partial-pages.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch
cxgb4-drop-__gfp_nofail-allocation.patch

