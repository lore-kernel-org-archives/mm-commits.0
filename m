From: akpm@linux-foundation.org
Subject: +
 userfaultfd-non-cooperative-split-the-find_userfault-routine.patch added to -mm tree
Date: Wed, 04 Jan 2017 16:53:27 -0800
Message-ID: <586d9907.etSPVfh3k5sgg4Oz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38100 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S969957AbdAEBBm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 20:01:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@parallels.com, RAPOPORT@il.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, hillf.zj@alibaba-inc.com, mike.kravetz@oracle.com, rppt@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: non-cooperative: Split the find_userfault() routine
has been added to the -mm tree.  Its filename is
     userfaultfd-non-cooperative-split-the-find_userfault-routine.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-non-cooperative-split-the-find_userfault-routine.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-non-cooperative-split-the-find_userfault-routine.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Emelyanov <xemul@parallels.com>
Subject: userfaultfd: non-cooperative: Split the find_userfault() routine

I will need one to lookup for userfaultfd_wait_queue-s in different
wait queue

Link: http://lkml.kernel.org/r/20161216144821.5183-6-aarcange@redhat.com
Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Michael Rapoport <RAPOPORT@il.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff -puN fs/userfaultfd.c~userfaultfd-non-cooperative-split-the-find_userfault-routine fs/userfaultfd.c
--- a/fs/userfaultfd.c~userfaultfd-non-cooperative-split-the-find_userfault-routine
+++ a/fs/userfaultfd.c
@@ -489,25 +489,30 @@ wakeup:
 }
 
 /* fault_pending_wqh.lock must be hold by the caller */
-static inline struct userfaultfd_wait_queue *find_userfault(
-	struct userfaultfd_ctx *ctx)
+static inline struct userfaultfd_wait_queue *find_userfault_in(
+		wait_queue_head_t *wqh)
 {
 	wait_queue_t *wq;
 	struct userfaultfd_wait_queue *uwq;
 
-	VM_BUG_ON(!spin_is_locked(&ctx->fault_pending_wqh.lock));
+	VM_BUG_ON(!spin_is_locked(&wqh->lock));
 
 	uwq = NULL;
-	if (!waitqueue_active(&ctx->fault_pending_wqh))
+	if (!waitqueue_active(wqh))
 		goto out;
 	/* walk in reverse to provide FIFO behavior to read userfaults */
-	wq = list_last_entry(&ctx->fault_pending_wqh.task_list,
-			     typeof(*wq), task_list);
+	wq = list_last_entry(&wqh->task_list, typeof(*wq), task_list);
 	uwq = container_of(wq, struct userfaultfd_wait_queue, wq);
 out:
 	return uwq;
 }
 
+static inline struct userfaultfd_wait_queue *find_userfault(
+		struct userfaultfd_ctx *ctx)
+{
+	return find_userfault_in(&ctx->fault_pending_wqh);
+}
+
 static unsigned int userfaultfd_poll(struct file *file, poll_table *wait)
 {
 	struct userfaultfd_ctx *ctx = file->private_data;
_

Patches currently in -mm which might be from xemul@parallels.com are

userfaultfd-non-cooperative-split-the-find_userfault-routine.patch
userfaultfd-non-cooperative-add-ability-to-report-non-pf-events-from-uffd-descriptor.patch
userfaultfd-non-cooperative-add-fork-event.patch
userfaultfd-non-cooperative-add-mremap-event.patch
userfaultfd-non-cooperative-add-madvise-event-for-madv_dontneed-request.patch

