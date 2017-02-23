From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-non-cooperative-avoid-madv_dontneed-race-condition.patch
 removed from -mm tree
Date: Thu, 23 Feb 2017 13:13:49 -0800
Message-ID: <58af508d.41qsvRy4EDxi/RoQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39910 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751223AbdBWVOr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:14:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, RAPOPORT@il.ibm.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: non-cooperative: avoid MADV_DONTNEED race condition
has been removed from the -mm tree.  Its filename was
     userfaultfd-non-cooperative-avoid-madv_dontneed-race-condition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: non-cooperative: avoid MADV_DONTNEED race condition

MADV_DONTNEED must be notified to userland before the pages are zapped. 
This allows userland to immediately stop adding pages to the userfaultfd
ranges before the pages are actually zapped or there could be non-zeropage
leftovers as result of concurrent UFFDIO_COPY run in between
zap_page_range and madvise_userfault_dontneed (both MADV_DONTNEED and
UFFDIO_COPY runs under the mmap_sem for reading, so they can run
concurrently).

Link: http://lkml.kernel.org/r/20161216144821.5183-15-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/madvise.c~userfaultfd-non-cooperative-avoid-madv_dontneed-race-condition mm/madvise.c
--- a/mm/madvise.c~userfaultfd-non-cooperative-avoid-madv_dontneed-race-condition
+++ a/mm/madvise.c
@@ -477,8 +477,8 @@ static long madvise_dontneed(struct vm_a
 	if (vma->vm_flags & (VM_LOCKED|VM_HUGETLB|VM_PFNMAP))
 		return -EINVAL;
 
-	zap_page_range(vma, start, end - start, NULL);
 	madvise_userfault_dontneed(vma, prev, start, end);
+	zap_page_range(vma, start, end - start, NULL);
 	return 0;
 }
 
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2.patch
userfaultfd-mcopy_atomic-return-enoent-when-no-compatible-vma-found-fix-2-fix-fix.patch

