From: akpm@linux-foundation.org
Subject: + lib-remove-prio_heap.patch added to -mm tree
Date: Mon, 22 Sep 2014 12:51:18 -0700
Message-ID: <54207db6.oMT/qdLvoZchHhvA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54035 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783AbaIVTvT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Sep 2014 15:51:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, chris@chris-wilson.co.uk, davem@davemloft.net, ffusco@redhat.com, gthelen@google.com, keescook@chromium.org, linux@horizon.com, mingo@kernel.org, msalter@redhat.com, peterz@infradead.org, rdunlap@infradead.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: remove prio_heap
has been added to the -mm tree.  Its filename is
     lib-remove-prio_heap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-remove-prio_heap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-remove-prio_heap.patch

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
Subject: lib: remove prio_heap

The prio_heap code is unused since 889ed9ceaa97 ("cgroup: remove
css_scan_tasks()").  It should be compiled out to shrink the binary kernel
size which can be done via introducing CONFIG_PRIO_HEAD or by removing
the code.

We can simply recover the code from git when needed, so it would be better
to remove it IMO.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Francesco Fusco <ffusco@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: George Spelvin <linux@horizon.com>
Cc: Mark Salter <msalter@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/prio_heap.h |   58 -----------------------------
 lib/Makefile              |    2 -
 lib/prio_heap.c           |   70 ------------------------------------
 3 files changed, 1 insertion(+), 129 deletions(-)

diff -puN include/linux/prio_heap.h~lib-remove-prio_heap /dev/null
--- a/include/linux/prio_heap.h
+++ /dev/null
@@ -1,58 +0,0 @@
-#ifndef _LINUX_PRIO_HEAP_H
-#define _LINUX_PRIO_HEAP_H
-
-/*
- * Simple insertion-only static-sized priority heap containing
- * pointers, based on CLR, chapter 7
- */
-
-#include <linux/gfp.h>
-
-/**
- * struct ptr_heap - simple static-sized priority heap
- * @ptrs - pointer to data area
- * @max - max number of elements that can be stored in @ptrs
- * @size - current number of valid elements in @ptrs (in the range 0..@size-1
- * @gt: comparison operator, which should implement "greater than"
- */
-struct ptr_heap {
-	void **ptrs;
-	int max;
-	int size;
-	int (*gt)(void *, void *);
-};
-
-/**
- * heap_init - initialize an empty heap with a given memory size
- * @heap: the heap structure to be initialized
- * @size: amount of memory to use in bytes
- * @gfp_mask: mask to pass to kmalloc()
- * @gt: comparison operator, which should implement "greater than"
- */
-extern int heap_init(struct ptr_heap *heap, size_t size, gfp_t gfp_mask,
-		     int (*gt)(void *, void *));
-
-/**
- * heap_free - release a heap's storage
- * @heap: the heap structure whose data should be released
- */
-void heap_free(struct ptr_heap *heap);
-
-/**
- * heap_insert - insert a value into the heap and return any overflowed value
- * @heap: the heap to be operated on
- * @p: the pointer to be inserted
- *
- * Attempts to insert the given value into the priority heap. If the
- * heap is full prior to the insertion, then the resulting heap will
- * consist of the smallest @max elements of the original heap and the
- * new element; the greatest element will be removed from the heap and
- * returned. Note that the returned element will be the new element
- * (i.e. no change to the heap) if the new element is greater than all
- * elements currently in the heap.
- */
-extern void *heap_insert(struct ptr_heap *heap, void *p);
-
-
-
-#endif /* _LINUX_PRIO_HEAP_H */
diff -puN lib/Makefile~lib-remove-prio_heap lib/Makefile
--- a/lib/Makefile~lib-remove-prio_heap
+++ a/lib/Makefile
@@ -11,7 +11,7 @@ lib-y := ctype.o string.o vsprintf.o cmd
 	 rbtree.o radix-tree.o dump_stack.o timerqueue.o\
 	 idr.o int_sqrt.o extable.o \
 	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
-	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
+	 proportions.o flex_proportions.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
 	 earlycpio.o
 
diff -puN lib/prio_heap.c~lib-remove-prio_heap /dev/null
--- a/lib/prio_heap.c
+++ /dev/null
@@ -1,70 +0,0 @@
-/*
- * Simple insertion-only static-sized priority heap containing
- * pointers, based on CLR, chapter 7
- */
-
-#include <linux/slab.h>
-#include <linux/prio_heap.h>
-
-int heap_init(struct ptr_heap *heap, size_t size, gfp_t gfp_mask,
-	      int (*gt)(void *, void *))
-{
-	heap->ptrs = kmalloc(size, gfp_mask);
-	if (!heap->ptrs)
-		return -ENOMEM;
-	heap->size = 0;
-	heap->max = size / sizeof(void *);
-	heap->gt = gt;
-	return 0;
-}
-
-void heap_free(struct ptr_heap *heap)
-{
-	kfree(heap->ptrs);
-}
-
-void *heap_insert(struct ptr_heap *heap, void *p)
-{
-	void *res;
-	void **ptrs = heap->ptrs;
-	int pos;
-
-	if (heap->size < heap->max) {
-		/* Heap insertion */
-		pos = heap->size++;
-		while (pos > 0 && heap->gt(p, ptrs[(pos-1)/2])) {
-			ptrs[pos] = ptrs[(pos-1)/2];
-			pos = (pos-1)/2;
-		}
-		ptrs[pos] = p;
-		return NULL;
-	}
-
-	/* The heap is full, so something will have to be dropped */
-
-	/* If the new pointer is greater than the current max, drop it */
-	if (heap->gt(p, ptrs[0]))
-		return p;
-
-	/* Replace the current max and heapify */
-	res = ptrs[0];
-	ptrs[0] = p;
-	pos = 0;
-
-	while (1) {
-		int left = 2 * pos + 1;
-		int right = 2 * pos + 2;
-		int largest = pos;
-		if (left < heap->size && heap->gt(ptrs[left], p))
-			largest = left;
-		if (right < heap->size && heap->gt(ptrs[right], ptrs[largest]))
-			largest = right;
-		if (largest == pos)
-			break;
-		/* Push p down the heap one level and bump one up */
-		ptrs[pos] = ptrs[largest];
-		ptrs[largest] = p;
-		pos = largest;
-	}
-	return res;
-}
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

lib-remove-prio_heap.patch
rbtree-add-comment-to-rb_insert_augmented.patch
linux-next.patch

