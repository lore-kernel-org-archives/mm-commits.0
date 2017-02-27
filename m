From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-non-cooperative-add-madvise-event-for-madv_remove-request.patch removed from -mm tree
Date: Mon, 27 Feb 2017 12:24:34 -0800
Message-ID: <58b48b02.Ti8AS8fw65KXDAeo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60410 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751743AbdB0UYq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:24:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rppt@linux.vnet.ibm.com, aarcange@redhat.com, hillf.zj@alibaba-inc.com, xemul@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: non-cooperative: add madvise() event for MADV_REMOVE request
has been removed from the -mm tree.  Its filename was
     userfaultfd-non-cooperative-add-madvise-event-for-madv_remove-request.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: userfaultfd: non-cooperative: add madvise() event for MADV_REMOVE request

When a page is removed from a shared mapping, the uffd reader should be
notified, so that it won't attempt to handle #PF events for the removed
pages.

We can reuse the UFFD_EVENT_REMOVE because from the uffd monitor point of
view, the semantices of madvise(MADV_DONTNEED) and madvise(MADV_REMOVE) is
exactly the same.

Link: http://lkml.kernel.org/r/1484814154-1557-3-git-send-email-rppt@linux.vnet.ibm.com
Signed-off-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Pavel Emelyanov <xemul@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/madvise.c~userfaultfd-non-cooperative-add-madvise-event-for-madv_remove-request mm/madvise.c
--- a/mm/madvise.c~userfaultfd-non-cooperative-add-madvise-event-for-madv_remove-request
+++ a/mm/madvise.c
@@ -520,6 +520,7 @@ static long madvise_remove(struct vm_are
 	 * mmap_sem.
 	 */
 	get_file(f);
+	userfaultfd_remove(vma, prev, start, end);
 	up_read(&current->mm->mmap_sem);
 	error = vfs_fallocate(f,
 				FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
_

Patches currently in -mm which might be from rppt@linux.vnet.ibm.com are


