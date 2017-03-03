From: akpm@linux-foundation.org
Subject: + userfaultfd-non-cooperative-rollback-userfaultfd_exit-fix.patch added to -mm tree
Date: Fri, 03 Mar 2017 14:45:52 -0800
Message-ID: <58b9f220.QoJA52DlKo8lKi6E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42282 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751742AbdCCWp5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 17:45:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: documentation fixup after removal of UFFD_EVENT_EXIT
has been added to the -mm tree.  Its filename is
     userfaultfd-non-cooperative-rollback-userfaultfd_exit-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-non-cooperative-rollback-userfaultfd_exit-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-non-cooperative-rollback-userfaultfd_exit-fix.patch

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
Subject: userfaultfd: documentation fixup after removal of UFFD_EVENT_EXIT

Link: http://lkml.kernel.org/r/1488345437-4364-1-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/userfaultfd.txt |    4 ----
 1 file changed, 4 deletions(-)

diff -puN Documentation/vm/userfaultfd.txt~userfaultfd-non-cooperative-rollback-userfaultfd_exit-fix Documentation/vm/userfaultfd.txt
--- a/Documentation/vm/userfaultfd.txt~userfaultfd-non-cooperative-rollback-userfaultfd_exit-fix
+++ a/Documentation/vm/userfaultfd.txt
@@ -172,10 +172,6 @@ the same read(2) protocol as for the pag
 manager has to explicitly enable these events by setting appropriate
 bits in uffdio_api.features passed to UFFDIO_API ioctl:
 
-UFFD_FEATURE_EVENT_EXIT - enable notification about exit() of the
-non-cooperative process. When the monitored process exits, the uffd
-manager will get UFFD_EVENT_EXIT.
