From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 101/155] mm/userfaultfd: honor FAULT_FLAG_KILLABLE
 in fault path
Date: Wed, 01 Apr 2020 21:09:00 -0700
Message-ID: <20200402040900.GK_bZs6EM%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbgDBEJD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:09:03 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, bgeffon@google.com, bobbypowers@gmail.com, cracauer@cons.org, david@redhat.com, dgilbert@redhat.com, dplotnikov@virtuozzo.com, gokhale2@llnl.gov, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, kirill@shutemov.name, linux-mm@kvack.org, mcfadden8@llnl.gov, mgorman@suse.de, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, peterx@redhat.com, rppt@linux.vnet.ibm.com, torvalds@linux-foundation.org, willy@infradead.org, xemul@openvz.org

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
