From: akpm@linux-foundation.org
Subject: [patch 14/16] userfaultfd: non-cooperative: flush event_wqh at
 release time
Date: Wed, 02 Aug 2017 13:32:24 -0700
Message-ID: <598236d8.+8z4r0ohhKM/fVWi%akpm__3433.8990146809$1501705949$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46192 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753077AbdHBUcZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 16:32:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, rppt@linux.vnet.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, stable@vger.kernel.org, xemul@virtuozzo.com

From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd: non-cooperative: flush event_wqh at release time

There may still be threads waiting on event_wqh at the time the userfault
file descriptor is closed.  Flush the events wait-queue to prevent waiting
threads from hanging.

Link: http://lkml.kernel.org/r/1501398127-30419-1-git-send-email-rppt@linux.vnet.ibm.com
Fixes: 9cd75c3cd4c3d ("userfaultfd: non-cooperative: add ability to report
non-PF events from uffd descriptor")
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/userfaultfd.c~userfaultfd-non-cooperative-flush-event_wqh-at-release-time fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-non-cooperative-flush-event_wqh-at-release-time
+++ a/fs/userfaultfd.c
@@ -854,6 +854,9 @@ wakeup:
 	__wake_up_locked_key(&ctx->fault_wqh, TASK_NORMAL, &range);
 	spin_unlock(&ctx->fault_pending_wqh.lock);
 
+	/* Flush pending events that may still wait on event_wqh */
+	wake_up_all(&ctx->event_wqh);
+
 	wake_up_poll(&ctx->fd_wqh, POLLHUP);
 	userfaultfd_ctx_put(ctx);
 	return 0;
_
