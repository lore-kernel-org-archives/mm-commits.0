From: akpm@linux-foundation.org
Subject: + mm-protect-against-concurrent-vma-expansion.patch added to -mm tree
Date: Tue, 04 Dec 2012 15:57:15 -0800
Message-ID: <20121204235716.2B48E20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:37115 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab2LDX5S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2012 18:57:18 -0500
Received: by mail-ea0-f202.google.com with SMTP id j12so323084eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Dec 2012 15:57:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, hughd@google.com, riel@redhat.com


The patch titled
     Subject: mm: protect against concurrent vma expansion
has been added to the -mm tree.  Its filename is
     mm-protect-against-concurrent-vma-expansion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: protect against concurrent vma expansion

expand_stack() runs with a shared mmap_sem lock.  Because of this, there
could be multiple concurrent stack expansions in the same mm, which may
cause problems in the vma gap update code.

I propose to solve this by taking the mm->page_table_lock around such vma
expansions, in order to avoid the concurrency issue.  We only have to
worry about concurrent expand_stack() calls here, since we hold a shared
mmap_sem lock and all vma modificaitons other than expand_stack() are done
under an exclusive mmap_sem lock.

I previously tried to achieve the same effect by making sure all growable
vmas in a given mm would share the same anon_vma, which we already lock
here.  However this turned out to be difficult - all of the schemes I
tried for refcounting the growable anon_vma and clearing turned out ugly. 
So, I'm now proposing only the minimal fix.

The overhead of taking the page table lock during stack expansion is
expected to be small: glibc doesn't use expandable stacks for the threads
it creates, so having multiple growable stacks is actually uncommon and we
don't expect the page table lock to get bounced between threads.

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff -puN mm/mmap.c~mm-protect-against-concurrent-vma-expansion mm/mmap.c
--- a/mm/mmap.c~mm-protect-against-concurrent-vma-expansion
+++ a/mm/mmap.c
@@ -2069,6 +2069,18 @@ int expand_upwards(struct vm_area_struct
 		if (vma->vm_pgoff + (size >> PAGE_SHIFT) >= vma->vm_pgoff) {
 			error = acct_stack_growth(vma, size, grow);
 			if (!error) {
+				/*
+				 * vma_gap_update() doesn't support concurrent
+				 * updates, but we only hold a shared mmap_sem
+				 * lock here, so we need to protect against
+				 * concurrent vma expansions.
+				 * vma_lock_anon_vma() doesn't help here, as
+				 * we don't guarantee that all growable vmas
+				 * in a mm share the same root anon vma.
+				 * So, we reuse mm->page_table_lock to guard
+				 * against concurrent vma expansions.
+				 */
+				spin_lock(&vma->vm_mm->page_table_lock);
 				anon_vma_interval_tree_pre_update_vma(vma);
 				vma->vm_end = address;
 				anon_vma_interval_tree_post_update_vma(vma);
@@ -2076,6 +2088,8 @@ int expand_upwards(struct vm_area_struct
 					vma_gap_update(vma->vm_next);
 				else
 					vma->vm_mm->highest_vm_end = address;
+				spin_unlock(&vma->vm_mm->page_table_lock);
+
 				perf_event_mmap(vma);
 			}
 		}
@@ -2126,11 +2140,25 @@ int expand_downwards(struct vm_area_stru
 		if (grow <= vma->vm_pgoff) {
 			error = acct_stack_growth(vma, size, grow);
 			if (!error) {
+				/*
+				 * vma_gap_update() doesn't support concurrent
+				 * updates, but we only hold a shared mmap_sem
+				 * lock here, so we need to protect against
+				 * concurrent vma expansions.
+				 * vma_lock_anon_vma() doesn't help here, as
+				 * we don't guarantee that all growable vmas
+				 * in a mm share the same root anon vma.
+				 * So, we reuse mm->page_table_lock to guard
+				 * against concurrent vma expansions.
+				 */
+				spin_lock(&vma->vm_mm->page_table_lock);
 				anon_vma_interval_tree_pre_update_vma(vma);
 				vma->vm_start = address;
 				vma->vm_pgoff -= grow;
 				anon_vma_interval_tree_post_update_vma(vma);
 				vma_gap_update(vma);
+				spin_unlock(&vma->vm_mm->page_table_lock);
+
 				perf_event_mmap(vma);
 			}
 		}
_

Patches currently in -mm which might be from walken@google.com are

lib-makefile-fix-oid_registry-build-dependency.patch
linux-next.patch
mm-augment-vma-rbtree-with-rb_subtree_gap.patch
mm-augment-vma-rbtree-with-rb_subtree_gap-ensure-safe-rb_subtree_gap-update-when-inserting-new-vma.patch
mm-augment-vma-rbtree-with-rb_subtree_gap-ensure-safe-rb_subtree_gap-update-when-removing-vma.patch
mm-augment-vma-rbtree-with-rb_subtree_gap--debug-code-to-verify-rb_subtree_gap-updates-are-safe.patch
mm-augment-vma-rbtree-with-rb_subtree_gap-fix.patch
mm-check-rb_subtree_gap-correctness.patch
mm-check-rb_subtree_gap-correctness-fix.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses-checkpatch-fixes.patch
mm-vm_unmapped_area-lookup-function.patch
mm-vm_unmapped_area-lookup-function-checkpatch-fixes.patch
mm-use-vm_unmapped_area-on-x86_64-architecture.patch
mm-fix-cache-coloring-on-x86_64-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture-fix.patch
mm-use-vm_unmapped_area-on-mips-architecture.patch
mm-use-vm_unmapped_area-on-mips-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix-fix.patch
mm-use-vm_unmapped_area-on-sh-architecture.patch
mm-use-vm_unmapped_area-on-sh-architecture-fix.patch
mm-use-vm_unmapped_area-on-sh-architecture-fix2.patch
mm-use-vm_unmapped_area-on-sparc32-architecture.patch
mm-use-vm_unmapped_area-on-sparc32-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc32-architecture-fix-fix.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc64-architecture.patch
mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc64-architecture-fix-fix.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-sparc64-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-sparc64-architecture-fix.patch
arch-sparc-kernel-sys_sparc_64c-s-colour-color.patch
mm-protect-against-concurrent-vma-expansion.patch
random32-rename-random32-to-prandom.patch
prandom-introduce-prandom_bytes-and-prandom_bytes_state.patch
bnx2x-use-prandom_bytes.patch
mtd-nandsim-use-prandom_bytes.patch
ubifs-use-prandom_bytes.patch
mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch
mtd-mtd_oobtest-convert-to-use-prandom-library.patch
mtd-mtd_pagetest-convert-to-use-prandom-library.patch
mtd-mtd_speedtest-use-prandom_bytes.patch
mtd-mtd_subpagetest-convert-to-use-prandom-library.patch
mtd-mtd_stresstest-use-prandom_bytes.patch

