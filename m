From: akpm@linux-foundation.org
Subject: - mm-remove-nopfn-fix.patch removed from -mm tree
Date: Wed, 23 Jul 2008 15:54:24 -0700
Message-ID: <200807232307.m6NN71Uh016701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53986 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753350AbYGWXHM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 19:07:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm-remove-nopfn fix
has been removed from the -mm tree.  Its filename was
     mm-remove-nopfn-fix.patch

This patch was dropped because it was folded into mm-remove-nopfn.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-remove-nopfn fix
From: Hugh Dickins <hugh@veritas.com>

mm-remove-nopfn.patch

is now giving

mm/memory.c: In function `use_zero_page': mm/memory.c:1089:
error: `struct vm_operations_struct' has no member named `nopfn'

because of use_zero_page() now in origin.patch: please fold in this patch too.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/memory.c~mm-remove-nopfn-fix mm/memory.c
--- a/mm/memory.c~mm-remove-nopfn-fix
+++ a/mm/memory.c
@@ -1058,11 +1058,9 @@ static inline int use_zero_page(struct v
 	if (vma->vm_flags & (VM_LOCKED | VM_SHARED))
 		return 0;
 	/*
-	 * And if we have a fault or a nopfn routine, it's not an
-	 * anonymous region.
+	 * And if we have a fault routine, it's not an anonymous region.
 	 */
-	return !vma->vm_ops ||
-		(!vma->vm_ops->fault && !vma->vm_ops->nopfn);
+	return !vma->vm_ops || !vma->vm_ops->fault;
 }
 
 int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
mm-remove-nopfn.patch
mm-remove-nopfn-fix.patch
access_process_vm-device-memory-infrastructure.patch
use-generic_access_phys-for-dev-mem-mappings.patch
use-generic_access_phys-for-dev-mem-mappings-fix.patch
use-generic_access_phys-for-pci-mmap-on-x86.patch
powerpc-ioremap_prot.patch
spufs-use-the-new-vm_ops-access.patch
spufs-use-the-new-vm_ops-access-fix.patch
mm-remove-double-indirection-on-tlb-parameter-to-free_pgd_range-co.patch
hugetlb-move-hugetlb_acct_memory.patch
hugetlb-reserve-huge-pages-for-reliable-map_private-hugetlbfs-mappings-until-fork.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-fix.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-build-fix.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-align-faulting-address-to-a-hugepage-boundary-before-unmapping.patch
huge-page-private-reservation-review-cleanups.patch
huge-page-private-reservation-review-cleanups-fix.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch
hugetlb-reservations-fix-hugetlb-map_private-reservations-across-vma-splits-v2.patch
vma-page-offset-has-no-callees-drop-it.patch
generic_file_aio_read-cleanups.patch
tmpfs-support-aio.patch
hugetlb-fix-race-when-reading-proc-meminfo.patch
hugetlb-quota-is-not-freed-for-unused-reserved-private-huge-pages.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifiers-add-mm_take_all_locks-operation-checkpatch-fixes.patch
mmu-notifier-core.patch
mmu-notifier-core-fix.patch
mmu-notifier-core-fix-2.patch
mm-fix-ever-decreasing-swap-priority.patch
security-remove-unused-forwards.patch

