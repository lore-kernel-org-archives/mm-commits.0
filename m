Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70607182B9
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 18:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716400839; cv=none; b=aQizNzozl4b+TjRw0hilG16DEjIxFtEUgZ4a/CBUwFwS/vUwFxMwwYTHxFlfg/KECjwp0husynPz0zaLsV+A9tOs35O4Iq/lg+XUrjSE1kK8BISvGphO+/rkLrLkM9q0I+HThvWSwtjtDRIqNl93KQWl8JalNxwfdwxVVCzYE6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716400839; c=relaxed/simple;
	bh=h9QZmvpy84zJA333yZXgdP1cIGTewJIPuPzrCMtGqlg=;
	h=Date:To:From:Subject:Message-Id; b=YZPMARrUN5w5Lg+YTbXOibak4epKXYJU4P3i1M+6MIRlCq2p9QPKnUkartu0EOXKjTqeI1+Xf7y/xb04qZ6KRVakLN3XsSK9QOZfd8xtI88SG1txILtlpwQyjJfGUwj4WY3Ny7ExcQ4fn8Icne6PFnxZ8O7vEMvmzVHEEfYwkV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rH27rNoV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rH27rNoV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86ADC3277B;
	Wed, 22 May 2024 18:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716400839;
	bh=h9QZmvpy84zJA333yZXgdP1cIGTewJIPuPzrCMtGqlg=;
	h=Date:To:From:Subject:From;
	b=rH27rNoVR7ipoS7PWZl4cAPhEeAK7/1hJ1a/upw5kzUbzacRK5uNfka1ZSyll4tff
	 VrihLSHgDjoLgvPcWzKZPDTATpfXwmGXVUfkHGZEpvlrGMhI3Psb/cp7V/X/gEiOJi
	 f03oGlgJhdJFIVMNKisQNgvfxlDv2P57wFh2R8H8=
Date: Wed, 22 May 2024 11:00:36 -0700
To: mm-commits@vger.kernel.org,tsbogend@alpha.franken.de,ryan.roberts@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,jcmvbkbc@gmail.com,ioworker0@gmail.com,david@redhat.com,chris@zankel.net,chenhuacai@kernel.org,libang.li@antgroup.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-update_mmu_tlb_range.patch added to mm-unstable branch
Message-Id: <20240522180038.E86ADC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add update_mmu_tlb_range()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-update_mmu_tlb_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-update_mmu_tlb_range.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Bang Li" <libang.li@antgroup.com>
Subject: mm: add update_mmu_tlb_range()
Date: Wed, 22 May 2024 14:12:02 +0800

Patch series "Add update_mmu_tlb_range() to simplify code", v4.

This series of commits mainly adds the update_mmu_tlb_range() to batch
update tlb in an address range and implement update_mmu_tlb() using
update_mmu_tlb_range().

After commit 19eaf44954df ("mm: thp: support allocation of anonymous
multi-size THP"), We may need to batch update tlb of a certain address
range by calling update_mmu_tlb() in a loop.  Using the
update_mmu_tlb_range(), we can simplify the code and possibly reduce the
execution of some unnecessary code in some architectures.


This patch (of 3):

Add update_mmu_tlb_range(), we can batch update tlb of an address range.

Link: https://lkml.kernel.org/r/20240522061204.117421-1-libang.li@antgroup.com
Link: https://lkml.kernel.org/r/20240522061204.117421-2-libang.li@antgroup.com
Signed-off-by: Bang Li <libang.li@antgroup.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/include/asm/pgtable.h |    2 ++
 arch/mips/include/asm/pgtable.h      |    2 ++
 arch/riscv/include/asm/pgtable.h     |    2 ++
 arch/xtensa/include/asm/pgtable.h    |    3 +++
 arch/xtensa/mm/tlb.c                 |    6 ++++++
 include/linux/pgtable.h              |    7 +++++++
 6 files changed, 22 insertions(+)

--- a/arch/loongarch/include/asm/pgtable.h~mm-add-update_mmu_tlb_range
+++ a/arch/loongarch/include/asm/pgtable.h
@@ -469,6 +469,8 @@ static inline void update_mmu_cache_rang
 
 #define __HAVE_ARCH_UPDATE_MMU_TLB
 #define update_mmu_tlb	update_mmu_cache
+#define update_mmu_tlb_range(vma, addr, ptep, nr) \
+	update_mmu_cache_range(NULL, vma, addr, ptep, nr)
 
 static inline void update_mmu_cache_pmd(struct vm_area_struct *vma,
 			unsigned long address, pmd_t *pmdp)
--- a/arch/mips/include/asm/pgtable.h~mm-add-update_mmu_tlb_range
+++ a/arch/mips/include/asm/pgtable.h
@@ -596,6 +596,8 @@ static inline void update_mmu_cache_rang
 
 #define	__HAVE_ARCH_UPDATE_MMU_TLB
 #define update_mmu_tlb	update_mmu_cache
+#define update_mmu_tlb_range(vma, address, ptep, nr) \
+	update_mmu_cache_range(NULL, vma, address, ptep, nr)
 
 static inline void update_mmu_cache_pmd(struct vm_area_struct *vma,
 	unsigned long address, pmd_t *pmdp)
--- a/arch/riscv/include/asm/pgtable.h~mm-add-update_mmu_tlb_range
+++ a/arch/riscv/include/asm/pgtable.h
@@ -491,6 +491,8 @@ static inline void update_mmu_cache_rang
 
 #define __HAVE_ARCH_UPDATE_MMU_TLB
 #define update_mmu_tlb update_mmu_cache
+#define update_mmu_tlb_range(vma, addr, ptep, nr) \
+	update_mmu_cache_range(NULL, vma, addr, ptep, nr)
 
 static inline void update_mmu_cache_pmd(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmdp)
--- a/arch/xtensa/include/asm/pgtable.h~mm-add-update_mmu_tlb_range
+++ a/arch/xtensa/include/asm/pgtable.h
@@ -413,6 +413,9 @@ typedef pte_t *pte_addr_t;
 void update_mmu_tlb(struct vm_area_struct *vma,
 		    unsigned long address, pte_t *ptep);
 #define __HAVE_ARCH_UPDATE_MMU_TLB
+void update_mmu_tlb_range(struct vm_area_struct *vma,
+		unsigned long address, pte_t *ptep, unsigned int nr);
+#define update_mmu_tlb_range update_mmu_tlb_range
 
 #endif /* !defined (__ASSEMBLY__) */
 
--- a/arch/xtensa/mm/tlb.c~mm-add-update_mmu_tlb_range
+++ a/arch/xtensa/mm/tlb.c
@@ -169,6 +169,12 @@ void update_mmu_tlb(struct vm_area_struc
 	local_flush_tlb_page(vma, address);
 }
 
+void update_mmu_tlb_range(struct vm_area_struct *vma,
+			unsigned long address, pte_t *ptep, unsigned int nr)
+{
+	local_flush_tlb_range(vma, address, address + PAGE_SIZE * nr);
+}
+
 #ifdef CONFIG_DEBUG_TLB_SANITY
 
 static unsigned get_pte_for_vaddr(unsigned vaddr)
--- a/include/linux/pgtable.h~mm-add-update_mmu_tlb_range
+++ a/include/linux/pgtable.h
@@ -729,6 +729,13 @@ static inline void clear_full_ptes(struc
  * fault. This function updates TLB only, do nothing with cache or others.
  * It is the difference with function update_mmu_cache.
  */
+#ifndef update_mmu_tlb_range
+static inline void update_mmu_tlb_range(struct vm_area_struct *vma,
+				unsigned long address, pte_t *ptep, unsigned int nr)
+{
+}
+#endif
+
 #ifndef __HAVE_ARCH_UPDATE_MMU_TLB
 static inline void update_mmu_tlb(struct vm_area_struct *vma,
 				unsigned long address, pte_t *ptep)
_

Patches currently in -mm which might be from libang.li@antgroup.com are

mm-add-update_mmu_tlb_range.patch
mm-implement-update_mmu_tlb-using-update_mmu_tlb_range.patch
mm-use-update_mmu_tlb_range-to-simplify-code.patch

