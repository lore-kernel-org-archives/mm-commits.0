From: akpm@linux-foundation.org
Subject: + lib-stackdepot-avoid-to-return-0-handle.patch added to -mm tree
Date: Wed, 04 May 2016 14:02:54 -0700
Message-ID: <572a637e.dhcvg+VTacbKspkp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36916 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbcEDVCz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 May 2016 17:02:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, aryabinin@virtuozzo.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: avoid to return 0 handle
has been added to the -mm tree.  Its filename is
     lib-stackdepot-avoid-to-return-0-handle.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-stackdepot-avoid-to-return-0-handle.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-stackdepot-avoid-to-return-0-handle.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: lib/stackdepot: avoid to return 0 handle

Recently, we allow to save the stacktrace whose hashed value is 0.  It
causes the problem that stackdepot could return 0 even if in success. 
User of stackdepot cannot distinguish whether it is success or not so we
need to solve this problem.  In this patch, 1 bit are added to handle and
make valid handle none 0 by setting this bit.  After that, valid handle
will not be 0 and 0 handle will represent failure correctly.

Fixes: 33334e25769c ("lib/stackdepot.c: allow the stack trace hash
to be zero")
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

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

lib-stackdepot-avoid-to-return-0-handle.patch
mm-slab-fix-the-theoretical-race-by-holding-proper-lock.patch
mm-slab-remove-bad_alien_magic-again.patch
mm-slab-drain-the-free-slab-as-much-as-possible.patch
mm-slab-factor-out-kmem_cache_node-initialization-code.patch
mm-slab-factor-out-kmem_cache_node-initialization-code-fix.patch
mm-slab-clean-up-kmem_cache_node-setup.patch
mm-slab-dont-keep-free-slabs-if-free_objects-exceeds-free_limit.patch
mm-slab-racy-access-modify-the-slab-color.patch
mm-slab-make-cache_grow-handle-the-page-allocated-on-arbitrary-node.patch
mm-slab-separate-cache_grow-to-two-parts.patch
mm-slab-refill-cpu-cache-through-a-new-slab-without-holding-a-node-lock.patch
mm-slab-lockless-decision-to-grow-cache.patch
mm-page_ref-use-page_ref-helper-instead-of-direct-modification-of-_count.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix-fix.patch
mm-hugetlb-add-same-zone-check-in-pfn_range_valid_gigantic.patch
mm-memory_hotplug-add-comment-to-some-functions-related-to-memory-hotplug.patch
mm-vmstat-add-zone-range-overlapping-check.patch
mm-page_owner-add-zone-range-overlapping-check.patch
power-add-zone-range-overlapping-check.patch
mm-writeback-correct-dirty-page-calculation-for-highmem.patch
mm-page_alloc-correct-highmem-memory-statistics.patch
mm-highmem-make-nr_free_highpages-handles-all-highmem-zones-by-itself.patch
mm-vmstat-make-node_page_state-handles-all-zones-by-itself.patch

