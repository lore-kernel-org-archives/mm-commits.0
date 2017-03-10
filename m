From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-non-cooperative-fix-fork-fctx-new-memleak.patch removed from
 -mm tree
Date: Fri, 10 Mar 2017 13:43:12 -0800
Message-ID: <58c31df0.zOo8Vxh173jVhjkq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38042 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933047AbdCJVnO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Mar 2017 16:43:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: non-cooperative: fix fork fctx->new memleak
has been removed from the -mm tree.  Its filename was
     userfaultfd-non-cooperative-fix-fork-fctx-new-memleak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


