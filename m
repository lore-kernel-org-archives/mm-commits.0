Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561FA3085CC
	for <mm-commits@vger.kernel.org>; Wed, 18 Jun 2025 22:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750287397; cv=none; b=bARf+NehsnRCoJS29O7zOOg/DFY0OVN22o8xYkJVM7szWwoeMWOQEwacjYfA5GeSoC3fiR3KlfZx9kc7zzKcxVYzssfNoHQpc83hJ9nm1USq215HxHw0SNZs/HnYyiDPCpBLOuOzmqie1A7OEy8ckL1AmyoYfnbQtbkAdlYoYAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750287397; c=relaxed/simple;
	bh=Q4VgWsapzUjLVBnUP72rHnhH1fyJKDJi9BTo6tqo7uc=;
	h=Date:To:From:Subject:Message-Id; b=BlG3gQOvNi32k2WGrluBXP2+j7gFmGAewZVHJDZpKEfmGzxcCbXGG4r6A2rbfl8UeVaWd0djXZj79MRJksHqsf76o0TyU0/0Igs9ExS8wVV4bMhgxvRl9tyqAH8HSR6iIy9KDDVsG3FnFYMZpNmUVsw9/bPskRm0Eh02QKrRfjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NMmUsky9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NMmUsky9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F23C4CEE7;
	Wed, 18 Jun 2025 22:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750287396;
	bh=Q4VgWsapzUjLVBnUP72rHnhH1fyJKDJi9BTo6tqo7uc=;
	h=Date:To:From:Subject:From;
	b=NMmUsky9O6e6+cQQqme2SqESHvyixLigPwdnPRFKTZrsyW6DgDmBJli4xxKkY+Bag
	 94F0kJ0nhSrqpWRCN6KbG+K2Or5AnjXuQPrEAAWt1lfovSs9ZjPgay3+5oB+yNwcqA
	 D425s4s4tzqS03zcaNsSvL0i+CTRZOwNsGHKNEw0=
Date: Wed, 18 Jun 2025 15:56:35 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,Liam.Howlett@oracle.com,kees@kernel.org,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-update-architecture-and-driver-code-to-use-vm_flags_t.patch added to mm-new branch
Message-Id: <20250618225636.B7F23C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: update architecture and driver code to use vm_flags_t
has been added to the -mm mm-new branch.  Its filename is
     mm-update-architecture-and-driver-code-to-use-vm_flags_t.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-update-architecture-and-driver-code-to-use-vm_flags_t.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: update architecture and driver code to use vm_flags_t
Date: Wed, 18 Jun 2025 20:42:54 +0100

In future we intend to change the vm_flags_t type, so it isn't correct for
architecture and driver code to assume it is unsigned long.  Correct this
assumption across the board.

Overall, this patch does not introduce any functional change.

Link: https://lkml.kernel.org/r/b6eb1894abc5555ece80bb08af5c022ef780c8bc.1750274467.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/fault.c                |    2 +-
 arch/arm64/include/asm/mman.h      |   10 +++++-----
 arch/arm64/mm/fault.c              |    2 +-
 arch/arm64/mm/mmu.c                |    2 +-
 arch/powerpc/include/asm/mman.h    |    2 +-
 arch/powerpc/include/asm/pkeys.h   |    4 ++--
 arch/powerpc/kvm/book3s_hv_uvmem.c |    2 +-
 arch/sparc/include/asm/mman.h      |    4 ++--
 arch/x86/kernel/cpu/sgx/encl.c     |    8 ++++----
 arch/x86/kernel/cpu/sgx/encl.h     |    2 +-
 tools/testing/vma/vma_internal.h   |    2 +-
 11 files changed, 20 insertions(+), 20 deletions(-)

--- a/arch/arm64/include/asm/mman.h~mm-update-architecture-and-driver-code-to-use-vm_flags_t
+++ a/arch/arm64/include/asm/mman.h
@@ -11,10 +11,10 @@
 #include <linux/shmem_fs.h>
 #include <linux/types.h>
 
-static inline unsigned long arch_calc_vm_prot_bits(unsigned long prot,
+static inline vm_flags_t arch_calc_vm_prot_bits(unsigned long prot,
 	unsigned long pkey)
 {
-	unsigned long ret = 0;
+	vm_flags_t ret = 0;
 
 	if (system_supports_bti() && (prot & PROT_BTI))
 		ret |= VM_ARM64_BTI;
@@ -34,8 +34,8 @@ static inline unsigned long arch_calc_vm
 }
 #define arch_calc_vm_prot_bits(prot, pkey) arch_calc_vm_prot_bits(prot, pkey)
 
-static inline unsigned long arch_calc_vm_flag_bits(struct file *file,
-						   unsigned long flags)
+static inline vm_flags_t arch_calc_vm_flag_bits(struct file *file,
+						unsigned long flags)
 {
 	/*
 	 * Only allow MTE on anonymous mappings as these are guaranteed to be
@@ -68,7 +68,7 @@ static inline bool arch_validate_prot(un
 }
 #define arch_validate_prot(prot, addr) arch_validate_prot(prot, addr)
 
-static inline bool arch_validate_flags(unsigned long vm_flags)
+static inline bool arch_validate_flags(vm_flags_t vm_flags)
 {
 	if (system_supports_mte()) {
 		/*
--- a/arch/arm64/mm/fault.c~mm-update-architecture-and-driver-code-to-use-vm_flags_t
+++ a/arch/arm64/mm/fault.c
@@ -549,7 +549,7 @@ static int __kprobes do_page_fault(unsig
 	const struct fault_info *inf;
 	struct mm_struct *mm = current->mm;
 	vm_fault_t fault;
-	unsigned long vm_flags;
+	vm_flags_t vm_flags;
 	unsigned int mm_flags = FAULT_FLAG_DEFAULT;
 	unsigned long addr = untagged_addr(far);
 	struct vm_area_struct *vma;
--- a/arch/arm64/mm/mmu.c~mm-update-architecture-and-driver-code-to-use-vm_flags_t
+++ a/arch/arm64/mm/mmu.c
@@ -720,7 +720,7 @@ void mark_rodata_ro(void)
 
 static void __init declare_vma(struct vm_struct *vma,
 			       void *va_start, void *va_end,
-			       unsigned long vm_flags)
+			       vm_flags_t vm_flags)
 {
 	phys_addr_t pa_start = __pa_symbol(va_start);
 	unsigned long size = va_end - va_start;
--- a/arch/arm/mm/fault.c~mm-update-architecture-and-driver-code-to-use-vm_flags_t
+++ a/arch/arm/mm/fault.c
@@ -268,7 +268,7 @@ do_page_fault(unsigned long addr, unsign
 	int sig, code;
 	vm_fault_t fault;
 	unsigned int flags = FAULT_FLAG_DEFAULT;
-	unsigned long vm_flags = VM_ACCESS_FLAGS;
+	vm_flags_t vm_flags = VM_ACCESS_FLAGS;
 
 	if (kprobe_page_fault(regs, fsr))
 		return 0;
--- a/arch/powerpc/include/asm/mman.h~mm-update-architecture-and-driver-code-to-use-vm_flags_t
+++ a/arch/powerpc/include/asm/mman.h
@@ -14,7 +14,7 @@
 #include <asm/cpu_has_feature.h>
 #include <asm/firmware.h>
 
-static inline unsigned long arch_calc_vm_prot_bits(unsigned long prot,
+static inline vm_flags_t arch_calc_vm_prot_bits(unsigned long prot,
 		unsigned long pkey)
 {
 #ifdef CONFIG_PPC_MEM_KEYS
--- a/arch/powerpc/include/asm/pkeys.h~mm-update-architecture-and-driver-code-to-use-vm_flags_t
+++ a/arch/powerpc/include/asm/pkeys.h
@@ -30,9 +30,9 @@ extern u32 reserved_allocation_mask; /*
 #endif
 
 
-static inline u64 pkey_to_vmflag_bits(u16 pkey)
+static inline vm_flags_t pkey_to_vmflag_bits(u16 pkey)
 {
-	return (((u64)pkey << VM_PKEY_SHIFT) & ARCH_VM_PKEY_FLAGS);
+	return (((vm_flags_t)pkey << VM_PKEY_SHIFT) & ARCH_VM_PKEY_FLAGS);
 }
 
 static inline int vma_pkey(struct vm_area_struct *vma)
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c~mm-update-architecture-and-driver-code-to-use-vm_flags_t
+++ a/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -393,7 +393,7 @@ static int kvmppc_memslot_page_merge(str
 {
 	unsigned long gfn = memslot->base_gfn;
 	unsigned long end, start = gfn_to_hva(kvm, gfn);
-	unsigned long vm_flags;
+	vm_flags_t vm_flags;
 	int ret = 0;
 	struct vm_area_struct *vma;
 	int merge_flag = (merge) ? MADV_MERGEABLE : MADV_UNMERGEABLE;
--- a/arch/sparc/include/asm/mman.h~mm-update-architecture-and-driver-code-to-use-vm_flags_t
+++ a/arch/sparc/include/asm/mman.h
@@ -28,7 +28,7 @@ static inline void ipi_set_tstate_mcde(v
 }
 
 #define arch_calc_vm_prot_bits(prot, pkey) sparc_calc_vm_prot_bits(prot)
-static inline unsigned long sparc_calc_vm_prot_bits(unsigned long prot)
+static inline vm_flags_t sparc_calc_vm_prot_bits(unsigned long prot)
 {
 	if (adi_capable() && (prot & PROT_ADI)) {
 		struct pt_regs *regs;
@@ -58,7 +58,7 @@ static inline int sparc_validate_prot(un
 /* arch_validate_flags() - Ensure combination of flags is valid for a
  *	VMA.
  */
-static inline bool arch_validate_flags(unsigned long vm_flags)
+static inline bool arch_validate_flags(vm_flags_t vm_flags)
 {
 	/* If ADI is being enabled on this VMA, check for ADI
 	 * capability on the platform and ensure VMA is suitable
--- a/arch/x86/kernel/cpu/sgx/encl.c~mm-update-architecture-and-driver-code-to-use-vm_flags_t
+++ a/arch/x86/kernel/cpu/sgx/encl.c
@@ -279,7 +279,7 @@ static struct sgx_encl_page *__sgx_encl_
 
 static struct sgx_encl_page *sgx_encl_load_page_in_vma(struct sgx_encl *encl,
 						       unsigned long addr,
-						       unsigned long vm_flags)
+						       vm_flags_t vm_flags)
 {
 	unsigned long vm_prot_bits = vm_flags & VM_ACCESS_FLAGS;
 	struct sgx_encl_page *entry;
@@ -520,9 +520,9 @@ static void sgx_vma_open(struct vm_area_
  * Return: 0 on success, -EACCES otherwise
  */
 int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
-		     unsigned long end, unsigned long vm_flags)
+		     unsigned long end, vm_flags_t vm_flags)
 {
-	unsigned long vm_prot_bits = vm_flags & VM_ACCESS_FLAGS;
+	vm_flags_t vm_prot_bits = vm_flags & VM_ACCESS_FLAGS;
 	struct sgx_encl_page *page;
 	unsigned long count = 0;
 	int ret = 0;
@@ -605,7 +605,7 @@ static int sgx_encl_debug_write(struct s
  */
 static struct sgx_encl_page *sgx_encl_reserve_page(struct sgx_encl *encl,
 						   unsigned long addr,
-						   unsigned long vm_flags)
+						   vm_flags_t vm_flags)
 {
 	struct sgx_encl_page *entry;
 
--- a/arch/x86/kernel/cpu/sgx/encl.h~mm-update-architecture-and-driver-code-to-use-vm_flags_t
+++ a/arch/x86/kernel/cpu/sgx/encl.h
@@ -101,7 +101,7 @@ static inline int sgx_encl_find(struct m
 }
 
 int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
-		     unsigned long end, unsigned long vm_flags);
+		     unsigned long end, vm_flags_t vm_flags);
 
 bool current_is_ksgxd(void);
 void sgx_encl_release(struct kref *ref);
--- a/tools/testing/vma/vma_internal.h~mm-update-architecture-and-driver-code-to-use-vm_flags_t
+++ a/tools/testing/vma/vma_internal.h
@@ -1220,7 +1220,7 @@ static inline void vma_set_page_prot(str
 	WRITE_ONCE(vma->vm_page_prot, vm_page_prot);
 }
 
-static inline bool arch_validate_flags(unsigned long)
+static inline bool arch_validate_flags(vm_flags_t)
 {
 	return true;
 }
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-missing-mm-workingsetc-file-to-mm-reclaim-section.patch
maintainers-add-missing-test-files-to-mm-gup-section.patch
maintainers-add-further-init-files-to-mm-init-block.patch
maintainers-add-hugetlb_cgroupc-to-hugetlb-section.patch
maintainers-add-stray-rmap-file-to-mm-rmap-section.patch
maintainers-add-memfd-shmem-quota-files-to-shmem-section.patch
maintainers-add-additional-mmap-related-files-to-mmap-section.patch
docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-use-per_vma-lock-for-madv_dontneed-fix.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon-fix.patch
mm-mremap-add-mremap_must_relocate_anon.patch
mm-mremap-add-mremap_relocate_anon-support-for-large-folios.patch
tools-uapi-update-copy-of-linux-mmanh-from-the-kernel-sources.patch
tools-testing-selftests-add-sys_mremap-helper-to-vm_utilh.patch
tools-testing-selftests-add-mremap-cases-that-merge-normally.patch
tools-testing-selftests-add-mremap_relocate_anon-merge-test-cases.patch
tools-testing-selftests-expand-mremap-tests-for-mremap_relocate_anon.patch
tools-testing-selftests-have-cow-self-test-use-mremap_relocate_anon.patch
tools-testing-selftests-test-relocate-anon-in-split-huge-page-test.patch
tools-testing-selftests-add-mremap_relocate_anon-fork-tests.patch
secretmem-remove-uses-of-struct-page-fix.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge.patch
mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument.patch
mm-update-core-kernel-code-to-use-vm_flags_t-consistently.patch
mm-update-architecture-and-driver-code-to-use-vm_flags_t.patch

