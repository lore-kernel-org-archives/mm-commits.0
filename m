From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 083/155] mm/vma: make vma_is_foreign() available
 for general use
Date: Wed, 01 Apr 2020 21:07:49 -0700
Message-ID: <20200402040749.dhAezOzXi%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726963AbgDBEHu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:07:50 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anshuman.khandual@arm.com, linux-mm@kvack.org, mingo@redhat.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, paulus@samba.org, tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz

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
@@ -543,6 +544,16 @@ static inline bool vma_is_anonymous(stru
 	return !vma->vm_ops;
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
