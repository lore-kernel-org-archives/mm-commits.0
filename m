From: akpm@linux-foundation.org
Subject: [patch 13/14] lib/stackdepot: avoid to return 0 handle
Date: Thu, 05 May 2016 16:22:35 -0700
Message-ID: <572bd5bb.iDH+26lQBzxwUxjo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34957 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589AbcEEXWh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 May 2016 19:22:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, aryabinin@virtuozzo.com, glider@google.com

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: lib/stackdepot: avoid to return 0 handle

Recently, we allow to save the stacktrace whose hashed value is 0.  It
causes the problem that stackdepot could return 0 even if in success. 
User of stackdepot cannot distinguish whether it is success or not so we
need to solve this problem.  In this patch, 1 bit are added to handle and
make valid handle none 0 by setting this bit.  After that, valid handle
will not be 0 and 0 handle will represent failure correctly.

Fixes: 33334e25769c ("lib/stackdepot.c: allow the stack trace hash to be zero")
Link: http://lkml.kernel.org/r/1462252403-1106-1-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN lib/stackdepot.c~lib-stackdepot-avoid-to-return-0-handle lib/stackdepot.c
--- a/lib/stackdepot.c~lib-stackdepot-avoid-to-return-0-handle
+++ a/lib/stackdepot.c
@@ -42,12 +42,14 @@
 
 #define DEPOT_STACK_BITS (sizeof(depot_stack_handle_t) * 8)
 
+#define STACK_ALLOC_NULL_PROTECTION_BITS 1
 #define STACK_ALLOC_ORDER 2 /* 'Slab' size order for stack depot, 4 pages */
 #define STACK_ALLOC_SIZE (1LL << (PAGE_SHIFT + STACK_ALLOC_ORDER))
 #define STACK_ALLOC_ALIGN 4
 #define STACK_ALLOC_OFFSET_BITS (STACK_ALLOC_ORDER + PAGE_SHIFT - \
 					STACK_ALLOC_ALIGN)
-#define STACK_ALLOC_INDEX_BITS (DEPOT_STACK_BITS - STACK_ALLOC_OFFSET_BITS)
+#define STACK_ALLOC_INDEX_BITS (DEPOT_STACK_BITS - \
+		STACK_ALLOC_NULL_PROTECTION_BITS - STACK_ALLOC_OFFSET_BITS)
 #define STACK_ALLOC_SLABS_CAP 1024
 #define STACK_ALLOC_MAX_SLABS \
 	(((1LL << (STACK_ALLOC_INDEX_BITS)) < STACK_ALLOC_SLABS_CAP) ? \
@@ -59,6 +61,7 @@ union handle_parts {
 	struct {
 		u32 slabindex : STACK_ALLOC_INDEX_BITS;
 		u32 offset : STACK_ALLOC_OFFSET_BITS;
+		u32 valid : STACK_ALLOC_NULL_PROTECTION_BITS;
 	};
 };
 
@@ -136,6 +139,7 @@ static struct stack_record *depot_alloc_
 	stack->size = size;
 	stack->handle.slabindex = depot_index;
 	stack->handle.offset = depot_offset >> STACK_ALLOC_ALIGN;
+	stack->handle.valid = 1;
 	memcpy(stack->entries, entries, size * sizeof(unsigned long));
 	depot_offset += required_size;
 
_
