From: akpm@linux-foundation.org
Subject: [folded-merged]
 stackdepot-check-depot_index-before-accessing-the-stack-slab-fix.patch
 removed from -mm tree
Date: Mon, 06 Apr 2020 18:49:07 -0700
Message-ID: <20200407014907.na7rowX4Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgDGBtI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 21:49:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot.c: fix a condition in stack_depot_fetch()
has been removed from the -mm tree.  Its filename was
     stackdepot-check-depot_index-before-accessing-the-stack-slab-fix.patch

This patch was dropped because it was folded into stackdepot-check-depot_index-before-accessing-the-stack-slab.patch

------------------------------------------------------
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

 lib/stackdepot.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/lib/stackdepot.c~stackdepot-check-depot_index-before-accessing-the-stack-slab-fix
+++ a/lib/stackdepot.c
@@ -206,18 +206,16 @@ unsigned int stack_depot_fetch(depot_sta
 	size_t offset = parts.offset << STACK_ALLOC_ALIGN;
 	struct stack_record *stack;
 
+	*entries = NULL;
 	if (parts.slabindex > depot_index) {
 		WARN(1, "slab index %d out of bounds (%d) for stack id %08x\n",
 			parts.slabindex, depot_index, handle);
-		*entries = NULL;
 		return 0;
 	}
 	slab = stack_slabs[parts.slabindex];
-	stack = slab + offset;
-	if (!stack) {
-		*entries = NULL;
+	if (!slab)
 		return 0;
-	}
+	stack = slab + offset;
 
 	*entries = stack->entries;
 	return stack->size;
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

stackdepot-check-depot_index-before-accessing-the-stack-slab.patch
lib-test_kmod-remove-a-null-test.patch
