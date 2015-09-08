From: akpm@linux-foundation.org
Subject: [merged] hugetlb-make-the-function-vma_shareable-bool.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 11:11:52 -0700
Message-ID: <55ef24e8.OFBJPe0BXoiD65WL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60364 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbbIHSLw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:11:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xerofoify@gmail.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: make vma_shareable() return bool
has been removed from the -mm tree.  Its filename was
     hugetlb-make-the-function-vma_shareable-bool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nicholas Krause <xerofoify@gmail.com>
Subject: mm/hugetlb.c: make vma_shareable() return bool

This makes vma_shareable() return bool now due to this particular function
only ever returning either one or zero as its return value.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-make-the-function-vma_shareable-bool mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-make-the-function-vma_shareable-bool
+++ a/mm/hugetlb.c
@@ -3779,7 +3779,7 @@ static unsigned long page_table_shareabl
 	return saddr;
 }
 
-static int vma_shareable(struct vm_area_struct *vma, unsigned long addr)
+static bool vma_shareable(struct vm_area_struct *vma, unsigned long addr)
 {
 	unsigned long base = addr & PUD_MASK;
 	unsigned long end = base + PUD_SIZE;
@@ -3789,8 +3789,8 @@ static int vma_shareable(struct vm_area_
 	 */
 	if (vma->vm_flags & VM_MAYSHARE &&
 	    vma->vm_start <= base && end <= vma->vm_end)
-		return 1;
-	return 0;
+		return true;
+	return false;
 }
 
 /*
_

Patches currently in -mm which might be from xerofoify@gmail.com are

mm-make-the-function-set_recommended_min_free_kbytes-have-a-return-type-of-void.patch

