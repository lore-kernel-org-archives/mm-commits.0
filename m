Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA0013F019
	for <mm-commits@vger.kernel.org>; Fri,  2 Feb 2024 12:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706876039; cv=none; b=c59faHk5IUb4H2txP00hoCHjrN/StknQGbdkfY9PX4PdXgJJVilNgTjRY1GxJ9vHRZ15ehxNGYxF+AoqeXNyU9pclMhR91BpaLdS1g5sF5uoE7b/mAh1ytNZF1HZeaqP9hxZQP4mc0jRjt4YpR4oO8kt6yvuAdA78SK3Ukd78FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706876039; c=relaxed/simple;
	bh=3NtD9l5hBhyAfG2qrJS8Tt7I2qwfYaZGoiO03i8eC8Q=;
	h=Date:To:From:Subject:Message-Id; b=CfNizIdjA9zXHuGvgRLFyICTydQcBVnsezBo6okqYyj83RyOSwHvbfDBpi8gy6F0rD8qRkecOJChVm905Tl9+/eWuei8bw+U0G1+kYT/fMzCArSoSN+EildUbr/Rgfd1vSuCByl41v3KD7Dk7HyDQuKRW+p8BUQov6Tt3LPdOGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FD3uk5Xy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FD3uk5Xy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20DDC433C7;
	Fri,  2 Feb 2024 12:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706876039;
	bh=3NtD9l5hBhyAfG2qrJS8Tt7I2qwfYaZGoiO03i8eC8Q=;
	h=Date:To:From:Subject:From;
	b=FD3uk5XyA7djTQ83NfVniBZI3P2Gm8wuLSE2rPhShmin6fafiN4DSe6JjIkJlcWGD
	 dwpfg8Qgi4WRpQ+ZxwjZM/C6vDjk6L2Z+W2rT2x4GXcggtdb5iUeCLR+hh+8baK7Kv
	 FsF4uLt3csn4y4TduNFfasQbdIqBo0u1N4qMK3YU=
Date: Fri, 02 Feb 2024 04:13:56 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,svens@linux.ibm.com,ryan.roberts@arm.com,paul.walmsley@sifive.com,palmer@dabbelt.com,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,linux@armlinux.org.uk,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,dinguyen@kernel.org,davem@davemloft.net,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,borntraeger@linux.ibm.com,aou@eecs.berkeley.edu,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-pgtable-define-pfn_pte_shift.patch added to mm-unstable branch
Message-Id: <20240202121358.B20DDC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc/pgtable: define PFN_PTE_SHIFT
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-pgtable-define-pfn_pte_shift.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-pgtable-define-pfn_pte_shift.patch

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
Subject: powerpc/pgtable: define PFN_PTE_SHIFT
Date: Mon, 29 Jan 2024 13:46:38 +0100

We want to make use of pte_next_pfn() outside of set_ptes().  Let's simply
define PFN_PTE_SHIFT, required by pte_next_pfn().

Link: https://lkml.kernel.org/r/20240129124649.189745-5-david@redhat.com
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

