From: akpm@linux-foundation.org
Subject: + mm-page_alloc-un-inline-the-bad-part-of-free_pages_check.patch
 added to -mm tree
Date: Wed, 27 Apr 2016 12:22:34 -0700
Message-ID: <5721117a.xB7gq3S3HX/40ni1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbcD0TWf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2016 15:22:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: un-inline the bad part of free_pages_check
has been added to the -mm tree.  Its filename is
     mm-page_alloc-un-inline-the-bad-part-of-free_pages_check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-un-inline-the-bad-part-of-free_pages_check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-un-inline-the-bad-part-of-free_pages_check.patch

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
Subject: mm, page_alloc: un-inline the bad part of free_pages_check


!DEBUG_VM size and bloat-o-meter:

add/remove: 1/0 grow/shrink: 0/2 up/down: 124/-370 (-246)
function                                     old     new   delta
free_pages_check_bad                           -     124    +124
free_pcppages_bulk                          1288    1171    -117
__free_pages_ok                              948     695    -253

DEBUG_VM:

add/remove: 1/0 grow/shrink: 0/1 up/down: 124/-214 (-90)
function                                     old     new   delta
free_pages_check_bad                           -     124    +124
free_pages_prepare                          1112     898    -214

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-un-inline-the-bad-part-of-free_pages_check mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-un-inline-the-bad-part-of-free_pages_check
+++ a/mm/page_alloc.c
@@ -806,18 +806,11 @@ static inline bool page_expected_state(s
 	return true;
 }
 
-static inline int free_pages_check(struct page *page)
+static void free_pages_check_bad(struct page *page)
 {
 	const char *bad_reason;
 	unsigned long bad_flags;
 
-	if (page_expected_state(page, PAGE_FLAGS_CHECK_AT_FREE)) {
-		page_cpupid_reset_last(page);
-		page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
-		return 0;
-	}
-
-	/* Something has gone sideways, find it */
 	bad_reason = NULL;
 	bad_flags = 0;
 
@@ -836,6 +829,17 @@ static inline int free_pages_check(struc
 		bad_reason = "page still charged to cgroup";
 #endif
 	bad_page(page, bad_reason, bad_flags);
+}
+static inline int free_pages_check(struct page *page)
+{
+	if (likely(page_expected_state(page, PAGE_FLAGS_CHECK_AT_FREE))) {
+		page_cpupid_reset_last(page);
+		page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
+		return 0;
+	}
+
+	/* Something has gone sideways, find it */
+	free_pages_check_bad(page);
 	return 1;
 }
 
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
mm-page_alloc-remove-unnecessary-variable-from-free_pcppages_bulk.patch
mm-page_alloc-inline-pageblock-lookup-in-page-free-fast-paths.patch
mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain.patch
mm-page_alloc-defer-debugging-checks-of-pages-allocated-from-the-pcp.patch

