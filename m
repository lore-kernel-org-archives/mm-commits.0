Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A6837B03F
	for <mm-commits@vger.kernel.org>; Sat,  8 Aug 2026 16:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786208288; cv=none; b=Kdur3jyHAyB02TEFXjoYQM2KR/Uo1M8qJwMLdGULY3Svxi678cO3Ln+gBkipIK77d/2LxuiO4y4cplU+/303RiAyEsV9Ji2WkKDxP4xcpDEVq77LzJl/cyqYj+ozbSb57TikOOlFhNIB/MA8/U3YwTXS05DwZVA0UILLAPWuGsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786208288; c=relaxed/simple;
	bh=2FM/GTbdIRm7k2seVr6rhQ6HDwDVjCXEyM9wcGI0akE=;
	h=Date:To:From:Subject:Message-Id; b=lnY3T7fQHTLG8sAt5ZA7mVGDgkjuUmlwjvDeI8M1x8jtViuiOlkiOwgkk9UAdXE/rgs2mtcL+FgEUTluFZcMQJGxto4zh5o2AVUBlSbOsHdXkjokWvPZchtKFKYSY1Cy6F92r5t6ODFrid8pEhFi0b7DRVGiJXZBNcpVZ9gFnvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y2emTjoP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y2emTjoP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 673711F000E9;
	Sat,  8 Aug 2026 16:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786208286;
	bh=Emfw1pk7UgbM7GMs/iczeB9muuiAFtjjpn2sx3yxCPg=;
	h=Date:To:From:Subject;
	b=Y2emTjoPWFVSq3I5pRup6ri+FaBtuGGODT9PQN8LBlriKEG+r1gsxso6pPoFA/MaY
	 ZlbyNa/xZvPHXGT+/CyTb1C+JoQMCTKzNjNZIlvkDff6QtKSiVh7dppj5FGT4PGf0u
	 Vw7yoaFzwUSjwe/O21CrkQZyP9XlrAbOtukL7exM=
Date: Sat, 08 Aug 2026 09:58:06 -0700
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,will@kernel.org,urezki@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,leo.yan@arm.com,jiangwenxiaomi@gmail.com,jiangwen6@xiaomi.com,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,anshuman.khandual@arm.com,ajd@linux.ibm.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte.patch removed from -mm tree
Message-Id: <20260808165806.673711F000E9@smtp.kernel.org>
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
Date: Wed, 15 Jul 2026 20:08:08 +0800

Allow arch_vmap_pte_range_map_size to batch across multiple CONT_PTE
blocks, reducing both PTE setup and TLB flush iterations.

For CONT_PTE_SIZE-aligned ranges, return a power-of-two mapping size that
may cover multiple CONT_PTE blocks, capped below PMD_SIZE.  These sizes
are vmalloc mapping spans, not HugeTLB hstate sizes.

Link: https://lore.kernel.org/20260715120813.3609949-3-jiangwen6@xiaomi.com
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

 arch/arm64/include/asm/vmalloc.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/arch/arm64/include/asm/vmalloc.h~arm64-vmalloc-allow-arch_vmap_pte_range_map_size-to-batch-multiple-cont_pte
+++ a/arch/arm64/include/asm/vmalloc.h
@@ -23,10 +23,14 @@ static inline unsigned long arch_vmap_pt
 						unsigned long end, u64 pfn,
 						unsigned int max_page_shift)
 {
+	unsigned long size;
+
 	/*
 	 * If the block is at least CONT_PTE_SIZE in size, and is naturally
 	 * aligned in both virtual and physical space, then we can pte-map the
 	 * block using the PTE_CONT bit for more efficient use of the TLB.
+	 * The returned mapping size may cover multiple CONT_PTE_SIZE blocks,
+	 * capped below PMD_SIZE.
 	 */
 	if (max_page_shift < CONT_PTE_SHIFT)
 		return PAGE_SIZE;
@@ -40,7 +44,9 @@ static inline unsigned long arch_vmap_pt
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

mm-vmalloc-extend-page-table-walk-to-support-larger-page_shift-sizes-and-eliminate-page-table-rewalk.patch
mm-vmalloc-map-contiguous-pages-in-batches-for-vmap-if-possible.patch
mm-vmalloc-align-vm_area-so-vmap-can-batch-mappings.patch

