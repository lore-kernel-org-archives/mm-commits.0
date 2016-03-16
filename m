From: akpm@linux-foundation.org
Subject: [merged]
 mm-slab-activate-debug_pagealloc-in-slab-when-it-is-actually-enabled.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:54:14 -0700
Message-ID: <56e9b9e6.kRhT5YF4insnc4j7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38511 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600AbcCPTyP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:54:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: activate debug_pagealloc in SLAB when it is actually enabled
has been removed from the -mm tree.  Its filename was
     mm-slab-activate-debug_pagealloc-in-slab-when-it-is-actually-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: activate debug_pagealloc in SLAB when it is actually enabled

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN mm/slab.c~mm-slab-activate-debug_pagealloc-in-slab-when-it-is-actually-enabled mm/slab.c
--- a/mm/slab.c~mm-slab-activate-debug_pagealloc-in-slab-when-it-is-actually-enabled
+++ a/mm/slab.c
@@ -1838,7 +1838,8 @@ static void slab_destroy_debugcheck(stru
 
 		if (cachep->flags & SLAB_POISON) {
 #ifdef CONFIG_DEBUG_PAGEALLOC
-			if (cachep->size % PAGE_SIZE == 0 &&
+			if (debug_pagealloc_enabled() &&
+				cachep->size % PAGE_SIZE == 0 &&
 					OFF_SLAB(cachep))
 				kernel_map_pages(virt_to_page(objp),
 					cachep->size / PAGE_SIZE, 1);
@@ -2176,7 +2177,8 @@ __kmem_cache_create (struct kmem_cache *
 	 * to check size >= 256. It guarantees that all necessary small
 	 * sized slab is initialized in current slab initialization sequence.
 	 */
-	if (!slab_early_init && size >= kmalloc_size(INDEX_NODE) &&
+	if (debug_pagealloc_enabled() &&
+		!slab_early_init && size >= kmalloc_size(INDEX_NODE) &&
 		size >= 256 && cachep->object_size > cache_line_size() &&
 		ALIGN(size, cachep->align) < PAGE_SIZE) {
 		cachep->obj_offset += PAGE_SIZE - ALIGN(size, cachep->align);
@@ -2232,7 +2234,8 @@ __kmem_cache_create (struct kmem_cache *
 		 * poisoning, then it's going to smash the contents of
 		 * the redzone and userword anyhow, so switch them off.
 		 */
-		if (size % PAGE_SIZE == 0 && flags & SLAB_POISON)
+		if (debug_pagealloc_enabled() &&
+			size % PAGE_SIZE == 0 && flags & SLAB_POISON)
 			flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
 #endif
 	}
@@ -2716,7 +2719,8 @@ static void *cache_free_debugcheck(struc
 	set_obj_status(page, objnr, OBJECT_FREE);
 	if (cachep->flags & SLAB_POISON) {
 #ifdef CONFIG_DEBUG_PAGEALLOC
-		if ((cachep->size % PAGE_SIZE)==0 && OFF_SLAB(cachep)) {
+		if (debug_pagealloc_enabled() &&
+			(cachep->size % PAGE_SIZE) == 0 && OFF_SLAB(cachep)) {
 			store_stackinfo(cachep, objp, caller);
 			kernel_map_pages(virt_to_page(objp),
 					 cachep->size / PAGE_SIZE, 0);
@@ -2861,7 +2865,8 @@ static void *cache_alloc_debugcheck_afte
 		return objp;
 	if (cachep->flags & SLAB_POISON) {
 #ifdef CONFIG_DEBUG_PAGEALLOC
-		if ((cachep->size % PAGE_SIZE) == 0 && OFF_SLAB(cachep))
+		if (debug_pagealloc_enabled() &&
+			(cachep->size % PAGE_SIZE) == 0 && OFF_SLAB(cachep))
 			kernel_map_pages(virt_to_page(objp),
 					 cachep->size / PAGE_SIZE, 1);
 		else
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

