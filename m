From: akpm@linux-foundation.org
Subject: +
 userfaultfd-non-cooperative-flush-event_wqh-at-release-time.patch added to
 -mm tree
Date: Mon, 31 Jul 2017 15:33:45 -0700
Message-ID: <597fb049.XD+HgvG3lces8zRy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48506 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751217AbdGaWdq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jul 2017 18:33:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, aarcange@redhat.com, dgilbert@redhat.com, stable@vger.kernel.org, xemul@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: non-cooperative: flush event_wqh at release time
has been added to the -mm tree.  Its filename is
     userfaultfd-non-cooperative-flush-event_wqh-at-release-time.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-non-cooperative-flush-event_wqh-at-release-time.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-non-cooperative-flush-event_wqh-at-release-time.patch

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

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are

userfaultfd-non-cooperative-notify-about-unmap-of-destination-during-mremap.patch
userfaultfd_zeropage-return-enospc-in-case-mm-has-gone.patch
userfaultfd-non-cooperative-flush-event_wqh-at-release-time.patch
shmem-shmem_charge-verify-max_block-is-not-exceeded-before-inode-update.patch
shmem-introduce-shmem_inode_acct_block.patch
userfaultfd-shmem-add-shmem_mfill_zeropage_pte-for-userfaultfd-support.patch
userfaultfd-mcopy_atomic-introduce-mfill_atomic_pte-helper.patch
userfaultfd-shmem-wire-up-shmem_mfill_zeropage_pte.patch
userfaultfd-report-uffdio_zeropage-as-available-for-shmem-vmas.patch
userfaultfd-selftest-enable-testing-of-uffdio_zeropage-for-shmem.patch

