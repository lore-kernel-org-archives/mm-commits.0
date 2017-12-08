From: akpm@linux-foundation.org
Subject: +
 mm-userfaultfd-thp-avoid-waiting-when-pmd-under-thp-migration.patch added
 to -mm tree
Date: Thu, 07 Dec 2017 16:15:50 -0800
Message-ID: <5a29d9b6.TdwWb/XV+5xXKSg5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36268 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752470AbdLHAPz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Dec 2017 19:15:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, rppt@linux.vnet.ibm.com, viro@zeniv.linux.org.UK, zi.yan@cs.rutgers.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, userfaultfd, THP: avoid waiting when PMD under THP migration
has been added to the -mm tree.  Its filename is
     mm-userfaultfd-thp-avoid-waiting-when-pmd-under-thp-migration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-userfaultfd-thp-avoid-waiting-when-pmd-under-thp-migration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-userfaultfd-thp-avoid-waiting-when-pmd-under-thp-migration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, userfaultfd, THP: avoid waiting when PMD under THP migration

If THP migration is enabled, for a VMA handled by userfaultfd, consider
the following situation,

do_page_fault()
  __do_huge_pmd_anonymous_page()
   handle_userfault()
     userfault_msg()
       /* a huge page is allocated and mapped at fault address */
       /* the huge page is under migration, leaves migration entry
          in page table */
     userfaultfd_must_wait()
       /* return true because !pmd_present() */
     /* may wait in loop until fatal signal */

That is, it may be possible for userfaultfd_must_wait() encounters a PMD
entry which is !pmd_none() && !pmd_present().  In the current
implementation, we will wait for such PMD entries, which may cause
unnecessary waiting, and potential soft lockup.

This is fixed via avoiding to wait when !pmd_none() && !pmd_present(),
only wait when pmd_none().

This may be not a problem in practice, because userfaultfd_must_wait() is
always called with mm->mmap_sem read-locked.  mremap() will write-lock
mm->mmap_sem.  And UFFDIO_COPY doesn't support to copy THP mapping.  But
the change introduced still makes the code more correct, and makes the PMD
and PTE code more consistent.

Link: http://lkml.kernel.org/r/20171207011752.3292-1-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.UK>
Cc: Zi Yan <zi.yan@cs.rutgers.edu>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/userfaultfd.c~mm-userfaultfd-thp-avoid-waiting-when-pmd-under-thp-migration fs/userfaultfd.c
--- a/fs/userfaultfd.c~mm-userfaultfd-thp-avoid-waiting-when-pmd-under-thp-migration
+++ a/fs/userfaultfd.c
@@ -294,10 +294,13 @@ static inline bool userfaultfd_must_wait
 	 * pmd_trans_unstable) of the pmd.
 	 */
 	_pmd = READ_ONCE(*pmd);
-	if (!pmd_present(_pmd))
+	if (pmd_none(_pmd))
 		goto out;
 
 	ret = false;
+	if (!pmd_present(_pmd))
+		goto out;
+
 	if (pmd_trans_huge(_pmd))
 		goto out;
 
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-userfaultfd-thp-avoid-waiting-when-pmd-under-thp-migration.patch

