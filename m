From: akpm@linux-foundation.org
Subject: + mm-page_alloc-pull-out-side-effects-from-free_pages_check.patch added to -mm tree
Date: Wed, 27 Apr 2016 12:23:14 -0700
Message-ID: <572111a2.LKQwQpWHipVJ7Jwz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48071 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbcD0TXP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2016 15:23:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: pull out side effects from free_pages_check
has been added to the -mm tree.  Its filename is
     mm-page_alloc-pull-out-side-effects-from-free_pages_check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-pull-out-side-effects-from-free_pages_check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-pull-out-side-effects-from-free_pages_check.patch

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
Subject: mm, page_alloc: pull out side effects from free_pages_check

Check without side-effects should be easier to maintain.  It also removes
the duplicated cpupid and flags reset done in !DEBUG_VM variant of both
free_pcp_prepare() and then bulkfree_pcp_prepare().  Finally, it enables
the next patch.

It shouldn't result in new branches, thanks to inlining of the check.

!DEBUG_VM bloat-o-meter:

add/remove: 0/0 grow/shrink: 0/2 up/down: 0/-27 (-27)
function                                     old     new   delta
__free_pages_ok                              748     739      -9
free_pcppages_bulk                          1403    1385     -18

DEBUG_VM:

add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-28 (-28)
function                                     old     new   delta
free_pages_prepare                           806     778     -28

This is also slightly faster because cpupid information is not set on tail
pages so we can avoid resets there.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-pull-out-side-effects-from-free_pages_check mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-pull-out-side-effects-from-free_pages_check
+++ a/mm/page_alloc.c
@@ -833,11 +833,8 @@ static void free_pages_check_bad(struct
 
 static inline int free_pages_check(struct page *page)
 {
-	if (likely(page_expected_state(page, PAGE_FLAGS_CHECK_AT_FREE))) {
-		page_cpupid_reset_last(page);
-		page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
+	if (likely(page_expected_state(page, PAGE_FLAGS_CHECK_AT_FREE)))
 		return 0;
-	}
 
 	/* Something has gone sideways, find it */
 	free_pages_check_bad(page);
@@ -1078,7 +1075,11 @@ static bool free_pages_prepare(struct pa
 		for (i = 1; i < (1 << order); i++) {
 			if (compound)
 				bad += free_tail_pages_check(page, page + i);
-			bad += free_pages_check(page + i);
+			if (unlikely(free_pages_check(page + i))) {
+				bad++;
+				continue;
+			}
+			(page + i)->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
 		}
 	}
 	if (PageAnonHead(page))
@@ -1087,6 +1088,8 @@ static bool free_pages_prepare(struct pa
 	if (bad)
 		return false;
 
+	page_cpupid_reset_last(page);
+	page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
 	reset_page_owner(page, order);
 
 	if (!PageHighMem(page)) {
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

