From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-check-multiple-page-fields-with-a-single-branch.patch removed from -mm tree
Date: Fri, 20 May 2016 14:06:51 -0700
Message-ID: <573f7c6b.KSefayfFHucTqvOh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47371 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbcETVGw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:06:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: check multiple page fields with a single branch
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-check-multiple-page-fields-with-a-single-branch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Vlastimil Babka <vbabka@suse.cz>
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
@@ -1492,9 +1518,14 @@ static inline void expand(struct zone *z
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


