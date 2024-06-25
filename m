Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1FA1411DE
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291571; cv=none; b=IKVIHdsx3zg4pinnl9DxE4lc/HfxHqy3e91MX1c1fwR86RJllMG9JkJZtjpzTf42fycvl8oarvMt8wVjuBgXk62GxQKPxKjHjCACOYV6omzb1U/T7D5FyoQeWUoEKzDn5SNoME8uqgpun14+kr3fxJd4cYu0TxCVJzDcyQS+Gyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291571; c=relaxed/simple;
	bh=fAbMMlFeHZSrlf1BvfzPGXK3f2nNt/WZMURhrM+KhMs=;
	h=Date:To:From:Subject:Message-Id; b=HB5Kv3iTtxItY2uAX2P5qEt6Q3T8gaX223BSvZjsev8pGz4x0yO8MMFjZyPCvz5xxQRfquPM2ryB5O59w/Lmb2/vOeYPOXO9fUXaulRr7xGbUASUJJeTn3OxzVlGzpaH69sA+czU4lklU92rmym+G9D2+25qmbHcwTAHQk4nYuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i+8V+2Ll; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i+8V+2Ll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D41C32789;
	Tue, 25 Jun 2024 04:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291570;
	bh=fAbMMlFeHZSrlf1BvfzPGXK3f2nNt/WZMURhrM+KhMs=;
	h=Date:To:From:Subject:From;
	b=i+8V+2LlOyKWgDAKNgdP1AmQDVyUl4+w/xbJ6lk5hrQ50cpu0i5o5mlgQUrK0KtE2
	 6ZVDsYzqu+xbHaQo8NxGGj+Pi9T2qKrr7FEO7YL7nlHP5iHiYnOPht4w3zVZ6SKzlo
	 5C/r5Oas6FSubjvaBEqdhKkRNiI72Q9nT/UQE3Ko=
Date: Mon, 24 Jun 2024 21:59:30 -0700
To: mm-commits@vger.kernel.org,tsbogend@alpha.franken.de,ryan.roberts@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,jcmvbkbc@gmail.com,ioworker0@gmail.com,david@redhat.com,chris@zankel.net,chenhuacai@kernel.org,libang.li@antgroup.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-update_mmu_tlb_range.patch removed from -mm tree
Message-Id: <20240625045930.D8D41C32789@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add update_mmu_tlb_range()
has been removed from the -mm tree.  Its filename was
     mm-add-update_mmu_tlb_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


