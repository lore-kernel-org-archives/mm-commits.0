From: akpm@linux-foundation.org
Subject: - add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch removed from -mm tree
Date: Mon, 07 May 2007 17:03:02 -0700
Message-ID: <200705080003.l480323h008913@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967329AbXEHADW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:03:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Add virt_to_head_page and consolidate code in slab and slub
has been removed from the -mm tree.  Its filename was
     add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add virt_to_head_page and consolidate code in slab and slub
From: Christoph Lameter <clameter@sgi.com>

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 ++++++
 mm/slab.c          |    9 ++++-----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff -puN include/linux/mm.h~add-virt_to_head_page-and-consolidate-code-in-slab-and-slub include/linux/mm.h
--- a/include/linux/mm.h~add-virt_to_head_page-and-consolidate-code-in-slab-and-slub
+++ a/include/linux/mm.h
@@ -286,6 +286,12 @@ static inline void get_page(struct page 
 	atomic_inc(&page->_count);
 }
 
+static inline struct page *virt_to_head_page(const void *x)
+{
+	struct page *page = virt_to_page(x);
+	return compound_head(page);
+}
+
 /*
  * Setup the page count before being freed into the page allocator for
  * the first time (boot or memory hotplug)
diff -puN mm/slab.c~add-virt_to_head_page-and-consolidate-code-in-slab-and-slub mm/slab.c
--- a/mm/slab.c~add-virt_to_head_page-and-consolidate-code-in-slab-and-slub
+++ a/mm/slab.c
@@ -614,20 +614,19 @@ static inline void page_set_slab(struct 
 
 static inline struct slab *page_get_slab(struct page *page)
 {
-	page = compound_head(page);
 	BUG_ON(!PageSlab(page));
 	return (struct slab *)page->lru.prev;
 }
 
 static inline struct kmem_cache *virt_to_cache(const void *obj)
 {
-	struct page *page = virt_to_page(obj);
+	struct page *page = virt_to_head_page(obj);
 	return page_get_cache(page);
 }
 
 static inline struct slab *virt_to_slab(const void *obj)
 {
-	struct page *page = virt_to_page(obj);
+	struct page *page = virt_to_head_page(obj);
 	return page_get_slab(page);
 }
 
@@ -2876,7 +2875,7 @@ static void *cache_free_debugcheck(struc
 
 	objp -= obj_offset(cachep);
 	kfree_debugcheck(objp);
-	page = virt_to_page(objp);
+	page = virt_to_head_page(objp);
 
 	slabp = page_get_slab(page);
 
@@ -3100,7 +3099,7 @@ static void *cache_alloc_debugcheck_afte
 		struct slab *slabp;
 		unsigned objnr;
 
-		slabp = page_get_slab(virt_to_page(objp));
+		slabp = page_get_slab(virt_to_head_page(objp));
 		objnr = (unsigned)(objp - slabp->s_mem) / cachep->buffer_size;
 		slab_bufctl(slabp)[objnr] = BUFCTL_ACTIVE;
 	}
diff -puN /dev/null /dev/null
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
