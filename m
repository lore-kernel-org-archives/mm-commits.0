From: akpm@linux-foundation.org
Subject: +
 userfaultfd-hugetlbfs-reserve-count-on-error-in-__mcopy_atomic_hugetlb.patch added to -mm tree
Date: Wed, 04 Jan 2017 16:54:12 -0800
Message-ID: <586d9934.fzqGyy//S9/UvwX9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36234 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935141AbdAEAyX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 19:54:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: hugetlbfs: reserve count on error in __mcopy_atomic_hugetlb
has been added to the -mm tree.  Its filename is
     userfaultfd-hugetlbfs-reserve-count-on-error-in-__mcopy_atomic_hugetlb.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-hugetlbfs-reserve-count-on-error-in-__mcopy_atomic_hugetlb.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-hugetlbfs-reserve-count-on-error-in-__mcopy_atomic_hugetlb.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

userfaultfd-hugetlbfs-add-copy_huge_page_from_user-for-hugetlb-userfaultfd-support.patch
userfaultfd-hugetlbfs-add-hugetlb_mcopy_atomic_pte-for-userfaultfd-support.patch
userfaultfd-hugetlbfs-add-__mcopy_atomic_hugetlb-for-huge-page-uffdio_copy.patch
userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing.patch
userfaultfd-hugetlbfs-add-userfaultfd-hugetlb-hook.patch
userfaultfd-hugetlbfs-allow-registration-of-ranges-containing-huge-pages.patch
userfaultfd-hugetlbfs-add-userfaultfd_hugetlb-test.patch
userfaultfd-hugetlbfs-userfaultfd_huge_must_wait-for-hugepmd-ranges.patch
userfaultfd-hugetlbfs-reserve-count-on-error-in-__mcopy_atomic_hugetlb.patch

