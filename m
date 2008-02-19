From: akpm@linux-foundation.org
Subject: + hugetlb-ensure-we-do-not-reference-a-surplus-page-after-handing-it-to-buddy.patch added to -mm tree
Date: Tue, 19 Feb 2008 15:30:19 -0800
Message-ID: <200802192331.m1JNVEfv005273@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59457 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751626AbYBSXbt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Feb 2008 18:31:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, agl@us.ibm.com, stable@kernel.org


The patch titled
     hugetlb: ensure we do not reference a surplus page after handing it to buddy
has been added to the -mm tree.  Its filename is
     hugetlb-ensure-we-do-not-reference-a-surplus-page-after-handing-it-to-buddy.patch

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
Subject: hugetlb: ensure we do not reference a surplus page after handing it to buddy
From: Andy Whitcroft <apw@shadowen.org>

When we free a page via free_huge_page and we detect that we are in surplus
the page will be returned to the buddy.  After this we no longer own the page.
 However at the end free_huge_page we clear out our mapping pointer from page
private.  Even where the page is not a surplus we free the page to the
hugepage pool, drop the pool locks and then clear page private.  In either
case the page may have been reallocated.  BAD.

Make sure we clear out page private before we free the page.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Adam Litke <agl@us.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlb-ensure-we-do-not-reference-a-surplus-page-after-handing-it-to-buddy mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-ensure-we-do-not-reference-a-surplus-page-after-handing-it-to-buddy
+++ a/mm/hugetlb.c
@@ -120,6 +120,7 @@ static void free_huge_page(struct page *
 	struct address_space *mapping;
 
 	mapping = (struct address_space *) page_private(page);
+	set_page_private(page, 0);
 	BUG_ON(page_count(page));
 	INIT_LIST_HEAD(&page->lru);
 
@@ -134,7 +135,6 @@ static void free_huge_page(struct page *
 	spin_unlock(&hugetlb_lock);
 	if (mapping)
 		hugetlb_put_quota(mapping, 1);
-	set_page_private(page, 0);
 }
 
 /*
_

Patches currently in -mm which might be from apw@shadowen.org are

hugetlb-ensure-we-do-not-reference-a-surplus-page-after-handing-it-to-buddy.patch
register_memory-unregister_memory-fix-use-after-free-and-refcounting.patch
page-owner-tracking-leak-detector.patch
