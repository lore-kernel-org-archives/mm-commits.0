From: akpm@linux-foundation.org
Subject: [merged] mm-slab-clean-up-debug_pagealloc-processing-code.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:54:20 -0700
Message-ID: <56e9b9ec.HdxlGCbl80yXlnZi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38521 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933996AbcCPTyV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:54:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: clean up DEBUG_PAGEALLOC processing code
has been removed from the -mm tree.  Its filename was
     mm-slab-clean-up-debug_pagealloc-processing-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: clean up DEBUG_PAGEALLOC processing code

Currently, open code for checking DEBUG_PAGEALLOC cache is spread to some
sites.  It makes code unreadable and hard to change.  This patch clean-up
these code.  Following patch will change the criteria for DEBUG_PAGEALLOC
cache so this clean-up will help it, too.

[akpm@linux-foundation.org: fix build with CONFIG_DEBUG_PAGEALLOC=n]
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   12 +++--
 mm/slab.c          |   97 +++++++++++++++++++++----------------------
 2 files changed, 57 insertions(+), 52 deletions(-)

diff -puN include/linux/mm.h~mm-slab-clean-up-debug_pagealloc-processing-code include/linux/mm.h
--- a/include/linux/mm.h~mm-slab-clean-up-debug_pagealloc-processing-code
+++ a/include/linux/mm.h
@@ -2195,14 +2195,18 @@ kernel_map_pages(struct page *page, int
 }
 #ifdef CONFIG_HIBERNATION
 extern bool kernel_page_present(struct page *page);
-#endif /* CONFIG_HIBERNATION */
-#else
+#endif	/* CONFIG_HIBERNATION */
+#else	/* CONFIG_DEBUG_PAGEALLOC */
 static inline void
 kernel_map_pages(struct page *page, int numpages, int enable) {}
 #ifdef CONFIG_HIBERNATION
 static inline bool kernel_page_present(struct page *page) { return true; }
-#endif /* CONFIG_HIBERNATION */
-#endif
+#endif	/* CONFIG_HIBERNATION */
+static inline bool debug_pagealloc_enabled(void)
+{
+	return false;
+}
+#endif	/* CONFIG_DEBUG_PAGEALLOC */
 
 #ifdef __HAVE_ARCH_GATE_AREA
 extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
diff -puN mm/slab.c~mm-slab-clean-up-debug_pagealloc-processing-code mm/slab.c
--- a/mm/slab.c~mm-slab-clean-up-debug_pagealloc-processing-code
+++ a/mm/slab.c
@@ -1661,6 +1661,14 @@ static void kmem_rcu_free(struct rcu_hea
 }
 
 #if DEBUG
+static bool is_debug_pagealloc_cache(struct kmem_cache *cachep)
+{
+	if (debug_pagealloc_enabled() && OFF_SLAB(cachep) &&
+		(cachep->size % PAGE_SIZE) == 0)
+		return true;
+
+	return false;
+}
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
 static void store_stackinfo(struct kmem_cache *cachep, unsigned long *addr,
@@ -1694,6 +1702,23 @@ static void store_stackinfo(struct kmem_
 	}
 	*addr++ = 0x87654321;
 }
+
+static void slab_kernel_map(struct kmem_cache *cachep, void *objp,
+				int map, unsigned long caller)
+{
+	if (!is_debug_pagealloc_cache(cachep))
+		return;
+
+	if (caller)
+		store_stackinfo(cachep, objp, caller);
+
+	kernel_map_pages(virt_to_page(objp), cachep->size / PAGE_SIZE, map);
+}
+
+#else
+static inline void slab_kernel_map(struct kmem_cache *cachep, void *objp,
+				int map, unsigned long caller) {}
+
 #endif
 
 static void poison_obj(struct kmem_cache *cachep, void *addr, unsigned char val)
@@ -1772,6 +1797,9 @@ static void check_poison_obj(struct kmem
 	int size, i;
 	int lines = 0;
 
+	if (is_debug_pagealloc_cache(cachep))
+		return;
+
 	realobj = (char *)objp + obj_offset(cachep);
 	size = cachep->object_size;
 
@@ -1837,17 +1865,8 @@ static void slab_destroy_debugcheck(stru
 		void *objp = index_to_obj(cachep, page, i);
 
 		if (cachep->flags & SLAB_POISON) {
-#ifdef CONFIG_DEBUG_PAGEALLOC
-			if (debug_pagealloc_enabled() &&
-				cachep->size % PAGE_SIZE == 0 &&
-					OFF_SLAB(cachep))
-				kernel_map_pages(virt_to_page(objp),
-					cachep->size / PAGE_SIZE, 1);
-			else
-				check_poison_obj(cachep, objp);
-#else
 			check_poison_obj(cachep, objp);
-#endif
+			slab_kernel_map(cachep, objp, 1, 0);
 		}
 		if (cachep->flags & SLAB_RED_ZONE) {
 			if (*dbg_redzone1(cachep, objp) != RED_INACTIVE)
@@ -2226,16 +2245,6 @@ __kmem_cache_create (struct kmem_cache *
 	if (flags & CFLGS_OFF_SLAB) {
 		/* really off slab. No need for manual alignment */
 		freelist_size = calculate_freelist_size(cachep->num, 0);
-
-#ifdef CONFIG_PAGE_POISONING
-		/* If we're going to use the generic kernel_map_pages()
-		 * poisoning, then it's going to smash the contents of
-		 * the redzone and userword anyhow, so switch them off.
-		 */
-		if (debug_pagealloc_enabled() &&
-			size % PAGE_SIZE == 0 && flags & SLAB_POISON)
-			flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
-#endif
 	}
 
 	cachep->colour_off = cache_line_size();
@@ -2251,7 +2260,19 @@ __kmem_cache_create (struct kmem_cache *
 	cachep->size = size;
 	cachep->reciprocal_buffer_size = reciprocal_value(size);
 
-	if (flags & CFLGS_OFF_SLAB) {
+#if DEBUG
+	/*
+	 * If we're going to use the generic kernel_map_pages()
+	 * poisoning, then it's going to smash the contents of
+	 * the redzone and userword anyhow, so switch them off.
+	 */
+	if (IS_ENABLED(CONFIG_PAGE_POISONING) &&
+		(cachep->flags & SLAB_POISON) &&
+		is_debug_pagealloc_cache(cachep))
+		cachep->flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
+#endif
+
+	if (OFF_SLAB(cachep)) {
 		cachep->freelist_cache = kmalloc_slab(freelist_size, 0u);
 		/*
 		 * This is a possibility for one of the kmalloc_{dma,}_caches.
@@ -2475,9 +2496,6 @@ static void cache_init_objs(struct kmem_
 	for (i = 0; i < cachep->num; i++) {
 		void *objp = index_to_obj(cachep, page, i);
 #if DEBUG
-		/* need to poison the objs? */
-		if (cachep->flags & SLAB_POISON)
-			poison_obj(cachep, objp, POISON_FREE);
 		if (cachep->flags & SLAB_STORE_USER)
 			*dbg_userword(cachep, objp) = NULL;
 
@@ -2501,10 +2519,11 @@ static void cache_init_objs(struct kmem_
 				slab_error(cachep, "constructor overwrote the"
 					   " start of an object");
 		}
-		if ((cachep->size % PAGE_SIZE) == 0 &&
-			    OFF_SLAB(cachep) && cachep->flags & SLAB_POISON)
-			kernel_map_pages(virt_to_page(objp),
-					 cachep->size / PAGE_SIZE, 0);
+		/* need to poison the objs? */
+		if (cachep->flags & SLAB_POISON) {
+			poison_obj(cachep, objp, POISON_FREE);
+			slab_kernel_map(cachep, objp, 0, 0);
+		}
 #else
 		if (cachep->ctor)
 			cachep->ctor(objp);
@@ -2716,18 +2735,8 @@ static void *cache_free_debugcheck(struc
 
 	set_obj_status(page, objnr, OBJECT_FREE);
 	if (cachep->flags & SLAB_POISON) {
-#ifdef CONFIG_DEBUG_PAGEALLOC
-		if (debug_pagealloc_enabled() &&
-			(cachep->size % PAGE_SIZE) == 0 && OFF_SLAB(cachep)) {
-			store_stackinfo(cachep, objp, caller);
-			kernel_map_pages(virt_to_page(objp),
-					 cachep->size / PAGE_SIZE, 0);
-		} else {
-			poison_obj(cachep, objp, POISON_FREE);
-		}
-#else
 		poison_obj(cachep, objp, POISON_FREE);
-#endif
+		slab_kernel_map(cachep, objp, 0, caller);
 	}
 	return objp;
 }
@@ -2862,16 +2871,8 @@ static void *cache_alloc_debugcheck_afte
 	if (!objp)
 		return objp;
 	if (cachep->flags & SLAB_POISON) {
-#ifdef CONFIG_DEBUG_PAGEALLOC
-		if (debug_pagealloc_enabled() &&
-			(cachep->size % PAGE_SIZE) == 0 && OFF_SLAB(cachep))
-			kernel_map_pages(virt_to_page(objp),
-					 cachep->size / PAGE_SIZE, 1);
-		else
-			check_poison_obj(cachep, objp);
-#else
 		check_poison_obj(cachep, objp);
-#endif
+		slab_kernel_map(cachep, objp, 1, 0);
 		poison_obj(cachep, objp, POISON_INUSE);
 	}
 	if (cachep->flags & SLAB_STORE_USER)
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-vmalloc-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting-v2.patch
sound-query-dynamic-debug_pagealloc-setting.patch
powerpc-query-dynamic-debug_pagealloc-setting.patch
tile-query-dynamic-debug_pagealloc-setting.patch
mm-introduce-page-reference-manipulation-functions.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3.patch

