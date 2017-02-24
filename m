From: akpm@linux-foundation.org
Subject: [patch 011/124] userfaultfd: non-cooperative: add madvise() event for MADV_REMOVE request
Date: Fri, 24 Feb 2017 14:56:05 -0800
Message-ID: <58b0ba05.5df3gLf3CJhQvzDF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37064 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751268AbdBXW4H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:56:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, rppt@linux.vnet.ibm.com, aarcange@redhat.com, hillf.zj@alibaba-inc.com, xemul@virtuozzo.com

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
