From: akpm@linux-foundation.org
Subject: + hugetlb-correct-page-count-for-surplus-huge-pages-fix.patch added to -mm tree
Date: Tue, 04 Mar 2008 14:05:30 -0800
Message-ID: <200803042205.m24M5Vtm031531@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756175AbYCDWGV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 17:06:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: agl@us.ibm.com, kamalesh@linux.vnet.ibm.com


The patch titled
     2.6.25-rc3-mm1 kernel bug while running libhugetlbfs
has been added to the -mm tree.  Its filename is
     hugetlb-correct-page-count-for-surplus-huge-pages-fix.patch

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
Subject: 2.6.25-rc3-mm1 kernel bug while running libhugetlbfs
From: Adam Litke <agl@us.ibm.com>

On Tue, 2008-03-04 at 11:51 -0800, Andrew Morton wrote:
> hugetlb-correct-page-count-for-surplus-huge-pages.patch adds:
>
>         if (page) {
>                 /*
>                  * This page is now managed by the hugetlb allocator and has
>                  * no users -- drop the buddy allocator's reference.
>                  */
>                 int page_count = put_page_testzero(page);
>                 BUG_ON(page_count != 0);
>
>

Ugh I got bitten by put_page_testzero().  When it returns 1, the page
count is zero (not the page count).

My initial version had a BUG_ON() with side-effects.  When a reviewer
pointed it out, I thought I could fix the patch up on its way out the
door.  I have self-administered my punishment.  This patch will fix it:

Signed-off-by: Adam Litke <agl@us.ibm.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-correct-page-count-for-surplus-huge-pages-fix mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-correct-page-count-for-surplus-huge-pages-fix
+++ a/mm/hugetlb.c
@@ -290,8 +290,8 @@ static struct page *alloc_buddy_huge_pag
 		 * This page is now managed by the hugetlb allocator and has
 		 * no users -- drop the buddy allocator's reference.
 		 */
-		int page_count = put_page_testzero(page);
-		BUG_ON(page_count != 0);
+		put_page_testzero(page);
+		VM_BUG_ON(page_count(page));
 		nid = page_to_nid(page);
 		set_compound_page_dtor(page, free_huge_page);
 		/*
_

Patches currently in -mm which might be from agl@us.ibm.com are

hugetlb-close-a-difficult-to-trigger-reservation-race.patch
hugetlb-fix-pool-shrinking-while-in-restricted-cpuset.patch
hugetlb-correct-page-count-for-surplus-huge-pages.patch
hugetlb-correct-page-count-for-surplus-huge-pages-fix.patch
hugetlb-decrease-hugetlb_lock-cycling-in-gather_surplus_huge_pages.patch

