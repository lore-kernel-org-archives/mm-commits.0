From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 stackdepot-check-depot_index-before-accessing-the-stack-slab-fix.patch
 added to -mm tree
Date: Thu, 12 Mar 2020 16:44:40 -0700
Message-ID: <20200312234440.vQvqS6ErA%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726788AbgCLXol (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Mar 2020 19:44:41 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot.c: fix a condition in stack_depot_fetch()
has been added to the -mm tree.  Its filename is
     stackdepot-check-depot_index-before-accessing-the-stack-slab-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/stackdepot-check-depot_index-before-accessing-the-stack-slab-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/stackdepot-check-depot_index-before-accessing-the-stack-slab-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

stackdepot-check-depot_index-before-accessing-the-stack-slab-fix.patch
lib-test_kmod-remove-a-null-test.patch
