Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC1F24332F
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837186; cv=none; b=DvxJhioi4Naj9NrOUgQhcFvApWo/+LMG7XlyZIBDzYup+8OklF5pXm0IAFogBJecgsDlQguP3UMDJyXUeFCX73BBMwlxGjyAQJGjF3e8QKqoR+jFGE+vqGs4yuWJHSiMW+58FBHGO6jOMsbEY/ngkosfeZKGVzAhVU2LJeM6WDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837186; c=relaxed/simple;
	bh=QB4QvYGAzPefsLOETdL2JIhm8m7R7/ZpslO43EFONqE=;
	h=Date:To:From:Subject:Message-Id; b=fmoAjKrzSX2z3ZKQOVWvMo7g0Od25zev/eAJ2MP9WhCm+6ixosG7Chk5bwZhF0GK6M4r4bBJzeXiE/lEg8ddIX2b8fXHc/tFtq5aMQzjA9acvKoZjIKsqwzzs/+d26AXN1dtALHEosc+SXSj12lKmF2QFw7jus4+2X4Xz1PsLKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cH77YMyY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cH77YMyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12FE0C4CEDF;
	Tue, 14 Jan 2025 06:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837186;
	bh=QB4QvYGAzPefsLOETdL2JIhm8m7R7/ZpslO43EFONqE=;
	h=Date:To:From:Subject:From;
	b=cH77YMyYXPqBYi32PrkXhuVjCN60fGVEqmc9YQdM2WBhR1Fw19S4u8oT9o/IyW+c4
	 tzZgIkJWGu0I12wM2eU/gqXR0Vsw90ImNB4HwWe8FJ+X+Z1xiSk62RdD/0b6FlFFVq
	 RyorQvZ/qMhxz81519pAOBBhft29UzC/ihE/t/So=
Date: Mon, 13 Jan 2025 22:46:25 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,catalin.marinas@arm.com,guoweikang.kernel@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memmap-prevent-double-scanning-of-memmap-by-kmemleak.patch removed from -mm tree
Message-Id: <20250114064626.12FE0C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memmap: prevent double scanning of memmap by kmemleak
has been removed from the -mm tree.  Its filename was
     mm-memmap-prevent-double-scanning-of-memmap-by-kmemleak.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Guo Weikang <guoweikang.kernel@gmail.com>
Subject: mm/memmap: prevent double scanning of memmap by kmemleak
Date: Mon, 6 Jan 2025 10:11:25 +0800

kmemleak explicitly scans the mem_map through the valid struct page
objects.  However, memmap_alloc() was also adding this memory to the gray
object list, causing it to be scanned twice.  Remove memmap_alloc() from
the scan list and add a comment to clarify the behavior.

Link: https://lore.kernel.org/lkml/CAOm6qn=FVeTpH54wGDFMHuCOeYtvoTx30ktnv9-w3Nh8RMofEA@mail.gmail.com/
Link: https://lkml.kernel.org/r/20250106021126.1678334-1-guoweikang.kernel@gmail.com
Signed-off-by: Guo Weikang <guoweikang.kernel@gmail.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    4 ++++
 mm/mm_init.c             |    8 ++++++--
 mm/sparse-vmemmap.c      |    5 +++--
 3 files changed, 13 insertions(+), 4 deletions(-)

--- a/include/linux/memblock.h~mm-memmap-prevent-double-scanning-of-memmap-by-kmemleak
+++ a/include/linux/memblock.h
@@ -378,6 +378,10 @@ static inline int memblock_get_region_no
 /* Flags for memblock allocation APIs */
 #define MEMBLOCK_ALLOC_ANYWHERE	(~(phys_addr_t)0)
 #define MEMBLOCK_ALLOC_ACCESSIBLE	0
+/*
+ *  MEMBLOCK_ALLOC_NOLEAKTRACE avoids kmemleak tracing. It implies
+ *  MEMBLOCK_ALLOC_ACCESSIBLE
+ */
 #define MEMBLOCK_ALLOC_NOLEAKTRACE	1
 
 /* We are using top down, so it is safe to use 0 here */
--- a/mm/mm_init.c~mm-memmap-prevent-double-scanning-of-memmap-by-kmemleak
+++ a/mm/mm_init.c
@@ -1585,13 +1585,17 @@ void __init *memmap_alloc(phys_addr_t si
 {
 	void *ptr;
 
+	/*
+	 * Kmemleak will explicitly scan mem_map by traversing all valid
+	 * `struct *page`,so memblock does not need to be added to the scan list.
+	 */
 	if (exact_nid)
 		ptr = memblock_alloc_exact_nid_raw(size, align, min_addr,
-						   MEMBLOCK_ALLOC_ACCESSIBLE,
+						   MEMBLOCK_ALLOC_NOLEAKTRACE,
 						   nid);
 	else
 		ptr = memblock_alloc_try_nid_raw(size, align, min_addr,
-						 MEMBLOCK_ALLOC_ACCESSIBLE,
+						 MEMBLOCK_ALLOC_NOLEAKTRACE,
 						 nid);
 
 	if (ptr && size > 0)
--- a/mm/sparse-vmemmap.c~mm-memmap-prevent-double-scanning-of-memmap-by-kmemleak
+++ a/mm/sparse-vmemmap.c
@@ -31,6 +31,8 @@
 #include <asm/dma.h>
 #include <asm/pgalloc.h>
 
+#include "internal.h"
+
 /*
  * Allocate a block of memory to be used to back the virtual memory map
  * or to back the page tables that are used to create the mapping.
@@ -42,8 +44,7 @@ static void * __ref __earlyonly_bootmem_
 				unsigned long align,
 				unsigned long goal)
 {
-	return memblock_alloc_try_nid_raw(size, align, goal,
-					       MEMBLOCK_ALLOC_ACCESSIBLE, node);
+	return memmap_alloc(size, align, goal, node, false);
 }
 
 void * __meminit vmemmap_alloc_block(unsigned long size, int node)
_

Patches currently in -mm which might be from guoweikang.kernel@gmail.com are

mm-memblock-add-memblock_alloc_or_panic-interface.patch
arch-s390-save_area_alloc-default-failure-behavior-changed-to-panic.patch

