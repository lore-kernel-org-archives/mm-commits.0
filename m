From: akpm@linux-foundation.org
Subject: + userfaultfd-non-cooperative-fix-fork-fctx-new-memleak.patch
 added to -mm tree
Date: Fri, 03 Mar 2017 14:17:30 -0800
Message-ID: <58b9eb7a.p8qF4PgftBYUskej%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42046 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752118AbdCCWky (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 17:40:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: non-cooperative: fix fork fctx->new memleak
has been added to the -mm tree.  Its filename is
     userfaultfd-non-cooperative-fix-fork-fctx-new-memleak.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-non-cooperative-fix-fork-fctx-new-memleak.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-non-cooperative-fix-fork-fctx-new-memleak.patch

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
Subject: userfaultfd: non-cooperative: fix fork fctx->new memleak

We have a memleak in the ->new ctx if the uffd of the parent is closed
before the fork event is read, nothing frees the new context.

Link: http://lkml.kernel.org/r/20170302173738.18994-2-aarcange@redhat.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN fs/userfaultfd.c~userfaultfd-non-cooperative-fix-fork-fctx-new-memleak fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-non-cooperative-fix-fork-fctx-new-memleak
+++ a/fs/userfaultfd.c
@@ -549,6 +549,15 @@ static void userfaultfd_event_wait_compl
 		if (ACCESS_ONCE(ctx->released) ||
 		    fatal_signal_pending(current)) {
 			__remove_wait_queue(&ctx->event_wqh, &ewq->wq);
+			if (ewq->msg.event == UFFD_EVENT_FORK) {
+				struct userfaultfd_ctx *new;
+
+				new = (struct userfaultfd_ctx *)
+					(unsigned long)
+					ewq->msg.arg.reserved.reserved1;
+
+				userfaultfd_ctx_put(new);
+			}
 			break;
 		}
 
_

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are

userfaultfd-non-cooperative-fix-fork-fctx-new-memleak.patch

