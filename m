From: akpm@linux-foundation.org
Subject: + userfaultfd_zeropage-return-enospc-in-case-mm-has-gone.patch
 added to -mm tree
Date: Thu, 27 Jul 2017 14:20:46 -0700
Message-ID: <597a592e.lO8/JFzeBVw7r79r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54598 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751544AbdG0VUr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Jul 2017 17:20:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, stable@vger.kernel.org, xemul@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd_zeropage: return -ENOSPC in case mm has gone
has been added to the -mm tree.  Its filename is
     userfaultfd_zeropage-return-enospc-in-case-mm-has-gone.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd_zeropage-return-enospc-in-case-mm-has-gone.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd_zeropage-return-enospc-in-case-mm-has-gone.patch

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

userfaultfd-non-cooperative-notify-about-unmap-of-destination-during-mremap.patch
userfaultfd_zeropage-return-enospc-in-case-mm-has-gone.patch

