Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C453DAC10
	for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2024 18:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711390277; cv=none; b=qr/qVWe5Eag7QkZmezo6LIQZtfmAS/FpXQ0xNNVSVNxPCTXKP7V1Jm1qU8sZeX7zUoMj6lqHC8Y33eVTdeZI82KdkZ0Jgj/1/aqTzzd+VMuGCCNVLM6FRNoAh3CINDLYGBM/cHDSV7MnNvcxd8kLv/VaWitMyBOLt5LDPzQz98k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711390277; c=relaxed/simple;
	bh=Mi7aZusVwlkRqq0cUt1HCyMgTLFNbIjcsZh3xvAW/kQ=;
	h=Date:To:From:Subject:Message-Id; b=KavBd1GVxt7vjJITA2nKZdJw9JQOxekY7llI3nqrsbTMEengvlQZoQSQG4fBktcrMDt92XJb1YBiV4NI17S+bkwO3jIscZFs8sT5dUPDWqIM1+ypHb3dTaHxC0rFAhllmF5n60Hze5Vm3zN+WcfS0DnNoGAyo4ma47IuYt/HBtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kPFUveK9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kPFUveK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA8BC433C7;
	Mon, 25 Mar 2024 18:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711390276;
	bh=Mi7aZusVwlkRqq0cUt1HCyMgTLFNbIjcsZh3xvAW/kQ=;
	h=Date:To:From:Subject:From;
	b=kPFUveK9BFL5OxLS97eJfUtbiPqa/W+uHEs5K7o9Mx94ytzxfKn0Ll5KNMdWOlWgq
	 QjZDd2YvyZiQX28wtpcF9OYc0qRjmk3fhMBEHgz7frgaETq0Elu9ASN7q/ubOYFqur
	 Y5EvAkYhYU+irC0ILAsPuwgjbZ1cLHHs+ufwGwQQ=
Date: Mon, 25 Mar 2024 11:11:16 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core.patch added to mm-unstable branch
Message-Id: <20240325181116.ADA8BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init.c: remove meaningless calculation of zone->managed_pages in free_area_init_core()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Baoquan He <bhe@redhat.com>
Subject: mm/mm_init.c: remove meaningless calculation of zone->managed_pages in free_area_init_core()
Date: Mon, 25 Mar 2024 22:56:44 +0800

Currently, in free_area_init_core(), when initialize zone's field, a rough
value is set to zone->managed_pages.  That value is calculated by
(zone->present_pages - memmap_pages).

In the meantime, add the value to nr_all_pages and nr_kernel_pages which
represent all free pages of system (only low memory or including HIGHMEM
memory separately).  Both of them are gonna be used in
alloc_large_system_hash().

However, the rough calculation and setting of zone->managed_pages is
meaningless because
  a) memmap pages are allocated on units of node in sparse_init() or
     alloc_node_mem_map(pgdat); The simple (zone->present_pages -
     memmap_pages) is too rough to make sense for zone;
  b) the set zone->managed_pages will be zeroed out and reset with
     acutal value in mem_init() via memblock_free_all(). Before the
     resetting, no buddy allocation request is issued.

Here, remove the meaningless and complicated calculation of
(zone->present_pages - memmap_pages), initialize zone->managed_pages as 0
which reflect its actual value because no any page is added into buddy
system right now.  It will be reset in mem_init().

And also remove the assignment of nr_all_pages and nr_kernel_pages in
free_area_init_core().  Instead, call the newly added
calc_nr_kernel_pages() to count up all free but not reserved memory in
memblock and assign to nr_all_pages and nr_kernel_pages.  The counting
excludes memmap_pages, and other kernel used data, which is more accurate
than old way and simpler, and can also cover the ppc required
arch_reserved_kernel_pages() case.

And also clean up the outdated code comment above free_area_init_core(). 
And free_area_init_core() is easy to understand now, no need to add words
to explain.

Link: https://lkml.kernel.org/r/20240325145646.1044760-5-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   46 +++++-----------------------------------------
 1 file changed, 5 insertions(+), 41 deletions(-)

--- a/mm/mm_init.c~mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core
+++ a/mm/mm_init.c
@@ -1566,15 +1566,6 @@ void __ref free_area_init_core_hotplug(s
 }
 #endif
 
-/*
- * Set up the zone data structures:
- *   - mark all pages reserved
- *   - mark all memory queues empty
- *   - clear the memory bitmaps
- *
- * NOTE: pgdat should get zeroed by caller.
- * NOTE: this function is only called during early init.
- */
 static void __init free_area_init_core(struct pglist_data *pgdat)
 {
 	enum zone_type j;
@@ -1585,41 +1576,13 @@ static void __init free_area_init_core(s
 
 	for (j = 0; j < MAX_NR_ZONES; j++) {
 		struct zone *zone = pgdat->node_zones + j;
-		unsigned long size, freesize, memmap_pages;
-
-		size = zone->spanned_pages;
-		freesize = zone->present_pages;
-
-		/*
-		 * Adjust freesize so that it accounts for how much memory
-		 * is used by this zone for memmap. This affects the watermark
-		 * and per-cpu initialisations
-		 */
-		memmap_pages = calc_memmap_size(size, freesize);
-		if (!is_highmem_idx(j)) {
-			if (freesize >= memmap_pages) {
-				freesize -= memmap_pages;
-				if (memmap_pages)
-					pr_debug("  %s zone: %lu pages used for memmap\n",
-						 zone_names[j], memmap_pages);
-			} else
-				pr_warn("  %s zone: %lu memmap pages exceeds freesize %lu\n",
-					zone_names[j], memmap_pages, freesize);
-		}
-
-		if (!is_highmem_idx(j))
-			nr_kernel_pages += freesize;
-		/* Charge for highmem memmap if there are enough kernel pages */
-		else if (nr_kernel_pages > memmap_pages * 2)
-			nr_kernel_pages -= memmap_pages;
-		nr_all_pages += freesize;
+		unsigned long size = zone->spanned_pages;
 
 		/*
-		 * Set an approximate value for lowmem here, it will be adjusted
-		 * when the bootmem allocator frees pages into the buddy system.
-		 * And all highmem pages will be managed by the buddy system.
+		 * Initialize zone->managed_pages as 0 , it will be reset
+		 * when memblock allocator frees pages into buddy system.
 		 */
-		zone_init_internals(zone, j, nid, freesize);
+		zone_init_internals(zone, j, nid, 0);
 
 		if (!size)
 			continue;
@@ -1916,6 +1879,7 @@ void __init free_area_init(unsigned long
 		check_for_memory(pgdat);
 	}
 
+	calc_nr_kernel_pages();
 	memmap_init();
 
 	/* disable hash distribution for systems with a single node */
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmallocc-optimize-to-reduce-arguments-of-alloc_vmap_area.patch
x86-remove-unneeded-memblock_find_dma_reserve.patch
mm-mm_initc-remove-the-useless-dma_reserve.patch
mm-mm_initc-add-new-function-calc_nr_all_pages.patch
mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core.patch
mm-mm_initc-remove-unneeded-calc_memmap_size.patch
mm-mm_initc-remove-arch_reserved_kernel_pages.patch

