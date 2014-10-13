From: akpm@linux-foundation.org
Subject: [merged] mm-use-vm_bug_on_mm-where-possible.patch removed from
 -mm tree
Date: Mon, 13 Oct 2014 11:20:55 -0700
Message-ID: <543c1807.27NFZLVRMyQeUEUR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60668 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501AbaJMSUz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:20:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use VM_BUG_ON_MM where possible
has been removed from the -mm tree.  Its filename was
     mm-use-vm_bug_on_mm-where-possible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: mm: use VM_BUG_ON_MM where possible

Dump the contents of the relevant struct_mm when we hit the bug condition.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c    |    3 +--
 kernel/sys.c     |    2 +-
 mm/huge_memory.c |    2 +-
 mm/mlock.c       |    2 +-
 mm/mmap.c        |    7 ++++---
 mm/pagewalk.c    |    2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

diff -puN kernel/fork.c~mm-use-vm_bug_on_mm-where-possible kernel/fork.c
--- a/kernel/fork.c~mm-use-vm_bug_on_mm-where-possible
+++ a/kernel/fork.c
@@ -601,9 +601,8 @@ static void check_mm(struct mm_struct *m
 			printk(KERN_ALERT "BUG: Bad rss-counter state "
 					  "mm:%p idx:%d val:%ld\n", mm, i, x);
 	}
-
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && !USE_SPLIT_PMD_PTLOCKS
-	VM_BUG_ON(mm->pmd_huge_pte);
+	VM_BUG_ON_MM(mm->pmd_huge_pte, mm);
 #endif
 }
 
diff -puN kernel/sys.c~mm-use-vm_bug_on_mm-where-possible kernel/sys.c
--- a/kernel/sys.c~mm-use-vm_bug_on_mm-where-possible
+++ a/kernel/sys.c
@@ -1634,7 +1634,7 @@ static int prctl_set_mm_exe_file_locked(
 	struct inode *inode;
 	int err;
 
-	VM_BUG_ON(!rwsem_is_locked(&mm->mmap_sem));
+	VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_sem), mm);
 
 	exe = fdget(fd);
 	if (!exe.file)
diff -puN mm/huge_memory.c~mm-use-vm_bug_on_mm-where-possible mm/huge_memory.c
--- a/mm/huge_memory.c~mm-use-vm_bug_on_mm-where-possible
+++ a/mm/huge_memory.c
@@ -2048,7 +2048,7 @@ int __khugepaged_enter(struct mm_struct
 		return -ENOMEM;
 
 	/* __khugepaged_exit() must not run from under us */
-	VM_BUG_ON(khugepaged_test_exit(mm));
+	VM_BUG_ON_MM(khugepaged_test_exit(mm), mm);
 	if (unlikely(test_and_set_bit(MMF_VM_HUGEPAGE, &mm->flags))) {
 		free_mm_slot(mm_slot);
 		return 0;
diff -puN mm/mlock.c~mm-use-vm_bug_on_mm-where-possible mm/mlock.c
--- a/mm/mlock.c~mm-use-vm_bug_on_mm-where-possible
+++ a/mm/mlock.c
@@ -235,7 +235,7 @@ long __mlock_vma_pages_range(struct vm_a
 	VM_BUG_ON(end   & ~PAGE_MASK);
 	VM_BUG_ON_VMA(start < vma->vm_start, vma);
 	VM_BUG_ON_VMA(end   > vma->vm_end, vma);
-	VM_BUG_ON(!rwsem_is_locked(&mm->mmap_sem));
+	VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_sem), mm);
 
 	gup_flags = FOLL_TOUCH | FOLL_MLOCK;
 	/*
diff -puN mm/mmap.c~mm-use-vm_bug_on_mm-where-possible mm/mmap.c
--- a/mm/mmap.c~mm-use-vm_bug_on_mm-where-possible
+++ a/mm/mmap.c
@@ -410,8 +410,9 @@ static void validate_mm_rb(struct rb_roo
 	for (nd = rb_first(root); nd; nd = rb_next(nd)) {
 		struct vm_area_struct *vma;
 		vma = rb_entry(nd, struct vm_area_struct, vm_rb);
-		BUG_ON(vma != ignore &&
-		       vma->rb_subtree_gap != vma_compute_subtree_gap(vma));
+		VM_BUG_ON_VMA(vma != ignore &&
+			vma->rb_subtree_gap != vma_compute_subtree_gap(vma),
+			vma);
 	}
 }
 
@@ -448,7 +449,7 @@ static void validate_mm(struct mm_struct
 			pr_emerg("map_count %d rb %d\n", mm->map_count, i);
 		bug = 1;
 	}
-	BUG_ON(bug);
+	VM_BUG_ON_MM(bug, mm);
 }
 #else
 #define validate_mm_rb(root, ignore) do { } while (0)
diff -puN mm/pagewalk.c~mm-use-vm_bug_on_mm-where-possible mm/pagewalk.c
--- a/mm/pagewalk.c~mm-use-vm_bug_on_mm-where-possible
+++ a/mm/pagewalk.c
@@ -177,7 +177,7 @@ int walk_page_range(unsigned long addr,
 	if (!walk->mm)
 		return -EINVAL;
 
-	VM_BUG_ON(!rwsem_is_locked(&walk->mm->mmap_sem));
+	VM_BUG_ON_MM(!rwsem_is_locked(&walk->mm->mmap_sem), walk->mm);
 
 	pgd = pgd_offset(walk->mm, addr);
 	do {
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

origin.patch
kernel-add-support-for-gcc-5.patch
kernel-add-support-for-gcc-5-checkpatch-fixes.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch

