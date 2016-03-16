From: akpm@linux-foundation.org
Subject: [merged]
 mm-slab-do-not-change-cache-size-if-debug-pagealloc-isnt-possible.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:54:38 -0700
Message-ID: <56e9b9fe.KFhYb726mJFDCdX6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38557 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbcCPTyj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:54:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: do not change cache size if debug pagealloc isn't possible
has been removed from the -mm tree.  Its filename was
     mm-slab-do-not-change-cache-size-if-debug-pagealloc-isnt-possible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: do not change cache size if debug pagealloc isn't possible

We can fail to setup off slab in some conditions.  Even in this case,
debug pagealloc increases cache size to PAGE_SIZE in advance and it is
waste because debug pagealloc cannot work for it when it isn't the off
slab.  To improve this situation, this patch checks first that this cache
with increased size is suitable for off slab.  It actually increases cache
size when it is suitable for off-slab, so possible waste is removed.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN mm/slab.c~mm-slab-do-not-change-cache-size-if-debug-pagealloc-isnt-possible mm/slab.c
--- a/mm/slab.c~mm-slab-do-not-change-cache-size-if-debug-pagealloc-isnt-possible
+++ a/mm/slab.c
@@ -2206,10 +2206,17 @@ __kmem_cache_create (struct kmem_cache *
 	 */
 	if (debug_pagealloc_enabled() && (flags & SLAB_POISON) &&
 		!slab_early_init && size >= kmalloc_size(INDEX_NODE) &&
-		size >= 256 && cachep->object_size > cache_line_size() &&
-		size < PAGE_SIZE) {
-		cachep->obj_offset += PAGE_SIZE - size;
-		size = PAGE_SIZE;
+		size >= 256 && cachep->object_size > cache_line_size()) {
+		if (size < PAGE_SIZE || size % PAGE_SIZE == 0) {
+			size_t tmp_size = ALIGN(size, PAGE_SIZE);
+
+			if (set_off_slab_cache(cachep, tmp_size, flags)) {
+				flags |= CFLGS_OFF_SLAB;
+				cachep->obj_offset += tmp_size - size;
+				size = tmp_size;
+				goto done;
+			}
+		}
 	}
 #endif
 
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

