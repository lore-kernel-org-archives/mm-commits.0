From: akpm@linux-foundation.org
Subject: + shmem-let-shared-anonymous-be-nonlinear-again.patch added to -mm tree
Date: Sun, 20 Mar 2011 19:09:11 -0700
Message-ID: <201103210212.p2L2CIhZ007397@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751827Ab1CUCMZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 Mar 2011 22:12:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, stable@kernel.org, theonetruekenny@yahoo.com


The patch titled
     shmem: let shared anonymous be nonlinear again
has been added to the -mm tree.  Its filename is
     shmem-let-shared-anonymous-be-nonlinear-again.patch

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
Subject: shmem: let shared anonymous be nonlinear again
From: Hugh Dickins <hughd@google.com>

Up to 2.6.22, you could use remap_file_pages(2) on a tmpfs file or a
shared mapping of /dev/zero or a shared anonymous mapping.  In 2.6.23 we
disabled it by default, but set VM_CAN_NONLINEAR to enable it on safe
mappings.  We made sure to set it in shmem_mmap() for tmpfs files, but
missed it in shmem_zero_setup() for the others.  Fix that at last.

Reported-by: Kenny Simpson <theonetruekenny@yahoo.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/shmem.c~shmem-let-shared-anonymous-be-nonlinear-again mm/shmem.c
--- a/mm/shmem.c~shmem-let-shared-anonymous-be-nonlinear-again
+++ a/mm/shmem.c
@@ -2792,5 +2792,6 @@ int shmem_zero_setup(struct vm_area_stru
 		fput(vma->vm_file);
 	vma->vm_file = file;
 	vma->vm_ops = &shmem_vm_ops;
+	vma->vm_flags |= VM_CAN_NONLINEAR;
 	return 0;
 }
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-swap-unlock-swapfile-inode-mutex-before-closing-file-on-bad-swapfiles.patch
oom-prevent-unnecessary-oom-kills-or-kernel-panics.patch
oom-avoid-deferring-oom-killer-if-exiting-task-is-being-traced.patch
mm-vmap-area-cache.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix.patch
mm-introduce-delete_from_page_cache.patch
mm-hugetlbfs-change-remove_from_page_cache.patch
mm-shmem-change-remove_from_page_cache.patch
mm-truncate-change-remove_from_page_cache.patch
mm-good-bye-remove_from_page_cache.patch
mm-change-__remove_from_page_cache.patch
mm-rename-drop_anon_vma-to-put_anon_vma.patch
mm-move-anon_vma-ref-out-from-under-config_foo.patch
mm-simplify-anon_vma-refcounts.patch
mm-remove-worrying-dead-code-from-find_get_pages.patch
mm-dont-return-0-too-early-from-find_get_pages.patch
sys_swapon-use-vzalloc-instead-of-vmalloc-memset.patch
sys_swapon-remove-changelog-from-function-comment.patch
sys_swapon-do-not-depend-on-type-after-allocation.patch
sys_swapon-separate-swap_info-allocation.patch
sys_swapon-simplify-error-return-from-swap_info-allocation.patch
sys_swapon-simplify-error-flow-in-alloc_swap_info.patch
sys_swapon-remove-initial-value-of-name-variable.patch
sys_swapon-move-setting-of-error-nearer-use.patch
sys_swapon-remove-did_down-variable.patch
sys_swapon-remove-bdev-variable.patch
sys_swapon-do-only-cleanup-in-the-cleanup-blocks.patch
sys_swapon-use-a-single-error-label.patch
sys_swapon-separate-bdev-claim-and-inode-lock.patch
sys_swapon-simplify-error-flow-in-claim_swapfile.patch
sys_swapon-move-setting-of-swapfilepages-near-use.patch
sys_swapon-separate-parsing-of-swapfile-header.patch
sys_swapon-simplify-error-flow-in-read_swap_header.patch
sys_swapon-call-swap_cgroup_swapon-earlier.patch
sys_swapon-separate-parsing-of-bad-blocks-and-extents.patch
sys_swapon-simplify-error-flow-in-setup_swap_map_and_extents.patch
sys_swapon-remove-nr_good_pages-variable.patch
sys_swapon-move-printk-outside-lock.patch
sys_swapoff-change-order-to-match-sys_swapon.patch
sys_swapon-separate-final-enabling-of-the-swapfile.patch
shmem-let-shared-anonymous-be-nonlinear-again.patch
mm-simplify-code-of-swapc.patch
mm-batch-activate_page-to-reduce-lock-contention.patch
prio_tree-debugging-patch.patch

