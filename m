From: akpm@linux-foundation.org
Subject: - buddy-clarify-comments-describing-buddy-merge.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:21:57 -0700
Message-ID: <200807242321.m6ONLvuc010438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751938AbYGXXWF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:22:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     buddy: clarify comments describing buddy merge
has been removed from the -mm tree.  Its filename was
     buddy-clarify-comments-describing-buddy-merge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: buddy: clarify comments describing buddy merge
From: Andy Whitcroft <apw@shadowen.org>

In __free_one_page(), the comment "Move the buddy up one level" appears
attached to the break and by implication when the break is taken we are
moving it up one level:

	if (!page_is_buddy(page, buddy, order))
		break;          /* Move the buddy up one level. */

In reality the inverse is true, we break out when we can no longer merge
this page with its buddy.  Looking back into pre-history (into the full
git history) it appears that these two lines accidentally got joined as
part of another change.

Move the comment down where it belongs below the if and clarify its
language.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~buddy-clarify-comments-describing-buddy-merge mm/page_alloc.c
--- a/mm/page_alloc.c~buddy-clarify-comments-describing-buddy-merge
+++ a/mm/page_alloc.c
@@ -432,8 +432,9 @@ static inline void __free_one_page(struc
 
 		buddy = __page_find_buddy(page, page_idx, order);
 		if (!page_is_buddy(page, buddy, order))
-			break;		/* Move the buddy up one level. */
+			break;
 
+		/* Our buddy is free, merge with it and move up one order. */
 		list_del(&buddy->lru);
 		zone->free_area[order].nr_free--;
 		rmv_page_order(buddy);
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
x86-implement-pte_special.patch
x86-implement-pte_special-fix.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
page-owner-tracking-leak-detector.patch

