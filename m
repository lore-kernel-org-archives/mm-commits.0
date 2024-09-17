Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F236152176
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560517; cv=none; b=aKQaZT6R+zJ+/MlJv+pMSRBv8xSDE4QzplSHmfkIyhGgyk7WgzF0A302ikCY8uQu4YdyqbE8oHrrUzk8EwC1/bORsX8o0/vio6Fho92o7gkxkWCkid+i3X6+Dp+tuZVOo1TFDuZFa5I4rfDSpvKDUAeiQqNipTLcPHaA1PqEjSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560517; c=relaxed/simple;
	bh=YXxhUwZbbDYroekc9F/HeWUBUCVj93EG2VwVF+HHSrQ=;
	h=Date:To:From:Subject:Message-Id; b=kdy2f6wNBENH9UkHb9Zrnc5Uvxzu3TpEiCVeXwQzRcQkva9P82ftasVCdW4zluLeqRJHoRr6prIhpz0qL2f4Vze3wMPCwy9BMJB4XYW6x7fvjghvYpgi1uedvphTsKjX4mWZrGvbeMMuDdS0u1rsdaS2sQaybKnPxp57acofSjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R6j8NoHY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R6j8NoHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E02C4CEC6;
	Tue, 17 Sep 2024 08:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560517;
	bh=YXxhUwZbbDYroekc9F/HeWUBUCVj93EG2VwVF+HHSrQ=;
	h=Date:To:From:Subject:From;
	b=R6j8NoHYcopnYbZi5+8J3Bfeni4Ow6k0YCEWaHc7PdgL5OFa/HClo4Jee4yDmuSZE
	 i66xrDfPm+k/nqyUNiSOprdwWx8R+zP/tZJ78ymlzSrDIRda7jfF762S8K0rjDu45/
	 RfKZttcgfE3NxGhkkoknKUJ6l7akucj678dfYqzE=
Date: Tue, 17 Sep 2024 01:08:34 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,svens@linux.ibm.com,seanjc@google.com,schnelle@linux.ibm.com,ryan.roberts@arm.com,pbonzini@redhat.com,mingo@redhat.com,jgg@nvidia.com,hca@linux.ibm.com,gshan@redhat.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aneesh.kumar@linux.ibm.com,alex.williamson@redhat.com,agordeev@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-arm64-support-large-pfn-mappings.patch removed from -mm tree
Message-Id: <20240917080836.90E02C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/arm64: support large pfn mappings
has been removed from the -mm tree.  Its filename was
     mm-arm64-support-large-pfn-mappings.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/arm64: support large pfn mappings
Date: Mon, 26 Aug 2024 16:43:52 -0400

Support huge pfnmaps by using bit 56 (PTE_SPECIAL) for "special" on
pmds/puds.  Provide the pmd/pud helpers to set/get special bit.

There's one more thing missing for arm64 which is the pxx_pgprot() for
pmd/pud.  Add them too, which is mostly the same as the pte version by
dropping the pfn field.  These helpers are essential to be used in the new
follow_pfnmap*() API to report valid pgprot_t results.

Note that arm64 doesn't yet support huge PUD yet, but it's still
straightforward to provide the pud helpers that we need altogether.  Only
PMD helpers will make an immediate benefit until arm64 will support huge
PUDs first in general (e.g.  in THPs).

Link: https://lkml.kernel.org/r/20240826204353.2228736-19-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig               |    1 +
 arch/arm64/include/asm/pgtable.h |   29 +++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

--- a/arch/arm64/include/asm/pgtable.h~mm-arm64-support-large-pfn-mappings
+++ a/arch/arm64/include/asm/pgtable.h
@@ -578,6 +578,14 @@ static inline pmd_t pmd_mkdevmap(pmd_t p
 	return pte_pmd(set_pte_bit(pmd_pte(pmd), __pgprot(PTE_DEVMAP)));
 }
 
+#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
+#define pmd_special(pte)	(!!((pmd_val(pte) & PTE_SPECIAL)))
+static inline pmd_t pmd_mkspecial(pmd_t pmd)
+{
+	return set_pmd_bit(pmd, __pgprot(PTE_SPECIAL));
+}
+#endif
+
 #define __pmd_to_phys(pmd)	__pte_to_phys(pmd_pte(pmd))
 #define __phys_to_pmd_val(phys)	__phys_to_pte_val(phys)
 #define pmd_pfn(pmd)		((__pmd_to_phys(pmd) & PMD_MASK) >> PAGE_SHIFT)
@@ -595,6 +603,27 @@ static inline pmd_t pmd_mkdevmap(pmd_t p
 #define pud_pfn(pud)		((__pud_to_phys(pud) & PUD_MASK) >> PAGE_SHIFT)
 #define pfn_pud(pfn,prot)	__pud(__phys_to_pud_val((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot))
 
+#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
+#define pud_special(pte)	pte_special(pud_pte(pud))
+#define pud_mkspecial(pte)	pte_pud(pte_mkspecial(pud_pte(pud)))
+#endif
+
+#define pmd_pgprot pmd_pgprot
+static inline pgprot_t pmd_pgprot(pmd_t pmd)
+{
+	unsigned long pfn = pmd_pfn(pmd);
+
+	return __pgprot(pmd_val(pfn_pmd(pfn, __pgprot(0))) ^ pmd_val(pmd));
+}
+
+#define pud_pgprot pud_pgprot
+static inline pgprot_t pud_pgprot(pud_t pud)
+{
+	unsigned long pfn = pud_pfn(pud);
+
+	return __pgprot(pud_val(pfn_pud(pfn, __pgprot(0))) ^ pud_val(pud));
+}
+
 static inline void __set_pte_at(struct mm_struct *mm,
 				unsigned long __always_unused addr,
 				pte_t *ptep, pte_t pte, unsigned int nr)
--- a/arch/arm64/Kconfig~mm-arm64-support-large-pfn-mappings
+++ a/arch/arm64/Kconfig
@@ -99,6 +99,7 @@ config ARM64
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select ARCH_SUPPORTS_PAGE_TABLE_CHECK
 	select ARCH_SUPPORTS_PER_VMA_LOCK
+	select ARCH_SUPPORTS_HUGE_PFNMAP if TRANSPARENT_HUGEPAGE
 	select ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION if COMPAT
 	select ARCH_WANT_DEFAULT_BPF_JIT
_

Patches currently in -mm which might be from peterx@redhat.com are


