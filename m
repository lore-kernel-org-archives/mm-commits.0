From: akpm@linux-foundation.org
Subject: - mm-apply_to_range-call-pte-function-with-lazy-updates.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:12:06 -0800
Message-ID: <200901072212.n07MC6pE012330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37950 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755430AbZAGWMU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:12:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, hannes@cmpxchg.org, hugh@veritas.com, jeremy.fitzhardinge@citrix.com, nickpiggin@yahoo.com.au, venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     mm/apply_to_range: call pte function with lazy updates
has been removed from the -mm tree.  Its filename was
     mm-apply_to_range-call-pte-function-with-lazy-updates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/apply_to_range: call pte function with lazy updates
From: Jeremy Fitzhardinge <jeremy@goop.org>

Make the pte-level function in apply_to_range be called in lazy mmu mode,
so that any pagetable modifications can be batched.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/memory.c~mm-apply_to_range-call-pte-function-with-lazy-updates mm/memory.c
--- a/mm/memory.c~mm-apply_to_range-call-pte-function-with-lazy-updates
+++ a/mm/memory.c
@@ -1645,6 +1645,8 @@ static int apply_to_pte_range(struct mm_
 
 	BUG_ON(pmd_huge(*pmd));
 
+	arch_enter_lazy_mmu_mode();
+
 	token = pmd_pgtable(*pmd);
 
 	do {
@@ -1653,6 +1655,8 @@ static int apply_to_pte_range(struct mm_
 			break;
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 
+	arch_leave_lazy_mmu_mode();
+
 	if (mm != &init_mm)
 		pte_unmap_unlock(pte-1, ptl);
 	return err;
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
linux-next.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
xen-add-xenfs-to-allow-usermode-xen-interaction-fix-xenbus-message-reads.patch

