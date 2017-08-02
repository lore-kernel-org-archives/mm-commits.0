From: akpm@linux-foundation.org
Subject: +
 userfaultfd-call-userfaultfd_unmap_prep-only-if-__split_vma-succeeds.patch
 added to -mm tree
Date: Wed, 02 Aug 2017 14:29:42 -0700
Message-ID: <59824446.2dhyIU2baXPzyAPw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41400 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751067AbdHBV3n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 17:29:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, a.perevalov@samsung.com, dgilbert@redhat.com, maxime.coquelin@redhat.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: call userfaultfd_unmap_prep only if __split_vma succeeds
has been added to the -mm tree.  Its filename is
     userfaultfd-call-userfaultfd_unmap_prep-only-if-__split_vma-succeeds.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-call-userfaultfd_unmap_prep-only-if-__split_vma-succeeds.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-call-userfaultfd_unmap_prep-only-if-__split_vma-succeeds.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: userfaultfd: call userfaultfd_unmap_prep only if __split_vma succeeds

A __split_vma is not a worthy event to report, and it's definitely not a
unmap so it would be incorrect to report unmap for the whole region to the
userfaultfd manager if a __split_vma fails.

So only call userfaultfd_unmap_prep after the __vma_splitting is over and
do_munmap cannot fail anymore.

Also add unlikely because it's better to optimize for the vast majority of
apps that aren't using userfaultfd in a non cooperative way.  Ideally we
should also find a way to eliminate the branch entirely if
CONFIG_USERFAULTFD=n, but it would complicate things so stick to unlikely
for now.

Link: http://lkml.kernel.org/r/20170802165145.22628-5-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Alexey Perevalov <a.perevalov@samsung.com>
Cc: Maxime Coquelin <maxime.coquelin@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff -puN mm/mmap.c~userfaultfd-call-userfaultfd_unmap_prep-only-if-__split_vma-succeeds mm/mmap.c
--- a/mm/mmap.c~userfaultfd-call-userfaultfd_unmap_prep-only-if-__split_vma-succeeds
+++ a/mm/mmap.c
@@ -2639,13 +2639,6 @@ int do_munmap(struct mm_struct *mm, unsi
 	if (vma->vm_start >= end)
 		return 0;
 
-	if (uf) {
-		int error = userfaultfd_unmap_prep(vma, start, end, uf);
-
-		if (error)
-			return error;
-	}
-
 	/*
 	 * If we need to split any vma, do it now to save pain later.
 	 *
@@ -2679,6 +2672,21 @@ int do_munmap(struct mm_struct *mm, unsi
 	}
 	vma = prev ? prev->vm_next : mm->mmap;
 
+	if (unlikely(uf)) {
+		/*
+		 * If userfaultfd_unmap_prep returns an error the vmas
+		 * will remain splitted, but userland will get a
+		 * highly unexpected error anyway. This is no
+		 * different than the case where the first of the two
+		 * __split_vma fails, but we don't undo the first
+		 * split, despite we could. This is unlikely enough
+		 * failure that it's not worth optimizing it for.
+		 */
+		int error = userfaultfd_unmap_prep(vma, start, end, uf);
+		if (error)
+			return error;
+	}
+
 	/*
 	 * unlock any mlock()ed ranges before detaching vmas
 	 */
_

Patches currently in -mm which might be from aarcange@redhat.com are

userfaultfd-hugetlbfs-remove-superfluous-page-unlock-in-vm_shared-case.patch
userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist.patch
userfaultfd-selftest-explicit-failure-if-the-sigbus-test-failed.patch
userfaultfd-call-userfaultfd_unmap_prep-only-if-__split_vma-succeeds.patch
userfaultfd-provide-pid-in-userfault-msg-add-feat-union.patch

