From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 094/155] mm: return faster for non-fatal signals
 in user mode faults
Date: Wed, 01 Apr 2020 21:08:29 -0700
Message-ID: <20200402040829.N5c0ja2Rp%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727746AbgDBEIb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:08:31 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, bgeffon@google.com, bobbypowers@gmail.com, cracauer@cons.org, david@redhat.com, dgilbert@redhat.com, dplotnikov@virtuozzo.com, gokhale2@llnl.gov, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, kirill@shutemov.name, linux-mm@kvack.org, mcfadden8@llnl.gov, mgorman@suse.de, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, peterx@redhat.com, rppt@linux.vnet.ibm.com, torvalds@linux-foundation.org, willy@infradead.org, xemul@openvz.org

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
