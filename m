From: akpm@linux-foundation.org
Subject: [merged]
 huge-pagecache-mmap_sem-is-unlocked-when-truncation-splits-pmd.patch
 removed from -mm tree
Date: Fri, 06 May 2016 14:17:20 -0700
Message-ID: <572d09e0.B3D2zQSZD7xREv6x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514AbcEFVRV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 May 2016 17:17:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, andreslc@google.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mgorman@techsingularity.net, quning@gmail.com, willy@linux.intel.com, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: huge pagecache: mmap_sem is unlocked when truncation splits pmd
has been removed from the -mm tree.  Its filename was
     huge-pagecache-mmap_sem-is-unlocked-when-truncation-splits-pmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: huge pagecache: mmap_sem is unlocked when truncation splits pmd

zap_pmd_range()'s CONFIG_DEBUG_VM !rwsem_is_locked(&mmap_sem) BUG() will
be invalid with huge pagecache, in whatever way it is implemented:
truncation of a hugely-mapped file to an unhugely-aligned size would
easily hit it.

(Although anon THP could in principle apply khugepaged to private file
mappings, which are not excluded by the MADV_HUGEPAGE restrictions, in
practice there's a vm_ops check which excludes them, so it never hits this
BUG() - there's no interface to "truncate" an anonymous mapping.)

We could complicate the test, to check i_mmap_rwsem also when there's a
vm_file; but my inclination was to make zap_pmd_range() more readable by
simply deleting this check.  A search has shown no report of the issue in
the years since commit e0897d75f0b2 ("mm, thp: print useful information
when mmap_sem is unlocked in zap_pmd_range") expanded it from VM_BUG_ON()
- though I cannot point to what commit I would say then fixed the issue.

But there are a couple of other patches now floating around, neither yet
in the tree: let's agree to retain the check as a VM_BUG_ON_VMA(), as
Matthew Wilcox has done; but subject to a vma_is_anonymous() check, as
Kirill Shutemov has done.  And let's get this in, without waiting for any
particular huge pagecache implementation to reach the tree.

Matthew said "We can reproduce this BUG() in the current Linus tree with
DAX PMDs".

Signed-off-by: Hugh Dickins <hughd@google.com>
Tested-by: Matthew Wilcox <willy@linux.intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Ning Qu <quning@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff -puN mm/memory.c~huge-pagecache-mmap_sem-is-unlocked-when-truncation-splits-pmd mm/memory.c
--- a/mm/memory.c~huge-pagecache-mmap_sem-is-unlocked-when-truncation-splits-pmd
+++ a/mm/memory.c
@@ -1222,15 +1222,8 @@ static inline unsigned long zap_pmd_rang
 		next = pmd_addr_end(addr, end);
 		if (pmd_trans_huge(*pmd) || pmd_devmap(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE) {
-#ifdef CONFIG_DEBUG_VM
-				if (!rwsem_is_locked(&tlb->mm->mmap_sem)) {
-					pr_err("%s: mmap_sem is unlocked! addr=0x%lx end=0x%lx vma->vm_start=0x%lx vma->vm_end=0x%lx\n",
-						__func__, addr, end,
-						vma->vm_start,
-						vma->vm_end);
-					BUG();
-				}
-#endif
+				VM_BUG_ON_VMA(vma_is_anonymous(vma) &&
+				    !rwsem_is_locked(&tlb->mm->mmap_sem), vma);
 				split_huge_pmd(vma, pmd, addr);
 			} else if (zap_huge_pmd(tlb, vma, pmd, addr))
 				goto next;
_

Patches currently in -mm which might be from hughd@google.com are

mm-compaction-skip-blocks-where-isolation-fails-in-async-direct-compaction-fix.patch
mm-update_lru_size-warn-and-reset-bad-lru_size.patch
mm-update_lru_size-do-the-__mod_zone_page_state.patch
mm-use-__setpageswapbacked-and-dont-clearpageswapbacked.patch
tmpfs-preliminary-minor-tidyups.patch
mm-proc-sys-vm-stat_refresh-to-force-vmstat-update.patch
huge-mm-move_huge_pmd-does-not-need-new_vma.patch
huge-pagecache-extend-mremap-pmd-rmap-lockout-to-files.patch
arch-fix-has_transparent_hugepage.patch
radix-tree-rewrite-radix_tree_locate_item-fix.patch

