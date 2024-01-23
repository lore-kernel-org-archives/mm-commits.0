Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11555DF33
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970492; cv=none; b=gJ3sL+/mZDswnDrPEY/8Kh84iUW/HOKd9ML20cEHuM8UQpoqHPD4TuKc2AC/zve3qI55HU+XSCRWdiu18Jtvui9fI0WPttdwetBgyJ8B22oW3U9rFwjaRuXT+vOUXRfOtxQmO9/jKZKJmkcbN64yb3s2Ugtk97oU22DJLgPyM/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970492; c=relaxed/simple;
	bh=GycjCKfm820odUZxUud5Le1OZh100/H4VNLXjFGkIFU=;
	h=Date:To:From:Subject:Message-Id; b=jUq4cDf3Hze/VngUOBBkdckN8JU/z1hD8QbzpwOfOcv5U9o9Y570C+spDluOk+BIQF7F1sih9TPL7apa8R7k2nvxX3E4Nu6yJX8tlzFIB0OQUhkJKK9cYjmi+SHry1qz9Hhu1BYhxtAyc9tvn3GDlPCOQTv1FPu0yrCWb5M5EA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LfB/F1R+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LfB/F1R+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A0BC433C7;
	Tue, 23 Jan 2024 00:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970492;
	bh=GycjCKfm820odUZxUud5Le1OZh100/H4VNLXjFGkIFU=;
	h=Date:To:From:Subject:From;
	b=LfB/F1R+DfNtMDFcV23DkJedmTAbDj680LPGpSsOP2nMjgpc9s8dXPdz5uQNCVmKT
	 CjwOhClv4BGGu8y/s2YW2oZzrIQocXj9gUC16j0e611BW79fNy7hCtCIK9GHyvpTuj
	 qWC7asQDQtKMpwNbsYjHjppm9Yn2Mwvas3JuvzG8=
Date: Mon, 22 Jan 2024 16:41:29 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,svens@linux.ibm.com,ryan.roberts@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,linux@armlinux.org.uk,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dinguyen@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sparc-pgtable-define-pfn_pte_shift.patch added to mm-unstable branch
Message-Id: <20240123004132.18A0BC433C7@smtp.kernel.org>
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
Date: Mon, 22 Jan 2024 20:41:55 +0100

We want to make use of pte_next_pfn() outside of set_ptes().  Let's
simpliy define PFN_PTE_SHIFT, required by pte_next_pfn().

Link: https://lkml.kernel.org/r/20240122194200.381241-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: "Aneesh Kumar K.V (IBM)" <aneesh.kumar@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Ryan Roberts <ryan.roberts@arm.com>
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

uprobes-use-pagesize-aligned-virtual-address-when-replacing-pages.patch
arm-pgtable-define-pfn_pte_shift-on-arm-and-arm64.patch
nios2-pgtable-define-pfn_pte_shift.patch
powerpc-pgtable-define-pfn_pte_shift.patch
risc-pgtable-define-pfn_pte_shift.patch
s390-pgtable-define-pfn_pte_shift.patch
sparc-pgtable-define-pfn_pte_shift.patch
mm-memory-factor-out-copying-the-actual-pte-in-copy_present_pte.patch
mm-memory-pass-pte-to-copy_present_pte.patch
mm-memory-optimize-fork-with-pte-mapped-thp.patch
mm-memory-ignore-dirty-accessed-soft-dirty-bits-in-folio_pte_batch.patch
mm-memory-ignore-writable-bit-in-folio_pte_batch.patch

