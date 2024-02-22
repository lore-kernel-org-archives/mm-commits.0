Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2EB210FF
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560172; cv=none; b=COp1xTq+rw39+g1MWW8nQrVBIkKh152T1YyMxuyAUX1gNonKM7e3gvE4C3MZnZ/jF5symUJ39HyKke8bW4V0fuHy4kEskLoB4fXa/tRgXpKUkF36aWB2r791Jhac5NL0dMGSKRLk1s6F2Qhijr5fyE0NInkp64lyz/Os+BcEDYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560172; c=relaxed/simple;
	bh=KLFKWYIcanbMHnlfBanN/J3XHJu0RuU+ypS7Vtpw7S0=;
	h=Date:To:From:Subject:Message-Id; b=OIgAb+cZmm6rmjDidnVRXGJ9VHYhglfPJVCzkSfw9rhnybJqOildms6GfVrrCynyvGMZ2CKPa/WkGGlyWnT1XtWnyP5iPIALyqLQ9qtUWMOgjsK+uCaltDK/k9Nj/Xa1YGbBNOyYSdnl37rE0df5ku4TtbSrlqPHjpHqGGWeIT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i7JQkPTh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i7JQkPTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8250DC43390;
	Thu, 22 Feb 2024 00:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560172;
	bh=KLFKWYIcanbMHnlfBanN/J3XHJu0RuU+ypS7Vtpw7S0=;
	h=Date:To:From:Subject:From;
	b=i7JQkPThYvC6JeuTUN6RyTpQ7KdmhNDdHdSt6DlYlurVDXlMDSPBMuM1V8P+AH2e7
	 TEbaieIB9gprSP2RjbBoUzx021kzr9/PQbpm7dYzLRrf74OFSI2wRTy+8IWVvYAuds
	 2gatIwBnswxLAKX4iNMC3T8KrSkgDZteniHuHPDE=
Date: Wed, 21 Feb 2024 16:02:52 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,svens@linux.ibm.com,ryan.roberts@arm.com,rppt@kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,linux@armlinux.org.uk,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dinguyen@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pgtable-make-pte_next_pfn-independent-of-set_ptes.patch removed from -mm tree
Message-Id: <20240222000252.8250DC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/pgtable: make pte_next_pfn() independent of set_ptes()
has been removed from the -mm tree.  Its filename was
     mm-pgtable-make-pte_next_pfn-independent-of-set_ptes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/pgtable: make pte_next_pfn() independent of set_ptes()
Date: Mon, 29 Jan 2024 13:46:42 +0100

Let's provide pte_next_pfn(), independently of set_ptes().  This allows
for using the generic pte_next_pfn() version in some arch-specific
set_ptes() implementations, and prepares for reusing pte_next_pfn() in
other context.

Link: https://lkml.kernel.org/r/20240129124649.189745-9-david@redhat.com
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

 include/linux/pgtable.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/pgtable.h~mm-pgtable-make-pte_next_pfn-independent-of-set_ptes
+++ a/include/linux/pgtable.h
@@ -212,7 +212,6 @@ static inline int pmd_dirty(pmd_t pmd)
 #define arch_flush_lazy_mmu_mode()	do {} while (0)
 #endif
 
-#ifndef set_ptes
 
 #ifndef pte_next_pfn
 static inline pte_t pte_next_pfn(pte_t pte)
@@ -221,6 +220,7 @@ static inline pte_t pte_next_pfn(pte_t p
 }
 #endif
 
+#ifndef set_ptes
 /**
  * set_ptes - Map consecutive pages to a contiguous range of addresses.
  * @mm: Address space to map the pages into.
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

