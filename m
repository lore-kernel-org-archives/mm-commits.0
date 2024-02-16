Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7EF170
	for <mm-commits@vger.kernel.org>; Fri, 16 Feb 2024 00:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708042642; cv=none; b=OqJRbTabOknVaYZlPecNtlMsDefJa/rKBa6iDwquNnS/v+2A1aEbOx3fD2FKTIROfc4ntRlEBRshB3ARPAgirIyo5pvcMHBEEuhwdWAr/SiMpDRhKogbAQfuwknWnBwEHkzZ45lgqwF8oWbcy5CYlKyoQltpz93oBP9yN1VNI18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708042642; c=relaxed/simple;
	bh=z5Mb/FTTbdXtrByrl0bhgCY674XOy2Wz+MyROfgNcEI=;
	h=Date:To:From:Subject:Message-Id; b=YSdiTQ4CsSxKm6mfE35TVhHULeX8qEhP3dYb1tP7Jv7yuXGnt0Ic38d9IMngdwqIirXgTW+fOyJQw16CEfrT6RFOI0XQTbOyCJk5soc7mHUrhHWM6LZ06Nxjx01jjH41yVt673UIaU5vb4XQlfdHVQnBD6GXNK3EEFtZjzSxqFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Lgdl9DKw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lgdl9DKw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83553C433F1;
	Fri, 16 Feb 2024 00:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708042641;
	bh=z5Mb/FTTbdXtrByrl0bhgCY674XOy2Wz+MyROfgNcEI=;
	h=Date:To:From:Subject:From;
	b=Lgdl9DKw/yanTm3bqRevdeKrVzVq2IGzPqVJk/+1Bzr1GJJTv35Zxht7nwkvjzuYi
	 +JF9rCyMatUc81nbUc4afQge+6+JJe5x3K2+ijg/fzO8cWTyHFIyYJCsMI+X2mXB6t
	 m/Qnt5+houc0Lh1fK8gGW9nm5MVO+mErLB/vdZEY=
Date: Thu, 15 Feb 2024 16:17:20 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,svens@linux.ibm.com,ryan.roberts@arm.com,rppt@kernel.org,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,linux@armlinux.org.uk,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dinguyen@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-pass-pte-to-copy_present_pte-fix.patch added to mm-unstable branch
Message-Id: <20240216001721.83553C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fixup: mm/memory: pass PTE to copy_present_pte()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-pass-pte-to-copy_present_pte-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-pass-pte-to-copy_present_pte-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
mm-memory-pass-pte-to-copy_present_pte-fix.patch
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

