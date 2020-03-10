From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-userfaultfd-honor-fault_flag_killable-in-fault-path.patch added to -mm
 tree
Date: Mon, 09 Mar 2020 20:39:21 -0700
Message-ID: <20200310033921.fnno4_JLN%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726170AbgCJDjZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 9 Mar 2020 23:39:25 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, bgeffon@google.com, bobbypowers@gmail.com, cracauer@cons.org, david@redhat.com, dgilbert@redhat.com, dplotnikov@virtuozzo.com, gokhale2@llnl.gov, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, kirill@shutemov.name, mcfadden8@llnl.gov, mgorman@suse.de, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, peterx@redhat.com, rppt@linux.vnet.ibm.com, torvalds@linux-foundation.org, willy@infradead.org, xemul@virtuozzo.com


The patch titled
     Subject: mm/userfaultfd: honor FAULT_FLAG_KILLABLE in fault path
has been added to the -mm tree.  Its filename is
     mm-userfaultfd-honor-fault_flag_killable-in-fault-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-userfaultfd-honor-fault_flag_killable-in-fault-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-userfaultfd-honor-fault_flag_killable-in-fault-path.patch

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
Subject: mm/userfaultfd: honor FAULT_FLAG_KILLABLE in fault path

Userfaultfd fault path was by default killable even if the caller does not
have FAULT_FLAG_KILLABLE.  That makes sense before in that when with gup
we don't have FAULT_FLAG_KILLABLE properly set before.  Now after previous
patch we've got FAULT_FLAG_KILLABLE applied even for gup code so it should
also make sense to let userfaultfd to honor the FAULT_FLAG_KILLABLE.

Because we're unconditionally setting FAULT_FLAG_KILLABLE in gup code
right now, this patch should have no functional change.  It also cleaned
the code a little bit by introducing some helpers.

Link: http://lkml.kernel.org/r/20200220160300.9941-1-peterx@redhat.com
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

 fs/userfaultfd.c |   36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

--- a/fs/userfaultfd.c~mm-userfaultfd-honor-fault_flag_killable-in-fault-path
+++ a/fs/userfaultfd.c
@@ -334,6 +334,30 @@ out:
 	return ret;
 }
 
+/* Should pair with userfaultfd_signal_pending() */
+static inline long userfaultfd_get_blocking_state(unsigned int flags)
+{
+	if (flags & FAULT_FLAG_INTERRUPTIBLE)
+		return TASK_INTERRUPTIBLE;
+
+	if (flags & FAULT_FLAG_KILLABLE)
+		return TASK_KILLABLE;
+
+	return TASK_UNINTERRUPTIBLE;
+}
+
+/* Should pair with userfaultfd_get_blocking_state() */
+static inline bool userfaultfd_signal_pending(unsigned int flags)
+{
+	if (flags & FAULT_FLAG_INTERRUPTIBLE)
+		return signal_pending(current);
+
+	if (flags & FAULT_FLAG_KILLABLE)
+		return fatal_signal_pending(current);
+
+	return false;
+}
+
 /*
  * The locking rules involved in returning VM_FAULT_RETRY depending on
  * FAULT_FLAG_ALLOW_RETRY, FAULT_FLAG_RETRY_NOWAIT and
@@ -355,7 +379,7 @@ vm_fault_t handle_userfault(struct vm_fa
 	struct userfaultfd_ctx *ctx;
 	struct userfaultfd_wait_queue uwq;
 	vm_fault_t ret = VM_FAULT_SIGBUS;
-	bool must_wait, return_to_userland;
+	bool must_wait;
 	long blocking_state;
 
 	/*
@@ -462,9 +486,7 @@ vm_fault_t handle_userfault(struct vm_fa
 	uwq.ctx = ctx;
 	uwq.waken = false;
 
-	return_to_userland = vmf->flags & FAULT_FLAG_INTERRUPTIBLE;
-	blocking_state = return_to_userland ? TASK_INTERRUPTIBLE :
-			 TASK_KILLABLE;
+	blocking_state = userfaultfd_get_blocking_state(vmf->flags);
 
 	spin_lock_irq(&ctx->fault_pending_wqh.lock);
 	/*
@@ -490,8 +512,7 @@ vm_fault_t handle_userfault(struct vm_fa
 	up_read(&mm->mmap_sem);
 
 	if (likely(must_wait && !READ_ONCE(ctx->released) &&
-		   (return_to_userland ? !signal_pending(current) :
-		    !fatal_signal_pending(current)))) {
+		   !userfaultfd_signal_pending(vmf->flags))) {
 		wake_up_poll(&ctx->fd_wqh, EPOLLIN);
 		schedule();
 		ret |= VM_FAULT_MAJOR;
@@ -513,8 +534,7 @@ vm_fault_t handle_userfault(struct vm_fa
 			set_current_state(blocking_state);
 			if (READ_ONCE(uwq.waken) ||
 			    READ_ONCE(ctx->released) ||
-			    (return_to_userland ? signal_pending(current) :
-			     fatal_signal_pending(current)))
+			    userfaultfd_signal_pending(vmf->flags))
 				break;
 			schedule();
 		}
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
