From: akpm@linux-foundation.org
Subject: [merged]
 userfaultfd-dont-retake-mmap_sem-to-emulate-nopage.patch removed from -mm
 tree
Date: Fri, 03 Apr 2020 13:38:45 -0700
Message-ID: <20200403203845.z0ZFG-BT-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727867AbgDCUiq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:38:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, bgeffon@google.com, bobbypowers@gmail.com, cracauer@cons.org, david@redhat.com, dgilbert@redhat.com, dplotnikov@virtuozzo.com, gokhale2@llnl.gov, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, kirill@shutemov.name, mcfadden8@llnl.gov, mgorman@suse.de, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, peterx@redhat.com, rppt@linux.vnet.ibm.com, torvalds@linux-foundation.org, willy@infradead.org, xemul@openvz.org


The patch titled
     Subject: userfaultfd: don't retake mmap_sem to emulate NOPAGE
has been removed from the -mm tree.  Its filename was
     userfaultfd-dont-retake-mmap_sem-to-emulate-nopage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: userfaultfd: don't retake mmap_sem to emulate NOPAGE

This patch removes the risk path in handle_userfault() then we will be
sure that the callers of handle_mm_fault() will know that the VMAs might
have changed.  Meanwhile with previous patch we don't lose responsiveness
as well since the core mm code now can handle the nonfatal userspace
signals even if we return VM_FAULT_RETRY.

Link: http://lkml.kernel.org/r/20200220160234.9646-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Suggested-by: Andrea Arcangeli <aarcange@redhat.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Tested-by: Brian Geffon <bgeffon@google.com>
Cc: Bobby Powers <bobbypowers@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Martin Cracauer <cracauer@cons.org>
Cc: Marty McFadden <mcfadden8@llnl.gov>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Maya Gokhale <gokhale2@llnl.gov>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   24 ------------------------
 1 file changed, 24 deletions(-)

--- a/fs/userfaultfd.c~userfaultfd-dont-retake-mmap_sem-to-emulate-nopage
+++ a/fs/userfaultfd.c
@@ -524,30 +524,6 @@ vm_fault_t handle_userfault(struct vm_fa
 
 	__set_current_state(TASK_RUNNING);
 
-	if (return_to_userland) {
-		if (signal_pending(current) &&
-		    !fatal_signal_pending(current)) {
-			/*
-			 * If we got a SIGSTOP or SIGCONT and this is
-			 * a normal userland page fault, just let
-			 * userland return so the signal will be
-			 * handled and gdb debugging works.  The page
-			 * fault code immediately after we return from
-			 * this function is going to release the
-			 * mmap_sem and it's not depending on it
-			 * (unlike gup would if we were not to return
-			 * VM_FAULT_RETRY).
-			 *
-			 * If a fatal signal is pending we still take
-			 * the streamlined VM_FAULT_RETRY failure path
-			 * and there's no need to retake the mmap_sem
-			 * in such case.
-			 */
-			down_read(&mm->mmap_sem);
-			ret = VM_FAULT_NOPAGE;
-		}
-	}
