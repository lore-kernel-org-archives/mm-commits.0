Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC6913F009
	for <mm-commits@vger.kernel.org>; Fri,  2 Feb 2024 12:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706876050; cv=none; b=iesppil/ILsl5iw4k1hqIMdhLcyjHTdqFctmz/SUrlXyAiTieY5yCMdO6zGPL/JKCDNM8OsuTyG9FXy9Zoz7E+7iQzJodSCKdNG7jSGDTjthoYt2GztpeUoMqPN9GNgrNMmnlmGvkmFV8MviMpsZxQOIWYMQ2Vr4zk17iGnK/bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706876050; c=relaxed/simple;
	bh=nvAh0IJz4Sxaet/q8JhVaYVHFCbWmeqNZNpC7PLUmdA=;
	h=Date:To:From:Subject:Message-Id; b=i6xorjoQxusKyDc9JvHA+Tszox4y6br4yFaoEGaBCdiKlBSwZCbsT8rajCVHdc+Xa8U6iz6M6x0OAFZA7+BcnyR9kw2XOAq+6DEMp3myO8K/YkZw1TH9d4abaTp8qJM6FPEtw0B+Xvyn2EbeFRw7qkQJhFlCaldEi7WFL9K44D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WDsEZSJF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WDsEZSJF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08D1C433C7;
	Fri,  2 Feb 2024 12:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706876050;
	bh=nvAh0IJz4Sxaet/q8JhVaYVHFCbWmeqNZNpC7PLUmdA=;
	h=Date:To:From:Subject:From;
	b=WDsEZSJFXvdq/1LQmWkUHi2+HFptCFH+hHKh6VoPXMTxJ+CafbehFjZtuX1nIYFt8
	 3d1YyG0QtfrFk0VIiqlena93AM/KhzJhiNWH9FcFtIiJ7r8PDn+08rr6vnCTF3aqG9
	 Ys9u8oEXnXtkisc4b8nHaMOITPjlkVtXRUD9BIKU=
Date: Fri, 02 Feb 2024 04:14:07 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,svens@linux.ibm.com,ryan.roberts@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,linux@armlinux.org.uk,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dinguyen@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pgtable-make-pte_next_pfn-independent-of-set_ptes.patch added to mm-unstable branch
Message-Id: <20240202121409.D08D1C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/pgtable: make pte_next_pfn() independent of set_ptes()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pgtable-make-pte_next_pfn-independent-of-set_ptes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pgtable-make-pte_next_pfn-independent-of-set_ptes.patch

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

