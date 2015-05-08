From: akpm@linux-foundation.org
Subject: + mm-page_allocc-cleanup-obsolete-km_user.patch added to -mm tree
Date: Fri, 08 May 2015 15:32:35 -0700
Message-ID: <554d3983.mBgqhIVZkFejtiX8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34529 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbbEHWcg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 May 2015 18:32:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anisse@astier.eu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: cleanup obsolete KM_USER*
has been added to the -mm tree.  Its filename is
     mm-page_allocc-cleanup-obsolete-km_user.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-cleanup-obsolete-km_user.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-cleanup-obsolete-km_user.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -453,20 +453,6 @@ void prep_compound_page(struct page *pag
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
