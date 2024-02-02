Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A26413F019
	for <mm-commits@vger.kernel.org>; Fri,  2 Feb 2024 12:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706876042; cv=none; b=SvQmeE92vpbM0oP4BLjgNZoEGRBC9wfB5vFUzyg6QrGRQh+H/VVgg3drNfQmuwe+Z4p8b134hASFtRPv1K8ntAomVrXyt1Ra6Xh+y5pOq4oRlM7zMSBjTYGpoHFyFLF6iXRZpIBOObg40bYH8f80jBkr5uubW86OvnPi8VO8ws0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706876042; c=relaxed/simple;
	bh=xRI75sgacN92i+ANbHvl8UVqpeuVbvl6el9ws/lksJQ=;
	h=Date:To:From:Subject:Message-Id; b=PvlBzdX2greZvyrCMxuVEkLLVg9JmNjBvP0oQh1VEUxxsiX8W1M9YdalVOJ6MTfwEdlJoYeYi+IhUHkoeclTZ3r/aPE+oCfckqgFaT27l+/CMQ3p+HAuzGhL+E2k3YFtEzIIvyLF6fg4gxcEcU78PLCdN59pk0SBrB9bqjQsAYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cpX60/vo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cpX60/vo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74186C433C7;
	Fri,  2 Feb 2024 12:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706876042;
	bh=xRI75sgacN92i+ANbHvl8UVqpeuVbvl6el9ws/lksJQ=;
	h=Date:To:From:Subject:From;
	b=cpX60/voj20YX1GbXxxYIDb8TIybeUa54+IAeaYVUfSv+u/pMvZ/3eO5/EIF/c8Mu
	 CcHOK8vXT5ezoFy0C2mFT5I1r3lgQNAcNUnNC6+xn+qD4XcaZxC6pbxTPEZP7VZXsM
	 1RbRr4x+fBjMcwE3Z1NRHblzpQOIIhZgfegp8Bps=
Date: Fri, 02 Feb 2024 04:13:59 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,svens@linux.ibm.com,ryan.roberts@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,linux@armlinux.org.uk,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dinguyen@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sparc-pgtable-define-pfn_pte_shift.patch added to mm-unstable branch
Message-Id: <20240202121401.74186C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sparc/pgtable: define PFN_PTE_SHIFT
has been added to the -mm mm-unstable branch.  Its filename is
     sparc-pgtable-define-pfn_pte_shift.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sparc-pgtable-define-pfn_pte_shift.patch

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
Subject: sparc/pgtable: define PFN_PTE_SHIFT
Date: Mon, 29 Jan 2024 13:46:41 +0100

We want to make use of pte_next_pfn() outside of set_ptes().  Let's simply
define PFN_PTE_SHIFT, required by pte_next_pfn().

Link: https://lkml.kernel.org/r/20240129124649.189745-8-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Tested-by: Ryan Roberts <ryan.roberts@arm.com>
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

 arch/sparc/include/asm/pgtable_64.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/sparc/include/asm/pgtable_64.h~sparc-pgtable-define-pfn_pte_shift
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -929,6 +929,8 @@ static inline void __set_pte_at(struct m
 	maybe_tlb_batch_add(mm, addr, ptep, orig, fullmm, PAGE_SHIFT);
 }
 
+#define PFN_PTE_SHIFT		PAGE_SHIFT
+
 static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
 		pte_t *ptep, pte_t pte, unsigned int nr)
 {
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

