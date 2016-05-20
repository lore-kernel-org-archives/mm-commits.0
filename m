From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-un-inline-the-bad-part-of-free_pages_check.patch removed from -mm tree
Date: Fri, 20 May 2016 14:06:53 -0700
Message-ID: <573f7c6d.dK8HdhRN49yP9Tec%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbcETVGy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:06:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: un-inline the bad part of free_pages_check
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-un-inline-the-bad-part-of-free_pages_check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: un-inline the bad part of free_pages_check

From: Vlastimil Babka <vbabka@suse.cz>

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

[akpm@linux-foundation.org: fix whitespace]
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

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
 
@@ -836,6 +829,18 @@ static inline int free_pages_check(struc
 		bad_reason = "page still charged to cgroup";
 #endif
 	bad_page(page, bad_reason, bad_flags);
+}
+
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


