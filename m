From: akpm@linux-foundation.org
Subject: [patch 059/142] userfaultfd: non-cooperative: avoid MADV_DONTNEED race condition
Date: Wed, 22 Feb 2017 15:42:43 -0800
Message-ID: <58ae21f3.9VjhnbULOAIHWgoL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48502 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934657AbdBVXmz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:42:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aarcange@redhat.com, RAPOPORT@il.ibm.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com

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
