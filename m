Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B56190696
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011088; cv=none; b=XwRUw5/bQkcdJSDb/8Z+n3pLdF92T7SHQCwlZHNSxO3pxhSHaOUWP6fcaFjyXzPDcDAzQXBZjkegFcp7vfyc5tyTF/Jl6hKndZttuylkcDM8LqSPeKrhdQBa+10UxGN/Pfk1SmFv8FXKU7rQxIX5CvN/LPKuFrcEI+BZ77l1JME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011088; c=relaxed/simple;
	bh=XTT+X/vGMXxN8Hq50YverAmxOf4yycTWKUtDtwjYs+Y=;
	h=Date:To:From:Subject:Message-Id; b=OTairPWeGqVvTGpIdiXTdOU7gwNXGQ2hPv8kP+oq75NkGtNkFxWpSmpgVGNLdH3ZZJCm+IqjK8AXfCbf33OQB0ZrcXIEZksg65UAOkE/Nq4elT/EemHgCjqPnMg41R7x/2Vat5gGPyuQylaEAGEkkmxx/ahwyEssmUlHt/RbkA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bmfHRYUO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bmfHRYUO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936D1C4CEE4;
	Mon, 12 May 2025 00:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011088;
	bh=XTT+X/vGMXxN8Hq50YverAmxOf4yycTWKUtDtwjYs+Y=;
	h=Date:To:From:Subject:From;
	b=bmfHRYUOjFOU4Z/fYXZsslNKUYkF2bLkiNpSitWSjqK+aIH9wm5zLXjGhOQLaXJCt
	 gBj8N3DRZDTNbzH2+L9xoFxe9pJOU9U+pT2hIQuTlEyNhwOTxz4KiHkVkre+IuasQL
	 kL/b545I29uaaSRzo444klcgF5KFOTxJf42WKyoI=
Date: Sun, 11 May 2025 17:51:28 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yang@os.amperecomputing.com,x86@kernel.org,willy@infradead.org,will@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,mark.rutland@arm.com,maddy@linux.ibm.com,linus.walleij@linaro.org,geert@linux-m68k.org,davem@davemloft.net,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aou@eecs.berkeley.edu,andreas@gaisler.com,agordeev@linux.ibm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mm-call-pud-p4d-ctor-in-__create_pgd_mapping.patch removed from -mm tree
Message-Id: <20250512005128.936D1C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: mm: call PUD/P4D ctor in __create_pgd_mapping()
has been removed from the -mm tree.  Its filename was
     arm64-mm-call-pud-p4d-ctor-in-__create_pgd_mapping.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


