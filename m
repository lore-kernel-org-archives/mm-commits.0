From: akpm@linux-foundation.org
Subject: [merged] mm-page_allocc-cleanup-obsolete-km_user.patch removed
 from -mm tree
Date: Mon, 29 Jun 2015 13:37:47 -0700
Message-ID: <5591ac9b.AqMn8sbRarJQbsQd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50321 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbbF2Uhs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:37:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anisse@astier.eu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: cleanup obsolete KM_USER*
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-cleanup-obsolete-km_user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anisse Astier <anisse@astier.eu>
Subject: mm/page_alloc.c: cleanup obsolete KM_USER*

It's been five years now that KM_* kmap flags have been removed and that
we can call clear_highpage from any context.  So we remove prep_zero_pages
accordingly.

Signed-off-by: Anisse Astier <anisse@astier.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff -puN mm/page_alloc.c~mm-page_allocc-cleanup-obsolete-km_user mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-cleanup-obsolete-km_user
+++ a/mm/page_alloc.c
@@ -380,20 +380,6 @@ void prep_compound_page(struct page *pag
 	}
 }
 
-static inline void prep_zero_page(struct page *page, unsigned int order,
-							gfp_t gfp_flags)
-{
-	int i;
-
-	/*
-	 * clear_highpage() will use KM_USER0, so it's a bug to use __GFP_ZERO
-	 * and __GFP_HIGHMEM from hard or soft interrupt context.
-	 */
-	VM_BUG_ON((gfp_flags & __GFP_HIGHMEM) && in_interrupt());
-	for (i = 0; i < (1 << order); i++)
-		clear_highpage(page + i);
-}
