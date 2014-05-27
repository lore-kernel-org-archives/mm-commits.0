From: akpm@linux-foundation.org
Subject: + pagewalk-update-page-table-walker-core-fix.patch added to -mm
 tree
Date: Tue, 27 May 2014 15:55:05 -0700
Message-ID: <538517c9.oyewClJr7dkoBl6v%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55782 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbaE0WzG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 May 2014 18:55:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com, n-horiguchi@ah.jp.nec.com

Subject: + pagewalk-update-page-table-walker-core-fix.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,kirill.shutemov@linux.intel.com
From: akpm@linux-foundation.org
Date: Tue, 27 May 2014 15:55:05 -0700


The patch titled
     Subject: pagewalk-update-page-table-walker-core-fix
has been added to the -mm tree.  Its filename is
     pagewalk-update-page-table-walker-core-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pagewalk-update-page-table-walker-core-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pagewalk-update-page-table-walker-core-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1099,10 +1099,8 @@ void unmap_vmas(struct mmu_gather *tlb,
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

tools-vm-page-typesc-catch-sigbus-if-raced-with-truncate.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-update-page-table-walker-core-fix.patch
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
mm-add-pte_present-check-on-existing-hugetlb_entry-callbacks.patch
mm-pagewalkc-move-pte-null-check.patch
mm-softdirty-clear-vm_softdirty-flag-inside-clear_refs_write-instead-of-clear_soft_dirty.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
mm-compaction-cleanup-isolate_freepages-fix-2.patch
mm-compaction-cleanup-isolate_freepages-fix3.patch
mm-migration-add-destination-page-freeing-callback.patch
mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch
mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-compaction-embed-migration-mode-in-compact_control-fix.patch
mm-thp-avoid-excessive-compaction-latency-during-fault.patch
mm-thp-avoid-excessive-compaction-latency-during-fault-fix.patch
mm-compaction-do-not-count-migratepages-when-unnecessary.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages-fix.patch
mm-memory-failurec-move-comment.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention.patch
hwpoison-remove-unused-global-variable-in-do_machine_check.patch
mm-prom-pid-clear_refs-avoid-split_huge_page.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

