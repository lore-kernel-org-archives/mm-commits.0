Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DD114386D
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291572; cv=none; b=HnTVJjBkBAjUcVPGjDMMNwxOPuoS+YSIHw61Opvoa7T+2rTADnezngunrfNa+rgYuAQG8Aip5vCZa+exXED9LFVPNKzAFq2Xsf380egBzY5aSOj7mTMELS9Bjlqh9lERfn6KjK2RzxmiLzIYytMNgMH5iFlIaIH8wj+lO10RifE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291572; c=relaxed/simple;
	bh=ZMsRmyHzIDjOHbLYOGFj60IWNDANt4RV/YkGSQ92pag=;
	h=Date:To:From:Subject:Message-Id; b=oZHVAwpzH0LsiMgVaci2Tf/0OLjFOCcmOWDU+RZt/1wxjDJXw/1/BO5ICnJFbBu9cj7lWUySSJPiPeWcTdtAoTOh1ChBlQLD3Wfg+oGPtJlzbVYH86EFb+Y0WwQe63xHAtyl5wzbUCRk8fzP2/gtTK+5YVbl9npsJhW78i2aZ9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LQ665E2k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LQ665E2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E53C32782;
	Tue, 25 Jun 2024 04:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291572;
	bh=ZMsRmyHzIDjOHbLYOGFj60IWNDANt4RV/YkGSQ92pag=;
	h=Date:To:From:Subject:From;
	b=LQ665E2kF6g8HVtS4MG6BlrRwHSi+ajzqdec7Yt39x6lhWc97TFcr/iVf/ujkoZoI
	 dDrzn6vDaQEVZezFgXj/+5FFETdTuQu8e7Ok1zDsFM1BZghdIxuOW3yVFXc/smiDFC
	 r52vW+UsqsSK+5WriLiCdTPRip447joNPhCu9kp0=
Date: Mon, 24 Jun 2024 21:59:31 -0700
To: mm-commits@vger.kernel.org,tsbogend@alpha.franken.de,ryan.roberts@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,jcmvbkbc@gmail.com,ioworker0@gmail.com,david@redhat.com,chris@zankel.net,chenhuacai@kernel.org,libang.li@antgroup.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-implement-update_mmu_tlb-using-update_mmu_tlb_range.patch removed from -mm tree
Message-Id: <20240625045931.E7E53C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: implement update_mmu_tlb() using update_mmu_tlb_range()
has been removed from the -mm tree.  Its filename was
     mm-implement-update_mmu_tlb-using-update_mmu_tlb_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


