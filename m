From: akpm@linux-foundation.org
Subject: - dont-allow-the-stack-to-grow-into-hugetlb-reserved-regions.patch removed from -mm tree
Date: Fri, 02 Feb 2007 13:37:13 -0800
Message-ID: <200702022137.l12LbD4E018492@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41614 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946131AbXBBVit (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Feb 2007 16:38:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agl@us.ibm.com, david@gibson.dropbear.id.au, hugh@veritas.com, stable@kernel.org, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     Don't allow the stack to grow into hugetlb reserved regions
has been removed from the -mm tree.  Its filename was
     dont-allow-the-stack-to-grow-into-hugetlb-reserved-regions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Don't allow the stack to grow into hugetlb reserved regions
From: Adam Litke <agl@us.ibm.com>

When expanding the stack, we don't currently check if the VMA will cross
into an area of the address space that is reserved for hugetlb pages. 
Subsequent faults on the expanded portion of such a VMA will confuse the
low-level MMU code, resulting in an OOPS.  Check for this.

Signed-off-by: Adam Litke <agl@us.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: William Lee Irwin III <wli@holomorphy.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/mmap.c |    7 +++++++
 1 files changed, 7 insertions(+)

diff -puN mm/mmap.c~dont-allow-the-stack-to-grow-into-hugetlb-reserved-regions mm/mmap.c
--- a/mm/mmap.c~dont-allow-the-stack-to-grow-into-hugetlb-reserved-regions
+++ a/mm/mmap.c
@@ -1477,6 +1477,7 @@ static int acct_stack_growth(struct vm_a
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct rlimit *rlim = current->signal->rlim;
+	unsigned long new_start;
 
 	/* address space limit tests */
 	if (!may_expand_vm(mm, grow))
@@ -1496,6 +1497,12 @@ static int acct_stack_growth(struct vm_a
 			return -ENOMEM;
 	}
 
+	/* Check to ensure the stack will not grow into a hugetlb-only region */
+	new_start = (vma->vm_flags & VM_GROWSUP) ? vma->vm_start :
+			vma->vm_end - size;
+	if (is_hugepage_only_range(vma->vm_mm, new_start, size))
+		return -EFAULT;
+
 	/*
 	 * Overcommit..  This must be the final test, as it will
 	 * update security statistics.
_

Patches currently in -mm which might be from agl@us.ibm.com are
