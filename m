From: akpm@linux-foundation.org
Subject: + mm-fix-potential-anon_vma-locking-issue-in-mprotect.patch added to -mm tree
Date: Tue, 04 Sep 2012 16:49:55 -0700
Message-ID: <20120904234955.C6C84100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:48503 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab2IDXt5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Sep 2012 19:49:57 -0400
Received: by ggnu1 with SMTP id u1so796164ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 04 Sep 2012 16:49:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, aarcange@redhat.com


The patch titled
     Subject: mm: fix potential anon_vma locking issue in mprotect()
has been added to the -mm tree.  Its filename is
     mm-fix-potential-anon_vma-locking-issue-in-mprotect.patch

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
Subject: mm: fix potential anon_vma locking issue in mprotect()

Fix an anon_vma locking issue in the following situation:

- vma has no anon_vma
- next has an anon_vma
- vma is being shrunk / next is being expanded, due to an mprotect call

We need to take next's anon_vma lock to avoid races with rmap users (such
as page migration) while next is being expanded.

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/mmap.c~mm-fix-potential-anon_vma-locking-issue-in-mprotect mm/mmap.c
--- a/mm/mmap.c~mm-fix-potential-anon_vma-locking-issue-in-mprotect
+++ a/mm/mmap.c
@@ -573,8 +573,12 @@ again:			remove_next = 1 + (end > next->
 	 */
 	if (vma->anon_vma && (importer || start != vma->vm_start)) {
 		anon_vma = vma->anon_vma;
+		VM_BUG_ON(adjust_next && next->anon_vma &&
+			  anon_vma != next->anon_vma);
+	} else if (adjust_next && next->anon_vma)
+		anon_vma = next->anon_vma;
+	if (anon_vma)
 		anon_vma_lock(anon_vma);
-	}
 
 	if (root) {
 		flush_dcache_mmap_lock(mapping);
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

