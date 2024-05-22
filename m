Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414E8182B9
	for <mm-commits@vger.kernel.org>; Wed, 22 May 2024 18:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716400843; cv=none; b=t1TTCb17Hf/qbPpIrQh9gEzOT9rq7JGNit9CijAiF3IB9T2n9PpwQShVERqvZVR2k6lts/uBlt7hXhUMfo1VzB8Q6+KZg2UZ2yQWyINK2es/eiag/qNfdNvhxiqgjCJJKN3yQrDMtUsGOsG1fMBzvNlC8P4vEDeQ7879bmy/xFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716400843; c=relaxed/simple;
	bh=B2Cz7OsJ4UT6ceu+1FF4WUDPdUX7hj1vq0G1bC3+Uss=;
	h=Date:To:From:Subject:Message-Id; b=fuLYa9ent3qbdNfNqjYKatUan+2K8lND08ceyvGI0tRFyFjsXjD7//13nTwnW0tB6WwfM4BCLlYRimLDx6IbB81tkwv4csUsrI5E6LozlGGQFMZBQnajecITWJRwCDC3dHBPHC3rAXugSY3zyoqOyc6/8JRH7E/6fZT3GjdQ8dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RJX8oIpG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RJX8oIpG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF464C2BBFC;
	Wed, 22 May 2024 18:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716400842;
	bh=B2Cz7OsJ4UT6ceu+1FF4WUDPdUX7hj1vq0G1bC3+Uss=;
	h=Date:To:From:Subject:From;
	b=RJX8oIpGTzZsQFfq65aAiXniq3lxyTGQBjFw4czcgYFlV7atACmeas7hlqBhhZS1q
	 TDRp0HdMFKnFRyV02+GvntdHmG+o0H7TMBNs78FZXVfGPDgcD3kBRrEbKKb7T/2FZM
	 d/CxJb8zGjClUXuIDitZTgjqFLFJ7QoNm56Q9Ycg=
Date: Wed, 22 May 2024 11:00:42 -0700
To: mm-commits@vger.kernel.org,tsbogend@alpha.franken.de,ryan.roberts@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,jcmvbkbc@gmail.com,ioworker0@gmail.com,david@redhat.com,chris@zankel.net,chenhuacai@kernel.org,libang.li@antgroup.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-implement-update_mmu_tlb-using-update_mmu_tlb_range.patch added to mm-unstable branch
Message-Id: <20240522180042.BF464C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: implement update_mmu_tlb() using update_mmu_tlb_range()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-implement-update_mmu_tlb-using-update_mmu_tlb_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-implement-update_mmu_tlb-using-update_mmu_tlb_range.patch

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
Subject: mm: implement update_mmu_tlb() using update_mmu_tlb_range()
Date: Wed, 22 May 2024 14:12:03 +0800

Let's make update_mmu_tlb() simply a generic wrapper around
update_mmu_tlb_range().  Only the latter can now be overridden by the
architecture.  We can now remove __HAVE_ARCH_UPDATE_MMU_TLB as well.

Link: https://lkml.kernel.org/r/20240522061204.117421-3-libang.li@antgroup.com
Signed-off-by: Bang Li <libang.li@antgroup.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/include/asm/pgtable.h |    2 --
 arch/mips/include/asm/pgtable.h      |    2 --
 arch/riscv/include/asm/pgtable.h     |    2 --
 arch/xtensa/include/asm/pgtable.h    |    3 ---
 arch/xtensa/mm/tlb.c                 |    6 ------
 include/linux/pgtable.h              |    4 +---
 6 files changed, 1 insertion(+), 18 deletions(-)

--- a/arch/loongarch/include/asm/pgtable.h~mm-implement-update_mmu_tlb-using-update_mmu_tlb_range
+++ a/arch/loongarch/include/asm/pgtable.h
@@ -467,8 +467,6 @@ static inline void update_mmu_cache_rang
 #define update_mmu_cache(vma, addr, ptep) \
 	update_mmu_cache_range(NULL, vma, addr, ptep, 1)
 
-#define __HAVE_ARCH_UPDATE_MMU_TLB
-#define update_mmu_tlb	update_mmu_cache
 #define update_mmu_tlb_range(vma, addr, ptep, nr) \
 	update_mmu_cache_range(NULL, vma, addr, ptep, nr)
 
--- a/arch/mips/include/asm/pgtable.h~mm-implement-update_mmu_tlb-using-update_mmu_tlb_range
+++ a/arch/mips/include/asm/pgtable.h
@@ -594,8 +594,6 @@ static inline void update_mmu_cache_rang
 #define update_mmu_cache(vma, address, ptep) \
 	update_mmu_cache_range(NULL, vma, address, ptep, 1)
 
-#define	__HAVE_ARCH_UPDATE_MMU_TLB
-#define update_mmu_tlb	update_mmu_cache
 #define update_mmu_tlb_range(vma, address, ptep, nr) \
 	update_mmu_cache_range(NULL, vma, address, ptep, nr)
 
--- a/arch/riscv/include/asm/pgtable.h~mm-implement-update_mmu_tlb-using-update_mmu_tlb_range
+++ a/arch/riscv/include/asm/pgtable.h
@@ -489,8 +489,6 @@ static inline void update_mmu_cache_rang
 #define update_mmu_cache(vma, addr, ptep) \
 	update_mmu_cache_range(NULL, vma, addr, ptep, 1)
 
-#define __HAVE_ARCH_UPDATE_MMU_TLB
-#define update_mmu_tlb update_mmu_cache
 #define update_mmu_tlb_range(vma, addr, ptep, nr) \
 	update_mmu_cache_range(NULL, vma, addr, ptep, nr)
 
--- a/arch/xtensa/include/asm/pgtable.h~mm-implement-update_mmu_tlb-using-update_mmu_tlb_range
+++ a/arch/xtensa/include/asm/pgtable.h
@@ -410,9 +410,6 @@ void update_mmu_cache_range(struct vm_fa
 
 typedef pte_t *pte_addr_t;
 
-void update_mmu_tlb(struct vm_area_struct *vma,
-		    unsigned long address, pte_t *ptep);
-#define __HAVE_ARCH_UPDATE_MMU_TLB
 void update_mmu_tlb_range(struct vm_area_struct *vma,
 		unsigned long address, pte_t *ptep, unsigned int nr);
 #define update_mmu_tlb_range update_mmu_tlb_range
--- a/arch/xtensa/mm/tlb.c~mm-implement-update_mmu_tlb-using-update_mmu_tlb_range
+++ a/arch/xtensa/mm/tlb.c
@@ -163,12 +163,6 @@ void local_flush_tlb_kernel_range(unsign
 	}
 }
 
-void update_mmu_tlb(struct vm_area_struct *vma,
-		    unsigned long address, pte_t *ptep)
-{
-	local_flush_tlb_page(vma, address);
-}
-
 void update_mmu_tlb_range(struct vm_area_struct *vma,
 			unsigned long address, pte_t *ptep, unsigned int nr)
 {
--- a/include/linux/pgtable.h~mm-implement-update_mmu_tlb-using-update_mmu_tlb_range
+++ a/include/linux/pgtable.h
@@ -736,13 +736,11 @@ static inline void update_mmu_tlb_range(
 }
 #endif
 
-#ifndef __HAVE_ARCH_UPDATE_MMU_TLB
 static inline void update_mmu_tlb(struct vm_area_struct *vma,
 				unsigned long address, pte_t *ptep)
 {
+	update_mmu_tlb_range(vma, address, ptep, 1);
 }
-#define __HAVE_ARCH_UPDATE_MMU_TLB
-#endif
 
 /*
  * Some architectures may be able to avoid expensive synchronization
_

Patches currently in -mm which might be from libang.li@antgroup.com are

mm-add-update_mmu_tlb_range.patch
mm-implement-update_mmu_tlb-using-update_mmu_tlb_range.patch
mm-use-update_mmu_tlb_range-to-simplify-code.patch

