Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAB0C2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011087; cv=none; b=sPta6FvC+5bVYeZDE1as+3a3DsgUDhwsE9qYdpqRaVA9bj5BXMI2BtybF52mReUfBR6hMEi6ocQKqmCUH1pTNKzdPc0P1Il+OHmEADyJWyg27JjX0EXB2TxzXB3aLQB09836q9QJ5pbLPjlxGng4G1sxwHemRlBhvhWmuydgcBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011087; c=relaxed/simple;
	bh=KwJaFLO/ehHuAAyqRNMxVu3ivThyDNp03HAj+WTHe+A=;
	h=Date:To:From:Subject:Message-Id; b=SUQLOJcGWpKLWepTDQTrHQqnte/rim7OUeAAiNS1RfsrsuJ0m5HTEdfFBbEzcCZfEHzkyAcjzoSkQk3PZHy+rmzBMrSQ1qw/aWyBlnFRMiOYkQZ8T3NQMKquxMQ//4hSuZu0mYZMjU6QH0wYf9HujqLpyB+U4HIBRgLcSjKnY6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IZu70qbk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IZu70qbk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33040C4CEE4;
	Mon, 12 May 2025 00:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011087;
	bh=KwJaFLO/ehHuAAyqRNMxVu3ivThyDNp03HAj+WTHe+A=;
	h=Date:To:From:Subject:From;
	b=IZu70qbkioAf1v0uSxWcHAKEbM+eOnHliuBcTZsD+uafJfYqgqMVQs3CCybQYTcPC
	 Pi7JTbAduR4SpYIyV5Il6V5LU0omhMG2BNtrn3W5IVNiBvEjO2qQxPKiy5V+/GV2pQ
	 2HMooiw6I0WrkF44KaaVTk9n+y/i22jJwnsD/atA=
Date: Sun, 11 May 2025 17:51:26 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yang@os.amperecomputing.com,x86@kernel.org,willy@infradead.org,will@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,mark.rutland@arm.com,maddy@linux.ibm.com,linus.walleij@linaro.org,geert@linux-m68k.org,davem@davemloft.net,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aou@eecs.berkeley.edu,andreas@gaisler.com,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] riscv-mm-clarify-ctor-mm-argument-in-alloc_ptepmd_late.patch removed from -mm tree
Message-Id: <20250512005127.33040C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: riscv: mm: clarify ctor mm argument in alloc_{pte,pmd}_late
has been removed from the -mm tree.  Its filename was
     riscv-mm-clarify-ctor-mm-argument-in-alloc_ptepmd_late.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


