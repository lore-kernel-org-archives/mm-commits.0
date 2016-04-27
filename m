From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-uninline-the-bad-page-part-of-check_new_page.patch added to
 -mm tree
Date: Wed, 27 Apr 2016 12:45:01 -0700
Message-ID: <572116bd.gsndvaUnPRI+GINX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48418 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbcD0TpD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Apr 2016 15:45:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, mgorman@techsingularity.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: uninline the bad page part of check_new_page()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-uninline-the-bad-page-part-of-check_new_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-uninline-the-bad-page-part-of-check_new_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-uninline-the-bad-page-part-of-check_new_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -1650,19 +1650,11 @@ static inline void expand(struct zone *z
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
@@ -1681,11 +1673,20 @@ static inline int check_new_page(struct
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

Patches currently in -mm which might be from vbabka@suse.cz are

mm-wake-kcompactd-before-kswapds-short-sleep.patch
mm-compaction-wrap-calculating-first-and-last-pfn-of-pageblock.patch
compaction-wrap-calculating-first-and-last-pfn-of-pageblock-fix.patch
mm-compaction-reduce-spurious-pcplist-drains.patch
mm-compaction-skip-blocks-where-isolation-fails-in-async-direct-compaction.patch
mm-page_alloc-un-inline-the-bad-part-of-free_pages_check.patch
cpuset-use-static-key-better-and-convert-to-new-api.patch
mm-page_alloc-uninline-the-bad-page-part-of-check_new_page.patch

