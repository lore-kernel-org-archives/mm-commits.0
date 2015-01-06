From: akpm@linux-foundation.org
Subject: + mm-replace-vma-shareadlinear-with-vma-shared.patch added to -mm tree
Date: Tue, 06 Jan 2015 15:34:00 -0800
Message-ID: <54ac70e8.snR1iBm8B6CCO+gR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44617 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbbAFXeB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 18:34:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: replace vma->sharead.linear with vma->shared
has been added to the -mm tree.  Its filename is
     mm-replace-vma-shareadlinear-with-vma-shared.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-replace-vma-shareadlinear-with-vma-shared.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-replace-vma-shareadlinear-with-vma-shared.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: replace vma->sharead.linear with vma->shared

After removing vma->shared.nonlinear we have only one member of
vma->shared union, which doesn't make much sense.

This patch drops the union and move struct vma->shared.linear to
vma->shared.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    8 +++-----
 mm/interval_tree.c       |   34 +++++++++++++++++-----------------
 2 files changed, 20 insertions(+), 22 deletions(-)

diff -puN include/linux/mm_types.h~mm-replace-vma-shareadlinear-with-vma-shared include/linux/mm_types.h
--- a/include/linux/mm_types.h~mm-replace-vma-shareadlinear-with-vma-shared
+++ a/include/linux/mm_types.h
@@ -275,11 +275,9 @@ struct vm_area_struct {
 	 * For areas with an address space and backing store,
 	 * linkage into the address_space->i_mmap interval tree.
 	 */
-	union {
-		struct {
-			struct rb_node rb;
-			unsigned long rb_subtree_last;
-		} linear;
+	struct {
+		struct rb_node rb;
+		unsigned long rb_subtree_last;
 	} shared;
 
 	/*
diff -puN mm/interval_tree.c~mm-replace-vma-shareadlinear-with-vma-shared mm/interval_tree.c
--- a/mm/interval_tree.c~mm-replace-vma-shareadlinear-with-vma-shared
+++ a/mm/interval_tree.c
@@ -21,8 +21,8 @@ static inline unsigned long vma_last_pgo
 	return v->vm_pgoff + ((v->vm_end - v->vm_start) >> PAGE_SHIFT) - 1;
 }
 
-INTERVAL_TREE_DEFINE(struct vm_area_struct, shared.linear.rb,
-		     unsigned long, shared.linear.rb_subtree_last,
+INTERVAL_TREE_DEFINE(struct vm_area_struct, shared.rb,
+		     unsigned long, shared.rb_subtree_last,
 		     vma_start_pgoff, vma_last_pgoff,, vma_interval_tree)
 
 /* Insert node immediately after prev in the interval tree */
@@ -36,26 +36,26 @@ void vma_interval_tree_insert_after(stru
 
 	VM_BUG_ON_VMA(vma_start_pgoff(node) != vma_start_pgoff(prev), node);
 
-	if (!prev->shared.linear.rb.rb_right) {
+	if (!prev->shared.rb.rb_right) {
 		parent = prev;
-		link = &prev->shared.linear.rb.rb_right;
+		link = &prev->shared.rb.rb_right;
 	} else {
-		parent = rb_entry(prev->shared.linear.rb.rb_right,
-				  struct vm_area_struct, shared.linear.rb);
-		if (parent->shared.linear.rb_subtree_last < last)
-			parent->shared.linear.rb_subtree_last = last;
-		while (parent->shared.linear.rb.rb_left) {
-			parent = rb_entry(parent->shared.linear.rb.rb_left,
-				struct vm_area_struct, shared.linear.rb);
-			if (parent->shared.linear.rb_subtree_last < last)
-				parent->shared.linear.rb_subtree_last = last;
+		parent = rb_entry(prev->shared.rb.rb_right,
+				  struct vm_area_struct, shared.rb);
+		if (parent->shared.rb_subtree_last < last)
+			parent->shared.rb_subtree_last = last;
+		while (parent->shared.rb.rb_left) {
+			parent = rb_entry(parent->shared.rb.rb_left,
+				struct vm_area_struct, shared.rb);
+			if (parent->shared.rb_subtree_last < last)
+				parent->shared.rb_subtree_last = last;
 		}
-		link = &parent->shared.linear.rb.rb_left;
+		link = &parent->shared.rb.rb_left;
 	}
 
-	node->shared.linear.rb_subtree_last = last;
-	rb_link_node(&node->shared.linear.rb, &parent->shared.linear.rb, link);
-	rb_insert_augmented(&node->shared.linear.rb, root,
+	node->shared.rb_subtree_last = last;
+	rb_link_node(&node->shared.rb, &parent->shared.rb, link);
+	rb_insert_augmented(&node->shared.rb, root,
 			    &vma_interval_tree_augment);
 }
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-protect-set_page_dirty-from-ongoing-truncation.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-drop-support-of-non-linear-mapping-from-unmap-zap-codepath.patch
mm-drop-support-of-non-linear-mapping-from-fault-codepath.patch
mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub.patch
proc-drop-handling-non-linear-mappings.patch
rmap-drop-support-of-non-linear-mappings.patch
mm-replace-vma-shareadlinear-with-vma-shared.patch
mm-remove-rest-usage-of-vm_nonlinear-and-pte_file.patch
asm-generic-drop-unused-pte_file-helpers.patch
alpha-drop-_page_file-and-pte_file-related-helpers.patch
arc-drop-_page_file-and-pte_file-related-helpers.patch
arm64-drop-pte_file-and-pte_file-related-helpers.patch
arm-drop-l_pte_file-and-pte_file-related-helpers.patch
avr32-drop-_page_file-and-pte_file-related-helpers.patch
blackfin-drop-pte_file.patch
c6x-drop-pte_file.patch
cris-drop-_page_file-and-pte_file-related-helpers.patch
frv-drop-_page_file-and-pte_file-related-helpers.patch
hexagon-drop-_page_file-and-pte_file-related-helpers.patch
ia64-drop-_page_file-and-pte_file-related-helpers.patch
m32r-drop-_page_file-and-pte_file-related-helpers.patch
m68k-drop-_page_file-and-pte_file-related-helpers.patch
metag-drop-_page_file-and-pte_file-related-helpers.patch
microblaze-drop-_page_file-and-pte_file-related-helpers.patch
mips-drop-_page_file-and-pte_file-related-helpers.patch
mn10300-drop-_page_file-and-pte_file-related-helpers.patch
nios2-drop-_page_file-and-pte_file-related-helpers.patch
openrisc-drop-_page_file-and-pte_file-related-helpers.patch
parisc-drop-_page_file-and-pte_file-related-helpers.patch
powerpc-drop-_page_file-and-pte_file-related-helpers.patch
s390-drop-pte_file-related-helpers.patch
score-drop-_page_file-and-pte_file-related-helpers.patch
sh-drop-_page_file-and-pte_file-related-helpers.patch
sparc-drop-pte_file-related-helpers.patch
tile-drop-pte_file-related-helpers.patch
um-drop-_page_file-and-pte_file-related-helpers.patch
unicore32-drop-pte_file-related-helpers.patch
x86-drop-_page_file-and-pte_file-related-helpers.patch
xtensa-drop-_page_file-and-pte_file-related-helpers.patch
mm-memory-remove-vm_file-check-on-shared-writable-vmas.patch
mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page.patch
mm-add-fields-for-compound-destructor-and-order-into-struct-page.patch
mm-add-vm_bug_on_page-for-page_mapcount.patch

