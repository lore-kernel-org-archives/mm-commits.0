From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-slab-introduce-new-slab-management-type-objfreelist_slab-fix.patch
 removed from -mm tree
Date: Tue, 15 Mar 2016 14:36:53 -0700
Message-ID: <56e88075.lWES9O1v+iYls4Re%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59776 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722AbcCOVgz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Mar 2016 17:36:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fix SLAB_DESTROTY_BY_RCU
has been removed from the -mm tree.  Its filename was
     mm-slab-introduce-new-slab-management-type-objfreelist_slab-fix.patch

This patch was dropped because it was folded into mm-slab-introduce-new-slab-management-type-objfreelist_slab.patch

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: fix SLAB_DESTROTY_BY_RCU

Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab.c~mm-slab-introduce-new-slab-management-type-objfreelist_slab-fix mm/slab.c
--- a/mm/slab.c~mm-slab-introduce-new-slab-management-type-objfreelist_slab-fix
+++ a/mm/slab.c
@@ -2044,7 +2044,7 @@ static bool set_objfreelist_slab_cache(s
 
 	cachep->num = 0;
 
-	if (cachep->ctor)
+	if (cachep->ctor || flags & SLAB_DESTROY_BY_RCU)
 		return false;
 
 	left = calculate_slab_order(cachep, size,
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

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
mm-slab-avoid-returning-values-by-reference.patch
mm-slab-re-implement-pfmemalloc-support.patch
mm-slab-re-implement-pfmemalloc-support-v2.patch
mm-slub-support-left-red-zone.patch
mm-slub-support-left-red-zone-fix.patch
mm-compaction-fix-invalid-free_pfn-and-compact_cached_free_pfn.patch
mm-compaction-pass-only-pageblock-aligned-range-to-pageblock_pfn_to_page.patch
mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous.patch

