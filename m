From: akpm@linux-foundation.org
Subject: + ksm-hold-anon_vma-in-rmap_item-fix.patch added to -mm tree
Date: Wed, 02 Dec 2009 12:49:50 -0800
Message-ID: <200912022049.nB2KnoXU006667@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40236 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754300AbZLBUul (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2009 15:50:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, balbir@linux.vnet.ibm.com, chrisw@redhat.com, ieidus@redhat.com


The patch titled
     ksm: hold anon_vma in rmap_item fix
has been added to the -mm tree.  Its filename is
     ksm-hold-anon_vma-in-rmap_item-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: hold anon_vma in rmap_item fix
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

KSM mem_cgroup testing oopsed on NULL pointer in mem_cgroup_from_task(),
called from the mm_match_cgroup() in page_referenced_ksm().

Right, it is inappropriate to use mm_match_cgroup() on rmap_item->mm
there: that mm could be waiting for ksmd's final mmdrop(), with its
mm->owner task long gone.

Move the mm_match_cgroup() test down into the anon_vma loop, which is
where it now should be to match page_referenced_anon().  The anon_vma
guarantees its vmas are valid, which guarantee their mms are valid.

However...  although this moves the oops from easy-to-reproduce to
never-seen, I think we shall want to do more later: so far as I can see,
with or without KSM, the use of mm->owner from page_referenced() is
unsafe.  No problem when NULL, but it may have been left pointing to a
task_struct freed by now, with nonsense in mm->owner->cgroups.

But let's put this patch in while we discuss that separately: perhaps
mm_need_new_owner() should not short-circuit when mm_users <= 1, or
perhaps it should then set mm->owner to NULL, or perhaps we abandon
mm->owner as more trouble than it's worth, or...  perhaps I'm wrong.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Chris Wright <chrisw@redhat.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/ksm.c~ksm-hold-anon_vma-in-rmap_item-fix mm/ksm.c
--- a/mm/ksm.c~ksm-hold-anon_vma-in-rmap_item-fix
+++ a/mm/ksm.c
@@ -1530,9 +1530,6 @@ again:
 		struct anon_vma *anon_vma = rmap_item->anon_vma;
 		struct vm_area_struct *vma;
 
-		if (memcg && !mm_match_cgroup(rmap_item->mm, memcg))
-			continue;
-
 		spin_lock(&anon_vma->lock);
 		list_for_each_entry(vma, &anon_vma->head, anon_vma_node) {
 			if (rmap_item->address < vma->vm_start ||
@@ -1547,6 +1544,9 @@ again:
 			if ((rmap_item->mm == vma->vm_mm) == search_new_forks)
 				continue;
 
+			if (memcg && !mm_match_cgroup(vma->vm_mm, memcg))
+				continue;
+
 			referenced += page_referenced_one(page, vma,
 				rmap_item->address, &mapcount, vm_flags);
 			if (!search_new_forks || !mapcount)
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
vmalloc-adjust-gfp-mask-passed-on-nested-vmalloc-invocation.patch
swap_info-private-to-swapfilec.patch
swap_info-change-to-array-of-pointers.patch
swap_info-include-first_swap_extent.patch
swap_info-include-first_swap_extent-fix.patch
swap_info-include-first_swap_extent-fix-fix.patch
swap_info-miscellaneous-minor-cleanups.patch
swap_info-swap_has_cache-cleanups.patch
swap_info-swap_map-of-chars-not-shorts.patch
swap_info-swap-count-continuations.patch
swap_info-note-swap_map_shmem.patch
swap_info-reorder-its-fields.patch
rmap-fix-the-comment-for-try_to_unmap_anon.patch
oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch
mm-define-page_mapping_flags.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-mlocking-in-try_to_unmap_one-fix.patch
mm-mlocking-in-try_to_unmap_one-fix-fix.patch
mm-config_mmu-for-pg_mlocked.patch
mm-pass-address-down-to-rmap-ones.patch
mm-stop-ptlock-enlarging-struct-page.patch
mm-sigbus-instead-of-abusing-oom.patch
ksm-three-remove_rmap_item_from_tree-cleanups.patch
ksm-remove-redundancies-when-merging-page.patch
ksm-cleanup-some-function-arguments.patch
ksm-singly-linked-rmap_list.patch
ksm-separate-stable_node.patch
ksm-stable_node-point-to-page-and-back.patch
ksm-fix-mlockfreed-to-munlocked.patch
ksm-let-shared-pages-be-swappable.patch
ksm-hold-anon_vma-in-rmap_item.patch
ksm-hold-anon_vma-in-rmap_item-fix.patch
ksm-take-keyhole-reference-to-page.patch
ksm-share-anon-page-without-allocating.patch
ksm-mem-cgroup-charge-swapin-copy.patch
ksm-rmap_walk-to-remove_migation_ptes.patch
ksm-memory-hotremove-migration-only.patch
ksm-remove-unswappable-max_kernel_pages.patch
hugetlb-prevent-deadlock-in-__unmap_hugepage_range-when-alloc_huge_page-fails-2.patch
mm-simplify-try_to_unmap_one.patch
mm-simplify-try_to_unmap_one-fix.patch
mm-uncached-vma-support-with-writenotify.patch
elf-kill-use_elf_core_dump.patch
prio_tree-debugging-patch.patch

