Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1E143E9FC
	for <mm-commits@vger.kernel.org>; Tue, 28 Apr 2026 13:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777382019; cv=none; b=GkPjopMlqDEp1r9eDJQwqHoz+7XLz/SccJcUgCRITaoFFunh2ZWHCoBKVKdcxUxoP5Lm8pH/tRFi8ja6fK8uN+mZUJh06aadN8Gs3wUVSJeyAGVE+AMS9QCWLo61Ksdbva8X1QF2My7vA0WKpwNKaWSpkcJNEc+fN36NXTX+QAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777382019; c=relaxed/simple;
	bh=t9pky/3WAF17X55627zCzdQXXVNldu7modo7jYo4/Rg=;
	h=Date:To:From:Subject:Message-Id; b=WZpzVn+foEaRMr/ZXgBOt6gfbIZV9NBEX2AwOUXAxgyXIQagp7SSiVRHbWafe5TlDK3/H7EPBs/9RhcI8coYG1W3T5GtMBSgCC0HqplYmrLESXT681sJBUOwGhtQDs5dKZnEofYEDtwKIpGqnYLYfqpsjLX1g9WEGYwQST3iwPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1on9YFCC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1on9YFCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89AB9C2BCAF;
	Tue, 28 Apr 2026 13:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777382019;
	bh=t9pky/3WAF17X55627zCzdQXXVNldu7modo7jYo4/Rg=;
	h=Date:To:From:Subject:From;
	b=1on9YFCCF9Aqql7+lCv49AqcUtCWVJaSxyATbceBn4tsN8X8rWkSoD06UBJfLjzXy
	 +09/vqh53HSOYZ7KPcCUB/vr7FPPKD4YoouE1gsxC416Kj5wldZ6SrvvH1st4lhI5L
	 QGvd5KMyQZSyLcy0NivwgqxPb7ZaMs44haq836Ls=
Date: Tue, 28 Apr 2026 06:13:39 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mm_init-fix-uninitialized-struct-pages-for-zone_device.patch removed from -mm tree
Message-Id: <20260428131339.89AB9C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init: fix uninitialized struct pages for ZONE_DEVICE
has been removed from the -mm tree.  Its filename was
     mm-mm_init-fix-uninitialized-struct-pages-for-zone_device.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/mm_init: fix uninitialized struct pages for ZONE_DEVICE
Date: Sun, 26 Apr 2026 17:26:40 +0800

If DAX memory is hotplugged into an unoccupied subsection of an early
section, section_activate() reuses the unoptimized boot memmap.
However, compound_nr_pages() still assumes that vmemmap optimization is
in effect and initializes only the reduced number of struct pages. As a
result, the remaining tail struct pages are left uninitialized, which
can later lead to unexpected behavior or crashes.

Fix this by treating early sections as unoptimized when calculating how
many struct pages to initialize.

Link: https://lore.kernel.org/20260426092640.375967-7-songmuchun@bytedance.com
Fixes: 6fd3620b3428 ("mm/page_alloc: reuse tail struct pages for compound devmaps")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
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

mm-memory_hotplug-fix-memory-block-reference-leak-on-remove.patch
drivers-base-memory-fix-memory-block-reference-leak-in-poison-accounting.patch
drivers-base-memory-fix-locking-for-poison-accounting-lookup.patch
mm-sparse-remove-sparse-buffer-pre-allocation-mechanism.patch

