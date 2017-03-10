From: akpm@linux-foundation.org
Subject: [patch 15/26] userfaultfd: non-cooperative: fix fork fctx->new
 memleak
Date: Thu, 09 Mar 2017 16:17:09 -0800
Message-ID: <58c1f085./AQDs1Em1/Uml+w7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51370 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754515AbdCJARP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Mar 2017 19:17:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, rppt@linux.vnet.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, xemul@parallels.com

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
