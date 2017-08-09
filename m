From: akpm@linux-foundation.org
Subject: +
 userfaultfd-replace-enospc-with-esrch-in-case-mm-has-gone-during-copy-zeropage.patch added to -mm tree
Date: Tue, 08 Aug 2017 17:06:16 -0700
Message-ID: <598a51f8./AWmkwDPDBCLa3eZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35692 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751970AbdHIAGR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Aug 2017 20:06:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com, xemul@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: replace ENOSPC with ESRCH in case mm has gone during copy/zeropage
has been added to the -mm tree.  Its filename is
     userfaultfd-replace-enospc-with-esrch-in-case-mm-has-gone-during-copy-zeropage.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-replace-enospc-with-esrch-in-case-mm-has-gone-during-copy-zeropage.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-replace-enospc-with-esrch-in-case-mm-has-gone-during-copy-zeropage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd: replace ENOSPC with ESRCH in case mm has gone during copy/zeropage

When the process exit races with outstanding mcopy_atomic, it would be
better to return ESRCH error.  When such race occurs the process and it's
mm are going away and returning "no such process" to the uffd monitor
seems better fit than ENOSPC.

Link: http://lkml.kernel.org/r/1502111545-32305-1-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-replace-enospc-with-esrch-in-case-mm-has-gone-during-copy-zeropage fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-replace-enospc-with-esrch-in-case-mm-has-gone-during-copy-zeropage
+++ a/fs/userfaultfd.c
@@ -1600,7 +1600,7 @@ static int userfaultfd_copy(struct userf
 				   uffdio_copy.len);
 		mmput(ctx->mm);
 	} else {
-		return -ENOSPC;
+		return -ESRCH;
 	}
 	if (unlikely(put_user(ret, &user_uffdio_copy->copy)))
 		return -EFAULT;
@@ -1647,7 +1647,7 @@ static int userfaultfd_zeropage(struct u
 				     uffdio_zeropage.range.len);
 		mmput(ctx->mm);
 	} else {
-		return -ENOSPC;
+		return -ESRCH;
 	}
 	if (unlikely(put_user(ret, &user_uffdio_zeropage->zeropage)))
 		return -EFAULT;
_

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are

userfaultfd-replace-enospc-with-esrch-in-case-mm-has-gone-during-copy-zeropage.patch
shmem-shmem_charge-verify-max_block-is-not-exceeded-before-inode-update.patch
shmem-introduce-shmem_inode_acct_block.patch
userfaultfd-shmem-add-shmem_mfill_zeropage_pte-for-userfaultfd-support.patch
userfaultfd-mcopy_atomic-introduce-mfill_atomic_pte-helper.patch
userfaultfd-shmem-wire-up-shmem_mfill_zeropage_pte.patch
userfaultfd-report-uffdio_zeropage-as-available-for-shmem-vmas.patch
userfaultfd-selftest-enable-testing-of-uffdio_zeropage-for-shmem.patch

