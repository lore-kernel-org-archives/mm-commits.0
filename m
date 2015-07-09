From: akpm@linux-foundation.org
Subject: + mm-make-the-function-vma_has_reserves-bool.patch added to -mm
 tree
Date: Thu, 09 Jul 2015 15:50:06 -0700
Message-ID: <559efa9e.kEche6JWidpPMniI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53422 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbbGIWuH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 18:50:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xerofoify@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: make vma_has_reserves() return bool
has been added to the -mm tree.  Its filename is
     mm-make-the-function-vma_has_reserves-bool.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-make-the-function-vma_has_reserves-bool.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-make-the-function-vma_has_reserves-bool.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

hugetlb-make-the-function-vma_shareable-bool.patch
mm-change-function-return-from-int-to-bool-for-the-function-is_page_busy.patch
memory-make-the-function-tlb_next_batch-bool-now.patch
mm-make-the-function-madvise_behaviour_valid-bool.patch
mm-make-the-function-vma_has_reserves-bool.patch
linux-next.patch

