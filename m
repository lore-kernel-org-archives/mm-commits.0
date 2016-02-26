From: akpm@linux-foundation.org
Subject: + mm-slab-avoid-returning-values-by-reference.patch added to -mm
 tree
Date: Fri, 26 Feb 2016 15:53:18 -0800
Message-ID: <56d0e56e.9IRtptmUJyRYdJjh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38136 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279AbcBZXxT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Feb 2016 18:53:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, cl@linux.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: avoid returning values by reference
has been added to the -mm tree.  Its filename is
     mm-slab-avoid-returning-values-by-reference.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-avoid-returning-values-by-reference.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-avoid-returning-values-by-reference.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: avoid returning values by reference

Returing values by reference is bad practice.  Instead, just use function
return value.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Suggested-by: Christoph Lameter <cl@linux.com>
Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN mm/slab.c~mm-slab-avoid-returning-values-by-reference mm/slab.c
--- a/mm/slab.c~mm-slab-avoid-returning-values-by-reference
+++ a/mm/slab.c
@@ -460,9 +460,10 @@ static inline struct array_cache *cpu_ca
 /*
  * Calculate the number of objects and left-over bytes for a given buffer size.
  */
-static void cache_estimate(unsigned long gfporder, size_t buffer_size,
-		unsigned long flags, size_t *left_over, unsigned int *num)
+static unsigned int cache_estimate(unsigned long gfporder, size_t buffer_size,
+		unsigned long flags, size_t *left_over)
 {
+	unsigned int num;
 	size_t slab_size = PAGE_SIZE << gfporder;
 
 	/*
@@ -483,13 +484,15 @@ static void cache_estimate(unsigned long
 	 * correct alignment when allocated.
 	 */
 	if (flags & (CFLGS_OBJFREELIST_SLAB | CFLGS_OFF_SLAB)) {
-		*num = slab_size / buffer_size;
+		num = slab_size / buffer_size;
 		*left_over = slab_size % buffer_size;
 	} else {
-		*num = slab_size / (buffer_size + sizeof(freelist_idx_t));
+		num = slab_size / (buffer_size + sizeof(freelist_idx_t));
 		*left_over = slab_size %
 			(buffer_size + sizeof(freelist_idx_t));
 	}
+
+	return num;
 }
 
 #if DEBUG
@@ -1893,7 +1896,7 @@ static size_t calculate_slab_order(struc
 		unsigned int num;
 		size_t remainder;
 
-		cache_estimate(gfporder, size, flags, &remainder, &num);
+		num = cache_estimate(gfporder, size, flags, &remainder);
 		if (!num)
 			continue;
 
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
mm-slab-introduce-new-slab-management-type-objfreelist_slab-fix.patch
mm-slab-avoid-returning-values-by-reference.patch
mm-slab-re-implement-pfmemalloc-support.patch
mm-slab-re-implement-pfmemalloc-support-v2.patch
mm-slub-support-left-red-zone.patch
mm-compaction-fix-invalid-free_pfn-and-compact_cached_free_pfn.patch
mm-compaction-pass-only-pageblock-aligned-range-to-pageblock_pfn_to_page.patch
mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous.patch
mm-vmalloc-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting-v2.patch
sound-query-dynamic-debug_pagealloc-setting.patch
powerpc-query-dynamic-debug_pagealloc-setting.patch
tile-query-dynamic-debug_pagealloc-setting.patch
mm-introduce-page-reference-manipulation-functions.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation.patch

