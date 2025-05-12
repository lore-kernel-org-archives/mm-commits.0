Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D69C2FB
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011079; cv=none; b=HvaoSEaUmHUFrWys5EJ8bm3l6M8+Y/1gjT7fhz8jCQeQL6kLeQ3baZGVgbW9gSxiD7YI5H8KX6kTMMqTHhHidTEMYjXuRhSfpPxK7ITllE54jxhZ1IHaNF9ZXcP0mICl6yzQ42BoySDJMF8AwULcwCSECIgsMQiSTwAJx+wF4Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011079; c=relaxed/simple;
	bh=0R6j0nSujTqftciKPTPiRz/8jQWWOLLW3fUkHzp3qEI=;
	h=Date:To:From:Subject:Message-Id; b=OMI8uB/2Q08UXXON9FQN5YUe8+3D1/l3Z0g2V2TVTUkyhYd/DNtUvpsRaex3cSz5EreKlIQgxg/nkgNI0qrT09gsT2v69C7SOpaUoSFe5FGdndIEn0fqeZ4IWQRaczmX7PZ/7qi8x4cacvfNH2AeDKVGUd1kere/3oJx23UxzeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zHnxV/GH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zHnxV/GH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9954C4CEE4;
	Mon, 12 May 2025 00:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011078;
	bh=0R6j0nSujTqftciKPTPiRz/8jQWWOLLW3fUkHzp3qEI=;
	h=Date:To:From:Subject:From;
	b=zHnxV/GHTvwwTIL6zLAPslj+Dn25IawIlUG2bRmQdRIbx8A2NHiaagCTRCB6xLsbV
	 FCG+zpebSKbWmLUHdP4afDCWeziocqCWUQRASzLIHSEliSSmDo8SLQM0dI4Kyg8gAI
	 iogYDds/eru6MPkn5RzN5atKCbrQip/UltUAfcno=
Date: Sun, 11 May 2025 17:51:18 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yang@os.amperecomputing.com,x86@kernel.org,willy@infradead.org,will@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,mark.rutland@arm.com,maddy@linux.ibm.com,linus.walleij@linaro.org,geert@linux-m68k.org,davem@davemloft.net,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aou@eecs.berkeley.edu,andreas@gaisler.com,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] m68k-mm-call-ctor-dtor-for-kernel-ptes.patch removed from -mm tree
Message-Id: <20250512005118.C9954C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: m68k: mm: call ctor/dtor for kernel PTEs
has been removed from the -mm tree.  Its filename was
     m68k-mm-call-ctor-dtor-for-kernel-ptes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


