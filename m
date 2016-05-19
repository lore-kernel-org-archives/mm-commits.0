From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix-fix.patch
 removed from -mm tree
Date: Thu, 19 May 2016 16:42:38 -0700
Message-ID: <573e4f6e.AXXbbS8CyBdJ5qyp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44864 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbcESXmj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 19:42:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix-fix.patch

This patch was dropped because it was folded into mm-rename-_count-field-of-the-struct-page-to-_refcount.patch

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix-fix
 fix fix

String in mm/page_alloc.c too

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix-fix
+++ a/mm/page_alloc.c
@@ -794,7 +794,7 @@ static inline int free_pages_check(struc
 	if (unlikely(page->mapping != NULL))
 		bad_reason = "non-NULL mapping";
 	if (unlikely(page_ref_count(page) != 0))
-		bad_reason = "nonzero _count";
+		bad_reason = "nonzero _refcount";
 	if (unlikely(page->flags & PAGE_FLAGS_CHECK_AT_FREE)) {
 		bad_reason = "PAGE_FLAGS_CHECK_AT_FREE flag(s) set";
 		bad_flags = PAGE_FLAGS_CHECK_AT_FREE;
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slab-fix-the-theoretical-race-by-holding-proper-lock.patch
mm-slab-remove-bad_alien_magic-again.patch
mm-slab-drain-the-free-slab-as-much-as-possible.patch
mm-slab-factor-out-kmem_cache_node-initialization-code.patch
mm-slab-clean-up-kmem_cache_node-setup.patch
mm-slab-dont-keep-free-slabs-if-free_objects-exceeds-free_limit.patch
mm-slab-racy-access-modify-the-slab-color.patch
mm-slab-make-cache_grow-handle-the-page-allocated-on-arbitrary-node.patch
mm-slab-separate-cache_grow-to-two-parts.patch
mm-slab-refill-cpu-cache-through-a-new-slab-without-holding-a-node-lock.patch
mm-slab-lockless-decision-to-grow-cache.patch
mm-page_ref-use-page_ref-helper-instead-of-direct-modification-of-_count.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount.patch
mm-hugetlb-add-same-zone-check-in-pfn_range_valid_gigantic.patch
mm-memory_hotplug-add-comment-to-some-functions-related-to-memory-hotplug.patch
mm-vmstat-add-zone-range-overlapping-check.patch
mm-page_owner-add-zone-range-overlapping-check.patch
power-add-zone-range-overlapping-check.patch
mm-writeback-correct-dirty-page-calculation-for-highmem.patch
mm-page_alloc-correct-highmem-memory-statistics.patch
mm-highmem-make-nr_free_highpages-handles-all-highmem-zones-by-itself.patch
mm-vmstat-make-node_page_state-handles-all-zones-by-itself.patch

