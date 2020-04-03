From: akpm@linux-foundation.org
Subject: [merged]
 mm-return-faster-for-non-fatal-signals-in-user-mode-faults.patch removed
 from -mm tree
Date: Fri, 03 Apr 2020 13:38:42 -0700
Message-ID: <20200403203842.3ksQDuyr0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727867AbgDCUin (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:38:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, bgeffon@google.com, bobbypowers@gmail.com, cracauer@cons.org, david@redhat.com, dgilbert@redhat.com, dplotnikov@virtuozzo.com, gokhale2@llnl.gov, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, kirill@shutemov.name, mcfadden8@llnl.gov, mgorman@suse.de, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, peterx@redhat.com, rppt@linux.vnet.ibm.com, torvalds@linux-foundation.org, willy@infradead.org, xemul@openvz.org


The patch titled
     Subject: mm: return faster for non-fatal signals in user mode faults
has been removed from the -mm tree.  Its filename was
     mm-return-faster-for-non-fatal-signals-in-user-mode-faults.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: return faster for non-fatal signals in user mode faults

The idea comes from the upstream discussion between Linus and Andrea:

  https://lore.kernel.org/lkml/20171102193644.GB22686@redhat.com/

A summary to the issue: there was a special path in handle_userfault() in
the past that we'll return a VM_FAULT_NOPAGE when we detected non-fatal
signals when waiting for userfault handling.  We did that by reacquiring
the mmap_sem before returning.  However that brings a risk in that the
vmas might have changed when we retake the mmap_sem and even we could be
holding an invalid vma structure.

This patch is a preparation of removing that special path by allowing the
page fault to return even faster if we were interrupted by a non-fatal
signal during a user-mode page fault handling routine.

Link: http://lkml.kernel.org/r/20200220160230.9598-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Suggested-by: Andrea Arcangeli <aarcange@redhat.com>
Tested-by: Brian Geffon <bgeffon@google.com>
Cc: Bobby Powers <bobbypowers@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
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

 include/linux/sched/signal.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/sched/signal.h~mm-return-faster-for-non-fatal-signals-in-user-mode-faults
+++ a/include/linux/sched/signal.h
@@ -381,7 +381,8 @@ static inline bool fault_signal_pending(
 					struct pt_regs *regs)
 {
 	return unlikely((fault_flags & VM_FAULT_RETRY) &&
-			fatal_signal_pending(current));
+			(fatal_signal_pending(current) ||
+			 (user_mode(regs) && signal_pending(current))));
 }
 
 /*
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-merge-parameters-for-change_protection.patch
userfaultfd-wp-apply-_page_uffd_wp-bit.patch
userfaultfd-wp-drop-_page_uffd_wp-properly-when-fork.patch
userfaultfd-wp-add-pmd_swp_uffd_wp-helpers.patch
userfaultfd-wp-support-swap-and-page-migration.patch
khugepaged-skip-collapse-if-uffd-wp-detected.patch
userfaultfd-wp-dont-wake-up-when-doing-write-protect.patch
userfaultfd-wp-declare-_uffdio_writeprotect-conditionally.patch
userfaultfd-selftests-refactor-statistics.patch
userfaultfd-selftests-add-write-protect-test.patch
