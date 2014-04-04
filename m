From: akpm@linux-foundation.org
Subject: [merged] mm-memoryc-mark-functions-as-static.patch removed from
 -mm tree
Date: Fri, 04 Apr 2014 12:31:40 -0700
Message-ID: <533f089c.ITW0XyUuzdXlpcqa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbaDDTbl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:31:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, riel@redhat.com, josh@joshtriplett.org, rashika.kheria@gmail.com

Subject: [merged] mm-memoryc-mark-functions-as-static.patch removed from -mm tree
To: rashika.kheria@gmail.com,josh@joshtriplett.org,riel@redhat.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:31:40 -0700


The patch titled
     Subject: mm/memory.c: mark functions as static
has been removed from the -mm tree.  Its filename was
     mm-memoryc-mark-functions-as-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: mm/memory.c: mark functions as static

mark functions as static in memory.c because they are not used outside
this file.

This eliminates the following warnings in mm/memory.c:
mm/memory.c:3530:5: warning: no previous prototype for `numa_migrate_prep' [-Wmissing-prototypes]
mm/memory.c:3545:5: warning: no previous prototype for `do_numa_page' [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mm-memoryc-mark-functions-as-static mm/memory.c
--- a/mm/memory.c~mm-memoryc-mark-functions-as-static
+++ a/mm/memory.c
@@ -3531,7 +3531,7 @@ static int do_nonlinear_fault(struct mm_
 	return __do_fault(mm, vma, address, pmd, pgoff, flags, orig_pte);
 }
 
-int numa_migrate_prep(struct page *page, struct vm_area_struct *vma,
+static int numa_migrate_prep(struct page *page, struct vm_area_struct *vma,
 				unsigned long addr, int page_nid,
 				int *flags)
 {
@@ -3546,7 +3546,7 @@ int numa_migrate_prep(struct page *page,
 	return mpol_misplaced(page, vma, addr);
 }
 
-int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
+static int do_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		   unsigned long addr, pte_t pte, pte_t *ptep, pmd_t *pmd)
 {
 	struct page *page = NULL;
_

Patches currently in -mm which might be from rashika.kheria@gmail.com are

origin.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
linux-next.patch

