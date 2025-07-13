Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F53D1EF38E
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450047; cv=none; b=JWRMx553KT+HaOKKjEMTXCKR3b5cIOvcvqubNooC7vFlDxHmspdWxU+uRQBLQd2TVWQ+YFa8r0Fbx0u+4HNT7xkkIDfGK0kPEUwPGdKDm0QdnXepWZqd6dSzEOac2GGQ1RFXyjC588jxQ1jac+e5TW87LjHuH7s7UTbuth7Z8ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450047; c=relaxed/simple;
	bh=bnwm9V9su9rVTt0t3fkpxLzH3VKfdp0Em4REhImN/8Y=;
	h=Date:To:From:Subject:Message-Id; b=EygJQwonXmTXJsOnMSXgvhhIke638Kd6xKJFQQJ1JujB3uP8HY/GFyE8ldUCGHTOxVJ4z+Fx+6ZFkBPvE47rNfrQfEqcnPeahzmvM91vlylHiGWVz8CWQYXJfec4k4jdd+ZA+G78wrHLVFbKSFMOfZw/xEsz20AgD1hazZyMVJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vJGpKTRN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vJGpKTRN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C48C4CEE3;
	Sun, 13 Jul 2025 23:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450047;
	bh=bnwm9V9su9rVTt0t3fkpxLzH3VKfdp0Em4REhImN/8Y=;
	h=Date:To:From:Subject:From;
	b=vJGpKTRNtckXApiuSz3Uj+RGj7YLccEKfBdMCoBidfdiQILChrHWFT37n+hXlpZ1s
	 3xGnvKOHoQjpcSAc+oA17hnUTj0mmpOmBy16XRj06NF7UQPaagHDkRfwHAB3H6Dp4z
	 0l8JHb73ZYdFytIbLIYYVKBvQR2yV2IzBNF1mWOY=
Date: Sun, 13 Jul 2025 16:40:46 -0700
To: mm-commits@vger.kernel.org,ptyadav@amazon.de,osalvador@suse.de,david@redhat.com,alexghiti@rivosinc.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] cma-move-__cma_declare_contiguous_nid-before-its-usage.patch removed from -mm tree
Message-Id: <20250713234047.12C48C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: cma: move __cma_declare_contiguous_nid() before its usage
has been removed from the -mm tree.  Its filename was
     cma-move-__cma_declare_contiguous_nid-before-its-usage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: cma: move __cma_declare_contiguous_nid() before its usage
Date: Thu, 3 Jul 2025 21:47:09 +0300

Patch series "cma: factor out allocation logic from
__cma_declare_contiguous_nid", v2.

We've discussed earlier that HIGHMEM related logic is spread all over
__cma_declare_contiguous_nid().  These patches decouple it into helper
functions.


This patch (of 3):

Move __cma_declare_contiguous_nid() before its usage and kill forward
declaration.

Link: https://lkml.kernel.org/r/20250703184711.3485940-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20250703184711.3485940-2-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Pratyush Yadav <ptyadav@amazon.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |  294 +++++++++++++++++++++++++----------------------------
 1 file changed, 144 insertions(+), 150 deletions(-)

--- a/mm/cma.c~cma-move-__cma_declare_contiguous_nid-before-its-usage
+++ a/mm/cma.c
@@ -36,12 +36,6 @@
 struct cma cma_areas[MAX_CMA_AREAS];
 unsigned int cma_area_count;
 
-static int __init __cma_declare_contiguous_nid(phys_addr_t *basep,
-			phys_addr_t size, phys_addr_t limit,
-			phys_addr_t alignment, unsigned int order_per_bit,
-			bool fixed, const char *name, struct cma **res_cma,
-			int nid);
-
 phys_addr_t cma_get_base(const struct cma *cma)
 {
 	WARN_ON_ONCE(cma->nranges != 1);
@@ -359,6 +353,150 @@ static void __init list_insert_sorted(
 	}
 }
 
+static int __init __cma_declare_contiguous_nid(phys_addr_t *basep,
+			phys_addr_t size, phys_addr_t limit,
+			phys_addr_t alignment, unsigned int order_per_bit,
+			bool fixed, const char *name, struct cma **res_cma,
+			int nid)
+{
+	phys_addr_t memblock_end = memblock_end_of_DRAM();
+	phys_addr_t highmem_start, base = *basep;
+	int ret;
+
+	/*
+	 * We can't use __pa(high_memory) directly, since high_memory
+	 * isn't a valid direct map VA, and DEBUG_VIRTUAL will (validly)
+	 * complain. Find the boundary by adding one to the last valid
+	 * address.
+	 */
+	if (IS_ENABLED(CONFIG_HIGHMEM))
+		highmem_start = __pa(high_memory - 1) + 1;
+	else
+		highmem_start = memblock_end_of_DRAM();
+	pr_debug("%s(size %pa, base %pa, limit %pa alignment %pa)\n",
+		__func__, &size, &base, &limit, &alignment);
+
+	if (cma_area_count == ARRAY_SIZE(cma_areas)) {
+		pr_err("Not enough slots for CMA reserved regions!\n");
+		return -ENOSPC;
+	}
+
+	if (!size)
+		return -EINVAL;
+
+	if (alignment && !is_power_of_2(alignment))
+		return -EINVAL;
+
+	if (!IS_ENABLED(CONFIG_NUMA))
+		nid = NUMA_NO_NODE;
+
+	/* Sanitise input arguments. */
+	alignment = max_t(phys_addr_t, alignment, CMA_MIN_ALIGNMENT_BYTES);
+	if (fixed && base & (alignment - 1)) {
+		pr_err("Region at %pa must be aligned to %pa bytes\n",
+			&base, &alignment);
+		return -EINVAL;
+	}
+	base = ALIGN(base, alignment);
+	size = ALIGN(size, alignment);
+	limit &= ~(alignment - 1);
+
+	if (!base)
+		fixed = false;
+
+	/* size should be aligned with order_per_bit */
+	if (!IS_ALIGNED(size >> PAGE_SHIFT, 1 << order_per_bit))
+		return -EINVAL;
+
+	/*
+	 * If allocating at a fixed base the request region must not cross the
+	 * low/high memory boundary.
+	 */
+	if (fixed && base < highmem_start && base + size > highmem_start) {
+		pr_err("Region at %pa defined on low/high memory boundary (%pa)\n",
+			&base, &highmem_start);
+		return -EINVAL;
+	}
+
+	/*
+	 * If the limit is unspecified or above the memblock end, its effective
+	 * value will be the memblock end. Set it explicitly to simplify further
+	 * checks.
+	 */
+	if (limit == 0 || limit > memblock_end)
+		limit = memblock_end;
+
+	if (base + size > limit) {
+		pr_err("Size (%pa) of region at %pa exceeds limit (%pa)\n",
+			&size, &base, &limit);
+		return -EINVAL;
+	}
+
+	/* Reserve memory */
+	if (fixed) {
+		if (memblock_is_region_reserved(base, size) ||
+		    memblock_reserve(base, size) < 0) {
+			return -EBUSY;
+		}
+	} else {
+		phys_addr_t addr = 0;
+
+		/*
+		 * If there is enough memory, try a bottom-up allocation first.
+		 * It will place the new cma area close to the start of the node
+		 * and guarantee that the compaction is moving pages out of the
+		 * cma area and not into it.
+		 * Avoid using first 4GB to not interfere with constrained zones
+		 * like DMA/DMA32.
+		 */
+#ifdef CONFIG_PHYS_ADDR_T_64BIT
+		if (!memblock_bottom_up() && memblock_end >= SZ_4G + size) {
+			memblock_set_bottom_up(true);
+			addr = memblock_alloc_range_nid(size, alignment, SZ_4G,
+							limit, nid, true);
+			memblock_set_bottom_up(false);
+		}
+#endif
+
+		/*
+		 * All pages in the reserved area must come from the same zone.
+		 * If the requested region crosses the low/high memory boundary,
+		 * try allocating from high memory first and fall back to low
+		 * memory in case of failure.
+		 */
+		if (!addr && base < highmem_start && limit > highmem_start) {
+			addr = memblock_alloc_range_nid(size, alignment,
+					highmem_start, limit, nid, true);
+			limit = highmem_start;
+		}
+
+		if (!addr) {
+			addr = memblock_alloc_range_nid(size, alignment, base,
+					limit, nid, true);
+			if (!addr)
+				return -ENOMEM;
+		}
+
+		/*
+		 * kmemleak scans/reads tracked objects for pointers to other
+		 * objects but this address isn't mapped and accessible
+		 */
+		kmemleak_ignore_phys(addr);
+		base = addr;
+	}
+
+	ret = cma_init_reserved_mem(base, size, order_per_bit, name, res_cma);
+	if (ret) {
+		memblock_phys_free(base, size);
+		return ret;
+	}
+
+	(*res_cma)->nid = nid;
+	*basep = base;
+
+	return 0;
+}
+
 /*
  * Create CMA areas with a total size of @total_size. A normal allocation
  * for one area is tried first. If that fails, the biggest memblock
@@ -593,150 +731,6 @@ int __init cma_declare_contiguous_nid(ph
 	return ret;
 }
 
-static int __init __cma_declare_contiguous_nid(phys_addr_t *basep,
-			phys_addr_t size, phys_addr_t limit,
-			phys_addr_t alignment, unsigned int order_per_bit,
-			bool fixed, const char *name, struct cma **res_cma,
-			int nid)
-{
-	phys_addr_t memblock_end = memblock_end_of_DRAM();
-	phys_addr_t highmem_start, base = *basep;
-	int ret;
-
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
-	pr_debug("%s(size %pa, base %pa, limit %pa alignment %pa)\n",
-		__func__, &size, &base, &limit, &alignment);
-
-	if (cma_area_count == ARRAY_SIZE(cma_areas)) {
-		pr_err("Not enough slots for CMA reserved regions!\n");
-		return -ENOSPC;
-	}
-
-	if (!size)
-		return -EINVAL;
-
-	if (alignment && !is_power_of_2(alignment))
-		return -EINVAL;
-
-	if (!IS_ENABLED(CONFIG_NUMA))
-		nid = NUMA_NO_NODE;
-
-	/* Sanitise input arguments. */
-	alignment = max_t(phys_addr_t, alignment, CMA_MIN_ALIGNMENT_BYTES);
-	if (fixed && base & (alignment - 1)) {
-		pr_err("Region at %pa must be aligned to %pa bytes\n",
-			&base, &alignment);
-		return -EINVAL;
-	}
-	base = ALIGN(base, alignment);
-	size = ALIGN(size, alignment);
-	limit &= ~(alignment - 1);
-
-	if (!base)
-		fixed = false;
-
-	/* size should be aligned with order_per_bit */
-	if (!IS_ALIGNED(size >> PAGE_SHIFT, 1 << order_per_bit))
-		return -EINVAL;
-
-	/*
-	 * If allocating at a fixed base the request region must not cross the
-	 * low/high memory boundary.
-	 */
-	if (fixed && base < highmem_start && base + size > highmem_start) {
-		pr_err("Region at %pa defined on low/high memory boundary (%pa)\n",
-			&base, &highmem_start);
-		return -EINVAL;
-	}
-
-	/*
-	 * If the limit is unspecified or above the memblock end, its effective
-	 * value will be the memblock end. Set it explicitly to simplify further
-	 * checks.
-	 */
-	if (limit == 0 || limit > memblock_end)
-		limit = memblock_end;
-
-	if (base + size > limit) {
-		pr_err("Size (%pa) of region at %pa exceeds limit (%pa)\n",
-			&size, &base, &limit);
-		return -EINVAL;
-	}
-
-	/* Reserve memory */
-	if (fixed) {
-		if (memblock_is_region_reserved(base, size) ||
-		    memblock_reserve(base, size) < 0) {
-			return -EBUSY;
-		}
-	} else {
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
-
-		/*
-		 * kmemleak scans/reads tracked objects for pointers to other
-		 * objects but this address isn't mapped and accessible
-		 */
-		kmemleak_ignore_phys(addr);
-		base = addr;
-	}
-
-	ret = cma_init_reserved_mem(base, size, order_per_bit, name, res_cma);
-	if (ret) {
-		memblock_phys_free(base, size);
-		return ret;
-	}
-
-	(*res_cma)->nid = nid;
-	*basep = base;
-
-	return 0;
-}
-
 static void cma_debug_show_areas(struct cma *cma)
 {
 	unsigned long next_zero_bit, next_set_bit, nr_zero;
_

Patches currently in -mm which might be from rppt@kernel.org are


