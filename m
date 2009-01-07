From: akpm@linux-foundation.org
Subject: - hugetlb-fix-sparse-warnings.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:13:42 -0800
Message-ID: <200901072213.n07MDg2r013738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43759 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762153AbZAGWNq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:13:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@hanneseder.net, nacc@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb: fix sparse warnings
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-sparse-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: fix sparse warnings
From: "Hannes Eder" <hannes@hanneseder.net>

Fix the following sparse warnings:

  mm/hugetlb.c:375:3: warning: returning void-valued expression
  mm/hugetlb.c:408:3: warning: returning void-valued expression

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
Acked-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-fix-sparse-warnings mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-fix-sparse-warnings
+++ a/mm/hugetlb.c
@@ -400,8 +400,10 @@ static void clear_huge_page(struct page 
 {
 	int i;
 
-	if (unlikely(sz > MAX_ORDER_NR_PAGES))
-		return clear_gigantic_page(page, addr, sz);
+	if (unlikely(sz > MAX_ORDER_NR_PAGES)) {
+		clear_gigantic_page(page, addr, sz);
+		return;
+	}
 
 	might_sleep();
 	for (i = 0; i < sz/PAGE_SIZE; i++) {
@@ -433,8 +435,10 @@ static void copy_huge_page(struct page *
 	int i;
 	struct hstate *h = hstate_vma(vma);
 
-	if (unlikely(pages_per_huge_page(h) > MAX_ORDER_NR_PAGES))
-		return copy_gigantic_page(dst, src, addr, vma);
+	if (unlikely(pages_per_huge_page(h) > MAX_ORDER_NR_PAGES)) {
+		copy_gigantic_page(dst, src, addr, vma);
+		return;
+	}
 
 	might_sleep();
 	for (i = 0; i < pages_per_huge_page(h); i++) {
_

Patches currently in -mm which might be from hannes@hanneseder.net are

origin.patch
linux-next.patch

