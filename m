From: akpm@linux-foundation.org
Subject: - mm-mmapc-fix-coding-style.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:14:31 -0800
Message-ID: <200901072214.n07MEVTx014441@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761391AbZAGWOi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:14:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: helight.xu@gmail.com, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     mm/mmap.c: fix coding style
has been removed from the -mm tree.  Its filename was
     mm-mmapc-fix-coding-style.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/mmap.c: fix coding style
From: ZhenwenXu <helight.xu@gmail.com>

Fix a little of the coding style in mm/mmap.c

[akpm@linux-foundation.org: cleanup]
Signed-off-by: ZhenwenXu <helight.xu@gmail.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN mm/mmap.c~mm-mmapc-fix-coding-style mm/mmap.c
--- a/mm/mmap.c~mm-mmapc-fix-coding-style
+++ a/mm/mmap.c
@@ -413,7 +413,7 @@ void __vma_link_rb(struct mm_struct *mm,
 
 static void __vma_link_file(struct vm_area_struct *vma)
 {
-	struct file * file;
+	struct file *file;
 
 	file = vma->vm_file;
 	if (file) {
@@ -474,11 +474,10 @@ static void vma_link(struct mm_struct *m
  * insert vm structure into list and rbtree and anon_vma,
  * but it has already been inserted into prio_tree earlier.
  */
-static void
-__insert_vm_struct(struct mm_struct * mm, struct vm_area_struct * vma)
+static void __insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 {
-	struct vm_area_struct * __vma, * prev;
-	struct rb_node ** rb_link, * rb_parent;
+	struct vm_area_struct *__vma, *prev;
+	struct rb_node **rb_link, *rb_parent;
 
 	__vma = find_vma_prepare(mm, vma->vm_start,&prev, &rb_link, &rb_parent);
 	BUG_ON(__vma && __vma->vm_start < vma->vm_end);
@@ -908,7 +907,7 @@ void vm_stat_account(struct mm_struct *m
  * The caller must hold down_write(current->mm->mmap_sem).
  */
 
-unsigned long do_mmap_pgoff(struct file * file, unsigned long addr,
+unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 			unsigned long len, unsigned long prot,
 			unsigned long flags, unsigned long pgoff)
 {
@@ -1464,7 +1463,7 @@ get_unmapped_area(struct file *file, uns
 EXPORT_SYMBOL(get_unmapped_area);
 
 /* Look up the first VMA which satisfies  addr < vm_end,  NULL if none. */
-struct vm_area_struct * find_vma(struct mm_struct * mm, unsigned long addr)
+struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
 {
 	struct vm_area_struct *vma = NULL;
 
@@ -1507,7 +1506,7 @@ find_vma_prev(struct mm_struct *mm, unsi
 			struct vm_area_struct **pprev)
 {
 	struct vm_area_struct *vma = NULL, *prev = NULL;
-	struct rb_node * rb_node;
+	struct rb_node *rb_node;
 	if (!mm)
 		goto out;
 
@@ -1541,7 +1540,7 @@ out:
  * update accounting. This is shared with both the
  * grow-up and grow-down cases.
  */
-static int acct_stack_growth(struct vm_area_struct * vma, unsigned long size, unsigned long grow)
+static int acct_stack_growth(struct vm_area_struct *vma, unsigned long size, unsigned long grow)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct rlimit *rlim = current->signal->rlim;
_

Patches currently in -mm which might be from helight.xu@gmail.com are

origin.patch

