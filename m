From: akpm@linux-foundation.org
Subject: [merged]
 mm-slab-use-more-appropriate-condition-check-for-debug_pagealloc.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:54:17 -0700
Message-ID: <56e9b9e9.Lq5UTAfjOjKOHRw/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933996AbcCPTyS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:54:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: use more appropriate condition check for debug_pagealloc
has been removed from the -mm tree.  Its filename was
     mm-slab-use-more-appropriate-condition-check-for-debug_pagealloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: use more appropriate condition check for debug_pagealloc

debug_pagealloc debugging is related to SLAB_POISON flag rather than
FORCED_DEBUG option, although FORCED_DEBUG option will enable SLAB_POISON.
Fix it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/slab.c~mm-slab-use-more-appropriate-condition-check-for-debug_pagealloc mm/slab.c
--- a/mm/slab.c~mm-slab-use-more-appropriate-condition-check-for-debug_pagealloc
+++ a/mm/slab.c
@@ -2169,7 +2169,6 @@ __kmem_cache_create (struct kmem_cache *
 		else
 			size += BYTES_PER_WORD;
 	}
-#if FORCED_DEBUG && defined(CONFIG_DEBUG_PAGEALLOC)
 	/*
 	 * To activate debug pagealloc, off-slab management is necessary
 	 * requirement. In early phase of initialization, small sized slab
@@ -2177,7 +2176,7 @@ __kmem_cache_create (struct kmem_cache *
 	 * to check size >= 256. It guarantees that all necessary small
 	 * sized slab is initialized in current slab initialization sequence.
 	 */
-	if (debug_pagealloc_enabled() &&
+	if (debug_pagealloc_enabled() && (flags & SLAB_POISON) &&
 		!slab_early_init && size >= kmalloc_size(INDEX_NODE) &&
 		size >= 256 && cachep->object_size > cache_line_size() &&
 		ALIGN(size, cachep->align) < PAGE_SIZE) {
@@ -2185,7 +2184,6 @@ __kmem_cache_create (struct kmem_cache *
 		size = PAGE_SIZE;
 	}
 #endif
-#endif
 
 	/*
 	 * Determine if the slab management is 'on' or 'off' slab.
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

