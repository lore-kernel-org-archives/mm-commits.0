From: akpm@linux-foundation.org
Subject: + mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare.patch
 added to -mm tree
Date: Wed, 27 Apr 2016 12:30:29 -0700
Message-ID: <57211355.850kEeBF76DwmxAn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48174 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbcD0Taa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2016 15:30:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: don't duplicate code in free_pcp_prepare
has been added to the -mm tree.  Its filename is
     mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: don't duplicate code in free_pcp_prepare

The new free_pcp_prepare() function shares a lot of code with
free_pages_prepare(), which makes this a maintenance risk when some future
patch modifies only one of them. We should be able to achieve the same effect
(skipping free_pages_check() from !DEBUG_VM configs) by adding a parameter to
free_pages_prepare() and making it inline, so the checks (and the order != 0
parts) are eliminated from the call from free_pcp_prepare().

!DEBUG_VM: bloat-o-meter reports no difference, as my gcc was already inlining
free_pages_prepare() and the elimination seems to work as expected

DEBUG_VM bloat-o-meter:

add/remove: 0/1 grow/shrink: 2/0 up/down: 1035/-778 (257)
function                                     old     new   delta
__free_pages_ok                              297    1060    +763
free_hot_cold_page                           480     752    +272
free_pages_prepare                           778       -    -778

Here inlining didn't occur before, and added some code, but it's ok for a debug
option.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
---
 1 file changed, 7 insertions(+), 28 deletions(-)

index b823f00c275b..bc4160bfb36b 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   35 +++++++----------------------------
 1 file changed, 7 insertions(+), 28 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare
+++ a/mm/page_alloc.c
@@ -996,7 +996,7 @@ static bool free_pages_prepare(struct pa
 #ifdef CONFIG_DEBUG_VM
 static inline bool free_pcp_prepare(struct page *page)
 {
-	return free_pages_prepare(page, 0);
+	return free_pages_prepare(page, 0, true);
 }
 
 static inline bool bulkfree_pcp_prepare(struct page *page)
@@ -1006,30 +1006,7 @@ static inline bool bulkfree_pcp_prepare(
 #else
 static bool free_pcp_prepare(struct page *page)
 {
-	VM_BUG_ON_PAGE(PageTail(page), page);
-
-	trace_mm_page_free(page, 0);
-	kmemcheck_free_shadow(page, 0);
-	kasan_free_pages(page, 0);
-
-	if (PageAnonHead(page))
-		page->mapping = NULL;
-
-	reset_page_owner(page, 0);
-
-	if (!PageHighMem(page)) {
-		debug_check_no_locks_freed(page_address(page),
-					   PAGE_SIZE);
-		debug_check_no_obj_freed(page_address(page),
-					   PAGE_SIZE);
-	}
-	arch_free_page(page, 0);
-	kernel_poison_pages(page, 0, 0);
-	kernel_map_pages(page, 0, 0);
-
-	page_cpupid_reset_last(page);
-	page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
-	return true;
+	return free_pages_prepare(page, 0, false);
 }
 
 static bool bulkfree_pcp_prepare(struct page *page)
@@ -1201,7 +1178,8 @@ void __meminit reserve_bootmem_region(un
 	}
 }
 
-static bool free_pages_prepare(struct page *page, unsigned int order)
+static __always_inline bool free_pages_prepare(struct page *page, unsigned int order,
+						bool check_free)
 {
 	int bad = 0;
 
@@ -1233,7 +1211,8 @@ static bool free_pages_prepare(struct pa
 	}
 	if (PageAnonHead(page))
 		page->mapping = NULL;
-	bad += free_pages_check(page);
+	if (check_free)
+		bad += free_pages_check(page);
 	if (bad)
 		return false;
 
@@ -1260,7 +1239,7 @@ static void __free_pages_ok(struct page
 	int migratetype;
 	unsigned long pfn = page_to_pfn(page);
 
-	if (!free_pages_prepare(page, order))
+	if (!free_pages_prepare(page, order, true))
 		return;
 
 	migratetype = get_pfnblock_migratetype(page, pfn);
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-only-check-pagecompound-for-high-order-pages.patch
mm-page_alloc-use-new-pageanonhead-helper-in-the-free-page-fast-path.patch
mm-page_alloc-reduce-branches-in-zone_statistics.patch
mm-page_alloc-inline-zone_statistics.patch
mm-page_alloc-inline-the-fast-path-of-the-zonelist-iterator.patch
mm-page_alloc-use-__dec_zone_state-for-order-0-page-allocation.patch
mm-page_alloc-avoid-unnecessary-zone-lookups-during-pageblock-operations.patch
mm-page_alloc-convert-alloc_flags-to-unsigned.patch
mm-page_alloc-convert-nr_fair_skipped-to-bool.patch
mm-page_alloc-remove-unnecessary-local-variable-in-get_page_from_freelist.patch
mm-page_alloc-remove-unnecessary-initialisation-in-get_page_from_freelist.patch
mm-page_alloc-remove-unnecessary-initialisation-from-__alloc_pages_nodemask.patch
mm-page_alloc-simplify-last-cpupid-reset.patch
mm-page_alloc-move-__gfp_hardwall-modifications-out-of-the-fastpath.patch
mm-page_alloc-check-once-if-a-zone-has-isolated-pageblocks.patch
mm-page_alloc-check-once-if-a-zone-has-isolated-pageblocks-fix.patch
mm-page_alloc-shorten-the-page-allocator-fast-path.patch
mm-page_alloc-reduce-cost-of-fair-zone-allocation-policy-retry.patch
mm-page_alloc-shortcut-watermark-checks-for-order-0-pages.patch
mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice.patch
mm-page_alloc-remove-field-from-alloc_context.patch
mm-page_alloc-check-multiple-page-fields-with-a-single-branch.patch
mm-page_alloc-un-inline-the-bad-part-of-free_pages_check.patch
mm-page_alloc-pull-out-side-effects-from-free_pages_check.patch
mm-page_alloc-remove-unnecessary-variable-from-free_pcppages_bulk.patch
mm-page_alloc-inline-pageblock-lookup-in-page-free-fast-paths.patch
mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain.patch
mm-page_alloc-defer-debugging-checks-of-pages-allocated-from-the-pcp.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare.patch

