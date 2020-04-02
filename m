From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 100/155] mm/gup: allow to react to fatal signals
Date: Wed, 01 Apr 2020 21:08:53 -0700
Message-ID: <20200402040853.kV3BL4oyi%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbgDBEI6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:08:58 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, akpm@linux-foundation.org, bgeffon@google.com, bobbypowers@gmail.com, cracauer@cons.org, david@redhat.com, dgilbert@redhat.com, dplotnikov@virtuozzo.com, gokhale2@llnl.gov, hannes@cmpxchg.org, hughd@google.com, jglisse@redhat.com, kirill@shutemov.name, linux-mm@kvack.org, mcfadden8@llnl.gov, mgorman@suse.de, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, peterx@redhat.com, rppt@linux.vnet.ibm.com, torvalds@linux-foundation.org, willy@infradead.org, xemul@openvz.org

From: Peter Xu <peterx@redhat.com>
Subject: mm/gup: allow to react to fatal signals

The existing gup code does not react to the fatal signals in many code
paths.  For example, in one retry path of gup we're still using
down_read() rather than down_read_killable().  Also, when doing page
faults we don't pass in FAULT_FLAG_KILLABLE as well, which means that
within the faulting process we'll wait in non-killable way as well.  These
were spotted by Linus during the code review of some other patches.

Let's allow the gup code to react to fatal signals to improve the
responsiveness of threads when during gup and being killed.

Link: http://lkml.kernel.org/r/20200220160256.9887-1-peterx@redhat.com
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

 mm/gup.c     |   12 +++++++++---
 mm/hugetlb.c |    3 ++-
 2 files changed, 11 insertions(+), 4 deletions(-)

--- a/mm/gup.c~mm-gup-allow-to-react-to-fatal-signals
+++ a/mm/gup.c
@@ -864,7 +864,7 @@ static int faultin_page(struct task_stru
 	if (*flags & FOLL_REMOTE)
 		fault_flags |= FAULT_FLAG_REMOTE;
 	if (locked)
-		fault_flags |= FAULT_FLAG_ALLOW_RETRY;
+		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
 	if (*flags & FOLL_NOWAIT)
 		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_RETRY_NOWAIT;
 	if (*flags & FOLL_TRIED) {
@@ -1207,7 +1207,7 @@ int fixup_user_fault(struct task_struct
 	address = untagged_addr(address);
 
 	if (unlocked)
-		fault_flags |= FAULT_FLAG_ALLOW_RETRY;
+		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
 
 retry:
 	vma = find_extend_vma(mm, address);
@@ -1329,7 +1329,13 @@ retry:
 			break;
 
 		*locked = 1;
-		down_read(&mm->mmap_sem);
+		ret = down_read_killable(&mm->mmap_sem);
+		if (ret) {
+			BUG_ON(ret > 0);
+			if (!pages_done)
+				pages_done = ret;
+			break;
+		}
 
 		ret = __get_user_pages(tsk, mm, start, 1, flags | FOLL_TRIED,
 				       pages, NULL, locked);
--- a/mm/hugetlb.c~mm-gup-allow-to-react-to-fatal-signals
+++ a/mm/hugetlb.c
@@ -4344,7 +4344,8 @@ long follow_hugetlb_page(struct mm_struc
 			if (flags & FOLL_WRITE)
 				fault_flags |= FAULT_FLAG_WRITE;
 			if (locked)
-				fault_flags |= FAULT_FLAG_ALLOW_RETRY;
+				fault_flags |= FAULT_FLAG_ALLOW_RETRY |
+					FAULT_FLAG_KILLABLE;
 			if (flags & FOLL_NOWAIT)
 				fault_flags |= FAULT_FLAG_ALLOW_RETRY |
 					FAULT_FLAG_RETRY_NOWAIT;
_
