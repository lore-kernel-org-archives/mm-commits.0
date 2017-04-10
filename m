From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-report-actual-registered-features-in-fdinfo.patch removed from
 -mm tree
Date: Mon, 10 Apr 2017 11:50:47 -0700
Message-ID: <58ebd407.L3+aJ0xTy3T3HQx2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46896 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752662AbdDJSus (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Apr 2017 14:50:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, aarcange@redhat.com, xemul@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: report actual registered features in fdinfo
has been removed from the -mm tree.  Its filename was
     userfaultfd-report-actual-registered-features-in-fdinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd: report actual registered features in fdinfo

fdinfo for userfault file descriptor reports UFFD_API_FEATURES.  Up until
recently, the UFFD_API_FEATURES was defined as 0, therefore corresponding
field in fdinfo always contained zero.  Now, with introduction of several
additional features, UFFD_API_FEATURES is not longer 0 and it seems better
to report actual features requested for the userfaultfd object described
by the fdinfo.  First, the applications that were using userfault will
still see zero at the features field in fdinfo.  Next, reporting actual
features rather than available features, gives clear indication of what
userfault features are used by an application.

Link: http://lkml.kernel.org/r/1491140181-22121-1-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/userfaultfd.c~userfaultfd-report-actual-registered-features-in-fdinfo fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-report-actual-registered-features-in-fdinfo
+++ a/fs/userfaultfd.c
@@ -1756,7 +1756,7 @@ static void userfaultfd_show_fdinfo(stru
 	 *	protocols: aa:... bb:...
 	 */
 	seq_printf(m, "pending:\t%lu\ntotal:\t%lu\nAPI:\t%Lx:%x:%Lx\n",
-		   pending, total, UFFD_API, UFFD_API_FEATURES,
+		   pending, total, UFFD_API, ctx->features,
 		   UFFD_API_IOCTLS|UFFD_API_RANGE_IOCTLS);
 }
 #endif
_

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are

userfaultfd-selftest-combine-all-cases-into-the-single-executable.patch

