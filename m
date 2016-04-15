From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-check-multiple-page-fields-with-a-single-branch.patch added
 to -mm tree
Date: Fri, 15 Apr 2016 16:12:29 -0700
Message-ID: <5711755d.X9YJqNlfbfhjEK5W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42602 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbcDOXMb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Apr 2016 19:12:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: check multiple page fields with a single branch
has been added to the -mm tree.  Its filename is
     mm-page_alloc-check-multiple-page-fields-with-a-single-branch.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-check-multiple-page-fields-with-a-single-branch.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-check-multiple-page-fields-with-a-single-branch.patch

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
Subject: mm, page_alloc: check multiple page fields with a single branch

Every page allocated or freed is checked for sanity to avoid corruptions
that are difficult to detect later.  A bad page could be due to a number
of fields.  Instead of using multiple branches, this patch combines
multiple fields into a single branch.  A detailed check is only necessary
if that check fails.

                                           4.6.0-rc2                  4.6.0-rc2
                                      initonce-v1r20            multcheck-v1r20
Min      alloc-odr0-1               359.00 (  0.00%)           348.00 (  3.06%)
Min      alloc-odr0-2               260.00 (  0.00%)           254.00 (  2.31%)
Min      alloc-odr0-4               214.00 (  0.00%)           213.00 (  0.47%)
Min      alloc-odr0-8               186.00 (  0.00%)           186.00 (  0.00%)
Min      alloc-odr0-16              173.00 (  0.00%)           173.00 (  0.00%)
Min      alloc-odr0-32              165.00 (  0.00%)           166.00 ( -0.61%)
Min      alloc-odr0-64              162.00 (  0.00%)           162.00 (  0.00%)
Min      alloc-odr0-128             161.00 (  0.00%)           160.00 (  0.62%)
Min      alloc-odr0-256             170.00 (  0.00%)           169.00 (  0.59%)
Min      alloc-odr0-512             181.00 (  0.00%)           180.00 (  0.55%)
Min      alloc-odr0-1024            190.00 (  0.00%)           188.00 (  1.05%)
Min      alloc-odr0-2048            196.00 (  0.00%)           194.00 (  1.02%)
Min      alloc-odr0-4096            202.00 (  0.00%)           199.00 (  1.49%)
Min      alloc-odr0-8192            205.00 (  0.00%)           202.00 (  1.46%)
Min      alloc-odr0-16384           205.00 (  0.00%)           203.00 (  0.98%)

Again, the benefit is marginal but avoiding excessive branches is
important.  Ideally the paths would not have to check these conditions at
all but regrettably abandoning the tests would make use-after-free bugs
much harder to detect.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   55 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 43 insertions(+), 12 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-check-multiple-page-fields-with-a-single-branch mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-check-multiple-page-fields-with-a-single-branch
+++ a/mm/page_alloc.c
@@ -784,10 +784,42 @@ out:
 	zone->free_area[order].nr_free++;
 }
 
+/*
+ * A bad page could be due to a number of fields. Instead of multiple branches,
+ * try and check multiple fields with one check. The caller must do a detailed
+ * check if necessary.
+ */
+static inline bool page_expected_state(struct page *page,
+					unsigned long check_flags)
+{
+	if (unlikely(atomic_read(&page->_mapcount) != -1))
+		return false;
+
+	if (unlikely((unsigned long)page->mapping |
+			page_ref_count(page) |
+#ifdef CONFIG_MEMCG
+			(unsigned long)page->mem_cgroup |
+#endif
+			(page->flags & check_flags)))
+		return false;
+
+	return true;
+}
+
 static inline int free_pages_check(struct page *page)
 {
-	const char *bad_reason = NULL;
-	unsigned long bad_flags = 0;
+	const char *bad_reason;
+	unsigned long bad_flags;
+
+	if (page_expected_state(page, PAGE_FLAGS_CHECK_AT_FREE)) {
+		page_cpupid_reset_last(page);
+		page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
+		return 0;
+	}
+
+	/* Something has gone sideways, find it */
+	bad_reason = NULL;
+	bad_flags = 0;
 
 	if (unlikely(atomic_read(&page->_mapcount) != -1))
 		bad_reason = "nonzero mapcount";
@@ -803,14 +835,8 @@ static inline int free_pages_check(struc
 	if (unlikely(page->mem_cgroup))
 		bad_reason = "page still charged to cgroup";
 #endif
-	if (unlikely(bad_reason)) {
-		bad_page(page, bad_reason, bad_flags);
-		return 1;
-	}
-	page_cpupid_reset_last(page);
-	if (page->flags & PAGE_FLAGS_CHECK_AT_PREP)
-		page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
-	return 0;
+	bad_page(page, bad_reason, bad_flags);
+	return 1;
 }
 
 /*
@@ -1491,9 +1517,14 @@ static inline void expand(struct zone *z
  */
 static inline int check_new_page(struct page *page)
 {
-	const char *bad_reason = NULL;
-	unsigned long bad_flags = 0;
+	const char *bad_reason;
+	unsigned long bad_flags;
+
+	if (page_expected_state(page, PAGE_FLAGS_CHECK_AT_PREP|__PG_HWPOISON))
+		return 0;
 
+	bad_reason = NULL;
+	bad_flags = 0;
 	if (unlikely(atomic_read(&page->_mapcount) != -1))
 		bad_reason = "nonzero mapcount";
 	if (unlikely(page->mapping != NULL))
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
mm-page_alloc-remove-redundant-check-for-empty-zonelist.patch
mm-page_alloc-simplify-last-cpupid-reset.patch
mm-page_alloc-move-might_sleep_if-check-to-the-allocator-slowpath.patch
mm-page_alloc-move-__gfp_hardwall-modifications-out-of-the-fastpath.patch
mm-page_alloc-check-once-if-a-zone-has-isolated-pageblocks.patch
mm-page_alloc-shorten-the-page-allocator-fast-path.patch
mm-page_alloc-reduce-cost-of-fair-zone-allocation-policy-retry.patch
mm-page_alloc-shortcut-watermark-checks-for-order-0-pages.patch
mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice.patch
mm-page_alloc-remove-field-from-alloc_context.patch
mm-page_alloc-check-multiple-page-fields-with-a-single-branch.patch
mm-page_alloc-remove-unnecessary-variable-from-free_pcppages_bulk.patch
mm-page_alloc-inline-pageblock-lookup-in-page-free-fast-paths.patch
mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain.patch
mm-page_alloc-defer-debugging-checks-of-pages-allocated-from-the-pcp.patch

