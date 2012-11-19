From: akpm@linux-foundation.org
Subject: [merged] tmpfs-fix-shmem_getpage_gfp-vm_bug_on.patch removed from -mm tree
Date: Mon, 19 Nov 2012 12:21:59 -0800
Message-ID: <20121119202200.6593D20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:43073 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab2KSUWC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Nov 2012 15:22:02 -0500
Received: by mail-bk0-f74.google.com with SMTP id je9so213826bkc.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Nov 2012 12:22:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, davej@redhat.com, hannes@cmpxchg.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: fix shmem_getpage_gfp() VM_BUG_ON
has been removed from the -mm tree.  Its filename was
     tmpfs-fix-shmem_getpage_gfp-vm_bug_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: tmpfs: fix shmem_getpage_gfp() VM_BUG_ON

Fuzzing with trinity hit the "impossible" VM_BUG_ON(error) (which Fedora
has converted to WARNING) in shmem_getpage_gfp():

WARNING: at mm/shmem.c:1151 shmem_getpage_gfp+0xa5c/0xa70()
Pid: 29795, comm: trinity-child4 Not tainted 3.7.0-rc2+ #49
Call Trace:
 [<ffffffff8107100f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff8107106a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff811903fc>] shmem_getpage_gfp+0xa5c/0xa70
 [<ffffffff81190e4f>] shmem_fault+0x4f/0xa0
 [<ffffffff8119f391>] __do_fault+0x71/0x5c0
 [<ffffffff811a2767>] handle_pte_fault+0x97/0xae0
 [<ffffffff811a4a39>] handle_mm_fault+0x289/0x350
 [<ffffffff816d091e>] __do_page_fault+0x18e/0x530
 [<ffffffff816d0ceb>] do_page_fault+0x2b/0x50
 [<ffffffff816cd3b8>] page_fault+0x28/0x30
 [<ffffffff816d5688>] tracesys+0xe1/0xe6

Thanks to Johannes for pointing to truncation: free_swap_and_cache() only
does a trylock on the page, so the page lock we've held since before
confirming swap is not enough to protect against truncation.

What cleanup is needed in this case?  Just delete_from_swap_cache(), which
takes care of the memcg uncharge.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Dave Jones <davej@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff -puN mm/shmem.c~tmpfs-fix-shmem_getpage_gfp-vm_bug_on mm/shmem.c
--- a/mm/shmem.c~tmpfs-fix-shmem_getpage_gfp-vm_bug_on
+++ a/mm/shmem.c
@@ -1145,8 +1145,20 @@ repeat:
 		if (!error) {
 			error = shmem_add_to_page_cache(page, mapping, index,
 						gfp, swp_to_radix_entry(swap));
-			/* We already confirmed swap, and make no allocation */
-			VM_BUG_ON(error);
+			/*
+			 * We already confirmed swap under page lock, and make
+			 * no memory allocation here, so usually no possibility
+			 * of error; but free_swap_and_cache() only trylocks a
+			 * page, so it is just possible that the entry has been
+			 * truncated or holepunched since swap was confirmed.
+			 * shmem_undo_range() will have done some of the
+			 * unaccounting, now delete_from_swap_cache() will do
+			 * the rest (including mem_cgroup_uncharge_swapcache).
+			 * Reset swap.val? No, leave it so "failed" goes back to
+			 * "repeat": reading a hole and writing should succeed.
+			 */
+			if (error)
+				delete_from_swap_cache(page);
 		}
 		if (error)
 			goto failed;
_

Patches currently in -mm which might be from hughd@google.com are

linux-next.patch
mm-add-comment-on-storage-key-dirty-bit-semantics.patch
mm-refactor-reinsert-of-swap_info-in-sys_swapoff.patch
mm-do-not-call-frontswap_init-during-swapoff.patch
mm-augment-vma-rbtree-with-rb_subtree_gap.patch
mm-augment-vma-rbtree-with-rb_subtree_gap-ensure-safe-rb_subtree_gap-update-when-inserting-new-vma.patch
mm-augment-vma-rbtree-with-rb_subtree_gap-ensure-safe-rb_subtree_gap-update-when-removing-vma.patch
mm-augment-vma-rbtree-with-rb_subtree_gap--debug-code-to-verify-rb_subtree_gap-updates-are-safe.patch
mm-check-rb_subtree_gap-correctness.patch
mm-check-rb_subtree_gap-correctness-fix.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses.patch
mm-vm_unmapped_area-lookup-function.patch
mm-use-vm_unmapped_area-on-x86_64-architecture.patch
mm-fix-cache-coloring-on-x86_64-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture-fix.patch
mm-use-vm_unmapped_area-on-mips-architecture.patch
mm-use-vm_unmapped_area-on-mips-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix.patch
mm-use-vm_unmapped_area-on-sh-architecture.patch
mm-use-vm_unmapped_area-on-sh-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc32-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture.patch
mm-use-vm_unmapped_area-on-sparc64-architecture.patch
mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-sparc64-architecture.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch

