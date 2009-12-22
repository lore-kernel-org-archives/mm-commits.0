From: akpm@linux-foundation.org
Subject: + mm-hugetlb-fix-clear_huge_page.patch added to -mm tree
Date: Tue, 22 Dec 2009 15:35:46 -0800
Message-ID: <200912222335.nBMNZkAX030999@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751293AbZLVXhG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Dec 2009 18:37:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, dwg@au1.ibm.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, rientjes@google.com


The patch titled
     mm: hugetlb: fix clear_huge_page()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-clear_huge_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
mm-hugetlb-fix-clear_huge_page.patch

