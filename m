Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E08283FEF
	for <mm-commits@vger.kernel.org>; Wed, 17 Dec 2025 18:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765995889; cv=none; b=XIa7AcsTI3ARggMv+5u8TpIHdF6nHOXrd0E/U0b+FuaTNLOi2i32MkponvxOTt91n0jFcdQ8lQCXKuRH6IkmWqbCWBRui8DdunBnyvja3Rxw7jPMFdm98djWltY9zQ4/C3+XxTF5sbgCq5YSkBtTuNqBn6DZvNYsu7VcHLuY2e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765995889; c=relaxed/simple;
	bh=ucZkwxPhXnwBcEAtUjIRlrg/F8nbGxxf+X/SPfJupsQ=;
	h=Date:To:From:Subject:Message-Id; b=ZV8X77XZxQpjcFj5Pw5LE18OF+jwhKhAxe/rnXy9Spv+w4pqAfMXFNTAfJnjcBoCTTcq7xOBzrpY7/L9F6K64ltN4hdx0BnBGO0GCMDp1zYbrv1a/jynKY3QSQIThSOBNMXt2//zMYaVu6jmKT8TKmAuR7WL26ZQzX0h8CUt5UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w9Xb+UvW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w9Xb+UvW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29508C4CEFB;
	Wed, 17 Dec 2025 18:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765995889;
	bh=ucZkwxPhXnwBcEAtUjIRlrg/F8nbGxxf+X/SPfJupsQ=;
	h=Date:To:From:Subject:From;
	b=w9Xb+UvWpci1zo/57u8QKEln0zA3mkX4f70qavnM3NRkAsiLIzh0BZAqzuk2BAi07
	 SYC1EQZPX0Xg2ztWtn7xl2JfkO9mQeTkGeEUnTDhp8qiUXPipdhVkk0wZDbnTLTbn7
	 4VuIKCdMZbAPGj9nuJywCL8AQl62Y2V8LjGFKdDU=
Date: Wed, 17 Dec 2025 10:24:48 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tsbogend@alpha.franken.de,richard@nod.at,richard.henderson@linaro.org,peterz@infradead.org,npiggin@gmail.com,mattst88@gmail.com,linmag7@gmail.com,kernel@xen0n.name,johannes@sipsolutions.net,James.Bottomley@HansenPartnership.com,ioworker0@gmail.com,dev.jain@arm.com,deller@gmx.de,david@kernel.org,chenhuacai@kernel.org,anton.ivanov@cambridgegreys.com,aneesh.kumar@kernel.org,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + loongarch-mm-enable-mmu_gather_rcu_table_free.patch added to mm-new branch
Message-Id: <20251217182449.29508C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: LoongArch: mm: enable MMU_GATHER_RCU_TABLE_FREE
has been added to the -mm mm-new branch.  Its filename is
     loongarch-mm-enable-mmu_gather_rcu_table_free.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/loongarch-mm-enable-mmu_gather_rcu_table_free.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: LoongArch: mm: enable MMU_GATHER_RCU_TABLE_FREE
Date: Wed, 17 Dec 2025 17:45:44 +0800

On a 64-bit system, madvise(MADV_DONTNEED) may cause a large number of
empty PTE page table pages (such as 100GB+).  To resolve this problem,
first enable MMU_GATHER_RCU_TABLE_FREE to prepare for enabling the
PT_RECLAIM feature, which resolves this problem.

Link: https://lkml.kernel.org/r/dae0a0b490e912273a62a49be9d92f470fbcaf04.1765963770.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/Kconfig               |    1 +
 arch/loongarch/include/asm/pgalloc.h |    7 +++----
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/loongarch/include/asm/pgalloc.h~loongarch-mm-enable-mmu_gather_rcu_table_free
+++ a/arch/loongarch/include/asm/pgalloc.h
@@ -55,8 +55,7 @@ static inline pte_t *pte_alloc_one_kerne
 	return pte;
 }
 
-#define __pte_free_tlb(tlb, pte, address)	\
-	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
+#define __pte_free_tlb(tlb, pte, address)	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 #ifndef __PAGETABLE_PMD_FOLDED
 
@@ -79,7 +78,7 @@ static inline pmd_t *pmd_alloc_one(struc
 	return pmd;
 }
 
-#define __pmd_free_tlb(tlb, x, addr)	pmd_free((tlb)->mm, x)
+#define __pmd_free_tlb(tlb, x, addr)	tlb_remove_ptdesc((tlb), virt_to_ptdesc(x))
 
 #endif
 
@@ -99,7 +98,7 @@ static inline pud_t *pud_alloc_one(struc
 	return pud;
 }
 
-#define __pud_free_tlb(tlb, x, addr)	pud_free((tlb)->mm, x)
+#define __pud_free_tlb(tlb, x, addr)	tlb_remove_ptdesc((tlb), virt_to_ptdesc(x))
 
 #endif /* __PAGETABLE_PUD_FOLDED */
 
--- a/arch/loongarch/Kconfig~loongarch-mm-enable-mmu_gather_rcu_table_free
+++ a/arch/loongarch/Kconfig
@@ -187,6 +187,7 @@ config LOONGARCH
 	select IRQ_LOONGARCH_CPU
 	select LOCK_MM_AND_FIND_VMA
 	select MMU_GATHER_MERGE_VMAS if MMU
+	select MMU_GATHER_RCU_TABLE_FREE
 	select MODULES_USE_ELF_RELA if MODULES
 	select NEED_PER_CPU_EMBED_FIRST_CHUNK
 	select NEED_PER_CPU_PAGE_FIRST_CHUNK
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-change-mm-pt_reclaimc-to-use-asm-tlbh-instead-of-asm-generic-tlbh.patch
alpha-mm-enable-mmu_gather_rcu_table_free.patch
loongarch-mm-enable-mmu_gather_rcu_table_free.patch
mips-mm-enable-mmu_gather_rcu_table_free.patch
parisc-mm-enable-mmu_gather_rcu_table_free.patch
um-mm-enable-mmu_gather_rcu_table_free.patch
mm-make-pt_reclaim-depends-on-mmu_gather_rcu_table_free.patch

