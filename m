From: akpm@linux-foundation.org
Subject: [merged] mm-clearing-pte-in-clear_soft_dirty.patch removed from
 -mm tree
Date: Fri, 06 Nov 2015 12:16:19 -0800
Message-ID: <563d0a93.k6RcgJdnv8ukzNpe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48922 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162953AbbKFUQT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:16:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ldufour@linux.vnet.ibm.com, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, mpe@ellerman.id.au, paulus@samba.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: clear pte in clear_soft_dirty()
has been removed from the -mm tree.  Its filename was
     mm-clearing-pte-in-clear_soft_dirty.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Subject: mm: clear pte in clear_soft_dirty()

As mentioned in the commit 56eecdb912b5 ("mm: Use ptep/pmdp_set_numa() for
updating _PAGE_NUMA bit"), architectures like ppc64 don't do tlb flush in
set_pte/pmd functions.

So when dealing with existing pte in clear_soft_dirty, the pte must be
cleared before being modified.

Signed-off-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-clearing-pte-in-clear_soft_dirty fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-clearing-pte-in-clear_soft_dirty
+++ a/fs/proc/task_mmu.c
@@ -792,19 +792,20 @@ static inline void clear_soft_dirty(stru
 	pte_t ptent = *pte;
 
 	if (pte_present(ptent)) {
+		ptent = ptep_modify_prot_start(vma->vm_mm, addr, pte);
 		ptent = pte_wrprotect(ptent);
 		ptent = pte_clear_soft_dirty(ptent);
+		ptep_modify_prot_commit(vma->vm_mm, addr, pte, ptent);
 	} else if (is_swap_pte(ptent)) {
 		ptent = pte_swp_clear_soft_dirty(ptent);
+		set_pte_at(vma->vm_mm, addr, pte, ptent);
 	}
