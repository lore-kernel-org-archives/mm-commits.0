From: akpm@linux-foundation.org
Subject: [nacked] pagewalk-update-page-table-walker-core-fix.patch removed from -mm tree
Date: Mon, 16 Jun 2014 16:31:56 -0700
Message-ID: <539f7e6c./MUdkAO1a1eiTN+2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46509 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbaFPXb4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jun 2014 19:31:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com, n-horiguchi@ah.jp.nec.com


The patch titled
     Subject: pagewalk-update-page-table-walker-core-fix
has been removed from the -mm tree.  Its filename was
     pagewalk-update-page-table-walker-core-fix.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: pagewalk-update-page-table-walker-core-fix

On Mon, May 26, 2014 at 02:33:51PM +0300, Kirill A. Shutemov wrote:
> On Mon, Feb 10, 2014 at 02:42:08PM -0800, akpm@linux-foundation.org wrote:
> > diff -puN include/linux/mm.h~pagewalk-update-page-table-walker-core include/linux/mm.h
> > --- a/include/linux/mm.h~pagewalk-update-page-table-walker-core
> > +++ a/include/linux/mm.h
> > @@ -1075,10 +1075,18 @@ void unmap_vmas(struct mmu_gather *tlb,
> >   * @pte_entry: if set, called for each non-empty PTE (4th-level) entry
> >   * @pte_hole: if set, called for each hole at all levels
> >   * @hugetlb_entry: if set, called for each hugetlb entry
> > - *		   *Caution*: The caller must hold mmap_sem() if @hugetlb_entry
> > - * 			      is used.
> > + * @test_walk: caller specific callback function to determine whether
> > + *             we walk over the current vma or not. A positive returned
> > + *             value means "do page table walk over the current vma,"
> > + *             and a negative one means "abort current page table walk
> > + *             right now." 0 means "skip the current vma."
>
> This comment conflicts with comment for walk_page_test() and code itself:

Thank you, this comment is obsolete and one on walk_page_test() is correct.
So could you apply the following patch on patch $SUBJECT, Andrew?

Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN include/linux/mm.h~pagewalk-update-page-table-walker-core-fix include/linux/mm.h
--- a/include/linux/mm.h~pagewalk-update-page-table-walker-core-fix
+++ a/include/linux/mm.h
@@ -1110,10 +1110,8 @@ void unmap_vmas(struct mmu_gather *tlb,
  * @pte_hole: if set, called for each hole at all levels
  * @hugetlb_entry: if set, called for each hugetlb entry
  * @test_walk: caller specific callback function to determine whether
- *             we walk over the current vma or not. A positive returned
- *             value means "do page table walk over the current vma,"
- *             and a negative one means "abort current page table walk
- *             right now." 0 means "skip the current vma."
+ *             we walk over the current vma or not. See the comment on
+ *             walk_page_test() for how the skip control works.
  * @mm:        mm_struct representing the target process of page table walk
  * @vma:       vma currently walked
  * @skip:      internal control flag which is set when we skip the lower
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

hwpoison-fix-the-handling-path-of-the-victimized-page-frame-that-belong-to-non-lur.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-pagewalkc-move-pte-null-check.patch
mm-prom-pid-clear_refs-avoid-split_huge_page.patch
mm-pagewalk-remove-pgd_entry-and-pud_entry.patch
mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control.patch
mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control-fix.patch
madvise-cleanup-swapin_walk_pmd_entry.patch
madvise-cleanup-swapin_walk_pmd_entry-fix.patch
memcg-separate-mem_cgroup_move_charge_pte_range.patch
memcg-separate-mem_cgroup_move_charge_pte_range-checkpatch-fixes.patch
arch-powerpc-mm-subpage-protc-cleanup-subpage_walk_pmd_entry.patch
mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code.patch
mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code-checkpatch-fixes.patch
mincore-apply-page-table-walker-on-do_mincore.patch
mincore-apply-page-table-walker-on-do_mincore-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

