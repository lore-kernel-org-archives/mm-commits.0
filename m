Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A6B128386
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 23:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708559204; cv=none; b=taVGXW75Kr797neXiduBGUOGiM1tzBKCgbNAELMsluwGM235ID2IqM2tctalNa/og3VuBdAV/2hCMfrCrvvQHRU4lsITGu08yXsyBPD3pkVhLuXYZNPe6T+l6Dcet0C5nDKBh67LUtGusCyntZB6QxjEipG2g0isGez1QNSA+IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708559204; c=relaxed/simple;
	bh=EQbUFoI7a+K8e1rZZSkWI4wd4JHeyGrhF53utkHzGSU=;
	h=Date:To:From:Subject:Message-Id; b=XZEIZur2TI/BC7UFpwyVK8S2L5Ej/VI3wYn2h3uXmzivfHjnYzx4w2d5ymuRYNTl0V0c2OCsfnSwmdZ9xH+Jo7voGQX0swfybQzbyXTN/PQcjiFJ2fwCNWBQe8N46RoFjnTkJUOd/4wd+aNd95bqS4uYpuS4xzEpdjNxpACUkRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=alCoPd2d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="alCoPd2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3E2C433F1;
	Wed, 21 Feb 2024 23:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708559204;
	bh=EQbUFoI7a+K8e1rZZSkWI4wd4JHeyGrhF53utkHzGSU=;
	h=Date:To:From:Subject:From;
	b=alCoPd2daNOYSeQkZsI7rtoPEuhGBbr5Wi2U5Bo7eF48ifNkdp16M1OqF3+azdgdm
	 k6tOQ2QwGqOebKq2y7iCMOky1sJVhZtz9TPmDbN646cAG74hVPdRxUpHbRWiB1sXCC
	 I3aExhCg5fr9oKpAwk65FE+AefV0jm63JjXvRHFE=
Date: Wed, 21 Feb 2024 15:46:43 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,svens@linux.ibm.com,ryan.roberts@arm.com,rppt@kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,linux@armlinux.org.uk,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dinguyen@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memory-pass-pte-to-copy_present_pte-fix.patch removed from -mm tree
Message-Id: <20240221234644.1C3E2C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fixup: mm/memory: pass PTE to copy_present_pte()
has been removed from the -mm tree.  Its filename was
     mm-memory-pass-pte-to-copy_present_pte-fix.patch

This patch was dropped because it was folded into mm-memory-pass-pte-to-copy_present_pte.patch

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: fixup: mm/memory: pass PTE to copy_present_pte()
Date: Wed, 14 Feb 2024 23:40:22 +0100

For device-exclusive nonswp entries (is_device_exclusive_entry()),
copy_nonpresent_pte() can turn the PTEs into actual present PTEs while
holding the page table lock.

We hae to re-read the PTE after that operation, such that we won't be
working on the stale non-present PTE, assuming it would be present.

This fixes the hmm "exclusive_cow" selftest.

  ./run_vmtests.sh -t hmm
  # #  RUN           hmm.hmm_device_private.exclusive_cow ...
  # #            OK  hmm.hmm_device_private.exclusive_cow
  # ok 23 hmm.hmm_device_private.exclusive_cow

Link: https://lkml.kernel.org/r/13f296b8-e882-47fd-b939-c2141dc28717@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
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
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Naveen N. Rao <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Russell King (Oracle) <linux@armlinux.org.uk>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memory.c~mm-memory-pass-pte-to-copy_present_pte-fix
+++ a/mm/memory.c
@@ -1093,6 +1093,8 @@ again:
 				progress += 8;
 				continue;
 			}
+			ptent = ptep_get(src_pte);
+			VM_WARN_ON_ONCE(!pte_present(ptent));
 
 			/*
 			 * Device exclusive entry restored, continue by copying
_

Patches currently in -mm which might be from david@redhat.com are

arm-pgtable-define-pfn_pte_shift.patch
nios2-pgtable-define-pfn_pte_shift.patch
powerpc-pgtable-define-pfn_pte_shift.patch
riscv-pgtable-define-pfn_pte_shift.patch
s390-pgtable-define-pfn_pte_shift.patch
sparc-pgtable-define-pfn_pte_shift.patch
mm-pgtable-make-pte_next_pfn-independent-of-set_ptes.patch
arm-mm-use-pte_next_pfn-in-set_ptes.patch
powerpc-mm-use-pte_next_pfn-in-set_ptes.patch
mm-memory-factor-out-copying-the-actual-pte-in-copy_present_pte.patch
mm-memory-pass-pte-to-copy_present_pte.patch
mm-memory-optimize-fork-with-pte-mapped-thp.patch
mm-memory-ignore-dirty-accessed-soft-dirty-bits-in-folio_pte_batch.patch
mm-memory-ignore-writable-bit-in-folio_pte_batch.patch
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

