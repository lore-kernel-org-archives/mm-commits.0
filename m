From: akpm@linux-foundation.org
Subject: +
 stackdepot-check-depot_index-before-accessing-the-stack-slab.patch added to
 -mm tree
Date: Thu, 20 Feb 2020 16:44:07 -0800
Message-ID: <20200221004407.S-7IX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729419AbgBUAoJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 Feb 2020 19:44:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vegard.nossum@oracle.com, sergey.senozhatsky@gmail.com, elver@google.com, dvyukov@google.com, aryabinin@virtuozzo.com, arnd@arndb.de, andreyknvl@google.com, glider@google.com


The patch titled
     Subject: lib/stackdepot.c: check depot_index before accessing the stack slab
has been added to the -mm tree.  Its filename is
     stackdepot-check-depot_index-before-accessing-the-stack-slab.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/stackdepot-check-depot_index-before-accessing-the-stack-slab.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/stackdepot-check-depot_index-before-accessing-the-stack-slab.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: lib/stackdepot.c: check depot_index before accessing the stack slab

Avoid crashes on corrupted stack ids.  Despite stack ID corruption may
indicate other bugs in the program, we'd better fail gracefully on such
IDs instead of crashing the kernel.

This patch has been previously mailed as part of KMSAN RFC patch series.

Link: http://lkml.kernel.org/r/20200220141916.55455-1-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/lib/stackdepot.c~stackdepot-check-depot_index-before-accessing-the-stack-slab
+++ a/lib/stackdepot.c
@@ -202,9 +202,22 @@ unsigned int stack_depot_fetch(depot_sta
 			       unsigned long **entries)
 {
 	union handle_parts parts = { .handle = handle };
-	void *slab = stack_slabs[parts.slabindex];
+	void *slab;
 	size_t offset = parts.offset << STACK_ALLOC_ALIGN;
-	struct stack_record *stack = slab + offset;
+	struct stack_record *stack;
+
+	if (parts.slabindex > depot_index) {
+		WARN(1, "slab index %d out of bounds (%d) for stack id %08x\n",
+			parts.slabindex, depot_index, handle);
+		*entries = NULL;
+		return 0;
+	}
+	slab = stack_slabs[parts.slabindex];
+	stack = slab + offset;
+	if (!stack) {
+		*entries = NULL;
+		return 0;
+	}
 
 	*entries = stack->entries;
 	return stack->size;
_

Patches currently in -mm which might be from glider@google.com are

lib-stackdepot-fix-global-out-of-bounds-in-stack_slabs.patch
stackdepot-check-depot_index-before-accessing-the-stack-slab.patch
stackdepot-build-with-fno-builtin.patch
kasan-stackdepot-move-filter_irq_stacks-to-stackdepotc.patch
