From: akpm@linux-foundation.org
Subject: + slob-improved-alignment-handling.patch added to -mm tree
Date: Tue, 22 May 2007 09:56:11 -0700
Message-ID: <200705221656.l4MGuBUK005874@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52911 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757863AbXEVQ60 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 12:58:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, mpm@selenic.com


The patch titled
     slob: improved alignment handling
has been added to the -mm tree.  Its filename is
     slob-improved-alignment-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slob: improved alignment handling
From: Nick Piggin <npiggin@suse.de>

Remove the core slob allocator's minimum alignment restrictions, and instead
introduce the alignment restrictions at the slab API layer.  This lets us heed
the ARCH_KMALLOC/SLAB_MINALIGN directives, and also use __alignof__ (unsigned
long) for the default alignment (which should allow relaxed alignment
architectures to take better advantage of SLOB's small minimum alignment).

Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slob.c |   49 ++++++++++++++++++++++++++-----------------------
 1 files changed, 26 insertions(+), 23 deletions(-)

diff -puN mm/slob.c~slob-improved-alignment-handling mm/slob.c
--- a/mm/slob.c~slob-improved-alignment-handling
+++ a/mm/slob.c
@@ -7,8 +7,8 @@
  *
  * The core of SLOB is a traditional K&R style heap allocator, with
  * support for returning aligned objects. The granularity of this
- * allocator is 4 bytes on 32-bit and 8 bytes on 64-bit, though it
- * could be as low as 2 if the compiler alignment requirements allow.
+ * allocator is as little as 2 bytes, however typically most architectures
+ * will require 4 bytes on 32-bit and 8 bytes on 64-bit.
  *
  * The slob heap is a linked list of pages from __get_free_page, and
  * within each page, there is a singly-linked list of free blocks (slob_t).
@@ -16,7 +16,7 @@
  * first-fit.
  *
  * Above this is an implementation of kmalloc/kfree. Blocks returned
- * from kmalloc are 4-byte aligned and prepended with a 4-byte header.
+ * from kmalloc are prepended with a 4-byte header with the kmalloc size.
  * If kmalloc is asked for objects of PAGE_SIZE or larger, it calls
  * __get_free_pages directly, allocating compound pages so the page order
  * does not have to be separately tracked, and also stores the exact
@@ -45,13 +45,6 @@
 #include <linux/list.h>
 #include <asm/atomic.h>
 
-/* SLOB_MIN_ALIGN == sizeof(long) */
-#if BITS_PER_BYTE == 32
-#define SLOB_MIN_ALIGN	4
-#else
-#define SLOB_MIN_ALIGN	8
-#endif
-
 /*
  * slob_block has a field 'units', which indicates size of block if +ve,
  * or offset of next block if -ve (in SLOB_UNITs).
@@ -60,19 +53,15 @@
  * Those with larger size contain their size in the first SLOB_UNIT of
  * memory, and the offset of the next free block in the second SLOB_UNIT.
  */
-#if PAGE_SIZE <= (32767 * SLOB_MIN_ALIGN)
+#if PAGE_SIZE <= (32767 * 2)
 typedef s16 slobidx_t;
 #else
 typedef s32 slobidx_t;
 #endif
 
-/*
- * Align struct slob_block to long for now, but can some embedded
- * architectures get away with less?
- */
 struct slob_block {
 	slobidx_t units;
-} __attribute__((aligned(SLOB_MIN_ALIGN)));
+};
 typedef struct slob_block slob_t;
 
 /*
@@ -384,14 +373,25 @@ out:
  * End of slob allocator proper. Begin kmem_cache_alloc and kmalloc frontend.
  */
 
+#ifndef ARCH_KMALLOC_MINALIGN
+#define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long)
+#endif
+
+#ifndef ARCH_SLAB_MINALIGN
+#define ARCH_SLAB_MINALIGN __alignof__(unsigned long)
+#endif
+
+
 void *__kmalloc(size_t size, gfp_t gfp)
 {
-	if (size < PAGE_SIZE - SLOB_UNIT) {
-		slob_t *m;
-		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
+	int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
+
+	if (size < PAGE_SIZE - align) {
+		unsigned int *m;
+		m = slob_alloc(size + align, gfp, align);
 		if (m)
-			m->units = size;
-		return m+1;
+			*m = size;
+		return (void *)m + align;
 	} else {
 		void *ret;
 
@@ -449,8 +449,9 @@ void kfree(const void *block)
 
 	sp = (struct slob_page *)virt_to_page(block);
 	if (slob_page(sp)) {
-		slob_t *m = (slob_t *)block - 1;
-		slob_free(m, m->units + SLOB_UNIT);
+		int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
+		unsigned int *m = (unsigned int *)(block - align);
+		slob_free(m, *m + align);
 	} else
 		put_page(&sp->page);
 }
@@ -499,6 +500,8 @@ struct kmem_cache *kmem_cache_create(con
 		c->ctor = ctor;
 		/* ignore alignment unless it's forced */
 		c->align = (flags & SLAB_HWCACHE_ALIGN) ? SLOB_ALIGN : 0;
+		if (c->align < ARCH_SLAB_MINALIGN)
+			c->align = ARCH_SLAB_MINALIGN;
 		if (c->align < align)
 			c->align = align;
 	} else if (flags & SLAB_PANIC)
_

Patches currently in -mm which might be from npiggin@suse.de are

mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
mm-remove-legacy-cruft.patch
mm-debug-check-for-the-fault-vs-invalidate-race.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
slob-rework-freelist-handling.patch
slob-remove-bigblock-tracking.patch
slob-improved-alignment-handling.patch
mm-document-fault_data-and-flags.patch
fs-introduce-some-page-buffer-invariants.patch
