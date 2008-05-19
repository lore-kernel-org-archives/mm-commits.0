From: akpm@linux-foundation.org
Subject: + buddy-clarify-comments-describing-buddy-merge.patch added to -mm tree
Date: Mon, 19 May 2008 14:09:06 -0700
Message-ID: <200805192109.m4JL97pq020619@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756979AbYESVJU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 May 2008 17:09:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org


The patch titled
     buddy: clarify comments describing buddy merge
has been added to the -mm tree.  Its filename is
     buddy-clarify-comments-describing-buddy-merge.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -441,8 +441,9 @@ static inline void __free_one_page(struc
 
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

mm-add-a-basic-debugging-framework-for-memory-initialisation.patch
mm-add-a-basic-debugging-framework-for-memory-initialisation-fix.patch
mm-verify-the-page-links-and-memory-model.patch
mm-make-defensive-checks-around-pfn-values-registered-for-memory-usage.patch
mm-print-out-the-zonelists-on-request-for-manual-verification.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
buddy-clarify-comments-describing-buddy-merge.patch
update-checkpatchpl-to-version-019.patch
update-checkpatchpl-to-version-019-fix.patch
page-owner-tracking-leak-detector.patch

