Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B6C13D8B1
	for <mm-commits@vger.kernel.org>; Wed,  9 Apr 2025 01:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744160867; cv=none; b=ueADmJunE98yVEB1BHxJZN7gk8dAogP3Z/0Ky+rZnLRboNll3reNkVuC+6XlGx0YLzhABfCa4TPAjZmr69IQET8vgdSnnrXdBnToMFw3azim3ix5zVuIXkw7WsYKdcaSrFt14iO7lFlXGpHJxSqIF97RQHxIEC2du22zX7vjW5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744160867; c=relaxed/simple;
	bh=u5+KmKNsj7/x/JUn/jxebrUev+xsdAqYCL6it27Rysc=;
	h=Date:To:From:Subject:Message-Id; b=ov9/MTj+CSZSixIQKh5NZxVof9owaonYeTwn5lLTxrCWMG3kP3UxBIofZg0Amfx/fAAuKVPnbr+uTkE/tzgKrQAAPrQdvUT8n81EE5ry2OSiqC76ihIZ0ydC1wAWiuI35PFiwY3rNqA3wly/bffT+UshsTc8MaOzgkAON6DF3C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OOMlGFWH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OOMlGFWH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67033C4CEE5;
	Wed,  9 Apr 2025 01:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744160867;
	bh=u5+KmKNsj7/x/JUn/jxebrUev+xsdAqYCL6it27Rysc=;
	h=Date:To:From:Subject:From;
	b=OOMlGFWHnViH//Eltr8YLOmhi9FEjbKPzt4nXKSlbGjrbdNsjpBaO4MESESEL5t8w
	 TNmELHdbkNkAn7WkCem673mj8g0EjeJqF9Vn/ufZZzNs8P1L2VFaKscKhkMPGrY8wZ
	 Vxmrn5yYLgpjKweKkAGhnw3ab6xrgngeu9rb1DfA=
Date: Tue, 08 Apr 2025 18:07:46 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yang@os.amperecomputing.com,x86@kernel.org,willy@infradead.org,will@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,mark.rutland@arm.com,maddy@linux.ibm.com,linus.walleij@linaro.org,geert@linux-m68k.org,davem@davemloft.net,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aou@eecs.berkeley.edu,andreas@gaisler.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-mm-clarify-ctor-mm-argument-in-alloc_ptepmd_late.patch added to mm-new branch
Message-Id: <20250409010747.67033C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: riscv: mm: clarify ctor mm argument in alloc_{pte,pmd}_late
has been added to the -mm mm-new branch.  Its filename is
     riscv-mm-clarify-ctor-mm-argument-in-alloc_ptepmd_late.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-mm-clarify-ctor-mm-argument-in-alloc_ptepmd_late.patch

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
Subject: riscv: mm: clarify ctor mm argument in alloc_{pte,pmd}_late
Date: Tue, 8 Apr 2025 10:52:20 +0100

pagetable_{pte,pmd}_ctor(mm, ptdesc) skip the ptlock initialisation if mm
is &init_mm.  To avoid unnecessary overhead, it is therefore preferable to
pass the actual mm associated to the PTE/PMD.

Unfortunately, this proves challenging for alloc_{pte,pmd}_late() as the
associated mm is not available at the point where they are called - in
fact not even top-level functions like create_pgd_mapping() are passed the
mm.  As a result they both call the ctor with NULL as mm; this is safe but
potentially wasteful.

This is not a new situation, but let's add a couple of comments to clarify
it.

Link: https://lkml.kernel.org/r/20250408095222.860601-11-kevin.brodsky@arm.com
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

 arch/riscv/mm/init.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/riscv/mm/init.c~riscv-mm-clarify-ctor-mm-argument-in-alloc_ptepmd_late
+++ a/arch/riscv/mm/init.c
@@ -442,6 +442,11 @@ static phys_addr_t __meminit alloc_pte_l
 {
 	struct ptdesc *ptdesc = pagetable_alloc(GFP_KERNEL & ~__GFP_HIGHMEM, 0);
 
+	/*
+	 * We do not know which mm the PTE page is associated to at this point.
+	 * Passing NULL to the ctor is the safe option, though it may result
+	 * in unnecessary work (e.g. initialising the ptlock for init_mm).
+	 */
 	BUG_ON(!ptdesc || !pagetable_pte_ctor(NULL, ptdesc));
 	return __pa((pte_t *)ptdesc_address(ptdesc));
 }
@@ -522,6 +527,7 @@ static phys_addr_t __meminit alloc_pmd_l
 {
 	struct ptdesc *ptdesc = pagetable_alloc(GFP_KERNEL & ~__GFP_HIGHMEM, 0);
 
+	/* See comment in alloc_pte_late() regarding NULL passed the ctor */
 	BUG_ON(!ptdesc || !pagetable_pmd_ctor(NULL, ptdesc));
 	return __pa((pmd_t *)ptdesc_address(ptdesc));
 }
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

