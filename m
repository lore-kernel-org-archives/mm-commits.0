Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CD1558BC;
	Wed,  6 Nov 2024 00:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854226; cv=none; b=gpxGxFXlevqp1R4IKgIiqLWqwowvr0GwHK6eTUUgWvIhjd1TVfJHUadI9WydNCDPcU65fyhyv0888adyUIeKZSUPtRVI2kgfQPwfSIyVPHTWVSQd71QF9cQerhEgsyi0lNytH0fWN54kJLtkIwy+iVFVD6cXr6tvW3UwB8bb35s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854226; c=relaxed/simple;
	bh=PpieqBXPS7+SvNF9kuiAi596AQanhftVc18JfiodU2k=;
	h=Date:To:From:Subject:Message-Id; b=ZskNYODiYexS7k2d0fXpuxDpozK69oyDfnRxmHOf1i2S0ioWyqoxyrILuo0ZNksaIDqId1M4T1Xw8gOWNewQTO4gl+eUmKu87SdYVylTi/BpnBAa3KfQgOhZT+0yBkuA5+gDWGlu2b1Im1D9XNawpKXkmg0Fw4Lgg5cSW6sAjak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LSGVCYFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LSGVCYFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3588C4CECF;
	Wed,  6 Nov 2024 00:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854226;
	bh=PpieqBXPS7+SvNF9kuiAi596AQanhftVc18JfiodU2k=;
	h=Date:To:From:Subject:From;
	b=LSGVCYFeO7TQIRvaB6KZ9S1jbty12p+W+Ih7kGYhwzxaLJ/ZgtdoFnBAyXawQFTGk
	 9kGjrqjscRpyOTqV5LcF9xxYE/q3+qtyxr/H+NtWPc/kOovYvJCwNQNmjXfKLsYrIa
	 KBpAwl6uf/OLmHzNj3YGPKQ3xgYeoh7VRlZKPJtA=
Date: Tue, 05 Nov 2024 16:50:25 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,torvalds@linux-foundation.org,stable@vger.kernel.org,peterx@redhat.com,Liam.Howlett@oracle.com,jannh@google.com,James.Bottomley@HansenPartnership.com,deller@gmx.de,davem@davemloft.net,catalin.marinas@arm.com,broonie@kernel.org,andreas@gaisler.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling.patch removed from -mm tree
Message-Id: <20241106005025.E3588C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: refactor arch_calc_vm_flag_bits() and arm64 MTE handling
has been removed from the -mm tree.  Its filename was
     mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: refactor arch_calc_vm_flag_bits() and arm64 MTE handling
Date: Tue, 29 Oct 2024 18:11:47 +0000

Currently MTE is permitted in two circumstances (desiring to use MTE
having been specified by the VM_MTE flag) - where MAP_ANONYMOUS is
specified, as checked by arch_calc_vm_flag_bits() and actualised by
setting the VM_MTE_ALLOWED flag, or if the file backing the mapping is
shmem, in which case we set VM_MTE_ALLOWED in shmem_mmap() when the mmap
hook is activated in mmap_region().

The function that checks that, if VM_MTE is set, VM_MTE_ALLOWED is also
set is the arm64 implementation of arch_validate_flags().

Unfortunately, we intend to refactor mmap_region() to perform this check
earlier, meaning that in the case of a shmem backing we will not have
invoked shmem_mmap() yet, causing the mapping to fail spuriously.

It is inappropriate to set this architecture-specific flag in general mm
code anyway, so a sensible resolution of this issue is to instead move the
check somewhere else.

We resolve this by setting VM_MTE_ALLOWED much earlier in do_mmap(), via
the arch_calc_vm_flag_bits() call.

This is an appropriate place to do this as we already check for the
MAP_ANONYMOUS case here, and the shmem file case is simply a variant of
the same idea - we permit RAM-backed memory.

This requires a modification to the arch_calc_vm_flag_bits() signature to
pass in a pointer to the struct file associated with the mapping, however
this is not too egregious as this is only used by two architectures anyway
- arm64 and parisc.

So this patch performs this adjustment and removes the unnecessary
assignment of VM_MTE_ALLOWED in shmem_mmap().

[akpm@linux-foundation.org: fix whitespace, per Catalin]
Link: https://lkml.kernel.org/r/ec251b20ba1964fb64cf1607d2ad80c47f3873df.1730224667.git.lorenzo.stoakes@oracle.com
Fixes: deb0f6562884 ("mm/mmap: undo ->mmap() when arch_validate_flags() fails")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Jann Horn <jannh@google.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Helge Deller <deller@gmx.de>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/mman.h  |   10 +++++++---
 arch/parisc/include/asm/mman.h |    5 +++--
 include/linux/mman.h           |    7 ++++---
 mm/mmap.c                      |    2 +-
 mm/nommu.c                     |    2 +-
 mm/shmem.c                     |    3 ---
 6 files changed, 16 insertions(+), 13 deletions(-)

--- a/arch/arm64/include/asm/mman.h~mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling
+++ a/arch/arm64/include/asm/mman.h
@@ -6,6 +6,8 @@
 
 #ifndef BUILD_VDSO
 #include <linux/compiler.h>
+#include <linux/fs.h>
+#include <linux/shmem_fs.h>
 #include <linux/types.h>
 
 static inline unsigned long arch_calc_vm_prot_bits(unsigned long prot,
@@ -31,19 +33,21 @@ static inline unsigned long arch_calc_vm
 }
 #define arch_calc_vm_prot_bits(prot, pkey) arch_calc_vm_prot_bits(prot, pkey)
 
-static inline unsigned long arch_calc_vm_flag_bits(unsigned long flags)
+static inline unsigned long arch_calc_vm_flag_bits(struct file *file,
+						   unsigned long flags)
 {
 	/*
 	 * Only allow MTE on anonymous mappings as these are guaranteed to be
 	 * backed by tags-capable memory. The vm_flags may be overridden by a
 	 * filesystem supporting MTE (RAM-based).
 	 */
-	if (system_supports_mte() && (flags & MAP_ANONYMOUS))
+	if (system_supports_mte() &&
+	    ((flags & MAP_ANONYMOUS) || shmem_file(file)))
 		return VM_MTE_ALLOWED;
 
 	return 0;
 }
-#define arch_calc_vm_flag_bits(flags) arch_calc_vm_flag_bits(flags)
+#define arch_calc_vm_flag_bits(file, flags) arch_calc_vm_flag_bits(file, flags)
 
 static inline bool arch_validate_prot(unsigned long prot,
 	unsigned long addr __always_unused)
--- a/arch/parisc/include/asm/mman.h~mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling
+++ a/arch/parisc/include/asm/mman.h
@@ -2,6 +2,7 @@
 #ifndef __ASM_MMAN_H__
 #define __ASM_MMAN_H__
 
+#include <linux/fs.h>
 #include <uapi/asm/mman.h>
 
 /* PARISC cannot allow mdwe as it needs writable stacks */
@@ -11,7 +12,7 @@ static inline bool arch_memory_deny_writ
 }
 #define arch_memory_deny_write_exec_supported arch_memory_deny_write_exec_supported
 
-static inline unsigned long arch_calc_vm_flag_bits(unsigned long flags)
+static inline unsigned long arch_calc_vm_flag_bits(struct file *file, unsigned long flags)
 {
 	/*
 	 * The stack on parisc grows upwards, so if userspace requests memory
@@ -23,6 +24,6 @@ static inline unsigned long arch_calc_vm
 
 	return 0;
 }
-#define arch_calc_vm_flag_bits(flags) arch_calc_vm_flag_bits(flags)
+#define arch_calc_vm_flag_bits(file, flags) arch_calc_vm_flag_bits(file, flags)
 
 #endif /* __ASM_MMAN_H__ */
--- a/include/linux/mman.h~mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling
+++ a/include/linux/mman.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_MMAN_H
 #define _LINUX_MMAN_H
 
+#include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/percpu_counter.h>
 
@@ -94,7 +95,7 @@ static inline void vm_unacct_memory(long
 #endif
 
 #ifndef arch_calc_vm_flag_bits
-#define arch_calc_vm_flag_bits(flags) 0
+#define arch_calc_vm_flag_bits(file, flags) 0
 #endif
 
 #ifndef arch_validate_prot
@@ -151,13 +152,13 @@ calc_vm_prot_bits(unsigned long prot, un
  * Combine the mmap "flags" argument into "vm_flags" used internally.
  */
 static inline unsigned long
-calc_vm_flag_bits(unsigned long flags)
+calc_vm_flag_bits(struct file *file, unsigned long flags)
 {
 	return _calc_vm_trans(flags, MAP_GROWSDOWN,  VM_GROWSDOWN ) |
 	       _calc_vm_trans(flags, MAP_LOCKED,     VM_LOCKED    ) |
 	       _calc_vm_trans(flags, MAP_SYNC,	     VM_SYNC      ) |
 	       _calc_vm_trans(flags, MAP_STACK,	     VM_NOHUGEPAGE) |
-	       arch_calc_vm_flag_bits(flags);
+	       arch_calc_vm_flag_bits(file, flags);
 }
 
 unsigned long vm_commit_limit(void);
--- a/mm/mmap.c~mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling
+++ a/mm/mmap.c
@@ -344,7 +344,7 @@ unsigned long do_mmap(struct file *file,
 	 * to. we assume access permissions have been handled by the open
 	 * of the memory object, so we don't do any here.
 	 */
-	vm_flags |= calc_vm_prot_bits(prot, pkey) | calc_vm_flag_bits(flags) |
+	vm_flags |= calc_vm_prot_bits(prot, pkey) | calc_vm_flag_bits(file, flags) |
 			mm->def_flags | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC;
 
 	/* Obtain the address to map to. we verify (or select) it and ensure
--- a/mm/nommu.c~mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling
+++ a/mm/nommu.c
@@ -842,7 +842,7 @@ static unsigned long determine_vm_flags(
 {
 	unsigned long vm_flags;
 
-	vm_flags = calc_vm_prot_bits(prot, 0) | calc_vm_flag_bits(flags);
+	vm_flags = calc_vm_prot_bits(prot, 0) | calc_vm_flag_bits(file, flags);
 
 	if (!file) {
 		/*
--- a/mm/shmem.c~mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling
+++ a/mm/shmem.c
@@ -2733,9 +2733,6 @@ static int shmem_mmap(struct file *file,
 	if (ret)
 		return ret;
 
-	/* arm64 - allow memory tagging on RAM-based files */
-	vm_flags_set(vma, VM_MTE_ALLOWED);
-
 	file_accessed(file);
 	/* This is anonymous shared memory if it is unlinked at the time of mmap */
 	if (inode->i_nlink)
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-refactor-mm_access-to-not-return-null.patch
mm-madvise-unrestrict-process_madvise-for-current-process.patch
maple_tree-do-not-hash-pointers-on-dump-in-debug-mode.patch
tools-testing-fix-phys_addr_t-size-on-64-bit-systems.patch
tools-testing-add-additional-vma_internalh-stubs.patch
mm-isolate-mmap-internal-logic-to-mm-vmac.patch
mm-refactor-__mmap_region.patch
mm-remove-unnecessary-reset-state-logic-on-merge-new-vma.patch
mm-defer-second-attempt-at-merge-on-mmap.patch
mm-pagewalk-add-the-ability-to-install-ptes.patch
mm-add-pte_marker_guard-pte-marker.patch
mm-madvise-implement-lightweight-guard-page-mechanism.patch
tools-testing-update-tools-uapi-header-for-mman-commonh.patch
selftests-mm-add-self-tests-for-guard-page-feature.patch
mm-remove-unnecessary-page_table_lock-on-stack-expansion.patch

