From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-use-helper-fault_signal_pending.patch added to
 -mm tree
Date: Mon, 09 Mar 2020 20:38:41 -0700
Message-ID: <20200310033841.lbt-oRC4K%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726195AbgCJDin (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 9 Mar 2020 23:38:43 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, bgeffon@google.com, bobbypowers@gmail.com, cracauer@cons.org, david@redhat.com, dgilbert@redhat.com, dplotnikov@virtuozzo.com, gokhale2@llnl.gov, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, kirill@shutemov.name, mcfadden8@llnl.gov, mgorman@suse.de, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, peterx@redhat.com, rppt@linux.vnet.ibm.com, torvalds@linux-foundation.org, willy@infradead.org, xemul@virtuozzo.com


The patch titled
     Subject: arm64/mm: use helper fault_signal_pending()
has been added to the -mm tree.  Its filename is
     arm64-mm-use-helper-fault_signal_pending.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64-mm-use-helper-fault_signal_pending.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64-mm-use-helper-fault_signal_pending.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: arm64/mm: use helper fault_signal_pending()

Let the arm64 fault handling to use the new fault_signal_pending() helper,
by moving the signal handling out of the retry logic.

Link: http://lkml.kernel.org/r/20200220155927.9264-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Bobby Powers <bobbypowers@gmail.com>
Cc: Brian Geffon <bgeffon@google.com>
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
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/fault.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/arch/arm64/mm/fault.c~arm64-mm-use-helper-fault_signal_pending
+++ a/arch/arm64/mm/fault.c
@@ -513,19 +513,14 @@ retry:
 	fault = __do_page_fault(mm, addr, mm_flags, vm_flags);
 	major |= fault & VM_FAULT_MAJOR;
 
-	if (fault & VM_FAULT_RETRY) {
-		/*
-		 * If we need to retry but a fatal signal is pending,
-		 * handle the signal first. We do not need to release
-		 * the mmap_sem because it would already be released
-		 * in __lock_page_or_retry in mm/filemap.c.
-		 */
-		if (fatal_signal_pending(current)) {
-			if (!user_mode(regs))
-				goto no_context;
-			return 0;
-		}
+	/* Quick path to respond to signals */
+	if (fault_signal_pending(fault, regs)) {
+		if (!user_mode(regs))
+			goto no_context;
+		return 0;
+	}
 
+	if (fault & VM_FAULT_RETRY) {
 		/*
 		 * Clear FAULT_FLAG_ALLOW_RETRY to avoid any risk of
 		 * starvation.
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-gup-rename-nonblocking-to-locked-where-proper.patch
mm-gup-fix-__get_user_pages-on-fault-retry-of-hugetlb.patch
mm-introduce-fault_signal_pending.patch
x86-mm-use-helper-fault_signal_pending.patch
arc-mm-use-helper-fault_signal_pending.patch
arm64-mm-use-helper-fault_signal_pending.patch
powerpc-mm-use-helper-fault_signal_pending.patch
sh-mm-use-helper-fault_signal_pending.patch
mm-return-faster-for-non-fatal-signals-in-user-mode-faults.patch
userfaultfd-dont-retake-mmap_sem-to-emulate-nopage.patch
mm-introduce-fault_flag_default.patch
mm-introduce-fault_flag_interruptible.patch
mm-allow-vm_fault_retry-for-multiple-times.patch
mm-gup-allow-vm_fault_retry-for-multiple-times.patch
mm-gup-allow-to-react-to-fatal-signals.patch
mm-userfaultfd-honor-fault_flag_killable-in-fault-path.patch
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
