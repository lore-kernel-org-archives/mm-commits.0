From: akpm@linux-foundation.org
Subject: - slub-add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch removed from -mm tree
Date: Mon, 07 May 2007 17:08:29 -0700
Message-ID: <200705080008.l4808TXl009383@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967432AbXEHAIv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:08:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Add virt_to_head_page and consolidate code in slab and slub
has been removed from the -mm tree.  Its filename was
     slub-add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add virt_to_head_page and consolidate code in slab and slub
From: Christoph Lameter <clameter@sgi.com>

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff -puN mm/slub.c~slub-add-virt_to_head_page-and-consolidate-code-in-slab-and-slub mm/slub.c
--- a/mm/slub.c~slub-add-virt_to_head_page-and-consolidate-code-in-slab-and-slub
+++ a/mm/slub.c
@@ -1323,9 +1323,7 @@ void kmem_cache_free(struct kmem_cache *
 {
 	struct page * page;
 
-	page = virt_to_page(x);
-
-	page = compound_head(page);
+	page = virt_to_head_page(x);
 
 	if (unlikely(PageError(page) && (s->flags & SLAB_STORE_USER)))
 		set_tracking(s, x, TRACK_FREE);
@@ -1336,7 +1334,7 @@ EXPORT_SYMBOL(kmem_cache_free);
 /* Figure out on which slab object the object resides */
 static struct page *get_object_page(const void *x)
 {
-	struct page *page = compound_head(virt_to_page(x));
+	struct page *page = virt_to_head_page(x);
 
 	if (!PageSlab(page))
 		return NULL;
@@ -2076,7 +2074,7 @@ void kfree(const void *x)
 	if (!x)
 		return;
 
-	page = compound_head(virt_to_page(x));
+	page = virt_to_head_page(x);
 
 	s = page->slab;
 
@@ -2112,7 +2110,7 @@ void *krealloc(const void *p, size_t new
 		return NULL;
 	}
 
-	page = compound_head(virt_to_page(p));
+	page = virt_to_head_page(p);
 
 	new_cache = get_slab(new_size, flags);
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-i386-support.patch
remove-constructor-from-buffer_head.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
vmstat-use-our-own-timer-events.patch
make-vm-statistics-update-interval-configurable.patch
make-vm-statistics-update-interval-configurable-fix.patch
readahead-state-based-method-aging-accounting.patch
