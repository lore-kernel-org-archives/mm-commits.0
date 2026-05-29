Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5839A36F8F5;
	Fri, 29 May 2026 04:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027642; cv=none; b=VAy+q8CYhhtC07FHrGIHSXHmgUUDJHrB7y8dawjxTCIRgLyUOcodoedV2vmBNzpLQAF/SMyn3RwbnXaRvcC4xTXAqHFXKTS+W23tGsa9OLUP4pEZzz+HShhCapm4mdpCdafVYVndUZw4I/vqqcWh90V7/+bGRXJ8toZyF9n818s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027642; c=relaxed/simple;
	bh=FfdzHRqYB+XTWElYdeTjfB/ZQdbyCDX1PsQF0i1OMgI=;
	h=Date:To:From:Subject:Message-Id; b=RK/b1cwjrC8RaC4b90ArSMvREO1r+XpTQAQ6uQMwIw8m0EVUtfu70/JJRQU0+90xtdvAFZ1hQlgMCJDstoHm6idjJXQu6+EbPDRR4pX8oe7PcSJvdNZG2Ui05e0XykFxiyFxGSE4nsGhrBayR89FFWz3RcM8tU/KaaDQ6Ht8v+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bEeB8elk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bEeB8elk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B7D1F0089A;
	Fri, 29 May 2026 04:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027641;
	bh=GgakimoZkaHGXwmFHtIgZx/9yIc/Nm/sJrpjaYsL0z0=;
	h=Date:To:From:Subject;
	b=bEeB8elkXhQpHeQoLkzyzaimBh5VRP0o3TiHwaumEmdamA9PAGQUoGDZ6YvUNF64A
	 toI2UZEdLfufrlxIKV14DMSXHjBs5IdEV5saQmZlwI7ZpYu/+s6fFRiduuMDzDQ8CS
	 ft0U8XhsZiprLemYih4+l6GdHn+xr8Bs6t1lx62s=
Date: Thu, 28 May 2026 21:07:20 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,joao.m.martins@oracle.com,david@kernel.org,aneesh.kumar@linux.ibm.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_init-fix-uninitialized-struct-pages-for-zone_device.patch removed from -mm tree
Message-Id: <20260529040720.E0B7D1F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init: fix uninitialized struct pages for ZONE_DEVICE
has been removed from the -mm tree.  Its filename was
     mm-mm_init-fix-uninitialized-struct-pages-for-zone_device.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/mm_init: fix uninitialized struct pages for ZONE_DEVICE
Date: Tue, 28 Apr 2026 16:18:55 +0800

If DAX memory is hotplugged into an unoccupied subsection of an early
section, section_activate() reuses the unoptimized boot memmap.  However,
compound_nr_pages() still assumes that vmemmap optimization is in effect
and initializes only the reduced number of struct pages.  As a result, the
remaining tail struct pages are left uninitialized, which can later lead
to unexpected behavior or crashes.

Fix this by treating early sections as unoptimized when calculating how
many struct pages to initialize.

Link: https://lore.kernel.org/20260428081855.1249045-7-songmuchun@bytedance.com
Fixes: 6fd3620b3428 ("mm/page_alloc: reuse tail struct pages for compound devmaps")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Liam R. Howlett <liam@infradead.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/mm/mm_init.c~mm-mm_init-fix-uninitialized-struct-pages-for-zone_device
+++ a/mm/mm_init.c
@@ -1055,10 +1055,17 @@ static void __ref __init_zone_device_pag
  * of how the sparse_vmemmap internals handle compound pages in the lack
  * of an altmap. See vmemmap_populate_compound_pages().
  */
-static inline unsigned long compound_nr_pages(struct vmem_altmap *altmap,
+static inline unsigned long compound_nr_pages(unsigned long pfn,
+					      struct vmem_altmap *altmap,
 					      struct dev_pagemap *pgmap)
 {
-	if (!vmemmap_can_optimize(altmap, pgmap))
+	/*
+	 * If DAX memory is hot-plugged into an unoccupied subsection
+	 * of an early section, the unoptimized boot memmap is reused.
+	 * See section_activate().
+	 */
+	if (early_section(__pfn_to_section(pfn)) ||
+	    !vmemmap_can_optimize(altmap, pgmap))
 		return pgmap_vmemmap_nr(pgmap);
 
 	return VMEMMAP_RESERVE_NR * (PAGE_SIZE / sizeof(struct page));
@@ -1128,7 +1135,7 @@ void __ref memmap_init_zone_device(struc
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(altmap, pgmap));
+				     compound_nr_pages(pfn, altmap, pgmap));
 	}
 
 	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb_vmemmap-fix-incorrect-vmemmap-restore-in-rollback.patch
mm-memory_hotplug-factor-out-altmap-freeing-checks.patch
drivers-base-memory-make-memory-block-get-put-explicit.patch

