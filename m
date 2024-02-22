Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59E510FF
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560173; cv=none; b=nZkL9JseNsajVe7cfL972Bk+e386xFpYy9TFeu+Ze3XdyiPrpBP0D4dXeh/rjTWIBwcRwEU5Sy5rQWLkDEKfsBegf09OAF1ddw43jpc9IkNZmKilf8igNelEdmroexPailJ4hcVS4cbxOsPe3CoTkiBHapbU4DwEDUPYeSMbmXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560173; c=relaxed/simple;
	bh=VavPe7vvlP5k7ieSQ0ZEL7Ohf17K5DOylRziXTfJEG0=;
	h=Date:To:From:Subject:Message-Id; b=ny1OsUJQYMaZU3I3crjZge/q4FHDSkmPxXc039MrLlqgcn3wC2cmWXvuy7QMG32ApQg5xYiDBKpZeDzgJrAGCnlR0NLK54GC9EInD/iC/+5q1JPXnMUkUKgkSfDXEp3lbwHCJ2X2J+2xfLbXA8e3Px84z4apsBqpkWbSsxRySQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bg/PkDHV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bg/PkDHV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F6BC433F1;
	Thu, 22 Feb 2024 00:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560173;
	bh=VavPe7vvlP5k7ieSQ0ZEL7Ohf17K5DOylRziXTfJEG0=;
	h=Date:To:From:Subject:From;
	b=bg/PkDHVBq8mC7OqAt5i841iQKa2SaxRCETkwSKLkG5TWeBPHV2oGA6pXD2GMibZM
	 zBqN2FfVaCWJiiVer9wsn/zjiQF3WZI0Lx4uD67oUsPoZmBNR9TwNxBBHfGbqCJJvl
	 o/9Us5AxnUmFKJtVrY8MZCoQV1hSblpyGSG2itsw=
Date: Wed, 21 Feb 2024 16:02:53 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,svens@linux.ibm.com,ryan.roberts@arm.com,rppt@kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,linux@armlinux.org.uk,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dinguyen@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm-mm-use-pte_next_pfn-in-set_ptes.patch removed from -mm tree
Message-Id: <20240222000253.81F6BC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm/mm: use pte_next_pfn() in set_ptes()
has been removed from the -mm tree.  Its filename was
     arm-mm-use-pte_next_pfn-in-set_ptes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: arm/mm: use pte_next_pfn() in set_ptes()
Date: Mon, 29 Jan 2024 13:46:43 +0100

Let's use our handy helper now that it's available on all archs.

Link: https://lkml.kernel.org/r/20240129124649.189745-10-david@redhat.com
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

 arch/arm/mm/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mm/mmu.c~arm-mm-use-pte_next_pfn-in-set_ptes
+++ a/arch/arm/mm/mmu.c
@@ -1814,6 +1814,6 @@ void set_ptes(struct mm_struct *mm, unsi
 		if (--nr == 0)
 			break;
 		ptep++;
-		pte_val(pteval) += PAGE_SIZE;
+		pteval = pte_next_pfn(pteval);
 	}
 }
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

