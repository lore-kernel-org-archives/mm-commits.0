Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A849929D292
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489904; cv=none; b=QuF/EwMDNvy3muQ6aKwevGwSQ3BKNfu22bxxzbi7HGStnsSDfVFi1QNm1wZ4FpBBN8/Sjo1ZdEuOpLxsU83YeVV8mWb97AW3Shk4c3wt13jQPop1M/8RyEGjjOKgrkt0dDeg8UFZP3ozUrWlK41viKSE31f/DcQuqiCxxoDbEGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489904; c=relaxed/simple;
	bh=ujUUEjxgo6B5f2/aTUl3ECwZ0e86wfKbFZF6D0Efhcw=;
	h=Date:To:From:Subject:Message-Id; b=nGymzzX+T1Hs+RGA2T8j2NetbkmgmFvzgaDf+EqGQVfDcjRLMdj9uHjjW2u84P3UqGglrNevSgjTjkbVHxywWGPsM0BN0aiu00a5DLYGInLSnFXa053OmkOsKHrG03qmLIEgYmG7AKE8HiVnijg8SI8iz13YxkGJzbox3k6HOoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K3GOdg3D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K3GOdg3D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DCF8C4CEE7;
	Sun, 21 Sep 2025 21:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489904;
	bh=ujUUEjxgo6B5f2/aTUl3ECwZ0e86wfKbFZF6D0Efhcw=;
	h=Date:To:From:Subject:From;
	b=K3GOdg3D7x4UwAq6k0avcwZCEPWfnI6d5XjssjhKyOEMez2/M3WxtT5uE5CSKlz8A
	 rFFU3JWqFX4D5GWn9nfhCXRXCTZs/hs7UUzAJiuCDmt2jRJbBP4ZuTT7qYtxY4iHSF
	 lwNWCPyUCI0IrewNHMDpfVXC73D3lnfJILOcBHYk=
Date: Sun, 21 Sep 2025 14:25:03 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,sj@kernel.org,rppt@kernel.org,ritesh.list@gmail.com,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mst@redhat.com,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,justin@coraid.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,axboe@kernel.dk,aou@eecs.berkeley.edu,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-stop-calling-page_address-in-free_pages.patch removed from -mm tree
Message-Id: <20250921212504.6DCF8C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: stop calling page_address() in free_pages()
has been removed from the -mm tree.  Its filename was
     arm64-stop-calling-page_address-in-free_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: arm64: stop calling page_address() in free_pages()
Date: Wed, 3 Sep 2025 11:59:20 -0700

free_pages() should be used when we only have a virtual address.  We
should call __free_pages() directly on our page instead.

Link: https://lkml.kernel.org/r/20250903185921.1785167-7-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Justin Sanders <justin@coraid.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/mm/mmu.c~arm64-stop-calling-page_address-in-free_pages
+++ a/arch/arm64/mm/mmu.c
@@ -836,7 +836,7 @@ static void free_hotplug_page_range(stru
 		vmem_altmap_free(altmap, size >> PAGE_SHIFT);
 	} else {
 		WARN_ON(PageReserved(page));
-		free_pages((unsigned long)page_address(page), get_order(size));
+		__free_pages(page, get_order(size));
 	}
 }
 
_

Patches currently in -mm which might be from vishal.moola@gmail.com are


