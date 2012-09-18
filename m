From: akpm@linux-foundation.org
Subject: + mm-anon-rmap-in-mremap-set-the-new-vmas-position-before-anon_vma_clone.patch added to -mm tree
Date: Tue, 18 Sep 2012 15:57:15 -0700
Message-ID: <20120918225716.587A020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:62009 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308Ab2IRW5T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Sep 2012 18:57:19 -0400
Received: by wibhr14 with SMTP id hr14so15975wib.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Sep 2012 15:57:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, hughd@google.com, jslaby@suse.cz, levinsasha928@gmail.com


The patch titled
     Subject: mm anon rmap: in mremap, set the new vma's position before anon_vma_clone()
has been added to the -mm tree.  Its filename is
     mm-anon-rmap-in-mremap-set-the-new-vmas-position-before-anon_vma_clone.patch

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
Subject: mm anon rmap: in mremap, set the new vma's position before anon_vma_clone()

anon_vma_clone() expects new_vma->vm_{start,end,pgoff} to be correctly set
so that the new vma can be indexed on the anon interval tree.

copy_vma() was failing to do that, which broke mremap().

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Tested-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/mmap.c~mm-anon-rmap-in-mremap-set-the-new-vmas-position-before-anon_vma_clone mm/mmap.c
--- a/mm/mmap.c~mm-anon-rmap-in-mremap-set-the-new-vmas-position-before-anon_vma_clone
+++ a/mm/mmap.c
@@ -2420,16 +2420,16 @@ struct vm_area_struct *copy_vma(struct v
 		new_vma = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 		if (new_vma) {
 			*new_vma = *vma;
+			new_vma->vm_start = addr;
+			new_vma->vm_end = addr + len;
+			new_vma->vm_pgoff = pgoff;
 			pol = mpol_dup(vma_policy(vma));
 			if (IS_ERR(pol))
 				goto out_free_vma;
+			vma_set_policy(new_vma, pol);
 			INIT_LIST_HEAD(&new_vma->anon_vma_chain);
 			if (anon_vma_clone(new_vma, vma))
 				goto out_free_mempol;
-			vma_set_policy(new_vma, pol);
-			new_vma->vm_start = addr;
-			new_vma->vm_end = addr + len;
-			new_vma->vm_pgoff = pgoff;
 			if (new_vma->vm_file)
 				get_file(new_vma->vm_file);
 			if (new_vma->vm_ops && new_vma->vm_ops->open)
_

Patches currently in -mm which might be from walken@google.com are

linux-next.patch
mm-adjust-final-endif-position-in-mm-internalh.patch
mm-fix-potential-anon_vma-locking-issue-in-mprotect.patch
ipc-mqueue-remove-unnecessary-rb_init_node-calls.patch
rbtree-reference-documentation-rbtreetxt-for-usage-instructions.patch
rbtree-empty-nodes-have-no-color.patch
rbtree-empty-nodes-have-no-color-fix.patch
rbtree-fix-incorrect-rbtree-node-insertion-in-fs-proc-proc_sysctlc.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec-fix.patch
rbtree-performance-and-correctness-test.patch
rbtree-performance-and-correctness-test-fix.patch
rbtree-break-out-of-rb_insert_color-loop-after-tree-rotation.patch
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary.patch
rbtree-low-level-optimizations-in-rb_insert_color.patch
rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary.patch
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary-fix.patch
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
mm-interval-tree-updates.patch
mm-anon-rmap-remove-anon_vma_moveto_tail.patch
mm-anon-rmap-replace-same_anon_vma-linked-list-with-an-interval-tree.patch
mm-rmap-remove-vma_address-check-for-address-inside-vma.patch
mm-add-config_debug_vm_rb-build-option.patch
mm-anon-rmap-in-mremap-set-the-new-vmas-position-before-anon_vma_clone.patch
mm-avoid-taking-rmap-locks-in-move_ptes.patch
thp-khugepaged_prealloc_page-forgot-to-reset-the-page-alloc-indicator.patch

