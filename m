Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4038D217664
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188392; cv=none; b=ai8u1M+dLuvbOrY+Ae2etxrF0iAw6iqbvtjIAru3ngElNCz1pUz88NomE79UpLWtu34VlIh8/EtKIQH4qph1naLe2VdB7mQT/6b6ENzntlO7S4gNI3sVf/T5As57HBJBn4XUrYIbOsUZfDm4kix4kWv1xvPAvXzQVX1x8ZfKwsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188392; c=relaxed/simple;
	bh=LiBrjbaSh5V4Dw7m6YUyreRFGEr4Bzwjdn3/ieKLOrQ=;
	h=Date:To:From:Subject:Message-Id; b=oBrJ39ZkurAsyK0SoC1TxjUt2WSR8/DLfU7gkOaP8Gcz4LwhA2/nHwXNREqu8DG/yFXBmf5Ez72TGK/B45Px4iVzF7O8cl2fHNsXnAjJVScltOWqlSk6asQGuGKcBI2c1dXBhoFQ1rwWTtShCO7FsnQe+kIjQGupa+qDPE41ubw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IxDACHNQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IxDACHNQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12BEFC4CEEC;
	Mon, 17 Mar 2025 05:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188392;
	bh=LiBrjbaSh5V4Dw7m6YUyreRFGEr4Bzwjdn3/ieKLOrQ=;
	h=Date:To:From:Subject:From;
	b=IxDACHNQ/RqbmmV/dC6SFhSH4gvNZmc7LHSIT/qNIlIubglFwQKoqx6m3J1GpyMI9
	 /pLpM9LA1r6Nbsqi/Xi8/og4MYnvbtvrqn13kepFf5jwc/Ds8ov+7X0KIy1NXjNi+r
	 fjwyiPrqhFt3ABvOyu2alL4kX5pjTQRsl8vJCkiw=
Date: Sun, 16 Mar 2025 22:13:11 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,usamaarif642@gmail.com,roman.gushchin@linux.dev,peterz@infradead.org,osalvador@suse.de,muchun.song@linux.dev,mpe@ellerman.id.au,maddy@linux.ibm.com,luto@kernel.org,joao.m.martins@oracle.com,hca@linux.ibm.com,hannes@cmpxchg.org,gor@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,arnd@arndb.de,agordeev@linux.ibm.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-setup-call-hugetlb_bootmem_alloc-early.patch removed from -mm tree
Message-Id: <20250317051312.12BEFC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/setup: call hugetlb_bootmem_alloc early
has been removed from the -mm tree.  Its filename was
     x86-setup-call-hugetlb_bootmem_alloc-early.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Frank van der Linden <fvdl@google.com>
Subject: x86/setup: call hugetlb_bootmem_alloc early
Date: Fri, 28 Feb 2025 18:29:21 +0000

Call hugetlb_bootmem_allloc in an earlier spot in setup, after
hugelb_cma_reserve.  This will make vmemmap preinit of the sections
covered by the allocated hugetlb pages possible.

Link: https://lkml.kernel.org/r/20250228182928.2645936-21-fvdl@google.com
Signed-off-by: Frank van der Linden <fvdl@google.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/setup.c~x86-setup-call-hugetlb_bootmem_alloc-early
+++ a/arch/x86/kernel/setup.c
@@ -1108,8 +1108,10 @@ void __init setup_arch(char **cmdline_p)
 	initmem_init();
 	dma_contiguous_reserve(max_pfn_mapped << PAGE_SHIFT);
 
-	if (boot_cpu_has(X86_FEATURE_GBPAGES))
+	if (boot_cpu_has(X86_FEATURE_GBPAGES)) {
 		hugetlb_cma_reserve(PUD_SHIFT - PAGE_SHIFT);
+		hugetlb_bootmem_alloc();
+	}
 
 	/*
 	 * Reserve memory for crash kernel after SRAT is parsed so that it
_

Patches currently in -mm which might be from fvdl@google.com are


