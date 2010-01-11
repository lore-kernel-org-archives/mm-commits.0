From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-fix-clear_huge_page.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:18:55 -0800
Message-ID: <201001112018.o0BKIt6h025521@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54469 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754217Ab0AKUgd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:36:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dwg@au1.ibm.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: hugetlb: fix clear_huge_page()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-clear_huge_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: hugetlb: fix clear_huge_page()
From: Andrea Arcangeli <aarcange@redhat.com>

sz is in bytes, MAX_ORDER_NR_PAGES is in pages.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Gibson <dwg@au1.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: David Rientjes <rientjes@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlb-fix-clear_huge_page mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-fix-clear_huge_page
+++ a/mm/hugetlb.c
@@ -402,7 +402,7 @@ static void clear_huge_page(struct page 
 {
 	int i;
 
-	if (unlikely(sz > MAX_ORDER_NR_PAGES)) {
+	if (unlikely(sz/PAGE_SIZE > MAX_ORDER_NR_PAGES)) {
 		clear_gigantic_page(page, addr, sz);
 		return;
 	}
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch

