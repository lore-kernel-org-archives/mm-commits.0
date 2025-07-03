Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7571885B8
	for <mm-commits@vger.kernel.org>; Thu,  3 Jul 2025 20:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751574599; cv=none; b=gLtDUt6AuhrGH9u8RJT1cC4dwWzeK7Fmwmg4akRbgtX/Gi/7kdS8aAgVvSFHPQZ6rBxU7r6XlutMKyMwP9JCqJuk/MaWqCB2T3N6XhsDXSCFEQugCImieAaEDyI/ordfCqalnVxKzZ3SK1suibuc47tzheedHb85j94ivO8qX+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751574599; c=relaxed/simple;
	bh=ZrSDUhUbbLP0u/ohIBKXxNdCeH//6DnVXycG4CzgQ/o=;
	h=Date:To:From:Subject:Message-Id; b=Z1pIutPpkIe5KO8ircf9uEnvfMln/gl5E5+Gu0bqZOcTGCZxKhxZoUO43fRSw5HnNN3Z6un95Gptk0e7/XdRr/x7oLOoI3OK+muQ/3O6e1wx+8cRSRHz4Wwe9j86o81jfz69najOB6/656j9dmqZ/lAk+uh+7xPWpSCN7pENEkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aY1gd67v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aY1gd67v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22349C4CEE3;
	Thu,  3 Jul 2025 20:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751574599;
	bh=ZrSDUhUbbLP0u/ohIBKXxNdCeH//6DnVXycG4CzgQ/o=;
	h=Date:To:From:Subject:From;
	b=aY1gd67vuryeoVPM/6rpouMAKHY7SCB6ruvMU564uwdKVE1i5fzGozZNjnxMLahoU
	 Je+9qZDqIKw9BJMN+IUq7yEGzfO5DHBL1FUVgtx1BIF7E3t8UQBq8zvpEfoLkf+rDy
	 tXC++KChR+DunRUFlb8V2+JP4/vgjUhypkRroZZ8=
Date: Thu, 03 Jul 2025 13:29:58 -0700
To: mm-commits@vger.kernel.org,ptyadav@amazon.de,osalvador@suse.de,david@redhat.com,alexghiti@rivosinc.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + cma-move-memory-allocation-to-a-helper-function.patch added to mm-new branch
Message-Id: <20250703202959.22349C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: cma: move memory allocation to a helper function
has been added to the -mm mm-new branch.  Its filename is
     cma-move-memory-allocation-to-a-helper-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cma-move-memory-allocation-to-a-helper-function.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

cma-move-__cma_declare_contiguous_nid-before-its-usage.patch
cma-split-resrvation-of-fixed-area-into-a-helper-function.patch
cma-move-memory-allocation-to-a-helper-function.patch

