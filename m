From: akpm@linux-foundation.org
Subject: +
 mm-hugetlbc-clean-code-by-removing-unnecessary-initialization.patch added
 to -mm tree
Date: Tue, 03 Mar 2020 15:43:01 -0800
Message-ID: <20200303234301.FqIWrVrgL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727429AbgCCXnC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Mar 2020 18:43:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mateusznosek0@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: clean code by removing unnecessary initialization
has been added to the -mm tree.  Its filename is
     mm-hugetlbc-clean-code-by-removing-unnecessary-initialization.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlbc-clean-code-by-removing-unnecessary-initialization.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlbc-clean-code-by-removing-unnecessary-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mateusz Nosek <mateusznosek0@gmail.com>
Subject: mm/hugetlb.c: clean code by removing unnecessary initialization

Previously variable 'check_addr' was initialized, but was not read later
before reassigning.  So the initialization can be removed.

Link: http://lkml.kernel.org/r/20200303212354.25226-1-mateusznosek0@gmail.com
Signed-off-by: Mateusz Nosek <mateusznosek0@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlbc-clean-code-by-removing-unnecessary-initialization
+++ a/mm/hugetlb.c
@@ -5020,7 +5020,7 @@ static bool vma_shareable(struct vm_area
 void adjust_range_if_pmd_sharing_possible(struct vm_area_struct *vma,
 				unsigned long *start, unsigned long *end)
 {
-	unsigned long check_addr = *start;
+	unsigned long check_addr;
 
 	if (!(vma->vm_flags & VM_MAYSHARE))
 		return;
_

Patches currently in -mm which might be from mateusznosek0@gmail.com are

mm-vmscanc-clean-code-by-removing-unnecessary-assignment.patch
mm-hugetlbc-clean-code-by-removing-unnecessary-initialization.patch
mm-shmemc-clean-code-by-removing-unnecessary-assignment.patch
mm-mm_initc-clean-code-use-build_bug_on-when-comparing-compile-time-constant.patch
