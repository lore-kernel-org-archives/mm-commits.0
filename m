Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704463921E9
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298475; cv=none; b=brK9uFuME8ctuF0qJLB/mD+AlV2DznolE+86agNl8rNobZJtHzQeaTKyUUqE2g2hRp4NEiX0Whphy9QxAZMee03uGtoXS1kkjMhRH4HKBNyFN0WPvTczZPF15+umaJuYQdMe+YHE2EyolT/bG2QwoG6izL83Bk41wCq3FLiXrGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298475; c=relaxed/simple;
	bh=Lk5WgV5cSKN3ZpTRxkB76di9/mSq8Ka0lQLDSQz/lsA=;
	h=Date:To:From:Subject:Message-Id; b=mAaB1HLID0w8zCC3eNrsi2vIeW5Wsv6VX4ybQ7GpLkBOyrLCzI1B151DIHXUUqQbucON7b2587lk4vI6TAdQ77eGu4eOqSFMdOR0vQSsvXh28Y0vxT2M9y0cs7dpA9JtkOdmfnWvFK9p2V2hxmRSOm3kWr8ymREh9SThKjYiOIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yKNdT3jQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yKNdT3jQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4458F1F00A3A;
	Wed, 29 Jul 2026 04:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298474;
	bh=YyEUwycg4me0Ns2+B2Z0k4f7ihUgVd5hcwBRnSTvjjc=;
	h=Date:To:From:Subject;
	b=yKNdT3jQ034J5tThX4QW6RR0j+mfpfi2LcMVGCkpaSQst+pIPmUbR6lyMfTTMeOeQ
	 gblJZjyAzQ0vX+cuh3qhCbSnRoJMLc+tAbsI22qajVZGyMr6CSnLJ+PxisOAH6NIfG
	 nFlduCk/xM9PL1IWdZAaHrzBu8ZAuG6Ub673DoNc=
Date: Tue, 28 Jul 2026 21:14:33 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.arif@linux.dev,rppt@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,osalvador@kernel.org,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,fvdl@google.com,david@kernel.org,aneesh.kumar@linux.ibm.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_vmemmap-move-bootmem-hvo-setup-to-early-init.patch removed from -mm tree
Message-Id: <20260729041434.4458F1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb_vmemmap: move bootmem HVO setup to early init
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-move-bootmem-hvo-setup-to-early-init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/hugetlb_vmemmap: move bootmem HVO setup to early init
Date: Fri, 12 Jun 2026 11:58:59 +0800

Bootmem HugeTLB pages currently defer HVO setup to
hugetlb_vmemmap_init_late(), because the optimization needs zone
information.

Now that zone initialization is available earlier, the bootmem HVO setup
can be done directly from hugetlb_vmemmap_init_early().  This lets
gigantic HugeTLB pages apply HVO as soon as they are allocated.

Bootmem gigantic pages that span multiple zones are now filtered out when
they are allocated, so the remaining bootmem gigantic pages seen by later
hugetlb initialization are already zone-valid.  As a result,
hugetlb_vmemmap_init_late() no longer needs to handle bootmem HVO setup.

Link: https://lore.kernel.org/20260612035903.2468601-16-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |   93 +++++++++++------------------------------
 1 file changed, 25 insertions(+), 68 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-move-bootmem-hvo-setup-to-early-init
+++ a/mm/hugetlb_vmemmap.c
@@ -745,6 +745,20 @@ static bool vmemmap_should_optimize_boot
 	return true;
 }
 
+static struct zone *pfn_to_zone(unsigned nid, unsigned long pfn)
+{
+	struct zone *zone;
+	enum zone_type zone_type;
+
+	for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
+		zone = &NODE_DATA(nid)->node_zones[zone_type];
+		if (zone_spans_pfn(zone, pfn))
+			return zone;
+	}
+
+	return NULL;
+}
+
 /*
  * Initialize memmap section for a gigantic page, HVO-style.
  */
@@ -752,6 +766,7 @@ void __init hugetlb_vmemmap_init_early(i
 {
 	unsigned long psize, paddr, section_size;
 	unsigned long ns, i, pnum, pfn, nr_pages;
+	unsigned long start, end;
 	struct huge_bootmem_page *m = NULL;
 	void *map;
 
@@ -761,6 +776,8 @@ void __init hugetlb_vmemmap_init_early(i
 	section_size = (1UL << PA_SECTION_SHIFT);
 
 	list_for_each_entry(m, &huge_boot_pages[nid], list) {
+		struct zone *zone;
+
 		if (!vmemmap_should_optimize_bootmem_page(m))
 			continue;
 
@@ -769,6 +786,14 @@ void __init hugetlb_vmemmap_init_early(i
 		paddr = virt_to_phys(m);
 		pfn = PHYS_PFN(paddr);
 		map = pfn_to_page(pfn);
+		start = (unsigned long)map;
+		end = start + hugetlb_vmemmap_size(m->hstate);
+		zone = pfn_to_zone(nid, pfn);
+
+		if (vmemmap_populate_hvo(start, end, huge_page_order(m->hstate),
+					 zone, HUGETLB_VMEMMAP_RESERVE_SIZE))
+			panic("Failed to allocate memmap for HugeTLB page\n");
+		memmap_boot_pages_add(DIV_ROUND_UP(HUGETLB_VMEMMAP_RESERVE_SIZE, PAGE_SIZE));
 
 		pnum = pfn_to_section_nr(pfn);
 		ns = psize / section_size;
@@ -784,76 +809,8 @@ void __init hugetlb_vmemmap_init_early(i
 	}
 }
 
-static struct zone *pfn_to_zone(unsigned nid, unsigned long pfn)
-{
-	struct zone *zone;
-	enum zone_type zone_type;
-
-	for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
-		zone = &NODE_DATA(nid)->node_zones[zone_type];
-		if (zone_spans_pfn(zone, pfn))
-			return zone;
-	}
-
-	return NULL;
-}
-
 void __init hugetlb_vmemmap_init_late(int nid)
 {
-	struct huge_bootmem_page *m, *tm;
-	unsigned long phys, nr_pages, start, end;
-	unsigned long pfn, nr_mmap;
-	struct zone *zone = NULL;
-	struct hstate *h;
-	void *map;
-
-	if (!READ_ONCE(vmemmap_optimize_enabled))
-		return;
-
-	list_for_each_entry_safe(m, tm, &huge_boot_pages[nid], list) {
-		if (!(m->flags & HUGE_BOOTMEM_HVO))
-			continue;
-
-		phys = virt_to_phys(m);
-		h = m->hstate;
-		pfn = PHYS_PFN(phys);
-		nr_pages = pages_per_huge_page(h);
-		map = pfn_to_page(pfn);
-		start = (unsigned long)map;
-		end = start + nr_pages * sizeof(struct page);
-
-		if (!hugetlb_bootmem_page_zones_valid(nid, m)) {
-			/*
-			 * Oops, the hugetlb page spans multiple zones.
-			 * Remove it from the list, and populate it normally.
-			 */
-			list_del(&m->list);
-
-			vmemmap_populate(start, end, nid, NULL);
-			nr_mmap = end - start;
-			memmap_boot_pages_add(DIV_ROUND_UP(nr_mmap, PAGE_SIZE));
-
-			memblock_phys_free(phys, huge_page_size(h));
-			continue;
-		}
-
-		if (!zone || !zone_spans_pfn(zone, pfn))
-			zone = pfn_to_zone(nid, pfn);
-		if (WARN_ON_ONCE(!zone))
-			continue;
-
-		if (vmemmap_populate_hvo(start, end, huge_page_order(h), zone,
-					 HUGETLB_VMEMMAP_RESERVE_SIZE) < 0) {
-			/* Fallback if HVO population fails */
-			vmemmap_populate(start, end, nid, NULL);
-			nr_mmap = end - start;
-		} else {
-			m->flags |= HUGE_BOOTMEM_ZONES_VALID;
-			nr_mmap = HUGETLB_VMEMMAP_RESERVE_SIZE;
-		}
-
-		memmap_boot_pages_add(DIV_ROUND_UP(nr_mmap, PAGE_SIZE));
-	}
 }
 #endif
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

selftests-mm-remove-obsolete-hugetlb-vmemmap-test.patch

