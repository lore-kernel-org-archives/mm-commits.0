From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 093/155] sh/mm: use helper fault_signal_pending()
Date: Wed, 01 Apr 2020 21:08:25 -0700
Message-ID: <20200402040825.j9OfRpmK6%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728135AbgDBEI1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:08:27 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, bgeffon@google.com, bobbypowers@gmail.com, cracauer@cons.org, david@redhat.com, dgilbert@redhat.com, dplotnikov@virtuozzo.com, gokhale2@llnl.gov, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, kirill@shutemov.name, linux-mm@kvack.org, mcfadden8@llnl.gov, mgorman@suse.de, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, peterx@redhat.com, rppt@linux.vnet.ibm.com, torvalds@linux-foundation.org, willy@infradead.org, xemul@openvz.org

From: Peter Xu <peterx@redhat.com>
Subject: sh/mm: use helper fault_signal_pending()

Let SH to use the new fault_signal_pending() helper.  Here we'll need to
move the up_read() out because that's actually needed as long as !RETRY
cases.  At the meantime we can drop all the rest of up_read()s now (which
seems to be cleaner).

Link: http://lkml.kernel.org/r/20200220160226.9550-1-peterx@redhat.com
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

 arch/sh/mm/fault.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/sh/mm/fault.c~sh-mm-use-helper-fault_signal_pending
+++ a/arch/sh/mm/fault.c
@@ -302,25 +302,25 @@ mm_fault_error(struct pt_regs *regs, uns
 	 * Pagefault was interrupted by SIGKILL. We have no reason to
 	 * continue pagefault.
 	 */
-	if (fatal_signal_pending(current)) {
-		if (!(fault & VM_FAULT_RETRY))
-			up_read(&current->mm->mmap_sem);
+	if (fault_signal_pending(fault, regs)) {
 		if (!user_mode(regs))
 			no_context(regs, error_code, address);
 		return 1;
 	}
 
+	/* Release mmap_sem first if necessary */
+	if (!(fault & VM_FAULT_RETRY))
+		up_read(&current->mm->mmap_sem);
+
 	if (!(fault & VM_FAULT_ERROR))
 		return 0;
 
 	if (fault & VM_FAULT_OOM) {
 		/* Kernel mode? Handle exceptions or die: */
 		if (!user_mode(regs)) {
-			up_read(&current->mm->mmap_sem);
 			no_context(regs, error_code, address);
 			return 1;
 		}
-		up_read(&current->mm->mmap_sem);
 
 		/*
 		 * We ran out of memory, call the OOM killer, and return the
_
