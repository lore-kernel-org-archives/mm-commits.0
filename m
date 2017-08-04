From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd_zeropage-return-enospc-in-case-mm-has-gone.patch removed from
 -mm tree
Date: Fri, 04 Aug 2017 14:18:39 -0700
Message-ID: <20170804211839.18NwAWx6X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51872 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751891AbdHDVSk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 4 Aug 2017 17:18:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dgilbert@redhat.com, mhocko@kernel.org, mm-commits@vger.kernel.org, rppt@linux.vnet.ibm.com, stable@vger.kernel.org, xemul@virtuozzo.com


The patch titled
     Subject: userfaultfd_zeropage: return -ENOSPC in case mm has gone
has been removed from the -mm tree.  Its filename was
     userfaultfd_zeropage-return-enospc-in-case-mm-has-gone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd_zeropage: return -ENOSPC in case mm has gone

In the non-cooperative userfaultfd case, the process exit may race with
outstanding mcopy_atomic called by the uffd monitor.  Returning -ENOSPC
instead of -EINVAL when mm is already gone will allow uffd monitor to
distinguish this case from other error conditions.

Unfortunately I overlooked userfaultfd_zeropage when updating
userfaultd_copy().

Link: http://lkml.kernel.org/r/1501136819-21857-1-git-send-email-rppt@linux.vnet.ibm.com
Fixes: 96333187ab162 ("userfaultfd_copy: return -ENOSPC in case mm has gone")
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/userfaultfd.c~userfaultfd_zeropage-return-enospc-in-case-mm-has-gone fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd_zeropage-return-enospc-in-case-mm-has-gone
+++ a/fs/userfaultfd.c
@@ -1643,6 +1643,8 @@ static int userfaultfd_zeropage(struct u
 		ret = mfill_zeropage(ctx->mm, uffdio_zeropage.range.start,
 				     uffdio_zeropage.range.len);
 		mmput(ctx->mm);
+	} else {
+		return -ENOSPC;
 	}
 	if (unlikely(put_user(ret, &user_uffdio_zeropage->zeropage)))
 		return -EFAULT;
_

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are

shmem-shmem_charge-verify-max_block-is-not-exceeded-before-inode-update.patch
shmem-introduce-shmem_inode_acct_block.patch
userfaultfd-shmem-add-shmem_mfill_zeropage_pte-for-userfaultfd-support.patch
userfaultfd-mcopy_atomic-introduce-mfill_atomic_pte-helper.patch
userfaultfd-shmem-wire-up-shmem_mfill_zeropage_pte.patch
userfaultfd-report-uffdio_zeropage-as-available-for-shmem-vmas.patch
userfaultfd-selftest-enable-testing-of-uffdio_zeropage-for-shmem.patch

