Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9742AA3D
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560166; cv=none; b=LtT0Tn0w0psA7cZQfVYKX7VIltIlsIOl6urwaboPglwDoSaGWsO70QtnSSQ10t7Fj560gM37/mNTxoZhh/mJHDFaFgYJqV9a8wj/Mlpe6UP2G/LIsxHQDMXwN8hbJapERQybOi2X+K3fDqt3eZbPjbnbrrXzLNZIOMo/H0N7TK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560166; c=relaxed/simple;
	bh=HInZxPixZtBZEjk6vg5HrsYyWlGgsZsz6wO0pREVdPM=;
	h=Date:To:From:Subject:Message-Id; b=G+WJk8UFJAxI+HgNRqogCT62zPTXTKJmLXGntd7V5OFKBA0dFmxZAu7Pky36K/gb4f29Wx5E/fjGLUKQDffPY3GLePktPTeYoD56QwgPMVOLxzcXl6XwYKgb6UbkTXQII60FXI6R3uvQ6cfObcokE+8kl2v9XIUUy4TVxEk5/yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j0Rvc4Oh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j0Rvc4Oh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 639C0C433C7;
	Thu, 22 Feb 2024 00:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560166;
	bh=HInZxPixZtBZEjk6vg5HrsYyWlGgsZsz6wO0pREVdPM=;
	h=Date:To:From:Subject:From;
	b=j0Rvc4Oh0nFFg2kz6A6OI3la+moFY61nJOX/UJ7uHE96Qgse+MyAnciugzklCwdcB
	 0dFDuCQwIS+GX3jtPI7+MBQWzl4tGv3vjyuF1pvIckSDQeglwUULXdaOPMZsCYCG4u
	 uxsgbzXisQGqDWLwDED8ksqIxECy8A+cMU+n9O2A=
Date: Wed, 21 Feb 2024 16:02:45 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,svens@linux.ibm.com,ryan.roberts@arm.com,rppt@kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,linux@armlinux.org.uk,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dinguyen@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm-pgtable-define-pfn_pte_shift.patch removed from -mm tree
Message-Id: <20240222000246.639C0C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm/pgtable: define PFN_PTE_SHIFT
has been removed from the -mm tree.  Its filename was
     arm-pgtable-define-pfn_pte_shift.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: arm/pgtable: define PFN_PTE_SHIFT
Date: Mon, 29 Jan 2024 13:46:36 +0100

We want to make use of pte_next_pfn() outside of set_ptes().  Let's simply
define PFN_PTE_SHIFT, required by pte_next_pfn().

Link: https://lkml.kernel.org/r/20240129124649.189745-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Tested-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N. Rao <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Russell King (Oracle) <linux@armlinux.org.uk>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgtable.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm/include/asm/pgtable.h~arm-pgtable-define-pfn_pte_shift
+++ a/arch/arm/include/asm/pgtable.h
@@ -209,6 +209,8 @@ static inline void __sync_icache_dcache(
 extern void __sync_icache_dcache(pte_t pteval);
 #endif
 
+#define PFN_PTE_SHIFT		PAGE_SHIFT
+
 void set_ptes(struct mm_struct *mm, unsigned long addr,
 		      pte_t *ptep, pte_t pteval, unsigned int nr);
 #define set_ptes set_ptes
_

Patches currently in -mm which might be from david@redhat.com are

mm-memory-factor-out-zapping-of-present-pte-into-zap_present_pte.patch
mm-memory-handle-page-case-in-zap_present_pte-separately.patch
mm-memory-further-separate-anon-and-pagecache-folio-handling-in-zap_present_pte.patch
mm-memory-factor-out-zapping-folio-pte-into-zap_present_folio_pte.patch
mm-mmu_gather-pass-delay_rmap-instead-of-encoded-page-to-__tlb_remove_page_size.patch
mm-mmu_gather-define-encoded_page_flag_delay_rmap.patch
mm-mmu_gather-add-tlb_remove_tlb_entries.patch
mm-mmu_gather-add-__tlb_remove_folio_pages.patch
mm-mmu_gather-improve-cond_resched-handling-with-large-folios-and-expensive-page-freeing.patch
mm-memory-optimize-unmap-zap-with-pte-mapped-thp.patch

