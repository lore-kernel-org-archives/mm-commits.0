Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939297E1
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560170; cv=none; b=swuEgNXN99vP4g3Qmybgo8zwMXKDWfi2c3nKKUodCmkf/xu2C1qT9bRWKN++TFHluP8jraUPkxtRgzM/0bIMSXhxCM0WP9nBP7819t0jZs8xpuA1ORrmUu1bcXlJ0s5r8Kwu2of4csG5bFzr+DXfTj/PBrjRvl30f8huIMvNK4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560170; c=relaxed/simple;
	bh=j998zcGpjXxuXhd6AO03qbBCnt8zmysR21TJ123lDX4=;
	h=Date:To:From:Subject:Message-Id; b=dVDXNzqCvDueyg550/TO20WHanuTwfmZKBKRV1/ConNSFQiKDvwdVlUKaP5FGuLS2y1Q7L82tD3FcsAdthWu56qhBI+On+fDSySeh2eRoUkCqrY+liEU57YG8B3VAHXg+UhIF+64LtEpLeiPKmPFeXyT7m2woUxohw/3lheeucY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NnUsuFPV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NnUsuFPV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6AEC433C7;
	Thu, 22 Feb 2024 00:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560170;
	bh=j998zcGpjXxuXhd6AO03qbBCnt8zmysR21TJ123lDX4=;
	h=Date:To:From:Subject:From;
	b=NnUsuFPVV/1CQlIYW6EA9WjIDFee79bSHjptldvTqL/Tr6umcWH51a9AYSP12ceUN
	 sZbs8z8ulGdfUV+bQnGU2axY1cjQKfbFfjeKWJBcub42Eirjx1C0qvKaMv1yU/y57n
	 ViTtKi/2MrO1DVXKUjsPkCtnhZcDLp+nxvyZ/oi4=
Date: Wed, 21 Feb 2024 16:02:49 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,svens@linux.ibm.com,ryan.roberts@arm.com,rppt@kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,linux@armlinux.org.uk,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dinguyen@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-pgtable-define-pfn_pte_shift.patch removed from -mm tree
Message-Id: <20240222000250.5F6AEC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390/pgtable: define PFN_PTE_SHIFT
has been removed from the -mm tree.  Its filename was
     s390-pgtable-define-pfn_pte_shift.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: s390/pgtable: define PFN_PTE_SHIFT
Date: Mon, 29 Jan 2024 13:46:40 +0100

We want to make use of pte_next_pfn() outside of set_ptes().  Let's simply
define PFN_PTE_SHIFT, required by pte_next_pfn().

Link: https://lkml.kernel.org/r/20240129124649.189745-7-david@redhat.com
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

 arch/s390/include/asm/pgtable.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/s390/include/asm/pgtable.h~s390-pgtable-define-pfn_pte_shift
+++ a/arch/s390/include/asm/pgtable.h
@@ -1316,6 +1316,8 @@ pgprot_t pgprot_writecombine(pgprot_t pr
 #define pgprot_writethrough	pgprot_writethrough
 pgprot_t pgprot_writethrough(pgprot_t prot);
 
+#define PFN_PTE_SHIFT		PAGE_SHIFT
+
 /*
  * Set multiple PTEs to consecutive pages with a single call.  All PTEs
  * are within the same folio, PMD and VMA.
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

