From: akpm@linux-foundation.org
Subject: [merged]
 mm-gup-allow-vm_fault_retry-for-multiple-times.patch removed from -mm tree
Date: Fri, 03 Apr 2020 13:38:57 -0700
Message-ID: <20200403203857.ko602ZFW_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbgDCUi7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:38:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, bgeffon@google.com, bobbypowers@gmail.com, cracauer@cons.org, david@redhat.com, dgilbert@redhat.com, dplotnikov@virtuozzo.com, gokhale2@llnl.gov, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, kirill@shutemov.name, mcfadden8@llnl.gov, mgorman@suse.de, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, peterx@redhat.com, rppt@linux.vnet.ibm.com, torvalds@linux-foundation.org, willy@infradead.org, xemul@openvz.org


The patch titled
     Subject: mm/gup: allow VM_FAULT_RETRY for multiple times
has been removed from the -mm tree.  Its filename was
     mm-gup-allow-vm_fault_retry-for-multiple-times.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/gup: allow VM_FAULT_RETRY for multiple times

This is the gup counterpart of the change that allows the VM_FAULT_RETRY
to happen for more than once.  One thing to mention is that we must check
the fatal signal here before retry because the GUP can be interrupted by
that, otherwise we can loop forever.

Link: http://lkml.kernel.org/r/20200220195357.16371-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Tested-by: Brian Geffon <bgeffon@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Bobby Powers <bobbypowers@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
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

 mm/gup.c     |   27 +++++++++++++++++++++------
 mm/hugetlb.c |    6 ++++--
 2 files changed, 25 insertions(+), 8 deletions(-)

--- a/mm/gup.c~mm-gup-allow-vm_fault_retry-for-multiple-times
+++ a/mm/gup.c
@@ -868,7 +868,10 @@ static int faultin_page(struct task_stru
 	if (*flags & FOLL_NOWAIT)
 		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_RETRY_NOWAIT;
 	if (*flags & FOLL_TRIED) {
-		VM_WARN_ON_ONCE(fault_flags & FAULT_FLAG_ALLOW_RETRY);
+		/*
+		 * Note: FAULT_FLAG_ALLOW_RETRY and FAULT_FLAG_TRIED
+		 * can co-exist
+		 */
 		fault_flags |= FAULT_FLAG_TRIED;
 	}
 
@@ -1228,7 +1231,6 @@ retry:
 		down_read(&mm->mmap_sem);
 		if (!(fault_flags & FAULT_FLAG_TRIED)) {
 			*unlocked = true;
-			fault_flags &= ~FAULT_FLAG_ALLOW_RETRY;
 			fault_flags |= FAULT_FLAG_TRIED;
 			goto retry;
 		}
@@ -1312,17 +1314,30 @@ static __always_inline long __get_user_p
 		if (likely(pages))
 			pages += ret;
 		start += ret << PAGE_SHIFT;
+		lock_dropped = true;
 
+retry:
 		/*
 		 * Repeat on the address that fired VM_FAULT_RETRY
-		 * without FAULT_FLAG_ALLOW_RETRY but with
-		 * FAULT_FLAG_TRIED.
+		 * with both FAULT_FLAG_ALLOW_RETRY and
+		 * FAULT_FLAG_TRIED.  Note that GUP can be interrupted
+		 * by fatal signals, so we need to check it before we
+		 * start trying again otherwise it can loop forever.
 		 */
+
+		if (fatal_signal_pending(current))
+			break;
+
 		*locked = 1;
-		lock_dropped = true;
 		down_read(&mm->mmap_sem);
+
 		ret = __get_user_pages(tsk, mm, start, 1, flags | FOLL_TRIED,
-				       pages, NULL, NULL);
+				       pages, NULL, locked);
+		if (!*locked) {
+			/* Continue to retry until we succeeded */
+			BUG_ON(ret != 0);
+			goto retry;
+		}
 		if (ret != 1) {
 			BUG_ON(ret > 1);
 			if (!pages_done)
--- a/mm/hugetlb.c~mm-gup-allow-vm_fault_retry-for-multiple-times
+++ a/mm/hugetlb.c
@@ -4349,8 +4349,10 @@ long follow_hugetlb_page(struct mm_struc
 				fault_flags |= FAULT_FLAG_ALLOW_RETRY |
 					FAULT_FLAG_RETRY_NOWAIT;
 			if (flags & FOLL_TRIED) {
-				VM_WARN_ON_ONCE(fault_flags &
-						FAULT_FLAG_ALLOW_RETRY);
+				/*
+				 * Note: FAULT_FLAG_ALLOW_RETRY and
+				 * FAULT_FLAG_TRIED can co-exist
+				 */
 				fault_flags |= FAULT_FLAG_TRIED;
 			}
 			ret = hugetlb_fault(mm, vma, vaddr, fault_flags);
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
