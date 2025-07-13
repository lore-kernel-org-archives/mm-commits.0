Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A461EF38E
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450050; cv=none; b=kPz0RogZa5o1BNHmZPxdiQiW0Q5yeWzpnCfUyKWUWxRssfMAO2a1WeguU9KMz/9fyfBA/cknNfuHsXHq0aeOO2KY0iDgumZnPJQnkG+mWgQda14/gE4v51gcw6GoAM78Y42l5Z2JTBxA2SnkvrktBsWSnRlnxVsENOZ32Hlf2ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450050; c=relaxed/simple;
	bh=UOVYXJI7YDLntCl+E4oUDZ79XhG8kCo39dSevx+2B/w=;
	h=Date:To:From:Subject:Message-Id; b=hvB+W5arTa5jgNA/0vVpB82yt5tL7e3Y0jpcM2FTE/ARsNpq7HHN7NxGP6kYuEetD8Otzg9JP/opAFzjS4pe9L/NFVAIl3viZIbSJ3qjgu1u+NPTIuV2GSV+r5z27FYjRxO233qPxYiEaIAxa57jCowA9ggRl/f6vkcm05hmiW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hl2Ad7gC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hl2Ad7gC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1ED7C4CEE3;
	Sun, 13 Jul 2025 23:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450050;
	bh=UOVYXJI7YDLntCl+E4oUDZ79XhG8kCo39dSevx+2B/w=;
	h=Date:To:From:Subject:From;
	b=hl2Ad7gCCgUSCDERDqwVrZKmud7XoRQRE6clB+VjPnmc3P1nkAifuvR0K4t3OVOvw
	 F7bnveeOq9HBoajLHvkp7gpOid9+m3o4+Lj8wQlLWNH43Kd3zMNfhdAfpzSKqbA7YO
	 RC4X4uRmr67yomN7iD8F4zkHLzSzE2CR7g7mq7vc=
Date: Sun, 13 Jul 2025 16:40:49 -0700
To: mm-commits@vger.kernel.org,ptyadav@amazon.de,osalvador@suse.de,david@redhat.com,alexghiti@rivosinc.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] cma-move-memory-allocation-to-a-helper-function.patch removed from -mm tree
Message-Id: <20250713234049.E1ED7C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: cma: move memory allocation to a helper function
has been removed from the -mm tree.  Its filename was
     cma-move-memory-allocation-to-a-helper-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: cma: move memory allocation to a helper function
Date: Thu, 3 Jul 2025 21:47:11 +0300

__cma_declare_contiguous_nid() tries to allocate memory in several ways:
* on systems with 64 bit physical address and enough memory it first
  attempts to allocate memory just above 4GiB
* if that fails, on systems with HIGHMEM the next attempt is from high
  memory
* and at last, if none of the previous attempts succeeded, or was even
  tried because of incompatible configuration, the memory is allocated
  anywhere within specified limits.

Move all the allocation logic to a helper function to make these steps more
obvious.

Link: https://lkml.kernel.org/r/20250703184711.3485940-4-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Pratyush Yadav <ptyadav@amazon.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |  104 +++++++++++++++++++++++++++--------------------------
 1 file changed, 54 insertions(+), 50 deletions(-)

--- a/mm/cma.c~cma-move-memory-allocation-to-a-helper-function
+++ a/mm/cma.c
@@ -377,6 +377,55 @@ static int __init cma_fixed_reserve(phys
 	return 0;
 }
 
+static phys_addr_t __init cma_alloc_mem(phys_addr_t base, phys_addr_t size,
+			phys_addr_t align, phys_addr_t limit, int nid)
+{
+	phys_addr_t addr = 0;
+
+	/*
+	 * If there is enough memory, try a bottom-up allocation first.
+	 * It will place the new cma area close to the start of the node
+	 * and guarantee that the compaction is moving pages out of the
+	 * cma area and not into it.
+	 * Avoid using first 4GB to not interfere with constrained zones
+	 * like DMA/DMA32.
+	 */
+#ifdef CONFIG_PHYS_ADDR_T_64BIT
+	if (!memblock_bottom_up() && limit >= SZ_4G + size) {
+		memblock_set_bottom_up(true);
+		addr = memblock_alloc_range_nid(size, align, SZ_4G, limit,
+						nid, true);
+		memblock_set_bottom_up(false);
+	}
+#endif
+
+	/*
+	 * On systems with HIGHMEM try allocating from there before consuming
+	 * memory in lower zones.
+	 */
+	if (!addr && IS_ENABLED(CONFIG_HIGHMEM)) {
+		phys_addr_t highmem = __pa(high_memory - 1) + 1;
+
+		/*
+		 * All pages in the reserved area must come from the same zone.
+		 * If the requested region crosses the low/high memory boundary,
+		 * try allocating from high memory first and fall back to low
+		 * memory in case of failure.
+		 */
+		if (base < highmem && limit > highmem) {
+			addr = memblock_alloc_range_nid(size, align, highmem,
+							limit, nid, true);
+			limit = highmem;
+		}
+	}
+
+	if (!addr)
+		addr = memblock_alloc_range_nid(size, align, base, limit, nid,
+						true);
+
+	return addr;
+}
+
 static int __init __cma_declare_contiguous_nid(phys_addr_t *basep,
 			phys_addr_t size, phys_addr_t limit,
 			phys_addr_t alignment, unsigned int order_per_bit,
@@ -384,19 +433,9 @@ static int __init __cma_declare_contiguo
 			int nid)
 {
 	phys_addr_t memblock_end = memblock_end_of_DRAM();
-	phys_addr_t highmem_start, base = *basep;
+	phys_addr_t base = *basep;
 	int ret;
 
-	/*
-	 * We can't use __pa(high_memory) directly, since high_memory
-	 * isn't a valid direct map VA, and DEBUG_VIRTUAL will (validly)
-	 * complain. Find the boundary by adding one to the last valid
-	 * address.
-	 */
-	if (IS_ENABLED(CONFIG_HIGHMEM))
-		highmem_start = __pa(high_memory - 1) + 1;
-	else
-		highmem_start = memblock_end_of_DRAM();
 	pr_debug("%s(size %pa, base %pa, limit %pa alignment %pa)\n",
 		__func__, &size, &base, &limit, &alignment);
 
@@ -453,50 +492,15 @@ static int __init __cma_declare_contiguo
 		if (ret)
 			return ret;
 	} else {
-		phys_addr_t addr = 0;
-
-		/*
-		 * If there is enough memory, try a bottom-up allocation first.
-		 * It will place the new cma area close to the start of the node
-		 * and guarantee that the compaction is moving pages out of the
-		 * cma area and not into it.
-		 * Avoid using first 4GB to not interfere with constrained zones
-		 * like DMA/DMA32.
-		 */
-#ifdef CONFIG_PHYS_ADDR_T_64BIT
-		if (!memblock_bottom_up() && memblock_end >= SZ_4G + size) {
-			memblock_set_bottom_up(true);
-			addr = memblock_alloc_range_nid(size, alignment, SZ_4G,
-							limit, nid, true);
-			memblock_set_bottom_up(false);
-		}
-#endif
-
-		/*
-		 * All pages in the reserved area must come from the same zone.
-		 * If the requested region crosses the low/high memory boundary,
-		 * try allocating from high memory first and fall back to low
-		 * memory in case of failure.
-		 */
-		if (!addr && base < highmem_start && limit > highmem_start) {
-			addr = memblock_alloc_range_nid(size, alignment,
-					highmem_start, limit, nid, true);
-			limit = highmem_start;
-		}
-
-		if (!addr) {
-			addr = memblock_alloc_range_nid(size, alignment, base,
-					limit, nid, true);
-			if (!addr)
-				return -ENOMEM;
-		}
+		base = cma_alloc_mem(base, size, alignment, limit, nid);
+		if (!base)
+			return -ENOMEM;
 
 		/*
 		 * kmemleak scans/reads tracked objects for pointers to other
 		 * objects but this address isn't mapped and accessible
 		 */
-		kmemleak_ignore_phys(addr);
-		base = addr;
+		kmemleak_ignore_phys(base);
 	}
 
 	ret = cma_init_reserved_mem(base, size, order_per_bit, name, res_cma);
_

Patches currently in -mm which might be from rppt@kernel.org are


