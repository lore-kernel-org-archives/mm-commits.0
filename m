Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04374A32
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560169; cv=none; b=c2z70siD3RCqHcyPdSQq+3WfnoSRcBFxha0nw0YKsBiieiHDd7jAw3j90ikWGRA4nm16RuvzU3UT6guRmYyyTdfsJFpSINk2M+qc13mUTbGtIb00G4vrhUCJ4NhlQoAleyaj20TH6mQcEryh1tmI1fGSjIe3o42sY+39SxRBY3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560169; c=relaxed/simple;
	bh=nY6q2m3xiUNlvD/3YO48ie/qZQxxD6Nt9545PB0Zzf8=;
	h=Date:To:From:Subject:Message-Id; b=Hhe/bwexagkvvMvSijgwLxGsvtGdE5zY1FJqAkL5d4cCCF8uD7HecNcT20nIdqLqgJRHiCe2VWePoSvaNbHoloU8KO8FSzNyR7hMEYbyW+9cBThQMjuG58dCD8ceB/vh6CFHBa3MWGYR0ZA2Ekxao+jzAa8OhoaqVvIybsEga8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wN83RFbe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wN83RFbe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66FEEC433F1;
	Thu, 22 Feb 2024 00:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560168;
	bh=nY6q2m3xiUNlvD/3YO48ie/qZQxxD6Nt9545PB0Zzf8=;
	h=Date:To:From:Subject:From;
	b=wN83RFbeNJIHUR5ei5sImSaUUfCEldR+fjzIOe/eC0QiAWP0EyjVyRgDpay+cq7Zg
	 DnVkpw9pCDwLC1IXrVlz/Cgr9pM8FjgqyzLVU8kwqhYBVPJA78amCg0qw/Elcbuqta
	 5WkTb8367+1VPZ9o7cvZJzkxSM8yGvy/Z6sOABV8=
Date: Wed, 21 Feb 2024 16:02:47 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,svens@linux.ibm.com,ryan.roberts@arm.com,rppt@kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,linux@armlinux.org.uk,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dinguyen@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-pgtable-define-pfn_pte_shift.patch removed from -mm tree
Message-Id: <20240222000248.66FEEC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc/pgtable: define PFN_PTE_SHIFT
has been removed from the -mm tree.  Its filename was
     powerpc-pgtable-define-pfn_pte_shift.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: powerpc/pgtable: define PFN_PTE_SHIFT
Date: Mon, 29 Jan 2024 13:46:38 +0100

We want to make use of pte_next_pfn() outside of set_ptes().  Let's simply
define PFN_PTE_SHIFT, required by pte_next_pfn().

Link: https://lkml.kernel.org/r/20240129124649.189745-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Tested-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
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

 arch/powerpc/include/asm/pgtable.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/include/asm/pgtable.h~powerpc-pgtable-define-pfn_pte_shift
+++ a/arch/powerpc/include/asm/pgtable.h
@@ -41,6 +41,8 @@ struct mm_struct;
 
 #ifndef __ASSEMBLY__
 
+#define PFN_PTE_SHIFT		PTE_RPN_SHIFT
+
 void set_ptes(struct mm_struct *mm, unsigned long addr, pte_t *ptep,
 		pte_t pte, unsigned int nr);
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

