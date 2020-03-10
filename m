From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 userfaultfd-wp-dont-wake-up-when-doing-write-protect.patch added to -mm
 tree
Date: Mon, 09 Mar 2020 20:42:02 -0700
Message-ID: <20200310034202.sjvoYMoHz%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726195AbgCJDmF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 9 Mar 2020 23:42:05 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, bgeffon@google.com, bobbypowers@gmail.com, cracauer@cons.org, david@redhat.com, dgilbert@redhat.com, dplotnikov@virtuozzo.com, gokhale2@llnl.gov, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, kirill@shutemov.name, mcfadden8@llnl.gov, mgorman@suse.de, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, peterx@redhat.com, riel@redhat.com, rppt@linux.vnet.ibm.com, shli@fb.com, xemul@parallels.com, xemul@virtuozzo.com


The patch titled
     Subject: userfaultfd: wp: don't wake up when doing write protect
has been added to the -mm tree.  Its filename is
     userfaultfd-wp-dont-wake-up-when-doing-write-protect.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/userfaultfd-wp-dont-wake-up-when-doing-write-protect.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/userfaultfd-wp-dont-wake-up-when-doing-write-protect.patch

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
Subject: userfaultfd: wp: don't wake up when doing write protect

It does not make sense to try to wake up any waiting thread when we're
write-protecting a memory region.  Only wake up when resolving a write
protected page fault.

Link: http://lkml.kernel.org/r/20200220163112.11409-16-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Bobby Powers <bobbypowers@gmail.com>
Cc:  Brian Geffon <bgeffon@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Martin Cracauer <cracauer@cons.org>
Cc: Marty McFadden <mcfadden8@llnl.gov>
Cc: Maya Gokhale <gokhale2@llnl.gov>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/fs/userfaultfd.c~userfaultfd-wp-dont-wake-up-when-doing-write-protect
+++ a/fs/userfaultfd.c
@@ -1812,6 +1812,7 @@ static int userfaultfd_writeprotect(stru
 	struct uffdio_writeprotect uffdio_wp;
 	struct uffdio_writeprotect __user *user_uffdio_wp;
 	struct userfaultfd_wake_range range;
+	bool mode_wp, mode_dontwake;
 
 	if (READ_ONCE(ctx->mmap_changing))
 		return -EAGAIN;
@@ -1830,18 +1831,20 @@ static int userfaultfd_writeprotect(stru
 	if (uffdio_wp.mode & ~(UFFDIO_WRITEPROTECT_MODE_DONTWAKE |
 			       UFFDIO_WRITEPROTECT_MODE_WP))
 		return -EINVAL;
-	if ((uffdio_wp.mode & UFFDIO_WRITEPROTECT_MODE_WP) &&
-	     (uffdio_wp.mode & UFFDIO_WRITEPROTECT_MODE_DONTWAKE))
+
+	mode_wp = uffdio_wp.mode & UFFDIO_WRITEPROTECT_MODE_WP;
+	mode_dontwake = uffdio_wp.mode & UFFDIO_WRITEPROTECT_MODE_DONTWAKE;
+
+	if (mode_wp && mode_dontwake)
 		return -EINVAL;
 
 	ret = mwriteprotect_range(ctx->mm, uffdio_wp.range.start,
-				  uffdio_wp.range.len, uffdio_wp.mode &
-				  UFFDIO_WRITEPROTECT_MODE_WP,
+				  uffdio_wp.range.len, mode_wp,
 				  &ctx->mmap_changing);
 	if (ret)
 		return ret;
 
-	if (!(uffdio_wp.mode & UFFDIO_WRITEPROTECT_MODE_DONTWAKE)) {
+	if (!mode_wp && !mode_dontwake) {
 		range.start = uffdio_wp.range.start;
 		range.len = uffdio_wp.range.len;
 		wake_userfault(ctx, &range);
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
