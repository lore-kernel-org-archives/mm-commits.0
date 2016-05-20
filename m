From: akpm@linux-foundation.org
Subject: [patch 116/117] mm, page_alloc: uninline the bad page part of
 check_new_page()
Date: Thu, 19 May 2016 17:14:41 -0700
Message-ID: <573e56f1.AiWkMfv0ed6B6k8E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46654 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311AbcETAOm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:14:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vbabka@suse.cz, mgorman@techsingularity.net

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: uninline the bad page part of check_new_page()

Bad pages should be rare so the code handling them doesn't need to be
inline for performance reasons.  Put it to separate function which returns
void.  This also assumes that the initial page_expected_state() result
will match the result of the thorough check, i.e.  the page doesn't become
"good" in the meanwhile.  This matches the same expectations already in
place in free_pages_check().

!DEBUG_VM bloat-o-meter:

add/remove: 1/0 grow/shrink: 0/1 up/down: 134/-274 (-140)
function                                     old     new   delta
check_new_page_bad                             -     134    +134
get_page_from_freelist                      3468    3194    -274

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-uninline-the-bad-page-part-of-check_new_page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-uninline-the-bad-page-part-of-check_new_page
+++ a/mm/page_alloc.c
@@ -1647,19 +1647,11 @@ static inline void expand(struct zone *z
 	}
 }
 
-/*
- * This page is about to be returned from the page allocator
- */
-static inline int check_new_page(struct page *page)
+static void check_new_page_bad(struct page *page)
 {
-	const char *bad_reason;
-	unsigned long bad_flags;
+	const char *bad_reason = NULL;
+	unsigned long bad_flags = 0;
 
-	if (page_expected_state(page, PAGE_FLAGS_CHECK_AT_PREP|__PG_HWPOISON))
-		return 0;
-
-	bad_reason = NULL;
-	bad_flags = 0;
 	if (unlikely(atomic_read(&page->_mapcount) != -1))
 		bad_reason = "nonzero mapcount";
 	if (unlikely(page->mapping != NULL))
@@ -1678,11 +1670,20 @@ static inline int check_new_page(struct
 	if (unlikely(page->mem_cgroup))
 		bad_reason = "page still charged to cgroup";
 #endif
-	if (unlikely(bad_reason)) {
-		bad_page(page, bad_reason, bad_flags);
-		return 1;
-	}
-	return 0;
+	bad_page(page, bad_reason, bad_flags);
+}
+
+/*
+ * This page is about to be returned from the page allocator
+ */
+static inline int check_new_page(struct page *page)
+{
+	if (likely(page_expected_state(page,
+				PAGE_FLAGS_CHECK_AT_PREP|__PG_HWPOISON)))
+		return 0;
+
+	check_new_page_bad(page);
+	return 1;
 }
 
 static inline bool free_pages_prezeroed(bool poisoned)
_
