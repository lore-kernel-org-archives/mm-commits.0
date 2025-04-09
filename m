Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CBC29A2
	for <mm-commits@vger.kernel.org>; Wed,  9 Apr 2025 01:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744160873; cv=none; b=Nb4X8Yl1iVPDx3tydH2Xz461CoJCTje25mCqbhlv2qQ6ObOJuaCl9hd9eNVMcgg58eMmdHVI2CdPHppxdrm1xlbXf6KHMqd1MPBwa/7sU5WyxwGc8eurtPW1sV9zI8S/gV0Lzbg3xx4AFrkY37ObEk/kDctfNEPdHoMVBwdOOLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744160873; c=relaxed/simple;
	bh=JCFLL2ghrTRZz+yLdnlGHEJaH3hFV3dHY81D69k5TAA=;
	h=Date:To:From:Subject:Message-Id; b=jo5PRAlyUHZPkAuv3oxBB+4GFYQvbKmkqambsBcRokTv/1beaolPe7lX8gcD8ZScN7GSCRcMd1pQm46C8zjx/cORtEV1jDV4aFlkcv4K+0UUIE6hgvu+ACveQi3wa8lLvfzZp6UVT0/uBPB4mObyaLudi0PSjgjMskysnczS9oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0ad8u5CE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0ad8u5CE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0432C4CEE5;
	Wed,  9 Apr 2025 01:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744160871;
	bh=JCFLL2ghrTRZz+yLdnlGHEJaH3hFV3dHY81D69k5TAA=;
	h=Date:To:From:Subject:From;
	b=0ad8u5CE9UI18jK/iFHQ0hYgTLrlownJIMJT6dHo+hOqlaPeJ4WS6GGHP+TwmAw9I
	 J3i23v1OOLci6LDhMtGm2mx56G/neW4vtjzGJc2PJ2xK8O0txLntVm5VF3BMy+AO5B
	 gTcr51XU06Ks6mlQYyBbwjKeGE1kVZtZajtvy/kA=
Date: Tue, 08 Apr 2025 18:07:51 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yang@os.amperecomputing.com,x86@kernel.org,willy@infradead.org,will@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,mark.rutland@arm.com,maddy@linux.ibm.com,linus.walleij@linaro.org,geert@linux-m68k.org,davem@davemloft.net,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aou@eecs.berkeley.edu,andreas@gaisler.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-mm-call-pud-p4d-ctor-in-special-kernel-pgtable-alloc.patch added to mm-new branch
Message-Id: <20250409010751.C0432C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: riscv: mm: call PUD/P4D ctor in special kernel pgtable alloc
has been added to the -mm mm-new branch.  Its filename is
     riscv-mm-call-pud-p4d-ctor-in-special-kernel-pgtable-alloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-mm-call-pud-p4d-ctor-in-special-kernel-pgtable-alloc.patch

This patch will later appear in the mm-new branch at
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
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
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

mm-pass-mm-down-to-pagetable_ptepmd_ctor.patch
x86-pgtable-always-use-pte_free_kernel.patch
mm-call-ctor-dtor-for-kernel-ptes.patch
m68k-mm-call-ctor-dtor-for-kernel-ptes.patch
powerpc-mm-call-ctor-dtor-for-kernel-ptes.patch
sparc64-mm-call-ctor-dtor-for-kernel-ptes.patch
mm-skip-ptlock_init-for-kernel-pmds.patch
arm64-mm-use-enum-to-identify-pgtable-level-instead-of-_shift.patch
arm64-mm-always-call-pte-pmd-ctor-in-__create_pgd_mapping.patch
riscv-mm-clarify-ctor-mm-argument-in-alloc_ptepmd_late.patch
arm64-mm-call-pud-p4d-ctor-in-__create_pgd_mapping.patch
riscv-mm-call-pud-p4d-ctor-in-special-kernel-pgtable-alloc.patch

