Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794207846;
	b=qnd6+c8ypq+U8bIYJzG//OaNXiLMIsHpmRVsEmz7Ol5oFOxO1yrm7RCpS0LnDmLsY7d2
	 1fgbEh+Lm08QYosdrRnPalkYkMDmcHOPTvDPGDlS4IFL5n8O6XzXj788PmGuAEIzrKwp3
	 679yEgNhHvWrhvuF1znG6Hin3OxJ0izcmoX76pThSvDQ2/wh7+Ubz+GNg3TKaa+AHOiTU
	 fLGxOAswKN8QtwTov2aNeN3UDib9bLj+oCDCB/EFfpmvMFTEAvgIamv6hVlNy+TlpG1QR
	 +9LPQiwDTyWQXtWVkLhvmHJFU/P3yO5SJ+IcGptBhtFSdeYwAQsLivWxepg+S9arwkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794207846;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=lnQZl7sB2RjkItr09OUEhaSWSOcdnq+LaozYdLzGPLU=;
	b=VRtFUlit70kM1ecmyYDkGWzy6p0/mMUhTOHNXs2WwgfWOiyzoD27lm8oqD/vqyxL9/gw
	 aZ58MtgFaLOEzNMg7dM7x5AKY2rKpXUaS1jSdnqB5uqzWvcrZ47nyazkEvsm7CEsRgt/4
	 ZGuobP60UjoZIj7eFRKhizW3g5qXKWCCJLPzy8HJJV442NtuuAKmJC49lKkYmBZN5mBvP
	 4LXWFg7e9loz55pBd+maZ5lgY7bsLTCO7DAyghBb5UzsS5hXCHI97dema4OMiz50oIlYp
	 RwkZCZNno+97SOvVRESnQ4KW0h2Lgi6POJveMlUrvvbsiCndka02mBkMo+gen2AbRyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pDdYgVsm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E42B606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 07:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pDdYgVsm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00211F0089F;
	Mon,  9 Nov 2026 07:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794207845;
	bh=lnQZl7sB2RjkItr09OUEhaSWSOcdnq+LaozYdLzGPLU=;
	h=Date:To:From:Subject;
	b=pDdYgVsmyTdc9ZF86r4rXVpKDFlXe6J8liQOTIs8eGs3FpvMKVFTh2AMNKbWdXveN
	 ePSA5/pv0BurlKLrM5SsdeG4Qj54bONWlMj/Uxq2Z3GAenxmzlD6rgSyx0IMEEvI8a
	 cW4UN9dBT62k5RPMxrooxzkT3VZA7LWQMDqPxS9w=
Date: Sun, 08 Nov 2026 23:04:05 -0800
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,will@kernel.org,
	urezki@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,npiggin@gmail.com,
	mpe@ellerman.id.au,maddy@linux.ibm.com,leo.yan@arm.com,
	jiangwenxiaomi@gmail.com,jiangwen6@xiaomi.com,dev.jain@arm.com,
	david@kernel.org,chleroy@kernel.org,catalin.marinas@arm.com,
	anshuman.khandual@arm.com,andrew+kernel@donnellan.id.au,baohua@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte.patch added to mm-new branch
Message-Id: <20261109070405.D00211F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: arm64/vmalloc: allow arch_vmap_pte_range_map_size() to batch multiple CONT_PTE
has been added to the -mm mm-new branch.  Its filename is
     arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: arm64/vmalloc: allow arch_vmap_pte_range_map_size() to batch multiple CONT_PTE
Date: Sat, 07 Nov 2026 21:49:48 +0800

Allow arch_vmap_pte_range_map_size to batch across multiple CONT_PTE
blocks, reducing both PTE setup and TLB flush iterations.

Previously the function returned a single CONT_PTE_SIZE for an aligned
range, so the caller mapped one CONT_PTE block per iteration. Now, for a
CONT_PTE_SIZE-aligned range, it returns the largest CONT_PTE-aligned size
that fits within both the remaining range and the caller's max_page_shift,
so a single vmap_pte_set_huge() call installs several CONT_PTE blocks at
once.

Link: https://lore.kernel.org/20261107134953.748622-6-jiangwenxiaomi@gmail.com
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Andrew Donnellan <andrew+kernel@donnellan.id.au>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>
---

 arch/arm64/include/asm/vmalloc.h |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/arch/arm64/include/asm/vmalloc.h~arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte
+++ a/arch/arm64/include/asm/vmalloc.h
@@ -23,10 +23,12 @@ static inline unsigned long arch_vmap_pt
 						unsigned long end, u64 pfn,
 						unsigned int max_page_shift)
 {
+	unsigned long size;
+
 	/*
-	 * If the block is at least CONT_PTE_SIZE in size, and is naturally
-	 * aligned in both virtual and physical space, then we can pte-map the
-	 * block using the PTE_CONT bit for more efficient use of the TLB.
+	 * If the range is at least CONT_PTE_SIZE and naturally aligned in both
+	 * virtual and physical space, return the largest CONT_PTE-aligned size
+	 * that fits, for more efficient use of the TLB.
 	 */
 	if (max_page_shift < CONT_PTE_SHIFT)
 		return PAGE_SIZE;
@@ -40,7 +42,9 @@ static inline unsigned long arch_vmap_pt
 	if (!IS_ALIGNED(PFN_PHYS(pfn), CONT_PTE_SIZE))
 		return PAGE_SIZE;
 
-	return CONT_PTE_SIZE;
+	size = min(end - addr, 1UL << max_page_shift);
+	size = round_down(size, CONT_PTE_SIZE);
+	return size;
 }
 
 #define arch_vmap_pte_range_unmap_size arch_vmap_pte_range_unmap_size
_

Patches currently in -mm which might be from baohua@kernel.org are

arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte.patch
mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch
mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch

