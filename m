From: akpm@linux-foundation.org
Subject: [merged]
 stackdepot-check-depot_index-before-accessing-the-stack-slab.patch removed
 from -mm tree
Date: Tue, 07 Apr 2020 19:01:04 -0700
Message-ID: <20200408020104.x5cP9OyBD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbgDHCBF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:01:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, arnd@arndb.de, aryabinin@virtuozzo.com, dan.carpenter@oracle.com, dvyukov@google.com, elver@google.com, glider@google.com, mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, vegard.nossum@oracle.com


The patch titled
     Subject: lib/stackdepot.c: check depot_index before accessing the stack slab
has been removed from the -mm tree.  Its filename was
     stackdepot-check-depot_index-before-accessing-the-stack-slab.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: lib/stackdepot.c: fix a condition in stack_depot_fetch()

We should check for a NULL pointer first before adding the offset. 
Otherwise if the pointer is NULL and the offset is non-zero, it will lead
to an Oops.

Link: http://lkml.kernel.org/r/20200312113006.GA20562@mwanda
Fixes: d45048e65a59 ("lib/stackdepot.c: check depot_index before accessing the stack slab")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/lib/stackdepot.c~stackdepot-check-depot_index-before-accessing-the-stack-slab
+++ a/lib/stackdepot.c
@@ -202,9 +202,20 @@ unsigned int stack_depot_fetch(depot_sta
 			       unsigned long **entries)
 {
 	union handle_parts parts = { .handle = handle };
-	void *slab = stack_slabs[parts.slabindex];
+	void *slab;
 	size_t offset = parts.offset << STACK_ALLOC_ALIGN;
-	struct stack_record *stack = slab + offset;
+	struct stack_record *stack;
+
+	*entries = NULL;
+	if (parts.slabindex > depot_index) {
+		WARN(1, "slab index %d out of bounds (%d) for stack id %08x\n",
+			parts.slabindex, depot_index, handle);
+		return 0;
+	}
+	slab = stack_slabs[parts.slabindex];
+	if (!slab)
+		return 0;
+	stack = slab + offset;
 
 	*entries = stack->entries;
 	return stack->size;
_

Patches currently in -mm which might be from glider@google.com are
