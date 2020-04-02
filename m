From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 092/155] powerpc/mm: use helper
 fault_signal_pending()
Date: Wed, 01 Apr 2020 21:08:22 -0700
Message-ID: <20200402040822._ZYNCCE1O%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBEIX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:08:23 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, bgeffon@google.com, bobbypowers@gmail.com, cracauer@cons.org, david@redhat.com, dgilbert@redhat.com, dplotnikov@virtuozzo.com, gokhale2@llnl.gov, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, kirill@shutemov.name, linux-mm@kvack.org, mcfadden8@llnl.gov, mgorman@suse.de, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, peterx@redhat.com, rppt@linux.vnet.ibm.com, torvalds@linux-foundation.org, willy@infradead.org, xemul@openvz.org

From: Peter Xu <peterx@redhat.com>
Subject: powerpc/mm: use helper fault_signal_pending()

Let powerpc code to use the new helper, by moving the signal handling
earlier before the retry logic.

Link: http://lkml.kernel.org/r/20200220160222.9422-1-peterx@redhat.com
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

 arch/powerpc/mm/fault.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/arch/powerpc/mm/fault.c~powerpc-mm-use-helper-fault_signal_pending
+++ a/arch/powerpc/mm/fault.c
@@ -582,6 +582,9 @@ good_area:
 
 	major |= fault & VM_FAULT_MAJOR;
 
+	if (fault_signal_pending(fault, regs))
+		return user_mode(regs) ? 0 : SIGBUS;
+
 	/*
 	 * Handle the retry right now, the mmap_sem has been released in that
 	 * case.
@@ -595,15 +598,8 @@ good_area:
 			 */
 			flags &= ~FAULT_FLAG_ALLOW_RETRY;
 			flags |= FAULT_FLAG_TRIED;
-			if (!fatal_signal_pending(current))
-				goto retry;
+			goto retry;
 		}
