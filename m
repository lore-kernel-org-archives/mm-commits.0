From: akpm@linux-foundation.org
Subject: + mm-slab-remove-object-status-buffer-for-debug_slab_leak.patch
 added to -mm tree
Date: Tue, 26 Jan 2016 21:30:26 -0800
Message-ID: <56a855f2.3twfySalYOpIGhll%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36825 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbcA0Fa1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 00:30:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: remove object status buffer for DEBUG_SLAB_LEAK
has been added to the -mm tree.  Its filename is
     mm-slab-remove-object-status-buffer-for-debug_slab_leak.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-remove-object-status-buffer-for-debug_slab_leak.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-remove-object-status-buffer-for-debug_slab_leak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm/slab: remove object status buffer for DEBUG_SLAB_LEAK

Now, we don't use object status buffer in any setup. Remove it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   34 ++--------------------------------
 1 file changed, 2 insertions(+), 32 deletions(-)

diff -puN mm/slab.c~mm-slab-remove-object-status-buffer-for-debug_slab_leak mm/slab.c
--- a/mm/slab.c~mm-slab-remove-object-status-buffer-for-debug_slab_leak
+++ a/mm/slab.c
@@ -380,22 +380,8 @@ static void **dbg_userword(struct kmem_c
 
 #endif
 
-#define OBJECT_FREE (0)
-#define OBJECT_ACTIVE (1)
-
 #ifdef CONFIG_DEBUG_SLAB_LEAK
 
-static void set_obj_status(struct page *page, int idx, int val)
-{
-	int freelist_size;
-	char *status;
-	struct kmem_cache *cachep = page->slab_cache;
-
-	freelist_size = cachep->num * sizeof(freelist_idx_t);
-	status = (char *)page->freelist + freelist_size;
-	status[idx] = val;
-}
-
 static inline bool is_store_user_clean(struct kmem_cache *cachep)
 {
 	return atomic_read(&cachep->store_user_clean) == 1;
@@ -413,7 +399,6 @@ static inline void set_store_user_dirty(
 }
 
 #else
-static inline void set_obj_status(struct page *page, int idx, int val) {}
 static inline void set_store_user_dirty(struct kmem_cache *cachep) {}
 
 #endif
@@ -476,9 +461,6 @@ static size_t calculate_freelist_size(in
 	size_t freelist_size;
 
 	freelist_size = nr_objs * sizeof(freelist_idx_t);
-	if (IS_ENABLED(CONFIG_DEBUG_SLAB_LEAK))
-		freelist_size += nr_objs * sizeof(char);
-
 	if (align)
 		freelist_size = ALIGN(freelist_size, align);
 
@@ -491,10 +473,7 @@ static int calculate_nr_objs(size_t slab
 	int nr_objs;
 	size_t remained_size;
 	size_t freelist_size;
-	int extra_space = 0;
 
-	if (IS_ENABLED(CONFIG_DEBUG_SLAB_LEAK))
-		extra_space = sizeof(char);
 	/*
 	 * Ignore padding for the initial guess. The padding
 	 * is at most @align-1 bytes, and @buffer_size is at
@@ -503,7 +482,7 @@ static int calculate_nr_objs(size_t slab
 	 * into the memory allocation when taking the padding
 	 * into account.
 	 */
-	nr_objs = slab_size / (buffer_size + idx_size + extra_space);
+	nr_objs = slab_size / (buffer_size + idx_size);
 
 	/*
 	 * This calculated number will be either the right
@@ -1961,16 +1940,13 @@ static size_t calculate_slab_order(struc
 			break;
 
 		if (flags & CFLGS_OFF_SLAB) {
-			size_t freelist_size_per_obj = sizeof(freelist_idx_t);
 			/*
 			 * Max number of objs-per-slab for caches which
 			 * use off-slab slabs. Needed to avoid a possible
 			 * looping condition in cache_grow().
 			 */
-			if (IS_ENABLED(CONFIG_DEBUG_SLAB_LEAK))
-				freelist_size_per_obj += sizeof(char);
 			offslab_limit = size;
-			offslab_limit /= freelist_size_per_obj;
+			offslab_limit /= sizeof(freelist_idx_t);
 
  			if (num > offslab_limit)
 				break;
@@ -2533,7 +2509,6 @@ static void cache_init_objs(struct kmem_
 		if (cachep->ctor)
 			cachep->ctor(objp);
 #endif
-		set_obj_status(page, i, OBJECT_FREE);
 		set_free_obj(page, i, i);
 	}
 }
@@ -2745,7 +2720,6 @@ static void *cache_free_debugcheck(struc
 	BUG_ON(objnr >= cachep->num);
 	BUG_ON(objp != index_to_obj(cachep, page, objnr));
 
-	set_obj_status(page, objnr, OBJECT_FREE);
 	if (cachep->flags & SLAB_POISON) {
 		poison_obj(cachep, objp, POISON_FREE);
 		slab_kernel_map(cachep, objp, 0, caller);
@@ -2878,8 +2852,6 @@ static inline void cache_alloc_debugchec
 static void *cache_alloc_debugcheck_after(struct kmem_cache *cachep,
 				gfp_t flags, void *objp, unsigned long caller)
 {
-	struct page *page;
-
 	if (!objp)
 		return objp;
 	if (cachep->flags & SLAB_POISON) {
@@ -2904,8 +2876,6 @@ static void *cache_alloc_debugcheck_afte
 		*dbg_redzone2(cachep, objp) = RED_ACTIVE;
 	}
 
-	page = virt_to_head_page(objp);
-	set_obj_status(page, obj_to_index(cachep, page, objp), OBJECT_ACTIVE);
 	objp += obj_offset(cachep);
 	if (cachep->ctor && cachep->flags & SLAB_POISON)
 		cachep->ctor(objp);
_

Patches currently in -mm which might be from js1304@gmail.com are

mm-slab-fix-stale-code-comment.patch
mm-slab-remove-useless-structure-define.patch
mm-slab-remove-the-checks-for-slab-implementation-bug.patch
mm-slab-activate-debug_pagealloc-in-slab-when-it-is-actually-enabled.patch
mm-slab-use-more-appropriate-condition-check-for-debug_pagealloc.patch
mm-slab-clean-up-debug_pagealloc-processing-code.patch
mm-slab-alternative-implementation-for-debug_slab_leak.patch
mm-slab-remove-object-status-buffer-for-debug_slab_leak.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page.patch
mm-slab-align-cache-size-first-before-determination-of-off_slab-candidate.patch
mm-slab-clean-up-cache-type-determination.patch
mm-slab-do-not-change-cache-size-if-debug-pagealloc-isnt-possible.patch
mm-slab-make-criteria-for-off-slab-determination-robust-and-simple.patch
mm-slab-factor-out-slab-list-fixup-code.patch
mm-slab-factor-out-debugging-initialization-in-cache_init_objs.patch
mm-slab-introduce-new-slab-management-type-objfreelist_slab.patch

