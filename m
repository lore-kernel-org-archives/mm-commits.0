Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A301482F2
	for <mm-commits@vger.kernel.org>; Wed,  9 Apr 2025 01:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744160856; cv=none; b=oRC/nB+I7UFDAXtuGPEq/Rx1a/kAz755kIcNS5BSBmd8nYn/LIH5av7h2uFyOIgVpzr3lMFCeliTU/4QR8wxDAi0MQ9RzTsOTOU20mik5LT32sj9tKIDr4f8kehEvwZ7wLnIBq3cIoPWJ9cEQH4biNVuFgQ4SPFXHisSQly8lII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744160856; c=relaxed/simple;
	bh=4GuIqNG1RYhEBFSAFRZAvZk6y8bQGNH+oqSGAdVSjCo=;
	h=Date:To:From:Subject:Message-Id; b=GJunsBFpY966/W7HsAA0oArtCF6BtjQoHUGXRHruMv8POO8zGUpTVzXeFGualflxgCtPZ0pLLZ6ndfFVlqQrJ87q1vbJ3dt7KL3LPkfqkg+sZCI7B2VhKPfbe6WeACU1KOaooLX+0My72bRIN/JUuXpNK8yyUoLJVh/cbEuuJY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A+amtGsC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A+amtGsC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4DCC4CEE9;
	Wed,  9 Apr 2025 01:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744160856;
	bh=4GuIqNG1RYhEBFSAFRZAvZk6y8bQGNH+oqSGAdVSjCo=;
	h=Date:To:From:Subject:From;
	b=A+amtGsCm1X83sE3Rx9+243oGqA0Wf8QwpwcTSBjUXeYoJoUiGa4O1qz1AcbbeAgU
	 ASOEYg73i+0/5DpIu+ajGPQZHe+szJQYXvypeiKdUUis3ywv1hWFNx+LkJlKKJIh5z
	 MAYyj78f4Yt4ant5ZjLckHipZ+KvTcvM238VbcAE=
Date: Tue, 08 Apr 2025 18:07:33 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yang@os.amperecomputing.com,x86@kernel.org,willy@infradead.org,will@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,mark.rutland@arm.com,maddy@linux.ibm.com,linus.walleij@linaro.org,geert@linux-m68k.org,davem@davemloft.net,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aou@eecs.berkeley.edu,andreas@gaisler.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-mm-call-ctor-dtor-for-kernel-ptes.patch added to mm-new branch
Message-Id: <20250409010734.0C4DCC4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc: mm: call ctor/dtor for kernel PTEs
has been added to the -mm mm-new branch.  Its filename is
     powerpc-mm-call-ctor-dtor-for-kernel-ptes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-mm-call-ctor-dtor-for-kernel-ptes.patch

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
Subject: powerpc: mm: call ctor/dtor for kernel PTEs
Date: Tue, 8 Apr 2025 10:52:15 +0100

The generic implementation of pte_{alloc_one,free}_kernel now calls the
[cd]tor, without initialising the ptlock needlessly as
pagetable_pte_ctor() skips it for init_mm.

On powerpc, all functions related to PTE allocation are implemented by
common helpers, which are passed a boolean to differentiate user from
kernel pgtables.  This patch aligns the powerpc implementation with the
generic one by calling pagetable_pte_[cd]tor() unconditionally in those
helpers.

Link: https://lkml.kernel.org/r/20250408095222.860601-6-kevin.brodsky@arm.com
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

 arch/powerpc/mm/pgtable-frag.c |   30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

--- a/arch/powerpc/mm/pgtable-frag.c~powerpc-mm-call-ctor-dtor-for-kernel-ptes
+++ a/arch/powerpc/mm/pgtable-frag.c
@@ -56,19 +56,17 @@ static pte_t *__alloc_for_ptecache(struc
 {
 	void *ret = NULL;
 	struct ptdesc *ptdesc;
+	gfp_t gfp = PGALLOC_GFP;
 
-	if (!kernel) {
-		ptdesc = pagetable_alloc(PGALLOC_GFP | __GFP_ACCOUNT, 0);
-		if (!ptdesc)
-			return NULL;
-		if (!pagetable_pte_ctor(mm, ptdesc)) {
-			pagetable_free(ptdesc);
-			return NULL;
-		}
-	} else {
-		ptdesc = pagetable_alloc(PGALLOC_GFP, 0);
-		if (!ptdesc)
-			return NULL;
+	if (!kernel)
+		gfp |= __GFP_ACCOUNT;
+
+	ptdesc = pagetable_alloc(gfp, 0);
+	if (!ptdesc)
+		return NULL;
+	if (!pagetable_pte_ctor(mm, ptdesc)) {
+		pagetable_free(ptdesc);
+		return NULL;
 	}
 
 	atomic_set(&ptdesc->pt_frag_refcount, 1);
@@ -124,12 +122,10 @@ void pte_fragment_free(unsigned long *ta
 
 	BUG_ON(atomic_read(&ptdesc->pt_frag_refcount) <= 0);
 	if (atomic_dec_and_test(&ptdesc->pt_frag_refcount)) {
-		if (kernel)
-			pagetable_free(ptdesc);
-		else if (folio_test_clear_active(ptdesc_folio(ptdesc)))
-			call_rcu(&ptdesc->pt_rcu_head, pte_free_now);
-		else
+		if (kernel || !folio_test_clear_active(ptdesc_folio(ptdesc)))
 			pte_free_now(&ptdesc->pt_rcu_head);
+		else
+			call_rcu(&ptdesc->pt_rcu_head, pte_free_now);
 	}
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

