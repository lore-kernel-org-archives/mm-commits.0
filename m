From: akpm@linux-foundation.org
Subject: [merged] mm-make-swapoff-more-robust-against-soft-dirty.patch
 removed from -mm tree
Date: Tue, 19 Jan 2016 12:14:18 -0800
Message-ID: <569e991a./6POXdh5ito+IfXq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44455 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbcASUOT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:14:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aneesh.kumar@linux.vnet.ibm.com, gorcunov@openvz.org, ldufour@linux.vnet.ibm.com, mpe@ellerman.id.au, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make swapoff more robust against soft dirty
has been removed from the -mm tree.  Its filename was
     mm-make-swapoff-more-robust-against-soft-dirty.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: make swapoff more robust against soft dirty

Both s390 and powerpc have hit the issue of swapoff hanging, when
CONFIG_HAVE_ARCH_SOFT_DIRTY and CONFIG_MEM_SOFT_DIRTY ifdefs were not
quite as x86_64 had them.  I think it would be much clearer if
HAVE_ARCH_SOFT_DIRTY was just a Kconfig option set by architectures to
determine whether the MEM_SOFT_DIRTY option should be offered, and the
actual code depend upon CONFIG_MEM_SOFT_DIRTY alone.

But won't embark on that change myself: instead make swapoff more robust,
by using pte_swp_clear_soft_dirty() on each pte it encounters, without an
explicit #ifdef CONFIG_MEM_SOFT_DIRTY.  That being a no-op, whether the
bit in question is defined as 0 or the asm-generic fallback is used,
unless soft dirty is fully turned on.

Why "maybe" in maybe_same_pte()?  Rename it pte_same_as_swp().

Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff -puN mm/swapfile.c~mm-make-swapoff-more-robust-against-soft-dirty mm/swapfile.c
--- a/mm/swapfile.c~mm-make-swapoff-more-robust-against-soft-dirty
+++ a/mm/swapfile.c
@@ -1111,19 +1111,9 @@ unsigned int count_swap_pages(int type,
 }
 #endif /* CONFIG_HIBERNATION */
 
-static inline int maybe_same_pte(pte_t pte, pte_t swp_pte)
+static inline int pte_same_as_swp(pte_t pte, pte_t swp_pte)
 {
-#ifdef CONFIG_MEM_SOFT_DIRTY
-	/*
-	 * When pte keeps soft dirty bit the pte generated
-	 * from swap entry does not has it, still it's same
-	 * pte from logical point of view.
-	 */
-	pte_t swp_pte_dirty = pte_swp_mksoft_dirty(swp_pte);
-	return pte_same(pte, swp_pte) || pte_same(pte, swp_pte_dirty);
-#else
-	return pte_same(pte, swp_pte);
-#endif
+	return pte_same(pte_swp_clear_soft_dirty(pte), swp_pte);
 }
 
 /*
@@ -1152,7 +1142,7 @@ static int unuse_pte(struct vm_area_stru
 	}
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	if (unlikely(!maybe_same_pte(*pte, swp_entry_to_pte(entry)))) {
+	if (unlikely(!pte_same_as_swp(*pte, swp_entry_to_pte(entry)))) {
 		mem_cgroup_cancel_charge(page, memcg, false);
 		ret = 0;
 		goto out;
@@ -1210,7 +1200,7 @@ static int unuse_pte_range(struct vm_are
 		 * swapoff spends a _lot_ of time in this loop!
 		 * Test inline before going to call unuse_pte.
 		 */
-		if (unlikely(maybe_same_pte(*pte, swp_pte))) {
+		if (unlikely(pte_same_as_swp(*pte, swp_pte))) {
 			pte_unmap(pte);
 			ret = unuse_pte(vma, pmd, addr, entry, page);
 			if (ret)
_

Patches currently in -mm which might be from hughd@google.com are


