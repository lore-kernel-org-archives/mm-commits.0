Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72879381C8
	for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2024 18:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710788008; cv=none; b=OxYElLvZHPsa5wDnuGlh2vTZAg504Q//0I4c0w/Riaff8TakdVqheEuGZAqT65fs+g8ZcZWGUSQCCW21KtnqjZUiW/LF5rOJIGcgoLSwk1FanNtUM3lHk7cC7IxxCmsjNYtJTpmbhtWbv9iWKH2c92WXwzL1QvcNzr0Mp7B6cMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710788008; c=relaxed/simple;
	bh=wTJMHz314rRFzL+WF740qZgLniDMNFt67jlLHnnh6FQ=;
	h=Date:To:From:Subject:Message-Id; b=Ka5okXH2Pi6hi42fccxnTz+E2/pFg1uSHlj+JRCLGe8F6jrjus5KJ+KMe8ZFsHUX4+XpL6HLVOP+ASdktmWbyQ3NQEuX5ibPDHekCoO/atzo0jdfOkRPtGfhBxK00y3b7plq+f1hyCULHCDkjJP7kzGipHP2TKx3yGY7QaIweWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=omTMmHhN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="omTMmHhN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D9BC433F1;
	Mon, 18 Mar 2024 18:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710788008;
	bh=wTJMHz314rRFzL+WF740qZgLniDMNFt67jlLHnnh6FQ=;
	h=Date:To:From:Subject:From;
	b=omTMmHhNCW30LvQoIYdOilSoefMn6jkxJ2G+J6tUE7F8fAsPrhsDG6nHxeIajQM8I
	 QQAvF9HU/fRg9n57srxCh8jIT44dwfFBzjNbOGFsFG27tDu11S2+qLl7taQTikYVJH
	 KO80u1uCDCrAq387kqA80MBF6oUAN7qhiN9vZRKo=
Date: Mon, 18 Mar 2024 11:53:27 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core.patch added to mm-unstable branch
Message-Id: <20240318185328.12D9BC433F1@smtp.kernel.org>
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
Date: Mon, 18 Mar 2024 22:21:36 +0800

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
(zone->present_pages - memmap_pages), directly set zone->present_pages to
zone->managed_pages.  It will be adjusted in mem_init().

And also remove the assignment of nr_all_pages and nr_kernel_pages in
free_area_init_core().  Instead, call the newly added
calc_nr_kernel_pages() to count up all free but not reserved memory in
memblock and assign to nr_all_pages and nr_kernel_pages.  The counting
excludes memmap_pages, and other kernel used data, which is more accurate
than old way and simpler, and can also cover the ppc required
arch_reserved_kernel_pages() case.

Link: https://lkml.kernel.org/r/20240318142138.783350-5-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   38 ++++++--------------------------------
 1 file changed, 6 insertions(+), 32 deletions(-)

--- a/mm/mm_init.c~mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core
+++ a/mm/mm_init.c
@@ -1584,41 +1584,14 @@ static void __init free_area_init_core(s
 
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
+		 * Set the zone->managed_pages as zone->present_pages roughly, it
+		 * be zeroed out and reset when memblock allocator frees pages into
+		 * buddy system.
 		 */
-		zone_init_internals(zone, j, nid, freesize);
+		zone_init_internals(zone, j, nid, zone->present_pages);
 
 		if (!size)
 			continue;
@@ -1915,6 +1888,7 @@ void __init free_area_init(unsigned long
 		check_for_memory(pgdat);
 	}
 
+	calc_nr_kernel_pages();
 	memmap_init();
 
 	/* disable hash distribution for systems with a single node */
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-mm_initc-remove-the-useless-dma_reserve.patch
x86-remove-memblock_find_dma_reserve.patch
mm-mm_initc-add-new-function-calc_nr_kernel_pages.patch
mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core.patch
mm-mm_initc-remove-unneeded-calc_memmap_size.patch
mm-mm_initc-remove-arch_reserved_kernel_pages.patch

