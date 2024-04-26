Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFCD7E58C
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103999; cv=none; b=o83k+HknAQuLQXnp3lBQmVmx7gS0EDqmbv+hCXczVghHFG/gPD+9/iefs/4yKcv5qcF4Vmx5EyyZGc4RPFJLlY2pB2x9TVxStqz9w2SPD5USnUC6bM0ZJdenLo7i8T+AtBvxdjfSXKiN6e5rLTIhOV6oGraIU0pk/yJ6xnn82SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103999; c=relaxed/simple;
	bh=cyJCVwk2+/PFyFGCvALTTKMOZ3UZPaj/sDZu2rv8CMg=;
	h=Date:To:From:Subject:Message-Id; b=QiaH365SzzNTCGMsehlRC5zaotSya427QgJIDctNYXYJ9PL+kiftUrgV1beGTLZAGZjlfitnYPOcMZDA0mLjRdj1Ls5FBYUfYlTVF3jLWkhrKwc/vB78wq05AirhH0C7SqNZsalEMqFvmREYEFrVTzoklNzz6uuht0Nlbg7JLO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DJ5Ec2jD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DJ5Ec2jD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F98C116B1;
	Fri, 26 Apr 2024 03:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103999;
	bh=cyJCVwk2+/PFyFGCvALTTKMOZ3UZPaj/sDZu2rv8CMg=;
	h=Date:To:From:Subject:From;
	b=DJ5Ec2jD2cI5yRhhj0kzzS19TaYSwTbvc2ZBlkd8SI2eJO+1VWopyDMgsJ3XvuJ8q
	 nilrmKCSVpBY7Z/TKqq8A31XNk064AGyhfGY/OTtLh2JLDRQS0q7K4aRf2Ydod8G/m
	 jOOtBLjCZdHXF81Be4HotuXC0NinM2x6mCSafvAI=
Date: Thu, 25 Apr 2024 20:59:58 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core.patch removed from -mm tree
Message-Id: <20240426035959.14F98C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init.c: remove meaningless calculation of zone->managed_pages in free_area_init_core()
has been removed from the -mm tree.  Its filename was
     mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
(zone->present_pages - memmap_pages), directly set zone->managed_pages as
zone->present_pages for now.  It will be adjusted in mem_init().

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

[bhe@redhat.com: initialize zone->managed_pages as zone->present_pages for now]
  Link: https://lkml.kernel.org/r/ZgU0bsJ2FEjykvju@MiWiFi-R3L-srv
Link: https://lkml.kernel.org/r/20240325145646.1044760-5-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
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
+		zone_init_internals(zone, j, nid, zone->present_pages);
 
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

documentation-kdump-clean-up-the-outdated-description.patch
kexec-fix-the-unexpected-kexec_dprintk-macro.patch
crash-add-prefix-for-crash-dumping-messages.patch

