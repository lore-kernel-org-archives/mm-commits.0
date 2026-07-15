Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9338D431A44
	for <mm-commits@vger.kernel.org>; Wed, 15 Jul 2026 18:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784140390; cv=none; b=iyqD89jnyJRUqfcoUNS9czmJSkq46QgzOfBwA1DXC4Th+12ZqX1Bm9S5fy4JosTVcCrs9/5aLEwsF6BQ96Y3nNqTFSXD3knwbfb10uAcPczPys3DYlTTW35bRyNv1J5kYf6gAl1Dd7cSrY93p9vhd1V/aAXYaE2T0QxM3vtaoHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784140390; c=relaxed/simple;
	bh=oLcNUOGlH3Ns80Mtjlj7A2eyFMUBOFbCHrHLX+5a6cQ=;
	h=Date:To:From:Subject:Message-Id; b=Ahgh8JT3+0sgEf6WA2TrONR4NEKjwNU/34Wf2yrAk6eBNGXUFFchU0pKP4a3rRbViOnbZgWLVM0bsC2Id5EtQzoFqM5M3CL3Jkc7LdJA1bEdriFXlmHhZMrKjGZxwWh0VLMdZEEFlRirYIgLPV/9ZzAbuNya0N8Yz7ejj5KXOE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eDwZOSwY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eDwZOSwY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF121F00A3A;
	Wed, 15 Jul 2026 18:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784140373;
	bh=vqT8WHj/+IlzX0W9HTj+Bt5BGGunO1VixRj6/+atLHc=;
	h=Date:To:From:Subject;
	b=eDwZOSwYSdvmU7h7nVuUN77QIKHv0YXXgb4ageinU6KtGH46UQ4YjFwpHESFHYqtV
	 ih7g3cZK8TRiYFUTiFmvNuRSil+NsCKadm28w3jlBIV4yqJoNR7Ha58M26hr+Da2l4
	 BzxmeR6w2pCQnu/4pBaQmr7DdYFOlL6zeUahb3gM=
Date: Wed, 15 Jul 2026 11:32:52 -0700
To: mm-commits@vger.kernel.org,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte.patch removed from -mm tree
Message-Id: <20260715183253.5DF121F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64/vmalloc: allow arch_vmap_pte_range_map_size to batch multiple CONT_PTE
has been removed from the -mm tree.  Its filename was
     arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: arm64/vmalloc: allow arch_vmap_pte_range_map_size to batch multiple CONT_PTE
Date: Thu, 9 Jul 2026 15:38:19 +0800

Allow arch_vmap_pte_range_map_size to batch across multiple CONT_PTE
blocks, reducing both PTE setup and TLB flush iterations.

Link: https://lore.kernel.org/20260709073823.6643-3-jiangwen6@xiaomi.com
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Andrew Donnellan <ajd@linux.ibm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/vmalloc.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/arm64/include/asm/vmalloc.h~arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte
+++ a/arch/arm64/include/asm/vmalloc.h
@@ -23,6 +23,8 @@ static inline unsigned long arch_vmap_pt
 						unsigned long end, u64 pfn,
 						unsigned int max_page_shift)
 {
+	unsigned long size;
+
 	/*
 	 * If the block is at least CONT_PTE_SIZE in size, and is naturally
 	 * aligned in both virtual and physical space, then we can pte-map the
@@ -40,7 +42,9 @@ static inline unsigned long arch_vmap_pt
 	if (!IS_ALIGNED(PFN_PHYS(pfn), CONT_PTE_SIZE))
 		return PAGE_SIZE;
 
-	return CONT_PTE_SIZE;
+	size = min3(end - addr, 1UL << max_page_shift, PMD_SIZE >> 1);
+	size = rounddown_pow_of_two(size);
+	return size;
 }
 
 #define arch_vmap_pte_range_unmap_size arch_vmap_pte_range_unmap_size
_

Patches currently in -mm which might be from baohua@kernel.org are

mm-avoid-unnecessary-lru-drain-for-wp_can_reuse_anon_folio.patch
mm-avoid-unnecessary-lru-drain-for-wp_can_reuse_anon_folio-fix.patch
mm-drop-stale-folio_ref_count==1-check-in-do_swap_page-reuse-logic.patch
mm-entirely-remove-lru_add_drain-in-do_swap_page.patch
mm-clarify-the-folio_free_swap-for-do_swap_page.patch
mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch
mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch

