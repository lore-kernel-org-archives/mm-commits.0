From: akpm@linux-foundation.org
Subject: +
 mm-vma-make-vma_is_foreign-available-for-general-use.patch added to -mm
 tree
Date: Sat, 29 Feb 2020 20:51:48 -0800
Message-ID: <20200301045148.udNk4hfQA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgCAEvv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 29 Feb 2020 23:51:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org, tglx@linutronix.de, vbabka@suse.cz


The patch titled
     Subject: mm/vma: make vma_is_foreign() available for general use
has been added to the -mm tree.  Its filename is
     mm-vma-make-vma_is_foreign-available-for-general-use.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vma-make-vma_is_foreign-available-for-general-use.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vma-make-vma_is_foreign-available-for-general-use.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/vma: make vma_is_foreign() available for general use

Idea of a foreign VMA with respect to the present context is very generic.
But currently there are two identical definitions for this in powerpc and
x86 platforms.  Lets consolidate those redundant definitions while making
vma_is_foreign() available for general use later.  This should not cause
any functional change.

Link: http://lkml.kernel.org/r/1582782965-3274-3-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/book3s64/pkeys.c   |   12 ------------
 arch/x86/include/asm/mmu_context.h |   15 ---------------
 include/linux/mm.h                 |   11 +++++++++++
 3 files changed, 11 insertions(+), 27 deletions(-)

--- a/arch/powerpc/mm/book3s64/pkeys.c~mm-vma-make-vma_is_foreign-available-for-general-use
+++ a/arch/powerpc/mm/book3s64/pkeys.c
@@ -381,18 +381,6 @@ bool arch_pte_access_permitted(u64 pte,
  * So do not enforce things if the VMA is not from the current mm, or if we are
  * in a kernel thread.
  */
-static inline bool vma_is_foreign(struct vm_area_struct *vma)
-{
-	if (!current->mm)
-		return true;
-
-	/* if it is not our ->mm, it has to be foreign */
-	if (current->mm != vma->vm_mm)
-		return true;
-
-	return false;
-}
-
 bool arch_vma_access_permitted(struct vm_area_struct *vma, bool write,
 			       bool execute, bool foreign)
 {
--- a/arch/x86/include/asm/mmu_context.h~mm-vma-make-vma_is_foreign-available-for-general-use
+++ a/arch/x86/include/asm/mmu_context.h
@@ -213,21 +213,6 @@ static inline void arch_unmap(struct mm_
  * So do not enforce things if the VMA is not from the current
  * mm, or if we are in a kernel thread.
  */
-static inline bool vma_is_foreign(struct vm_area_struct *vma)
-{
-	if (!current->mm)
-		return true;
-	/*
-	 * Should PKRU be enforced on the access to this VMA?  If
-	 * the VMA is from another process, then PKRU has no
-	 * relevance and should not be enforced.
-	 */
-	if (current->mm != vma->vm_mm)
-		return true;
-
-	return false;
-}
-
 static inline bool arch_vma_access_permitted(struct vm_area_struct *vma,
 		bool write, bool execute, bool foreign)
 {
--- a/include/linux/mm.h~mm-vma-make-vma_is_foreign-available-for-general-use
+++ a/include/linux/mm.h
@@ -27,6 +27,7 @@
 #include <linux/memremap.h>
 #include <linux/overflow.h>
 #include <linux/sizes.h>
+#include <linux/sched.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -548,6 +549,16 @@ static inline bool vma_is_accessible(str
 	return vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC);
 }
 
+static inline bool vma_is_foreign(struct vm_area_struct *vma)
+{
+	if (!current->mm)
+		return true;
+
+	if (current->mm != vma->vm_mm)
+		return true;
+
+	return false;
+}
 #ifdef CONFIG_SHMEM
 /*
  * The vma_is_shmem is not inline because it is used only by slow
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-debug-add-tests-validating-architecture-page-table-helpers.patch
mm-debug-add-tests-validating-architecture-page-table-helpers-fix-2.patch
mm-vma-add-missing-vma-flag-readable-name-for-vm_sync.patch
mm-vma-make-vma_is_accessible-available-for-general-use.patch
mm-vma-replace-all-remaining-open-encodings-with-is_vm_hugetlb_page.patch
mm-vma-replace-all-remaining-open-encodings-with-vma_is_anonymous.patch
mm-vma-append-unlikely-while-testing-vma-access-permissions.patch
mm-vma-move-vm_no_khugepaged-into-generic-header.patch
mm-vma-make-vma_is_foreign-available-for-general-use.patch
mm-vma-make-is_vma_temporary_stack-available-for-general-use.patch
