From: akpm@linux-foundation.org
Subject: [patch 09/26] userfaultfd: non-cooperative: robustness check
Date: Thu, 09 Mar 2017 16:16:52 -0800
Message-ID: <58c1f074.EbZmFLqfKnOAVlqh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51282 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751366AbdCJAQx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Mar 2017 19:16:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, xemul@parallels.com

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
@@ -530,8 +530,13 @@ out:
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
 
@@ -566,7 +571,7 @@ static int userfaultfd_event_wait_comple
 	 * ctx may go away after this if the userfault pseudo fd is
 	 * already released.
 	 */
