From: akpm@linux-foundation.org
Subject: [merged] userfaultfd_copy-return-enospc-in-case-mm-has-gone.patch removed from -mm tree
Date: Mon, 27 Feb 2017 12:26:44 -0800
Message-ID: <58b48b84.RjSkUP3qrxObJRTu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60534 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751742AbdB0U16 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:27:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, xemul@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd_copy: return -ENOSPC in case mm has gone
has been removed from the -mm tree.  Its filename was
     userfaultfd_copy-return-enospc-in-case-mm-has-gone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd_copy: return -ENOSPC in case mm has gone

In the non-cooperative userfaultfd case, the process exit may race with
outstanding mcopy_atomic called by the uffd monitor.  Returning -ENOSPC
instead of -EINVAL when mm is already gone will allow uffd monitor to
distinguish this case from other error conditions.

Link: http://lkml.kernel.org/r/1485542673-24387-6-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/userfaultfd.c~userfaultfd_copy-return-enospc-in-case-mm-has-gone fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd_copy-return-enospc-in-case-mm-has-gone
+++ a/fs/userfaultfd.c
@@ -1607,6 +1607,8 @@ static int userfaultfd_copy(struct userf
 		ret = mcopy_atomic(ctx->mm, uffdio_copy.dst, uffdio_copy.src,
 				   uffdio_copy.len);
 		mmput(ctx->mm);
+	} else {
+		return -ENOSPC;
 	}
 	if (unlikely(put_user(ret, &user_uffdio_copy->copy)))
 		return -EFAULT;
_

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are


