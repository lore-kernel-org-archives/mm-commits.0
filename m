Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E884C1C548C
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837116; cv=none; b=Vmn4rG7hRIYg7TE501oceLy1EM9nd8v/Dsi0uuyKgATAc3wcgy6+BqMOExEgW+VG7PwVgsbfX7yVUsCtlLckZED3Vjdi6yYgZuYN1ksepJardjBLE0rem6SHErHEC99k7qEovhOLkG0yamPoWv0vMtPq5YtF2bWAnDsr4Qh4Y1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837116; c=relaxed/simple;
	bh=M9UW6PYQ2pND+Ef80zb3jQIscyZvvO31YbsSzAd8hdM=;
	h=Date:To:From:Subject:Message-Id; b=VcHMf2Ob6Jd84SDs1fo9GfJTPWGWDBmnOpxcuA1+7QtGK+2yYah2TsE5hgPu7lb1qqMBkhcYOP/BXMCnUewGW8hO1SxIRoq9QHhdobSnjuQKVxXtHLDIJ7cU3FWP9njW2S4E6UAKqHSVqaiIfwxGYB4s5lMecbcW37zptmU56yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PDq8Ubjc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PDq8Ubjc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6895DC4CEDD;
	Tue, 14 Jan 2025 06:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837115;
	bh=M9UW6PYQ2pND+Ef80zb3jQIscyZvvO31YbsSzAd8hdM=;
	h=Date:To:From:Subject:From;
	b=PDq8UbjcaO1bD5qMQJHIqFAa2qkFKIoXUrqdqSA0JRxAKoxHvQ7PnYvV/NVPawo7d
	 P5vui24ubOFMDEy9LgDzW57XopkRI/IT8icvgIMtSd4yegzYQUbKRIACaYDQ3/iSRh
	 a7vyllIwCfqsncibf5kzeLrCs1ErYHl2P1s2UDOc=
Date: Mon, 13 Jan 2025 22:45:14 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,will@kernel.org,vishal.moola@gmail.com,tglx@linutronix.de,ryan.roberts@arm.com,rppt@kernel.org,rientjes@google.com,peterz@infradead.org,palmer@dabbelt.com,npiggin@gmail.com,muchun.song@linux.dev,lorenzo.stoakes@oracle.com,kevin.brodsky@arm.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,arnd@arndb.de,aneesh.kumar@kernel.org,andreas@gaisler.com,alexghiti@rivosinc.com,alex@ghiti.fr,agordeev@linux.ibm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-pgtable-use-mmu-gather-to-free-p4d-level-page-table.patch removed from -mm tree
Message-Id: <20250114064515.6895DC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: pgtable: use mmu gather to free p4d level page table
has been removed from the -mm tree.  Its filename was
     arm64-pgtable-use-mmu-gather-to-free-p4d-level-page-table.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: arm64: pgtable: use mmu gather to free p4d level page table
Date: Wed, 8 Jan 2025 14:57:21 +0800

Like other levels of page tables, also use mmu gather mechanism to free
p4d level page table.

Link: https://lkml.kernel.org/r/3fd48525397b34a64f7c0eb76746da30814dc941.1736317725.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Originally-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgalloc.h |    1 -
 arch/arm64/include/asm/tlb.h     |   14 ++++++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

--- a/arch/arm64/include/asm/pgalloc.h~arm64-pgtable-use-mmu-gather-to-free-p4d-level-page-table
+++ a/arch/arm64/include/asm/pgalloc.h
@@ -85,7 +85,6 @@ static inline void pgd_populate(struct m
 	__pgd_populate(pgdp, __pa(p4dp), pgdval);
 }
 
-#define __p4d_free_tlb(tlb, p4d, addr)  p4d_free((tlb)->mm, p4d)
 #else
 static inline void __pgd_populate(pgd_t *pgdp, phys_addr_t p4dp, pgdval_t prot)
 {
--- a/arch/arm64/include/asm/tlb.h~arm64-pgtable-use-mmu-gather-to-free-p4d-level-page-table
+++ a/arch/arm64/include/asm/tlb.h
@@ -111,4 +111,18 @@ static inline void __pud_free_tlb(struct
 }
 #endif
 
+#if CONFIG_PGTABLE_LEVELS > 4
+static inline void __p4d_free_tlb(struct mmu_gather *tlb, p4d_t *p4dp,
+				  unsigned long addr)
+{
+	struct ptdesc *ptdesc = virt_to_ptdesc(p4dp);
+
+	if (!pgtable_l5_enabled())
+		return;
+
+	pagetable_p4d_dtor(ptdesc);
+	tlb_remove_ptdesc(tlb, ptdesc);
+}
+#endif
+
 #endif
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


