From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 151/155] mm/hugetlb.c: clean code by removing
 unnecessary initialization
Date: Wed, 01 Apr 2020 21:11:45 -0700
Message-ID: <20200402041145.oU4KXU7yk%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBELs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:11:48 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux-mm@kvack.org, mateusznosek0@gmail.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
