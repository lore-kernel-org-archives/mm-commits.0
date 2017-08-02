From: akpm@linux-foundation.org
Subject: [patch 11/16] userfaultfd_zeropage: return -ENOSPC in case mm has gone
Date: Wed, 02 Aug 2017 13:32:15 -0700
Message-ID: <598236cf.DLBE5WzW2m62N79H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46036 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753053AbdHBUcQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 16:32:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, rppt@linux.vnet.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, mhocko@kernel.org, stable@vger.kernel.org, xemul@virtuozzo.com

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
