From: akpm@linux-foundation.org
Subject: +
 mm-slab-make-criteria-for-off-slab-determination-robust-and-simple.patch
 added to -mm tree
Date: Tue, 26 Jan 2016 21:30:32 -0800
Message-ID: <56a855f8.aq/Us8d57l68nMjs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36857 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbcA0Fad (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 00:30:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: make criteria for off slab determination robust and simple
has been added to the -mm tree.  Its filename is
     mm-slab-make-criteria-for-off-slab-determination-robust-and-simple.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-make-criteria-for-off-slab-determination-robust-and-simple.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-make-criteria-for-off-slab-determination-robust-and-simple.patch

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
Subject: mm/slab: make criteria for off slab determination robust and simple

To become an off slab, there are some constraints to avoid bootstrapping
problem and recursive call.  This can be avoided differently by simply
checking that corresponding kmalloc cache is ready and it's not a off
slab.  It would be more robust because static size checking can be
affected by cache size change or architecture type but dynamic checking
isn't.

One check 'freelist_cache->size > cachep->size / 2' is added to check
benefit of choosing off slab, because, now, there is no size constraint
which ensures enough advantage when selecting off slab.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   45 +++++++++++++++++----------------------------
 1 file changed, 17 insertions(+), 28 deletions(-)

diff -puN mm/slab.c~mm-slab-make-criteria-for-off-slab-determination-robust-and-simple mm/slab.c
--- a/mm/slab.c~mm-slab-make-criteria-for-off-slab-determination-robust-and-simple
+++ a/mm/slab.c
@@ -272,7 +272,6 @@ static void kmem_cache_node_init(struct 
 
 #define CFLGS_OFF_SLAB		(0x80000000UL)
 #define	OFF_SLAB(x)	((x)->flags & CFLGS_OFF_SLAB)
-#define OFF_SLAB_MIN_SIZE (max_t(size_t, PAGE_SIZE >> 5, KMALLOC_MIN_SIZE + 1))
 
 #define BATCHREFILL_LIMIT	16
 /*
@@ -1880,7 +1879,6 @@ static void slabs_destroy(struct kmem_ca
 static size_t calculate_slab_order(struct kmem_cache *cachep,
 				size_t size, unsigned long flags)
 {
-	unsigned long offslab_limit;
 	size_t left_over = 0;
 	int gfporder;
 
@@ -1897,16 +1895,24 @@ static size_t calculate_slab_order(struc
 			break;
 
 		if (flags & CFLGS_OFF_SLAB) {
+			struct kmem_cache *freelist_cache;
+			size_t freelist_size;
+
+			freelist_size = num * sizeof(freelist_idx_t);
+			freelist_cache = kmalloc_slab(freelist_size, 0u);
+			if (!freelist_cache)
+				continue;
+
 			/*
-			 * Max number of objs-per-slab for caches which
-			 * use off-slab slabs. Needed to avoid a possible
-			 * looping condition in cache_grow().
+			 * Needed to avoid possible looping condition
+			 * in cache_grow()
 			 */
-			offslab_limit = size;
-			offslab_limit /= sizeof(freelist_idx_t);
+			if (OFF_SLAB(freelist_cache))
+				continue;
 
- 			if (num > offslab_limit)
-				break;
+			/* check if off slab has enough benefit */
+			if (freelist_cache->size > cachep->size / 2)
+				continue;
 		}
 
 		/* Found something acceptable - save it away */
@@ -2032,17 +2038,9 @@ static bool set_off_slab_cache(struct km
 	cachep->num = 0;
 
 	/*
-	 * Determine if the slab management is 'on' or 'off' slab.
-	 * (bootstrapping cannot cope with offslab caches so don't do
-	 * it too early on. Always use on-slab management when
-	 * SLAB_NOLEAKTRACE to avoid recursive calls into kmemleak)
+	 * Always use on-slab management when SLAB_NOLEAKTRACE
+	 * to avoid recursive calls into kmemleak.
 	 */
-	if (size < OFF_SLAB_MIN_SIZE)
-		return false;
-
-	if (slab_early_init)
-		return false;
-
 	if (flags & SLAB_NOLEAKTRACE)
 		return false;
 
@@ -2206,7 +2204,6 @@ __kmem_cache_create (struct kmem_cache *
 	 * sized slab is initialized in current slab initialization sequence.
 	 */
 	if (debug_pagealloc_enabled() && (flags & SLAB_POISON) &&
-		!slab_early_init && size >= kmalloc_size(INDEX_NODE) &&
 		size >= 256 && cachep->object_size > cache_line_size()) {
 		if (size < PAGE_SIZE || size % PAGE_SIZE == 0) {
 			size_t tmp_size = ALIGN(size, PAGE_SIZE);
@@ -2255,14 +2252,6 @@ done:
 	if (OFF_SLAB(cachep)) {
 		cachep->freelist_cache =
 			kmalloc_slab(cachep->freelist_size, 0u);
-		/*
-		 * This is a possibility for one of the kmalloc_{dma,}_caches.
-		 * But since we go off slab only for object size greater than
-		 * OFF_SLAB_MIN_SIZE, and kmalloc_{dma,}_caches get created
-		 * in ascending order,this should not happen at all.
-		 * But leave a BUG_ON for some lucky dude.
-		 */
-		BUG_ON(ZERO_OR_NULL_PTR(cachep->freelist_cache));
 	}
 
 	err = setup_cpu_cache(cachep, gfp);
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

