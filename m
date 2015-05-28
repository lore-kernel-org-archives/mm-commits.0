From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-remove-unused-arch-hook-prepare-release_hugepage.patch added to
 -mm tree
Date: Thu, 28 May 2015 13:35:05 -0700
Message-ID: <55677bf9.G3ujlRPxueaAnvER%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58623 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbbE1UfG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 May 2015 16:35:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dingel@linux.vnet.ibm.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: remove unused arch hook prepare/release_hugepage
has been added to the -mm tree.  Its filename is
     mm-hugetlb-remove-unused-arch-hook-prepare-release_hugepage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-remove-unused-arch-hook-prepare-release_hugepage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-remove-unused-arch-hook-prepare-release_hugepage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dominik Dingel <dingel@linux.vnet.ibm.com>
Subject: mm/hugetlb: remove unused arch hook prepare/release_hugepage

With s390 dropping support for emulated hugepages, the last user of
arch_prepare_hugepage and arch_release_hugepage is gone.

Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-remove-unused-arch-hook-prepare-release_hugepage mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-remove-unused-arch-hook-prepare-release_hugepage
+++ a/mm/hugetlb.c
@@ -975,7 +975,6 @@ static void update_and_free_page(struct
 		destroy_compound_gigantic_page(page, huge_page_order(h));
 		free_gigantic_page(page, huge_page_order(h));
 	} else {
-		arch_release_hugepage(page);
 		__free_pages(page, huge_page_order(h));
 	}
 }
@@ -1160,10 +1159,6 @@ static struct page *alloc_fresh_huge_pag
 						__GFP_REPEAT|__GFP_NOWARN,
 		huge_page_order(h));
 	if (page) {
-		if (arch_prepare_hugepage(page)) {
-			__free_pages(page, huge_page_order(h));
-			return NULL;
-		}
 		prep_new_huge_page(h, page, nid);
 	}
 
@@ -1315,11 +1310,6 @@ static struct page *alloc_buddy_huge_pag
 			htlb_alloc_mask(h)|__GFP_COMP|__GFP_THISNODE|
 			__GFP_REPEAT|__GFP_NOWARN, huge_page_order(h));
 
-	if (page && arch_prepare_hugepage(page)) {
-		__free_pages(page, huge_page_order(h));
-		page = NULL;
-	}
