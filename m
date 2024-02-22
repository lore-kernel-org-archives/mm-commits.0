Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFA86E5F1
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644486; cv=none; b=oz/fJISiQu8EQ1r6TlRfp6tWby7mElLz43+bFx1DFsEBpIeQlJYgLUtX+3PsqdgkZ3kY9DCc9WZu99UHAJIsX4gQiadagGlyccmVAnpI0+/jN+VpnwB3gGRONRdFd8L3VVOxEYcMdpkLRj2ik312m5QVVWOrdc27h/n997V/nD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644486; c=relaxed/simple;
	bh=zHnGuomsZUg9v4kFm7UiM1tXL4r7AiM1dKSH6SRGEEk=;
	h=Date:To:From:Subject:Message-Id; b=Q8NPGPehN2zHhSBkIXeGyzjUcqlzOScRZ3TDfe2TbwB8IAcSSyt0Jnq5U4mn9FfdbYpMtOANasmNQl+30ypLKiwgGQHnxtTq3ymN5RoZAPTzSLVqc0XVTI08z9eHzridjdZYfjLfRFuNurcHMsOLT8KIhRsg/c0LT6ZYEBGoFKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qNBFTusx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qNBFTusx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25505C43399;
	Thu, 22 Feb 2024 23:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644486;
	bh=zHnGuomsZUg9v4kFm7UiM1tXL4r7AiM1dKSH6SRGEEk=;
	h=Date:To:From:Subject:From;
	b=qNBFTusxSmDqLs6UXBGo7FCaIXZfbiJn5a44GvfUr7T069ddfADnHCCQ1+ZCGyQGl
	 vjQ28JUy2ErerGSI0l3RDWtx/djKyMfvMKs6Qsb4QoYdqZH9sVb0GTCK6OKNWe5dvB
	 wim8sMEpndIR1Vy+qMbdXRspVoVFTKz/KXBI0lc8=
Date: Thu, 22 Feb 2024 15:28:05 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,james.morse@arm.com,hpa@zytor.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,apopple@nvidia.com,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-pte_advance_pfn-and-use-for-pte_next_pfn.patch removed from -mm tree
Message-Id: <20240222232806.25505C43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce pte_advance_pfn() and use for pte_next_pfn()
has been removed from the -mm tree.  Its filename was
     mm-introduce-pte_advance_pfn-and-use-for-pte_next_pfn.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: introduce pte_advance_pfn() and use for pte_next_pfn()
Date: Thu, 15 Feb 2024 10:31:50 +0000

The goal is to be able to advance a PTE by an arbitrary number of PFNs. 
So introduce a new API that takes a nr param.  Define the default
implementation here and allow for architectures to override. 
pte_next_pfn() becomes a wrapper around pte_advance_pfn().

Follow up commits will convert each overriding architecture's
pte_next_pfn() to pte_advance_pfn().

Link: https://lkml.kernel.org/r/20240215103205.2607016-4-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Morse <james.morse@arm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/include/linux/pgtable.h~mm-introduce-pte_advance_pfn-and-use-for-pte_next_pfn
+++ a/include/linux/pgtable.h
@@ -212,14 +212,17 @@ static inline int pmd_dirty(pmd_t pmd)
 #define arch_flush_lazy_mmu_mode()	do {} while (0)
 #endif
 
-
 #ifndef pte_next_pfn
-static inline pte_t pte_next_pfn(pte_t pte)
+#ifndef pte_advance_pfn
+static inline pte_t pte_advance_pfn(pte_t pte, unsigned long nr)
 {
-	return __pte(pte_val(pte) + (1UL << PFN_PTE_SHIFT));
+	return __pte(pte_val(pte) + (nr << PFN_PTE_SHIFT));
 }
 #endif
 
+#define pte_next_pfn(pte) pte_advance_pfn(pte, 1)
+#endif
+
 #ifndef set_ptes
 /**
  * set_ptes - Map consecutive pages to a contiguous range of addresses.
_

Patches currently in -mm which might be from ryan.roberts@arm.com are


