From: akpm@linux-foundation.org
Subject: + userfaultfd-non-cooperative-robustness-check.patch added to -mm tree
Date: Tue, 28 Feb 2017 14:13:34 -0800
Message-ID: <58b5f60e.u2EUuHFuIN03fvA7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37320 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751099AbdB1X13 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 18:27:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: non-cooperative: robustness check
has been added to the -mm tree.  Its filename is
     userfaultfd-non-cooperative-robustness-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-non-cooperative-robustness-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-non-cooperative-robustness-check.patch

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
Subject: userfaultfd: non-cooperative: robustness check

Similar to the handle_userfault() case, also make sure to never
attempt to send any event past the PF_EXITING point of no return.

This is purely a robustness check.

Link: http://lkml.kernel.org/r/20170224181957.19736-3-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-non-cooperative-robustness-check fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-non-cooperative-robustness-check
+++ a/fs/userfaultfd.c
@@ -529,8 +529,13 @@ out:
 static int userfaultfd_event_wait_completion(struct userfaultfd_ctx *ctx,
 					     struct userfaultfd_wait_queue *ewq)
 {
-	int ret = 0;
+	int ret;
 
+	ret = -1;
+	if (WARN_ON_ONCE(current->flags & PF_EXITING))
+		goto out;
+
+	ret = 0;
 	ewq->ctx = ctx;
 	init_waitqueue_entry(&ewq->wq, current);
 
@@ -565,7 +570,7 @@ static int userfaultfd_event_wait_comple
 	 * ctx may go away after this if the userfault pseudo fd is
 	 * already released.
 	 */
