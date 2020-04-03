From: akpm@linux-foundation.org
Subject: [merged]
 mm-vma-make-is_vma_temporary_stack-available-for-general-use.patch removed
 from -mm tree
Date: Fri, 03 Apr 2020 13:38:14 -0700
Message-ID: <20200403203814.JBpUV2zxb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727809AbgDCUiR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:38:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org, tglx@linutronix.de, vbabka@suse.cz


The patch titled
     Subject: mm/vma: make is_vma_temporary_stack() available for general use
has been removed from the -mm tree.  Its filename was
     mm-vma-make-is_vma_temporary_stack-available-for-general-use.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/vma: make is_vma_temporary_stack() available for general use

Currently the declaration and definition for is_vma_temporary_stack() are
scattered.  Lets make is_vma_temporary_stack() helper available for
general use and also drop the declaration from (include/linux/huge_mm.h)
which is no longer required.  While at this, rename this as
vma_is_temporary_stack() in line with existing helpers.  This should not
cause any functional change.

Link: http://lkml.kernel.org/r/1582782965-3274-4-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    4 +---
 include/linux/mm.h      |   14 ++++++++++++++
 mm/khugepaged.c         |    2 +-
 mm/mremap.c             |    2 +-
 mm/rmap.c               |   16 +---------------
 5 files changed, 18 insertions(+), 20 deletions(-)

--- a/include/linux/huge_mm.h~mm-vma-make-is_vma_temporary_stack-available-for-general-use
+++ a/include/linux/huge_mm.h
@@ -87,8 +87,6 @@ extern struct kobj_attribute shmem_enabl
 #define HPAGE_PUD_SIZE	((1UL) << HPAGE_PUD_SHIFT)
 #define HPAGE_PUD_MASK	(~(HPAGE_PUD_SIZE - 1))
 
-extern bool is_vma_temporary_stack(struct vm_area_struct *vma);
-
 extern unsigned long transparent_hugepage_flags;
 
 /*
@@ -100,7 +98,7 @@ static inline bool __transparent_hugepag
 	if (vma->vm_flags & VM_NOHUGEPAGE)
 		return false;
 
-	if (is_vma_temporary_stack(vma))
+	if (vma_is_temporary_stack(vma))
 		return false;
 
 	if (test_bit(MMF_DISABLE_THP, &vma->vm_mm->flags))
--- a/include/linux/mm.h~mm-vma-make-is_vma_temporary_stack-available-for-general-use
+++ a/include/linux/mm.h
@@ -544,6 +544,20 @@ static inline bool vma_is_anonymous(stru
 	return !vma->vm_ops;
 }
 
+static inline bool vma_is_temporary_stack(struct vm_area_struct *vma)
+{
+	int maybe_stack = vma->vm_flags & (VM_GROWSDOWN | VM_GROWSUP);
+
+	if (!maybe_stack)
+		return false;
+
+	if ((vma->vm_flags & VM_STACK_INCOMPLETE_SETUP) ==
+						VM_STACK_INCOMPLETE_SETUP)
+		return true;
+
+	return false;
+}
+
 static inline bool vma_is_foreign(struct vm_area_struct *vma)
 {
 	if (!current->mm)
--- a/mm/khugepaged.c~mm-vma-make-is_vma_temporary_stack-available-for-general-use
+++ a/mm/khugepaged.c
@@ -421,7 +421,7 @@ static bool hugepage_vma_check(struct vm
 	}
 	if (!vma->anon_vma || vma->vm_ops)
 		return false;
-	if (is_vma_temporary_stack(vma))
+	if (vma_is_temporary_stack(vma))
 		return false;
 	return !(vm_flags & VM_NO_KHUGEPAGED);
 }
--- a/mm/mremap.c~mm-vma-make-is_vma_temporary_stack-available-for-general-use
+++ a/mm/mremap.c
@@ -133,7 +133,7 @@ static void move_ptes(struct vm_area_str
 	 * such races:
 	 *
 	 * - During exec() shift_arg_pages(), we use a specially tagged vma
-	 *   which rmap call sites look for using is_vma_temporary_stack().
+	 *   which rmap call sites look for using vma_is_temporary_stack().
 	 *
 	 * - During mremap(), new_vma is often known to be placed after vma
 	 *   in rmap traversal order. This ensures rmap will always observe
--- a/mm/rmap.c~mm-vma-make-is_vma_temporary_stack-available-for-general-use
+++ a/mm/rmap.c
@@ -1699,23 +1699,9 @@ discard:
 	return ret;
 }
 
-bool is_vma_temporary_stack(struct vm_area_struct *vma)
-{
-	int maybe_stack = vma->vm_flags & (VM_GROWSDOWN | VM_GROWSUP);
-
-	if (!maybe_stack)
-		return false;
-
-	if ((vma->vm_flags & VM_STACK_INCOMPLETE_SETUP) ==
-						VM_STACK_INCOMPLETE_SETUP)
-		return true;
-
-	return false;
-}
