From: akpm@linux-foundation.org
Subject: [merged] fork-annotate-a-data-race-in-vm_area_dup.patch
 removed from -mm tree
Date: Sun, 23 Feb 2020 16:45:06 -0800
Message-ID: <20200224004506.zLEgdtPnw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727156AbgBXApH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 23 Feb 2020 19:45:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cai@lca.pw, elver@google.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, paulmck@kernel.org, peterz@infradead.org


The patch titled
     Subject: fork: annotate a data race in vm_area_dup()
has been removed from the -mm tree.  Its filename was
     fork-annotate-a-data-race-in-vm_area_dup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: fork: annotate a data race in vm_area_dup()

struct vm_area_struct could be accessed concurrently as noticed by
KCSAN,

 write to 0xffff9cf8bba08ad8 of 8 bytes by task 14263 on cpu 35:
  vma_interval_tree_insert+0x101/0x150:
  rb_insert_augmented_cached at include/linux/rbtree_augmented.h:58
  (inlined by) vma_interval_tree_insert at mm/interval_tree.c:23
  __vma_link_file+0x6e/0xe0
  __vma_link_file at mm/mmap.c:629
  vma_link+0xa2/0x120
  mmap_region+0x753/0xb90
  do_mmap+0x45c/0x710
  vm_mmap_pgoff+0xc0/0x130
  ksys_mmap_pgoff+0x1d1/0x300
  __x64_sys_mmap+0x33/0x40
  do_syscall_64+0x91/0xc44
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

 read to 0xffff9cf8bba08a80 of 200 bytes by task 14262 on cpu 122:
  vm_area_dup+0x6a/0xe0
  vm_area_dup at kernel/fork.c:362
  __split_vma+0x72/0x2a0
  __split_vma at mm/mmap.c:2661
  split_vma+0x5a/0x80
  mprotect_fixup+0x368/0x3f0
  do_mprotect_pkey+0x263/0x420
  __x64_sys_mprotect+0x51/0x70
  do_syscall_64+0x91/0xc44
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

vm_area_dup() blindly copies all fields of original VMA to the new one. 
This includes coping vm_area_struct::shared.rb which is normally protected
by i_mmap_lock.  But this is fine because the read value will be
overwritten on the following __vma_link_file() under proper protection. 
Thus, mark it as an intentional data race and insert a few assertions for
the fields that should not be modified concurrently.

Link: http://lkml.kernel.org/r/1582122495-12885-1-git-send-email-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/kernel/fork.c~fork-annotate-a-data-race-in-vm_area_dup
+++ a/kernel/fork.c
@@ -359,7 +359,13 @@ struct vm_area_struct *vm_area_dup(struc
 	struct vm_area_struct *new = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 
 	if (new) {
-		*new = *orig;
+		ASSERT_EXCLUSIVE_WRITER(orig->vm_flags);
+		ASSERT_EXCLUSIVE_WRITER(orig->vm_file);
+		/*
+		 * orig->shared.rb may be modified concurrently, but the clone
+		 * will be reinitialized.
+		 */
+		*new = data_race(*orig);
 		INIT_LIST_HEAD(&new->anon_vma_chain);
 		new->vm_next = new->vm_prev = NULL;
 	}
_

Patches currently in -mm which might be from cai@lca.pw are

mm-frontswap-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races-v2.patch
mm-swap_state-mark-various-intentional-data-races.patch
mm-kmemleak-annotate-various-data-races-obj-ptr.patch
mm-swapfile-fix-and-annotate-various-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races-v2.patch
mm-page_counter-fix-various-data-races-at-memsw.patch
mm-memcontrol-fix-a-data-race-in-scan-count.patch
mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch
mm-mempool-fix-a-data-race-in-mempool_free.patch
mm-util-annotate-an-data-race-at-vm_committed_as.patch
mm-rmap-annotate-a-data-race-at-tlb_flush_batched.patch
mm-annotate-a-data-race-in-page_zonenum.patch
