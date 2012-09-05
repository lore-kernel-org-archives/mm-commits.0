From: akpm@linux-foundation.org
Subject: + mm-mmu_notifier-make-the-mmu_notifier-srcu-static.patch added to -mm tree
Date: Wed, 05 Sep 2012 15:58:29 -0700
Message-ID: <20120905225830.13B7920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:44478 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759760Ab2IEW6c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Sep 2012 18:58:32 -0400
Received: by fass10 with SMTP id s10so65937fas.1
        for <mm-commits@vger.kernel.org>; Wed, 05 Sep 2012 15:58:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, a.p.zijlstra@chello.nl, haggaie@mellanox.com, sagig@mellanox.com, xiaoguangrong@linux.vnet.ibm.com


The patch titled
     Subject: mm: mmu_notifier: make the mmu_notifier srcu static
has been added to the -mm tree.  Its filename is
     mm-mmu_notifier-make-the-mmu_notifier-srcu-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: mmu_notifier: make the mmu_notifier srcu static

The variable must be static especially given the variable name.

s/RCU/SRCU/ over a few comments.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Haggai Eran <haggaie@mellanox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_notifier.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/mmu_notifier.c~mm-mmu_notifier-make-the-mmu_notifier-srcu-static mm/mmu_notifier.c
--- a/mm/mmu_notifier.c~mm-mmu_notifier-make-the-mmu_notifier-srcu-static
+++ a/mm/mmu_notifier.c
@@ -20,7 +20,7 @@
 #include <linux/slab.h>
 
 /* global SRCU for all MMs */
-struct srcu_struct srcu;
+static struct srcu_struct srcu;
 
 /*
  * This function can't run concurrently against mmu_notifier_register
@@ -41,7 +41,7 @@ void __mmu_notifier_release(struct mm_st
 	int id;
 
 	/*
-	 * RCU here will block mmu_notifier_unregister until
+	 * SRCU here will block mmu_notifier_unregister until
 	 * ->release returns.
 	 */
 	id = srcu_read_lock(&srcu);
@@ -302,7 +302,7 @@ void mmu_notifier_unregister(struct mmu_
 
 	if (!hlist_unhashed(&mn->hlist)) {
 		/*
-		 * RCU here will force exit_mmap to wait ->release to finish
+		 * SRCU here will force exit_mmap to wait ->release to finish
 		 * before freeing the pages.
 		 */
 		int id;
_

Patches currently in -mm which might be from aarcange@redhat.com are

mm-remove-__gfp_no_kswapd.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
mm-mmu_notifier-have-mmu_notifiers-use-a-global-srcu-so-they-may-safely-schedule.patch
mm-mmu_notifier-init-notifier-if-necessary.patch
thp-fix-the-count-of-thp_collapse_alloc.patch
thp-remove-unnecessary-check-in-start_khugepaged.patch
thp-move-khugepaged_mutex-out-of-khugepaged.patch
thp-remove-unnecessary-khugepaged_thread-check.patch
thp-remove-wake_up_interruptible-in-the-exit-path.patch
thp-remove-some-code-depend-on-config_numa.patch
thp-merge-page-pre-alloc-in-khugepaged_loop-into-khugepaged_do_scan.patch
thp-release-page-in-page-pre-alloc-path.patch
thp-introduce-khugepaged_prealloc_page-and-khugepaged_alloc_page.patch
thp-remove-khugepaged_loop.patch
thp-use-khugepaged_enabled-to-remove-duplicate-code.patch
thp-remove-unnecessary-set_recommended_min_free_kbytes.patch
mm-fix-potential-anon_vma-locking-issue-in-mprotect.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch
rbtree-reference-documentation-rbtreetxt-for-usage-instructions.patch
rbtree-empty-nodes-have-no-color.patch
rbtree-fix-incorrect-rbtree-node-insertion-in-fs-proc-proc_sysctlc.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec.patch
rbtree-performance-and-correctness-test.patch
rbtree-break-out-of-rb_insert_color-loop-after-tree-rotation.patch
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary.patch
rbtree-low-level-optimizations-in-rb_insert_color.patch
rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary.patch
rbtree-optimize-case-selection-logic-in-__rb_erase_color.patch
rbtree-low-level-optimizations-in-__rb_erase_color.patch
rbtree-coding-style-adjustments.patch
rbtree-optimize-fetching-of-sibling-node.patch
rbtree-test-fix-sparse-warning-about-64-bit-constant.patch
rbtree-add-__rb_change_child-helper-function.patch
rbtree-place-easiest-case-first-in-rb_erase.patch
rbtree-handle-1-child-recoloring-in-rb_erase-instead-of-rb_erase_color.patch
rbtree-low-level-optimizations-in-rb_erase.patch
rbtree-augmented-rbtree-test.patch
rbtree-faster-augmented-rbtree-manipulation.patch
rbtree-remove-prior-augmented-rbtree-implementation.patch
rbtree-add-rb_declare_callbacks-macro.patch
rbtree-add-prio-tree-and-interval-tree-tests.patch
mm-replace-vma-prio_tree-with-an-interval-tree.patch
kmemleak-use-rbtree-instead-of-prio-tree.patch
prio_tree-remove.patch
rbtree-move-augmented-rbtree-functionality-to-rbtree_augmentedh.patch
mm-mmu_notifier-make-the-mmu_notifier-srcu-static.patch

