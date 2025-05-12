Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2487DC2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011090; cv=none; b=NMinYrQBN7NOOiBp4Zb4HqYzDR4n1fpmTfcst6O+1s9l2ToJtk6kyBLVlZPAr5rQuKao8CvUALicpTqRKL6CEfucNcyLNEfoRGYC/ZzHyyWM+MnwqwWaS6Kxkr11kXyaqpMifmvoOElLuXwQrTRIbyjgtU4meH4R/1PIq3SlON0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011090; c=relaxed/simple;
	bh=1pfoMbiAlb6kLdwpzumidWSX8tv/ID0K7LWMfTylHDo=;
	h=Date:To:From:Subject:Message-Id; b=JcX6qh13OIbzsbyacZEnxOGW/N9uUPJVfD99nFfl09PTpoxPT3i9esYPeBFu+GR9e4YiomkKknIr+0XerMa80Z3+R0r57CZfeDP67fEvkuizPRKBMRAOSlNJIvLY2lOMEy9lzMgCKIUxNo06xQdUDfyklQCr8rOwBToGiIv74Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p5uXnrmS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p5uXnrmS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9B8C4CEE4;
	Mon, 12 May 2025 00:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011090;
	bh=1pfoMbiAlb6kLdwpzumidWSX8tv/ID0K7LWMfTylHDo=;
	h=Date:To:From:Subject:From;
	b=p5uXnrmSoR/lWIpJDTuEMQgG2nRDL/AFSc8ZHLbr6Ip1ARtesR7b8W8RDOorokZzG
	 EEdSOYKpRzspUalbOFmyodKi7elPK0w8lsTxRXbAFbd6FHZ4eiFuCDCniJK/Ylbo5d
	 h6ph28qf3ktGr0J+KtbEQLHV1+CN0BEk+GhyvU9o=
Date: Sun, 11 May 2025 17:51:29 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yang@os.amperecomputing.com,x86@kernel.org,willy@infradead.org,will@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,mark.rutland@arm.com,maddy@linux.ibm.com,linus.walleij@linaro.org,geert@linux-m68k.org,davem@davemloft.net,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aou@eecs.berkeley.edu,andreas@gaisler.com,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] riscv-mm-call-pud-p4d-ctor-in-special-kernel-pgtable-alloc.patch removed from -mm tree
Message-Id: <20250512005129.ED9B8C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: riscv: mm: call PUD/P4D ctor in special kernel pgtable alloc
has been removed from the -mm tree.  Its filename was
     riscv-mm-call-pud-p4d-ctor-in-special-kernel-pgtable-alloc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: riscv: mm: call PUD/P4D ctor in special kernel pgtable alloc
Date: Tue, 8 Apr 2025 10:52:22 +0100

Constructors for PUD/P4D-level pgtables were recently introduced.  They
should be called for all pgtables; make sure they are called for special
kernel mappings created by create_pgd_mapping() too.

While at it also switch to using pagetable_alloc() like in
alloc_{pte,pmd}_late().

Link: https://lkml.kernel.org/r/20250408095222.860601-13-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Waleij <linus.walleij@linaro.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: <x86@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/mm/init.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/arch/riscv/mm/init.c~riscv-mm-call-pud-p4d-ctor-in-special-kernel-pgtable-alloc
+++ a/arch/riscv/mm/init.c
@@ -590,11 +590,11 @@ static phys_addr_t __init alloc_pud_fixm
 
 static phys_addr_t __meminit alloc_pud_late(uintptr_t va)
 {
-	unsigned long vaddr;
+	struct ptdesc *ptdesc = pagetable_alloc(GFP_KERNEL, 0);
 
-	vaddr = __get_free_page(GFP_KERNEL);
-	BUG_ON(!vaddr);
-	return __pa(vaddr);
+	BUG_ON(!ptdesc);
+	pagetable_pud_ctor(ptdesc);
+	return __pa((pud_t *)ptdesc_address(ptdesc));
 }
 
 static p4d_t *__init get_p4d_virt_early(phys_addr_t pa)
@@ -628,11 +628,11 @@ static phys_addr_t __init alloc_p4d_fixm
 
 static phys_addr_t __meminit alloc_p4d_late(uintptr_t va)
 {
-	unsigned long vaddr;
+	struct ptdesc *ptdesc = pagetable_alloc(GFP_KERNEL, 0);
 
-	vaddr = __get_free_page(GFP_KERNEL);
-	BUG_ON(!vaddr);
-	return __pa(vaddr);
+	BUG_ON(!ptdesc);
+	pagetable_p4d_ctor(ptdesc);
+	return __pa((p4d_t *)ptdesc_address(ptdesc));
 }
 
 static void __meminit create_pud_mapping(pud_t *pudp, uintptr_t va, phys_addr_t pa, phys_addr_t sz,
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are


