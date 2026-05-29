Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05CB370AC6;
	Fri, 29 May 2026 04:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027642; cv=none; b=gtXbGNYZH419mSCsl5uJG//IhKd1MVb1nWDBfCPLg1zo75mGOfxfl8fe5kt3R7sdcdCR2oJFctyp8okLpvrXt3SKrxrQcp3GFZpmnfqaoGxKR+2Z5QYmIXM1G27tEmQ0baYSVrY7lqk2UPi3eX6cNSKTKOZJyiH2TUWt1ObG/xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027642; c=relaxed/simple;
	bh=iCZSkhe4mvprrmCaqOU6Gbgd03mutY3Oog8YoipJnIM=;
	h=Date:To:From:Subject:Message-Id; b=gTCicroBdlJ9zKiSHUJtUzJ7OL/vlgaETQozByu3ih9Q5r/hgkthraQLnQJV+G6g6OtLaaMd2OyrmNtrPQv33iIS0bvsCwkUjoW3+qz8xQ/gdekhLUwUes9bR8XaYw/U8l5/F4JDnRbBjr0REdbs+PE8Y3drEZOTLLEWq11QwMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XHf/VFzl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XHf/VFzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE361F00893;
	Fri, 29 May 2026 04:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027637;
	bh=N25n1aFW3f/k4p6+vehWQmYJcgOLqaemhjr1rj4IoIA=;
	h=Date:To:From:Subject;
	b=XHf/VFzl43ViyAKOyYKk9pVBa8sopAoAKB1lWcZ+EePPt9eF4CByDw/IYdH4XAmme
	 pORW6pGf+opdfU1a6gxpTiq9/Up8NSs/KbZDzbiHpSDSE9+/LUwic+5BNgWjf59xRv
	 l5MeHSaVo8G6ACTxENWWceAZyTUZrXJtuag3sofA=
Date: Thu, 28 May 2026 21:07:17 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,joao.m.martins@oracle.com,david@kernel.org,aneesh.kumar@linux.ibm.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-vmemmap-fix-dax-vmemmap-accounting-with-optimization.patch removed from -mm tree
Message-Id: <20260529040717.9AE361F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse-vmemmap: fix DAX vmemmap accounting with optimization
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-fix-dax-vmemmap-accounting-with-optimization.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/sparse-vmemmap: fix DAX vmemmap accounting with optimization
Date: Tue, 28 Apr 2026 16:18:53 +0800

When vmemmap optimization is enabled for DAX, the nr_memmap_pages counter
in /proc/vmstat is incorrect.  The current code always accounts for the
full, non-optimized vmemmap size, but vmemmap optimization reduces the
actual number of vmemmap pages by reusing tail pages.  This causes the
system to overcount vmemmap usage, leading to inaccurate page statistics
in /proc/vmstat.

Fix this by introducing section_nr_vmemmap_pages(), which returns the
exact vmemmap page count for a given pfn range based on whether
optimization is in effect.

Link: https://lore.kernel.org/20260428081855.1249045-5-songmuchun@bytedance.com
Fixes: 15995a352474 ("mm: report per-page metadata information")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Liam R. Howlett <liam@infradead.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse-vmemmap.c |   34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-fix-dax-vmemmap-accounting-with-optimization
+++ a/mm/sparse-vmemmap.c
@@ -647,6 +647,31 @@ void offline_mem_sections(unsigned long
 	}
 }
 
+static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+{
+	const unsigned int order = pgmap ? pgmap->vmemmap_shift : 0;
+	const unsigned long pages_per_compound = 1UL << order;
+
+	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
+	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
+
+	if (!vmemmap_can_optimize(altmap, pgmap))
+		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
+
+	if (order < PFN_SECTION_SHIFT) {
+		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
+		return VMEMMAP_RESERVE_NR * nr_pages / pages_per_compound;
+	}
+
+	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
+
+	if (IS_ALIGNED(pfn, pages_per_compound))
+		return VMEMMAP_RESERVE_NR;
+
+	return 0;
+}
+
 static struct page * __meminit populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
@@ -654,7 +679,7 @@ static struct page * __meminit populate_
 	struct page *page = __populate_section_memmap(pfn, nr_pages, nid, altmap,
 						      pgmap);
 
-	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
+	memmap_pages_add(section_nr_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
 
 	return page;
 }
@@ -665,7 +690,7 @@ static void depopulate_section_memmap(un
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
-	memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
+	memmap_pages_add(-section_nr_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
 	vmemmap_free(start, end, altmap);
 }
 
@@ -673,9 +698,10 @@ static void free_map_bootmem(struct page
 {
 	unsigned long start = (unsigned long)memmap;
 	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
+	unsigned long pfn = page_to_pfn(memmap);
 
-	memmap_boot_pages_add(-1L * (DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
-						  PAGE_SIZE)));
+	memmap_boot_pages_add(-section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
+							NULL, NULL));
 	vmemmap_free(start, end, NULL);
 }
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb_vmemmap-fix-incorrect-vmemmap-restore-in-rollback.patch
mm-memory_hotplug-factor-out-altmap-freeing-checks.patch
drivers-base-memory-make-memory-block-get-put-explicit.patch

