Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E28629A2
	for <mm-commits@vger.kernel.org>; Wed,  9 Apr 2025 01:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744160853; cv=none; b=RCCLphnT9JhoIztTkVDO93jJP2wvnKThb2iuCaaVXbXOcSOx4TNTWjwmQauNMfXI/nduDfikasPeKcbN8O48XvD/a+y5Fpvqd/exO2WnihTM8ccyjk+OAd9uNNekuPNtlMLpJTDk56UzlXV7CzzNZz8q7w0BkCbyJwcq2ftthwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744160853; c=relaxed/simple;
	bh=MPPeD5oGVvjIA73BatcT4P3ZnwNZSsMEC8NV4VGokQw=;
	h=Date:To:From:Subject:Message-Id; b=Y757pB1Lw2LJ6MJkz1/niyxToS3Py5zCLUtoY33AJ7d7YB3JOye3ClzKReBY0whkt4t3xu1aZd3+ffUhZxZS5jGq+jvwojhQvnMMqIpl/E/a9P/4WnpPQecuH18AOc29eLNJJ1FpPq6+8XhhhZ/WAaSsMuoXTJ8G6lprjMTbZjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CT4kOpKk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CT4kOpKk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4706C4CEE5;
	Wed,  9 Apr 2025 01:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744160851;
	bh=MPPeD5oGVvjIA73BatcT4P3ZnwNZSsMEC8NV4VGokQw=;
	h=Date:To:From:Subject:From;
	b=CT4kOpKkC+uEoM4mBYnAPPfoDxnqq14L4/G0wDwUFNZ7By6ax6oIqI8J+zDF/IwsM
	 Hju7OQ9UH5IaCTxvwj+KOLBaAnyHDNT36VQg2lpApxJ7sfd1PJAngwjQch3vHUXU/h
	 jT/XeZOyldlVHvtb6ocpp5zlkPKOQI8hidN37ypc=
Date: Tue, 08 Apr 2025 18:07:31 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yang@os.amperecomputing.com,x86@kernel.org,willy@infradead.org,will@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,mark.rutland@arm.com,maddy@linux.ibm.com,linus.walleij@linaro.org,geert@linux-m68k.org,davem@davemloft.net,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aou@eecs.berkeley.edu,andreas@gaisler.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + m68k-mm-call-ctor-dtor-for-kernel-ptes.patch added to mm-new branch
Message-Id: <20250409010731.D4706C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: m68k: mm: call ctor/dtor for kernel PTEs
has been added to the -mm mm-new branch.  Its filename is
     m68k-mm-call-ctor-dtor-for-kernel-ptes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/m68k-mm-call-ctor-dtor-for-kernel-ptes.patch

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
Subject: m68k: mm: call ctor/dtor for kernel PTEs
Date: Tue, 8 Apr 2025 10:52:14 +0100

The generic implementation of pte_{alloc_one,free}_kernel now calls the
[cd]tor.  Align the m68k/ColdFire implementation of those functions by
calling the [cd]tor explicitly.

Link: https://lkml.kernel.org/r/20250408095222.860601-5-kevin.brodsky@arm.com
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

 arch/m68k/include/asm/mcf_pgalloc.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/m68k/include/asm/mcf_pgalloc.h~m68k-mm-call-ctor-dtor-for-kernel-ptes
+++ a/arch/m68k/include/asm/mcf_pgalloc.h
@@ -7,7 +7,7 @@
 
 static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
 {
-	pagetable_free(virt_to_ptdesc(pte));
+	pagetable_dtor_free(virt_to_ptdesc(pte));
 }
 
 extern const char bad_pmd_string[];
@@ -19,6 +19,10 @@ static inline pte_t *pte_alloc_one_kerne
 
 	if (!ptdesc)
 		return NULL;
+	if (!pagetable_pte_ctor(mm, ptdesc)) {
+		pagetable_free(ptdesc);
+		return NULL;
+	}
 
 	return ptdesc_address(ptdesc);
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

