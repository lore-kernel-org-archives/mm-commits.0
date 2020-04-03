From: akpm@linux-foundation.org
Subject: [merged] x86-mm-use-helper-fault_signal_pending.patch
 removed from -mm tree
Date: Fri, 03 Apr 2020 13:38:27 -0700
Message-ID: <20200403203827.XH_72RtRS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUi3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:38:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, bgeffon@google.com, bobbypowers@gmail.com, cracauer@cons.org, david@redhat.com, dgilbert@redhat.com, dplotnikov@virtuozzo.com, gokhale2@llnl.gov, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, kirill@shutemov.name, mcfadden8@llnl.gov, mgorman@suse.de, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, peterx@redhat.com, rppt@linux.vnet.ibm.com, torvalds@linux-foundation.org, willy@infradead.org, xemul@openvz.org


The patch titled
     Subject: x86/mm: use helper fault_signal_pending()
has been removed from the -mm tree.  Its filename was
     x86-mm-use-helper-fault_signal_pending.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: x86/mm: use helper fault_signal_pending()

Let's move the fatal signal check even earlier so that we can directly use
the new fault_signal_pending() in x86 mm code.

Link: http://lkml.kernel.org/r/20200220155353.8676-5-peterx@redhat.com
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

 arch/x86/mm/fault.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

--- a/arch/x86/mm/fault.c~x86-mm-use-helper-fault_signal_pending
+++ a/arch/x86/mm/fault.c
@@ -1464,27 +1464,25 @@ good_area:
 	fault = handle_mm_fault(vma, address, flags);
 	major |= fault & VM_FAULT_MAJOR;
 
+	/* Quick path to respond to signals */
+	if (fault_signal_pending(fault, regs)) {
+		if (!user_mode(regs))
+			no_context(regs, hw_error_code, address, SIGBUS,
+				   BUS_ADRERR);
+		return;
+	}
+
 	/*
 	 * If we need to retry the mmap_sem has already been released,
 	 * and if there is a fatal signal pending there is no guarantee
 	 * that we made any progress. Handle this case first.
 	 */
-	if (unlikely(fault & VM_FAULT_RETRY)) {
+	if (unlikely((fault & VM_FAULT_RETRY) &&
+		     (flags & FAULT_FLAG_ALLOW_RETRY))) {
 		/* Retry at most once */
-		if (flags & FAULT_FLAG_ALLOW_RETRY) {
-			flags &= ~FAULT_FLAG_ALLOW_RETRY;
-			flags |= FAULT_FLAG_TRIED;
-			if (!fatal_signal_pending(tsk))
-				goto retry;
-		}
-
-		/* User mode? Just return to handle the fatal exception */
-		if (flags & FAULT_FLAG_USER)
-			return;
