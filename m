From: akpm@linux-foundation.org
Subject: [patch 21/21] userfaultfd: replace ENOSPC with ESRCH in case mm
 has gone during copy/zeropage
Date: Thu, 10 Aug 2017 15:24:32 -0700
Message-ID: <598cdd20.R021p/RSHZc79v4h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48586 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753142AbdHJWYd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2017 18:24:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, rppt@linux.vnet.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com, xemul@virtuozzo.com

From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd: replace ENOSPC with ESRCH in case mm has gone during copy/zeropage

When the process exit races with outstanding mcopy_atomic, it would be
better to return ESRCH error.  When such race occurs the process and it's
mm are going away and returning "no such process" to the uffd monitor
seems better fit than ENOSPC.

Link: http://lkml.kernel.org/r/1502111545-32305-1-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
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
