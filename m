Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DEF71733
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644491; cv=none; b=IkUHTpxxzi8wjAeTh0qD7RDAKg2/V9LlHhpzxu/5HJq3Cebbhr/8NYbss6/az+5DaeIgORZ+0JDtEizIsHJUQu+wqrhpGTXShr0VZTGgdaoL2WeBOtErAp7IFvkHFL3/xxjY1+I7V6fGRbxfflxXroSFqJgL8Fkz6/100S1SVrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644491; c=relaxed/simple;
	bh=4gb0jh0xOBT0C96bDam46TV+uH6VuEGi0KBnNTsncFc=;
	h=Date:To:From:Subject:Message-Id; b=S4vssFWgdA3KFdU5kP1iyqqdar7P4jNRi3uNwJ8SD1r3+mXCaKBdoyZkqlFinJ3xEw9v8Coiet27RdNqPAoIpdF/xVk1lXi3aPKOYP3xPquRgF38zg6Ogk5dTvd0sP7tlNco2iPgxcphSjdMaOepnicFVOrkzJqORRxGNqMzUQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P9igiPBq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P9igiPBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF7AC433C7;
	Thu, 22 Feb 2024 23:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644491;
	bh=4gb0jh0xOBT0C96bDam46TV+uH6VuEGi0KBnNTsncFc=;
	h=Date:To:From:Subject:From;
	b=P9igiPBqKYhJBCM5zEoj46FUzBw4ARdhBq7G1ncfa+JtdLRMSvoKhDO4L8xSFw+Qk
	 ozsMkgkMjWvqnLsyW7oE9ghaNSQZzoo2Gf0E1LDdUu7AdHBUUUH89u0aKC3DCWc9mZ
	 2M+YSg1UHwa/yphTT+KVeACuy/oFVDrlnW3H3IY8=
Date: Thu, 22 Feb 2024 15:28:10 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,james.morse@arm.com,hpa@zytor.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,apopple@nvidia.com,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mm-convert-set_pte_at-to-set_ptes-1.patch removed from -mm tree
Message-Id: <20240222232811.0FF7AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64/mm: convert set_pte_at() to set_ptes(..., 1)
has been removed from the -mm tree.  Its filename was
     arm64-mm-convert-set_pte_at-to-set_ptes-1.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: arm64/mm: convert set_pte_at() to set_ptes(..., 1)
Date: Thu, 15 Feb 2024 10:31:55 +0000

Since set_ptes() was introduced, set_pte_at() has been implemented as a
generic macro around set_ptes(..., 1).  So this change should continue to
generate the same code.  However, making this change prepares us for the
transparent contpte support.  It means we can reroute set_ptes() to
__set_ptes().  Since set_pte_at() is a generic macro, there will be no
equivalent __set_pte_at() to reroute to.

Note that a couple of calls to set_pte_at() remain in the arch code.  This
is intentional, since those call sites are acting on behalf of core-mm and
should continue to call into the public set_ptes() rather than the
arch-private __set_ptes().

Link: https://lkml.kernel.org/r/20240215103205.2607016-9-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Morse <james.morse@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |    2 +-
 arch/arm64/kernel/mte.c          |    2 +-
 arch/arm64/kvm/guest.c           |    2 +-
 arch/arm64/mm/fault.c            |    2 +-
 arch/arm64/mm/hugetlbpage.c      |   10 +++++-----
 5 files changed, 9 insertions(+), 9 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~arm64-mm-convert-set_pte_at-to-set_ptes-1
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1084,7 +1084,7 @@ static inline void arch_swap_restore(swp
 #endif /* CONFIG_ARM64_MTE */
 
 /*
- * On AArch64, the cache coherency is handled via the set_pte_at() function.
+ * On AArch64, the cache coherency is handled via the set_ptes() function.
  */
 static inline void update_mmu_cache_range(struct vm_fault *vmf,
 		struct vm_area_struct *vma, unsigned long addr, pte_t *ptep,
--- a/arch/arm64/kernel/mte.c~arm64-mm-convert-set_pte_at-to-set_ptes-1
+++ a/arch/arm64/kernel/mte.c
@@ -67,7 +67,7 @@ int memcmp_pages(struct page *page1, str
 	/*
 	 * If the page content is identical but at least one of the pages is
 	 * tagged, return non-zero to avoid KSM merging. If only one of the
-	 * pages is tagged, set_pte_at() may zero or change the tags of the
+	 * pages is tagged, set_ptes() may zero or change the tags of the
 	 * other page via mte_sync_tags().
 	 */
 	if (page_mte_tagged(page1) || page_mte_tagged(page2))
--- a/arch/arm64/kvm/guest.c~arm64-mm-convert-set_pte_at-to-set_ptes-1
+++ a/arch/arm64/kvm/guest.c
@@ -1072,7 +1072,7 @@ int kvm_vm_ioctl_mte_copy_tags(struct kv
 		} else {
 			/*
 			 * Only locking to serialise with a concurrent
-			 * set_pte_at() in the VMM but still overriding the
+			 * set_ptes() in the VMM but still overriding the
 			 * tags, hence ignoring the return value.
 			 */
 			try_page_mte_tagging(page);
--- a/arch/arm64/mm/fault.c~arm64-mm-convert-set_pte_at-to-set_ptes-1
+++ a/arch/arm64/mm/fault.c
@@ -205,7 +205,7 @@ static void show_pte(unsigned long addr)
  *
  * It needs to cope with hardware update of the accessed/dirty state by other
  * agents in the system and can safely skip the __sync_icache_dcache() call as,
- * like set_pte_at(), the PTE is never changed from no-exec to exec here.
+ * like set_ptes(), the PTE is never changed from no-exec to exec here.
  *
  * Returns whether or not the PTE actually changed.
  */
--- a/arch/arm64/mm/hugetlbpage.c~arm64-mm-convert-set_pte_at-to-set_ptes-1
+++ a/arch/arm64/mm/hugetlbpage.c
@@ -247,12 +247,12 @@ void set_huge_pte_at(struct mm_struct *m
 
 	if (!pte_present(pte)) {
 		for (i = 0; i < ncontig; i++, ptep++, addr += pgsize)
-			set_pte_at(mm, addr, ptep, pte);
+			set_ptes(mm, addr, ptep, pte, 1);
 		return;
 	}
 
 	if (!pte_cont(pte)) {
-		set_pte_at(mm, addr, ptep, pte);
+		set_ptes(mm, addr, ptep, pte, 1);
 		return;
 	}
 
@@ -263,7 +263,7 @@ void set_huge_pte_at(struct mm_struct *m
 	clear_flush(mm, addr, ptep, pgsize, ncontig);
 
 	for (i = 0; i < ncontig; i++, ptep++, addr += pgsize, pfn += dpfn)
-		set_pte_at(mm, addr, ptep, pfn_pte(pfn, hugeprot));
+		set_ptes(mm, addr, ptep, pfn_pte(pfn, hugeprot), 1);
 }
 
 pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
@@ -471,7 +471,7 @@ int huge_ptep_set_access_flags(struct vm
 
 	hugeprot = pte_pgprot(pte);
 	for (i = 0; i < ncontig; i++, ptep++, addr += pgsize, pfn += dpfn)
-		set_pte_at(mm, addr, ptep, pfn_pte(pfn, hugeprot));
+		set_ptes(mm, addr, ptep, pfn_pte(pfn, hugeprot), 1);
 
 	return 1;
 }
@@ -500,7 +500,7 @@ void huge_ptep_set_wrprotect(struct mm_s
 	pfn = pte_pfn(pte);
 
 	for (i = 0; i < ncontig; i++, ptep++, addr += pgsize, pfn += dpfn)
-		set_pte_at(mm, addr, ptep, pfn_pte(pfn, hugeprot));
+		set_ptes(mm, addr, ptep, pfn_pte(pfn, hugeprot), 1);
 }
 
 pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
_

Patches currently in -mm which might be from ryan.roberts@arm.com are


