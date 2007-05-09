From: akpm@linux-foundation.org
Subject: - slub-use-check_valid_pointer-in-kmem_ptr_validate.patch removed from -mm tree
Date: Wed, 09 May 2007 14:47:53 -0700
Message-ID: <200705092147.l49LlrJa002522@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52517 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757070AbXEIVrz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:47:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: use check_valid_pointer in kmem_ptr_validate
has been removed from the -mm tree.  Its filename was
     slub-use-check_valid_pointer-in-kmem_ptr_validate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: use check_valid_pointer in kmem_ptr_validate
From: Christoph Lameter <clameter@sgi.com>

We needlessly duplicate code. Also make check_valid_pointer inline.

Signed-off-by: Christoph LAemter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff -puN mm/slub.c~slub-use-check_valid_pointer-in-kmem_ptr_validate mm/slub.c
--- a/mm/slub.c~slub-use-check_valid_pointer-in-kmem_ptr_validate
+++ a/mm/slub.c
@@ -405,9 +405,8 @@ static int check_bytes(u8 *start, unsign
 	return 1;
 }
 
-
-static int check_valid_pointer(struct kmem_cache *s, struct page *page,
-					 void *object)
+static inline int check_valid_pointer(struct kmem_cache *s,
+				struct page *page, const void *object)
 {
 	void *base;
 
@@ -1796,13 +1795,7 @@ int kmem_ptr_validate(struct kmem_cache 
 		/* No slab or wrong slab */
 		return 0;
 
-	addr = page_address(page);
-	if (object < addr || object >= addr + s->objects * s->size)
-		/* Out of bounds */
-		return 0;
-
-	if ((object - addr) % s->size)
-		/* Improperly aligned */
+	if (!check_valid_pointer(s, page, object))
 		return 0;
 
 	/*
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slub-support-concurrent-local-and-remote-frees-and-allocs-on-a-slab.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-reduce-antifrag-max-order.patch
slub-i386-support.patch
define-percpu-smp-cacheline-align-interface.patch
call-percpu-smp-cacheline-algin-interface.patch
remove-constructor-from-buffer_head.patch
mm-implement-swap-prefetching.patch
revoke-core-code.patch
