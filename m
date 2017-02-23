From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-hugetlbfs-reserve-count-on-error-in-__mcopy_atomic_hugetlb.patch removed from -mm tree
Date: Thu, 23 Feb 2017 13:14:25 -0800
Message-ID: <58af50b1.pLwImOccBJ05Ovs0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39878 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751223AbdBWVOt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:14:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: hugetlbfs: reserve count on error in __mcopy_atomic_hugetlb
has been removed from the -mm tree.  Its filename was
     userfaultfd-hugetlbfs-reserve-count-on-error-in-__mcopy_atomic_hugetlb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: userfaultfd: hugetlbfs: reserve count on error in __mcopy_atomic_hugetlb

If __mcopy_atomic_hugetlb exits with an error, put_page will be called if
a huge page was allocated and needs to be freed.  If a reservation was
associated with the huge page, the PagePrivate flag will be set.  Clear
PagePrivate before calling put_page/free_huge_page so that the global
reservation count is not incremented.

Link: http://lkml.kernel.org/r/20161216144821.5183-26-aarcange@redhat.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff -puN mm/userfaultfd.c~userfaultfd-hugetlbfs-reserve-count-on-error-in-__mcopy_atomic_hugetlb mm/userfaultfd.c
--- a/mm/userfaultfd.c~userfaultfd-hugetlbfs-reserve-count-on-error-in-__mcopy_atomic_hugetlb
+++ a/mm/userfaultfd.c
@@ -301,8 +301,23 @@ retry:
 out_unlock:
 	up_read(&dst_mm->mmap_sem);
 out:
-	if (page)
+	if (page) {
+		/*
+		 * We encountered an error and are about to free a newly
+		 * allocated huge page.  It is possible that there was a
+		 * reservation associated with the page that has been
+		 * consumed.  See the routine restore_reserve_on_error
+		 * for details.  Unfortunately, we can not call
+		 * restore_reserve_on_error now as it would require holding
+		 * mmap_sem.  Clear the PagePrivate flag so that the global
+		 * reserve count will not be incremented in free_huge_page.
+		 * The reservation map will still indicate the reservation
+		 * was consumed and possibly prevent later page allocation.
+		 * This is better than leaking a global reservation.
+		 */
+		ClearPagePrivate(page);
 		put_page(page);
+	}
 	BUG_ON(copied < 0);
 	BUG_ON(err > 0);
 	BUG_ON(!copied && !err);
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


