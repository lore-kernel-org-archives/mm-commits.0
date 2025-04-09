Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB02714D70E
	for <mm-commits@vger.kernel.org>; Wed,  9 Apr 2025 01:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744160869; cv=none; b=OpfH3KJ/lbpiKfxiCOI188aAI4edXZLPrmU+7Ox0o9tW6WZgHNKJT0fufDWBpQfVha5+y7LiXZzL1l34VhCPfHlNt43oTDhvvMqIm0n+5xVePBK4Ximk3iQsFiJu3jLcuWOl5JwNKN3gBNLeC4+T/MgXKNx8AQS/aNvIjoOueSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744160869; c=relaxed/simple;
	bh=Ktv7oQt97Li8gjE+LtWGKpkjIIhYEDLdLwwFPy5qKJA=;
	h=Date:To:From:Subject:Message-Id; b=hhWMiroWgBJNv95fXsoVszANQcpfuikK4ru/a+vwpR4Ravokl+Pm8/2D88nyXVeV69e2ghXXu2sgj8sGNx/O20tQptwWCm4M6dW1jsHKzKLBo0dFcJxDCoIGUIZ2R99QBKPVCfvs8jGdlW8zrxXjmbLzJncf1V6hc2/FCj2SkiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yCuiapoA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yCuiapoA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC05C4CEE5;
	Wed,  9 Apr 2025 01:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744160869;
	bh=Ktv7oQt97Li8gjE+LtWGKpkjIIhYEDLdLwwFPy5qKJA=;
	h=Date:To:From:Subject:From;
	b=yCuiapoAlxQ85216+RK99rm1DMEiQIfKgJCWMzIpq4P/znk2KJDO/tx4c/693i8/Y
	 ppyGitoL9v+klo2VK403E9YAyWDGDE8+E8+LZqT0SMZ4hrTMccFLMagbspmOgwYvxc
	 YFU2Cg4/mXPZfFhmeF2gw5oe3erZytLsq+dNc0wk=
Date: Tue, 08 Apr 2025 18:07:49 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yang@os.amperecomputing.com,x86@kernel.org,willy@infradead.org,will@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,mark.rutland@arm.com,maddy@linux.ibm.com,linus.walleij@linaro.org,geert@linux-m68k.org,davem@davemloft.net,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aou@eecs.berkeley.edu,andreas@gaisler.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-call-pud-p4d-ctor-in-__create_pgd_mapping.patch added to mm-new branch
Message-Id: <20250409010749.8FC05C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64: mm: call PUD/P4D ctor in __create_pgd_mapping()
has been added to the -mm mm-new branch.  Its filename is
     arm64-mm-call-pud-p4d-ctor-in-__create_pgd_mapping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-call-pud-p4d-ctor-in-__create_pgd_mapping.patch

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
Subject: arm64: mm: call PUD/P4D ctor in __create_pgd_mapping()
Date: Tue, 8 Apr 2025 10:52:21 +0100

Constructors for PUD/P4D-level pgtables were recently introduced.  They
should be called for all pgtables; make sure they are called for special
kernel mappings created by __create_pgd_mapping() too.

Link: https://lkml.kernel.org/r/20250408095222.860601-12-kevin.brodsky@arm.com
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

 arch/arm64/mm/mmu.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/arm64/mm/mmu.c~arm64-mm-call-pud-p4d-ctor-in-__create_pgd_mapping
+++ a/arch/arm64/mm/mmu.c
@@ -497,7 +497,11 @@ static phys_addr_t __pgd_pgtable_alloc(s
 	case TABLE_PMD:
 		BUG_ON(!pagetable_pmd_ctor(mm, ptdesc));
 		break;
-	default:
+	case TABLE_PUD:
+		pagetable_pud_ctor(ptdesc);
+		break;
+	case TABLE_P4D:
+		pagetable_p4d_ctor(ptdesc);
 		break;
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

