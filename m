From: akpm@linux-foundation.org
Subject: +
 userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing-fix.patch added to -mm tree
Date: Fri, 13 Jan 2017 13:37:56 -0800
Message-ID: <587948b4.qCSFBzsLjJEQXTuH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42980 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750908AbdAMVh5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2017 16:37:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: hugetlbfs: unmap the correct pointer
has been added to the -mm tree.  Its filename is
     userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: userfaultfd: hugetlbfs: unmap the correct pointer

kunmap_atomic() and kunmap() take different pointers.  People often get
these mixed up.

Fixes: 16374db2e9a0 ("userfaultfd: hugetlbfs: fix __mcopy_atomic_hugetlb retry/error processing")
Link: http://lkml.kernel.org/r/20170113082608.GA3548@mwanda
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing-fix mm/memory.c
--- a/mm/memory.c~userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing-fix
+++ a/mm/memory.c
@@ -4172,7 +4172,7 @@ long copy_huge_page_from_user(struct pag
 				(const void __user *)(src + i * PAGE_SIZE),
 				PAGE_SIZE);
 		if (allow_pagefault)
-			kunmap(page_kaddr);
+			kunmap(page_kaddr + i);
 		else
 			kunmap_atomic(page_kaddr);
 
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing-fix.patch

