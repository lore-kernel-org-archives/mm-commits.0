From: akpm@linux-foundation.org
Subject: + hugetlb-make-the-function-vma_shareable-bool.patch added to -mm tree
Date: Thu, 09 Jul 2015 15:17:50 -0700
Message-ID: <559ef30e.rHqCtmFcCLiWy/Hc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53042 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbbGIWRv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 18:17:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xerofoify@gmail.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: make vma_shareable() return bool
has been added to the -mm tree.  Its filename is
     hugetlb-make-the-function-vma_shareable-bool.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlb-make-the-function-vma_shareable-bool.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-make-the-function-vma_shareable-bool.patch

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

hugetlb-make-the-function-vma_shareable-bool.patch
linux-next.patch

