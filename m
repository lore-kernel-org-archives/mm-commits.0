From: akpm@linux-foundation.org
Subject: [merged] mm-make-the-function-vma_has_reserves-bool.patch removed from -mm tree
Date: Tue, 08 Sep 2015 11:12:17 -0700
Message-ID: <55ef2501.tW0RMheetIu8nr7d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60429 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbbIHSMR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:12:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xerofoify@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: make vma_has_reserves() return bool
has been removed from the -mm tree.  Its filename was
     mm-make-the-function-vma_has_reserves-bool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nicholas Krause <xerofoify@gmail.com>
Subject: mm/hugetlb.c: make vma_has_reserves() return bool

This makes vma_has_reserves() return bool due to this particular function
only returning either one or zero as its return value.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/hugetlb.c~mm-make-the-function-vma_has_reserves-bool mm/hugetlb.c
--- a/mm/hugetlb.c~mm-make-the-function-vma_has_reserves-bool
+++ a/mm/hugetlb.c
@@ -616,7 +616,7 @@ void reset_vma_resv_huge_pages(struct vm
 }
 
 /* Returns true if the VMA has associated reserve pages */
-static int vma_has_reserves(struct vm_area_struct *vma, long chg)
+static bool vma_has_reserves(struct vm_area_struct *vma, long chg)
 {
 	if (vma->vm_flags & VM_NORESERVE) {
 		/*
@@ -629,23 +629,23 @@ static int vma_has_reserves(struct vm_ar
 		 * properly, so add work-around here.
 		 */
 		if (vma->vm_flags & VM_MAYSHARE && chg == 0)
-			return 1;
+			return true;
 		else
-			return 0;
+			return false;
 	}
 
 	/* Shared mappings always use reserves */
 	if (vma->vm_flags & VM_MAYSHARE)
-		return 1;
+		return true;
 
 	/*
 	 * Only the process that called mmap() has reserves for
 	 * private mappings.
 	 */
 	if (is_vma_resv_set(vma, HPAGE_RESV_OWNER))
-		return 1;
+		return true;
 
-	return 0;
+	return false;
 }
 
 static void enqueue_huge_page(struct hstate *h, struct page *page)
_

Patches currently in -mm which might be from xerofoify@gmail.com are

mm-make-the-function-set_recommended_min_free_kbytes-have-a-return-type-of-void.patch

