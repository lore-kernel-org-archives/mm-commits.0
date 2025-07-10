Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFEE2857F2
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126324; cv=none; b=DxXTurU7bIzOgd8dtoJexHT1s3zvAZMe7B6imd3/3fblD8I2LhguiEY2fq3v9ccjwf1s3Srx9p5cKTwcXpvGNaWIgyjLNpVWyVNLPgOPLeIJgvqhQR3Qd2OAIZqpqbH5X3h7kSpy6RwJBcO4400EANIBepTmbeT+q7J/IYeiJks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126324; c=relaxed/simple;
	bh=IG1EmYpd6SKHnljfLL8xz2pxLXDwmg6PeB3mYjLtyqk=;
	h=Date:To:From:Subject:Message-Id; b=l/k5G3mS2SZiYX419Zz3HFZ6Cm0TfVKjvoWFtWec5o69/jTBKcc8oelAwwQlPcYnd0pfW9i5wFaaTcJtPcK9jPO6z+MU3BoLqBhxhOigbO89EntnyGMUn0SE060LK1rrVrh8KgbwuwSkDCuM5xtQ/Z0Ejaa/nOwwDeE4dqNAUA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=po9jEOUA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="po9jEOUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87171C4CEE3;
	Thu, 10 Jul 2025 05:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126324;
	bh=IG1EmYpd6SKHnljfLL8xz2pxLXDwmg6PeB3mYjLtyqk=;
	h=Date:To:From:Subject:From;
	b=po9jEOUAiEQ3prCiwYLhbNtSlUdwAM/DTwxzaTt0e1LkCmzF+L/pM02Cf1NCE8iDe
	 6DKTYxBwB4bxt4G4xl9CxnaAgKDGhsRl+srxRXKF3avfC0fABQlIPKS3HbuC+T91fu
	 tdXz4Hrk6rQEaLBfoB14qV64UQZdi4XpTjvXOee8=
Date: Wed, 09 Jul 2025 22:45:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,rppt@kernel.org,pfalcato@suse.de,osalvador@suse.de,Liam.Howlett@oracle.com,kees@kernel.org,jarkko@kernel.org,jannh@google.com,jack@suse.cz,david@redhat.com,catalin.marinas@arm.com,brauner@kernel.org,anshuman.khandual@arm.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-update-architecture-and-driver-code-to-use-vm_flags_t.patch removed from -mm tree
Message-Id: <20250710054524.87171C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: update architecture and driver code to use vm_flags_t
has been removed from the -mm tree.  Its filename was
     mm-update-architecture-and-driver-code-to-use-vm_flags_t.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Christian Brauner <brauner@kernel.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>	[arm64]
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Jan Kara <jack@suse.cz>
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
@@ -1215,7 +1215,7 @@ static inline void vma_set_page_prot(str
 	WRITE_ONCE(vma->vm_page_prot, vm_page_prot);
 }
 
-static inline bool arch_validate_flags(unsigned long)
+static inline bool arch_validate_flags(vm_flags_t)
 {
 	return true;
 }
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-madvise-remove-the-visitor-pattern-and-thread-anon_vma-state.patch
mm-madvise-thread-mm_struct-through-madvise_behavior.patch
mm-madvise-thread-vma-range-state-through-madvise_behavior.patch
mm-madvise-thread-all-madvise-state-through-madv_behavior.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma-fix.patch
tools-testing-selftests-add-mremap-unfaulted-faulted-test-cases.patch
mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap-fix.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch

