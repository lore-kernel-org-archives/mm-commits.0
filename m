From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlbc-clean-code-by-removing-unnecessary-initialization.patch removed
 from -mm tree
Date: Fri, 03 Apr 2020 13:41:00 -0700
Message-ID: <20200403204100._bjPBMVi6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727928AbgDCUlB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:41:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mateusznosek0@gmail.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: clean code by removing unnecessary initialization
has been removed from the -mm tree.  Its filename was
     mm-hugetlbc-clean-code-by-removing-unnecessary-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mateusz Nosek <mateusznosek0@gmail.com>
Subject: mm/hugetlb.c: clean code by removing unnecessary initialization

Previously variable 'check_addr' was initialized, but was not read later
before reassigning.  So the initialization can be removed.

Link: http://lkml.kernel.org/r/20200303212354.25226-1-mateusznosek0@gmail.com
Signed-off-by: Mateusz Nosek <mateusznosek0@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlbc-clean-code-by-removing-unnecessary-initialization
+++ a/mm/hugetlb.c
@@ -5156,7 +5156,7 @@ static bool vma_shareable(struct vm_area
 void adjust_range_if_pmd_sharing_possible(struct vm_area_struct *vma,
 				unsigned long *start, unsigned long *end)
 {
-	unsigned long check_addr = *start;
+	unsigned long check_addr;
 
 	if (!(vma->vm_flags & VM_MAYSHARE))
 		return;
_

Patches currently in -mm which might be from mateusznosek0@gmail.com are

mm-shmemc-clean-code-by-removing-unnecessary-assignment.patch
mm-mm_initc-clean-code-use-build_bug_on-when-comparing-compile-time-constant.patch
mm-dmapoolc-micro-optimisation-remove-unnecessary-branch.patch
