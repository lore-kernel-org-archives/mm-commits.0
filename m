Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676F52BE659
	for <mm-commits@vger.kernel.org>; Wed,  2 Jul 2025 20:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751489319; cv=none; b=WsiSYA8IflrQ6LHUrOvdWMj5TbbkKf6WT0JApeVGssr7qplvTdkfP4J0MZnHgUEhC4+cLhoPqyMHo6X+e58ypOLP9XvyMgLsQXNMOfC1LDYfXPa/mMk4JQx0ZzAIMQJBY9z1nKSgY0y/3bxGdmkEudlQhEjlVDG7PfkHDp0jlAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751489319; c=relaxed/simple;
	bh=chBZcKuRs/T/vJ1RcW6/5t1/Id1fuAj0Gw3MsxB7TB8=;
	h=Date:To:From:Subject:Message-Id; b=Y77TvrpQ8Fc5Wde8JvFfAZXBsCCsSzR/310x6vPyPhNZv3hwCxz5lWurmWrHdsplMdExzGBcoaGLhXi8MsbAKc5l+1+VUKW/vxLvN/ZrIOLwwgqypzntQiuYOi9shWRxof/zbkg/KXYj6PY24jNOZ6f7aN+Xwt1ED1ai+CtZR1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gAEWLLss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gAEWLLss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D070BC4CEE7;
	Wed,  2 Jul 2025 20:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751489318;
	bh=chBZcKuRs/T/vJ1RcW6/5t1/Id1fuAj0Gw3MsxB7TB8=;
	h=Date:To:From:Subject:From;
	b=gAEWLLssczhmh77Xu34KrzsyT/2zGioKxfFPkSjJWXbnAJRgBR5+8J2T0GxIuzbAm
	 10RjeYPfopniZh75REMo+2mPyl/5a1h39HdJb7yV99BxEVDZwZDPUgODTYfiiTVOxQ
	 wIkkycYmtbA7TxXM8ekp/8NF7tAnUySdhTnwTGvQ=
Date: Wed, 02 Jul 2025 13:48:38 -0700
To: mm-commits@vger.kernel.org,ptyadav@amazon.de,osalvador@suse.de,david@redhat.com,alexghiti@rivosinc.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + cma-move-allocation-from-highmem-to-a-helper-function.patch added to mm-new branch
Message-Id: <20250702204838.D070BC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: cma: move allocation from HIGHMEM to a helper function
has been added to the -mm mm-new branch.  Its filename is
     cma-move-allocation-from-highmem-to-a-helper-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/cma-move-allocation-from-highmem-to-a-helper-function.patch

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
Subject: cma: move allocation from HIGHMEM to a helper function
Date: Wed, 2 Jul 2025 20:36:05 +0300

When CONFIG_HIGMEM is enabled, __cma_declare_contiguous_nid() first tries
to allocate the area from HIGHMEM and if that fails it falls back to
allocation from low memory.

Split allocation from HIGMEM into a helper function to further decouple
logic related to CONFIG_HIGHMEM.

Link: https://lkml.kernel.org/r/20250702173605.2198924-4-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pratyush Yadav <ptyadav@amazon.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |   52 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 23 deletions(-)

--- a/mm/cma.c~cma-move-allocation-from-highmem-to-a-helper-function
+++ a/mm/cma.c
@@ -377,6 +377,30 @@ static int __init cma_fixed_reserve(phys
 	return 0;
 }
 
+static phys_addr_t __init cma_alloc_highmem(phys_addr_t base, phys_addr_t size,
+			phys_addr_t align, phys_addr_t *limit, int nid)
+{
+	phys_addr_t addr = 0;
+
+	if (IS_ENABLED(CONFIG_HIGHMEM)) {
+		phys_addr_t highmem = __pa(high_memory - 1) + 1;
+
+		/*
+		 * All pages in the reserved area must come from the same zone.
+		 * If the requested region crosses the low/high memory boundary,
+		 * try allocating from high memory first and fall back to low
+		 * memory in case of failure.
+		 */
+		if (base < highmem && *limit > highmem) {
+			addr = memblock_alloc_range_nid(size, align, highmem,
+							*limit, nid, true);
+			*limit = highmem;
+		}
+	}
+
+	return addr;
+}
+
 static int __init __cma_declare_contiguous_nid(phys_addr_t *basep,
 			phys_addr_t size, phys_addr_t limit,
 			phys_addr_t alignment, unsigned int order_per_bit,
@@ -384,19 +408,9 @@ static int __init __cma_declare_contiguo
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
 
@@ -473,18 +487,10 @@ static int __init __cma_declare_contiguo
 		}
 #endif
 
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
+		/* On systems with HIGHMEM try allocating from there first */
+		if (!addr)
+			addr = cma_alloc_highmem(base, size, alignment, &limit,
+						 nid);
 		if (!addr) {
 			addr = memblock_alloc_range_nid(size, alignment, base,
 					limit, nid, true);
_

Patches currently in -mm which might be from rppt@kernel.org are

cma-move-__cma_declare_contiguous_nid-before-its-usage.patch
cma-split-resrvation-of-fixed-area-into-a-helper-function.patch
cma-move-allocation-from-highmem-to-a-helper-function.patch

