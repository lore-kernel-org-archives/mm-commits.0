From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_allocc-bad_-is-not-necessary-when-pagehwpoison.patch removed from
 -mm tree
Date: Thu, 04 Jun 2020 10:17:43 -0700
Message-ID: <20200604171743.1mNhPbM59%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729999AbgFDRRo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:17:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, rientjes@google.com


The patch titled
     Subject: mm/page_alloc.c: bad_[reason|flags] is not necessary when PageHWPoison
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-bad_-is-not-necessary-when-pagehwpoison.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/page_alloc.c: bad_[reason|flags] is not necessary when PageHWPoison

Patch series "mm/page_alloc.c: cleanup on check page", v3.

This patchset does some cleanup related to check page.

1. Remove unnecessary bad_reason assignment
2. Remove bad_flags to bad_page()
3. Rename function for naming convention
4. Extract common part to check page

Thanks for suggestions from David Rientjes and Anshuman Khandual.


This patch (of 5):

Since function returns directly, bad_[reason|flags] is not used any where.
And move this to the first.

This is a following cleanup for commit e570f56cccd21 ("mm:
check_new_page_bad() directly returns in __PG_HWPOISON case")

Link: http://lkml.kernel.org/r/20200411220357.9636-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-bad_-is-not-necessary-when-pagehwpoison
+++ a/mm/page_alloc.c
@@ -2097,19 +2097,17 @@ static void check_new_page_bad(struct pa
 	const char *bad_reason = NULL;
 	unsigned long bad_flags = 0;
 
+	if (unlikely(page->flags & __PG_HWPOISON)) {
+		/* Don't complain about hwpoisoned pages */
+		page_mapcount_reset(page); /* remove PageBuddy */
+		return;
+	}
 	if (unlikely(atomic_read(&page->_mapcount) != -1))
 		bad_reason = "nonzero mapcount";
 	if (unlikely(page->mapping != NULL))
 		bad_reason = "non-NULL mapping";
 	if (unlikely(page_ref_count(page) != 0))
 		bad_reason = "nonzero _refcount";
-	if (unlikely(page->flags & __PG_HWPOISON)) {
-		bad_reason = "HWPoisoned (hardware-corrupted)";
-		bad_flags = __PG_HWPOISON;
-		/* Don't complain about hwpoisoned pages */
-		page_mapcount_reset(page); /* remove PageBuddy */
-		return;
-	}
 	if (unlikely(page->flags & PAGE_FLAGS_CHECK_AT_PREP)) {
 		bad_reason = "PAGE_FLAGS_CHECK_AT_PREP flag set";
 		bad_flags = PAGE_FLAGS_CHECK_AT_PREP;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

bitops-simplify-get_count_order_long.patch
bitops-use-the-same-mechanism-for-get_count_order.patch
lib-test-get_count_order-long-in-test_bitopsc.patch
