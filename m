From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 17/35] mm/vma: introduce VM_ACCESS_FLAGS
Date: Fri, 10 Apr 2020 14:33:09 -0700
Message-ID: <20200410213309.Gegw27cKS%akpm@linux-foundation.org>
References: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726713AbgDJVdM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Apr 2020 17:33:12 -0400
In-Reply-To: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anshuman.khandual@arm.com, catalin.marinas@arm.com, dave.hansen@linux.intel.com, geert@linux-m68k.org, gregkh@linuxfoundation.org, gxt@pku.edu.cn, heiko.carstens@de.ibm.com, ley.foon.tan@intel.com, linux-mm@kvack.org, linux@armlinux.org.uk, mm-commits@vger.kernel.org, mpe@ellerman.id.au, msalter@redhat.com, nickhu@andestech.com, rspringer@google.com, tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz, ysato@users.sourceforge.jp

From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/vma: introduce VM_ACCESS_FLAGS

There are many places where all basic VMA access flags (read, write, exec)
are initialized or checked against as a group.  One such example is during
page fault.  Existing vma_is_accessible() wrapper already creates the
notion of VMA accessibility as a group access permissions.  Hence lets
just create VM_ACCESS_FLAGS (VM_READ|VM_WRITE|VM_EXEC) which will not only
reduce code duplication but also extend the VMA accessibility concept in
general.

Link: http://lkml.kernel.org/r/1583391014-8170-3-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Nick Hu <nickhu@andestech.com>
Cc: Ley Foon Tan <ley.foon.tan@intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Guan Xuetao <gxt@pku.edu.cn>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rob Springer <rspringer@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/fault.c                  |    2 +-
 arch/arm64/mm/fault.c                |    2 +-
 arch/nds32/mm/fault.c                |    2 +-
 arch/powerpc/mm/book3s64/pkeys.c     |    2 +-
 arch/s390/mm/fault.c                 |    2 +-
 arch/unicore32/mm/fault.c            |    2 +-
 arch/x86/mm/pkeys.c                  |    2 +-
 drivers/staging/gasket/gasket_core.c |    2 +-
 include/linux/mm.h                   |    6 +++++-
 mm/mmap.c                            |    2 +-
 mm/mprotect.c                        |    4 ++--
 11 files changed, 16 insertions(+), 12 deletions(-)

--- a/arch/arm64/mm/fault.c~mm-vma-introduce-vm_access_flags
+++ a/arch/arm64/mm/fault.c
@@ -445,7 +445,7 @@ static int __kprobes do_page_fault(unsig
 	const struct fault_info *inf;
 	struct mm_struct *mm = current->mm;
 	vm_fault_t fault, major = 0;
-	unsigned long vm_flags = VM_READ | VM_WRITE | VM_EXEC;
+	unsigned long vm_flags = VM_ACCESS_FLAGS;
 	unsigned int mm_flags = FAULT_FLAG_DEFAULT;
 
 	if (kprobe_page_fault(regs, esr))
--- a/arch/arm/mm/fault.c~mm-vma-introduce-vm_access_flags
+++ a/arch/arm/mm/fault.c
@@ -189,7 +189,7 @@ void do_bad_area(unsigned long addr, uns
  */
 static inline bool access_error(unsigned int fsr, struct vm_area_struct *vma)
 {
-	unsigned int mask = VM_READ | VM_WRITE | VM_EXEC;
+	unsigned int mask = VM_ACCESS_FLAGS;
 
 	if ((fsr & FSR_WRITE) && !(fsr & FSR_CM))
 		mask = VM_WRITE;
--- a/arch/nds32/mm/fault.c~mm-vma-introduce-vm_access_flags
+++ a/arch/nds32/mm/fault.c
@@ -79,7 +79,7 @@ void do_page_fault(unsigned long entry,
 	struct vm_area_struct *vma;
 	int si_code;
 	vm_fault_t fault;
-	unsigned int mask = VM_READ | VM_WRITE | VM_EXEC;
+	unsigned int mask = VM_ACCESS_FLAGS;
 	unsigned int flags = FAULT_FLAG_DEFAULT;
 
 	error_code = error_code & (ITYPE_mskINST | ITYPE_mskETYPE);
--- a/arch/powerpc/mm/book3s64/pkeys.c~mm-vma-introduce-vm_access_flags
+++ a/arch/powerpc/mm/book3s64/pkeys.c
@@ -315,7 +315,7 @@ int __execute_only_pkey(struct mm_struct
 static inline bool vma_is_pkey_exec_only(struct vm_area_struct *vma)
 {
 	/* Do this check first since the vm_flags should be hot */
-	if ((vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC)) != VM_EXEC)
+	if ((vma->vm_flags & VM_ACCESS_FLAGS) != VM_EXEC)
 		return false;
 
 	return (vma_pkey(vma) == vma->vm_mm->context.execute_only_pkey);
--- a/arch/s390/mm/fault.c~mm-vma-introduce-vm_access_flags
+++ a/arch/s390/mm/fault.c
@@ -580,7 +580,7 @@ void do_dat_exception(struct pt_regs *re
 	int access;
 	vm_fault_t fault;
 
-	access = VM_READ | VM_EXEC | VM_WRITE;
+	access = VM_ACCESS_FLAGS;
 	fault = do_exception(regs, access);
 	if (unlikely(fault))
 		do_fault_error(regs, access, fault);
--- a/arch/unicore32/mm/fault.c~mm-vma-introduce-vm_access_flags
+++ a/arch/unicore32/mm/fault.c
@@ -149,7 +149,7 @@ void do_bad_area(unsigned long addr, uns
  */
 static inline bool access_error(unsigned int fsr, struct vm_area_struct *vma)
 {
-	unsigned int mask = VM_READ | VM_WRITE | VM_EXEC;
+	unsigned int mask = VM_ACCESS_FLAGS;
 
 	if (!(fsr ^ 0x12))	/* write? */
 		mask = VM_WRITE;
--- a/arch/x86/mm/pkeys.c~mm-vma-introduce-vm_access_flags
+++ a/arch/x86/mm/pkeys.c
@@ -63,7 +63,7 @@ int __execute_only_pkey(struct mm_struct
 static inline bool vma_is_pkey_exec_only(struct vm_area_struct *vma)
 {
 	/* Do this check first since the vm_flags should be hot */
-	if ((vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC)) != VM_EXEC)
+	if ((vma->vm_flags & VM_ACCESS_FLAGS) != VM_EXEC)
 		return false;
 	if (vma_pkey(vma) != vma->vm_mm->context.execute_only_pkey)
 		return false;
--- a/drivers/staging/gasket/gasket_core.c~mm-vma-introduce-vm_access_flags
+++ a/drivers/staging/gasket/gasket_core.c
@@ -689,7 +689,7 @@ static bool gasket_mmap_has_permissions(
 
 	/* Make sure that no wrong flags are set. */
 	requested_permissions =
-		(vma->vm_flags & (VM_WRITE | VM_READ | VM_EXEC));
+		(vma->vm_flags & VM_ACCESS_FLAGS);
 	if (requested_permissions & ~(bar_permissions)) {
 		dev_dbg(gasket_dev->dev,
 			"Attempting to map a region with requested permissions 0x%x, but region has permissions 0x%x.\n",
--- a/include/linux/mm.h~mm-vma-introduce-vm_access_flags
+++ a/include/linux/mm.h
@@ -369,6 +369,10 @@ extern unsigned int kobjsize(const void
 
 #define VM_STACK_FLAGS	(VM_STACK | VM_STACK_DEFAULT_FLAGS | VM_ACCOUNT)
 
+/* VMA basic access permission flags */
+#define VM_ACCESS_FLAGS (VM_READ | VM_WRITE | VM_EXEC)
+
+
 /*
  * Special vmas that are non-mergable, non-mlock()able.
  */
@@ -646,7 +650,7 @@ static inline bool vma_is_foreign(struct
 
 static inline bool vma_is_accessible(struct vm_area_struct *vma)
 {
-	return vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC);
+	return vma->vm_flags & VM_ACCESS_FLAGS;
 }
 
 #ifdef CONFIG_SHMEM
--- a/mm/mmap.c~mm-vma-introduce-vm_access_flags
+++ a/mm/mmap.c
@@ -1224,7 +1224,7 @@ static int anon_vma_compatible(struct vm
 	return a->vm_end == b->vm_start &&
 		mpol_equal(vma_policy(a), vma_policy(b)) &&
 		a->vm_file == b->vm_file &&
-		!((a->vm_flags ^ b->vm_flags) & ~(VM_READ|VM_WRITE|VM_EXEC|VM_SOFTDIRTY)) &&
+		!((a->vm_flags ^ b->vm_flags) & ~(VM_ACCESS_FLAGS | VM_SOFTDIRTY)) &&
 		b->vm_pgoff == a->vm_pgoff + ((b->vm_start - a->vm_start) >> PAGE_SHIFT);
 }
 
--- a/mm/mprotect.c~mm-vma-introduce-vm_access_flags
+++ a/mm/mprotect.c
@@ -419,7 +419,7 @@ mprotect_fixup(struct vm_area_struct *vm
 	 */
 	if (arch_has_pfn_modify_check() &&
 	    (vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) &&
-	    (newflags & (VM_READ|VM_WRITE|VM_EXEC)) == 0) {
+	    (newflags & VM_ACCESS_FLAGS) == 0) {
 		pgprot_t new_pgprot = vm_get_page_prot(newflags);
 
 		error = walk_page_range(current->mm, start, end,
@@ -598,7 +598,7 @@ static int do_mprotect_pkey(unsigned lon
 		newflags |= (vma->vm_flags & ~mask_off_old_flags);
 
 		/* newflags >> 4 shift VM_MAY% in place of VM_% */
-		if ((newflags & ~(newflags >> 4)) & (VM_READ | VM_WRITE | VM_EXEC)) {
+		if ((newflags & ~(newflags >> 4)) & VM_ACCESS_FLAGS) {
 			error = -EACCES;
 			goto out;
 		}
_
