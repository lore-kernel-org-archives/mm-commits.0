Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486E75EE9B
	for <mm-commits@vger.kernel.org>; Tue, 23 Jan 2024 00:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970496; cv=none; b=MKEclmltJZhF8i38dmcMLtcjfZL7lHouTxsN3r09X1yqR/ESY3o10ZfhhTSams9ybs6YhSUJIwTV3OqG5LoWrNSnNEeN7QS0B/ggUEH9gxUL1rLBTjQmPEF69X3J7KgmGNkXQVLI6AAiRriWrzQoEEOxqgRCoiCJ39JR8c/QgRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970496; c=relaxed/simple;
	bh=ns8fgJuss8mYzIS/oFgbumk29Ptrn4BFi2eMA29Bcdk=;
	h=Date:To:From:Subject:Message-Id; b=H/HCVHjxRmH5be1YAv8ywRWWdRtNRlYVm91aoEckIAeG/hH4EvDp0Yc93TeoQMtxXhth7BV3zYy3ns9oa5QDaXu+xCjFrPDWzvpPCpsKj2Z7enZwyGjEycUbYxbLH4PtMs/71ZrnpvPq8jk6WGNYVCg3Sv641tdFNaROKA53aA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tdOhSU1S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tdOhSU1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43B3C43390;
	Tue, 23 Jan 2024 00:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705970496;
	bh=ns8fgJuss8mYzIS/oFgbumk29Ptrn4BFi2eMA29Bcdk=;
	h=Date:To:From:Subject:From;
	b=tdOhSU1SSwjwLR7xl39wFcRwATUNFjzXxGXI42cU1HYpp9Vq/4YZUk1R/m7eCbcmO
	 nQDF4ov8M6Gw6p7WONfUbmJPqlE66H6IEkLBiGgROahPnCgTUJ+5Vprgbuma5i2J0d
	 Fkk3N+d4wep58o1zUsxtQssJWutS9zCCA6OTt+ec=
Date: Mon, 22 Jan 2024 16:41:33 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,svens@linux.ibm.com,ryan.roberts@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,linux@armlinux.org.uk,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dinguyen@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + s390-pgtable-define-pfn_pte_shift.patch added to mm-unstable branch
Message-Id: <20240123004135.A43B3C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: s390/pgtable: define PFN_PTE_SHIFT
has been added to the -mm mm-unstable branch.  Its filename is
     s390-pgtable-define-pfn_pte_shift.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/s390-pgtable-define-pfn_pte_shift.patch

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
Subject: s390/pgtable: define PFN_PTE_SHIFT
Date: Mon, 22 Jan 2024 20:41:54 +0100

We want to make use of pte_next_pfn() outside of set_ptes().  Let's
simpliy define PFN_PTE_SHIFT, required by pte_next_pfn().

Link: https://lkml.kernel.org/r/20240122194200.381241-6-david@redhat.com
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

