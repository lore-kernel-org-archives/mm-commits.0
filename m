Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BD8392806
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298461; cv=none; b=sOvHyUFLPEqATGi6doxz8vUriTgebsXZeiPoQVEoCvVNzYJCPFhWcsnQE9vyjLKtfJSYaRL9FwsxZ4Zi7FSp/+mp7WW9kMcv3LaCkegi3PWCVUHL3giP9jhVDJ9dSQzVhfoNnkJqZYvgX52vKhLoqDYY5zw4sc1YEOI3E+XUpv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298461; c=relaxed/simple;
	bh=vl9ZlJ0/bxKW4wigfLMaot27qcGBSzLH1+o+ST0y2eY=;
	h=Date:To:From:Subject:Message-Id; b=I7Z2i1hGNCKbYCzkJv5P7nrPky9D17ARods+CSbnUjCj3QR1dAHylsjW7dYZQIgMvA7+Jhz9G6qyWcof4XdUWwgGqdCxhhqVTyJBdbpLkgzHnOdt70ECXudMfcS/1JKn5xcZUry38ucbfLFMvUuG/BiDk8xF3aXexycoiJ7MgV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jTTq/EeC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jTTq/EeC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC1B1F00A3A;
	Wed, 29 Jul 2026 04:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298460;
	bh=vOdp/QlmyWEWrAT26AIJWUCYD7jhzQ6BDQqtfHDwf/U=;
	h=Date:To:From:Subject;
	b=jTTq/EeC5HhprNyzTJoaIUJuljC+xYJxy4cus9RwIQ0MQkIznkLKNRF8zJLqJNXrm
	 OoaBIh8lXdqfPx0uWs96WWHHzOMcILHNLfOf+JXy7yF91tgI252FNLGP3STm8uBHrf
	 H3B9lGHG6o/SVkZqKsUiNOEoUEHUjJAYJRpRK99c=
Date: Tue, 28 Jul 2026 21:14:19 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.arif@linux.dev,rppt@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,osalvador@kernel.org,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,fvdl@google.com,david@kernel.org,aneesh.kumar@linux.ibm.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-panic-on-memmap-and-usemap-allocation-failure.patch removed from -mm tree
Message-Id: <20260729041420.3DC1B1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse: panic on memmap and usemap allocation failure
has been removed from the -mm tree.  Its filename was
     mm-sparse-panic-on-memmap-and-usemap-allocation-failure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/sparse: panic on memmap and usemap allocation failure
Date: Fri, 12 Jun 2026 11:58:50 +0800

When vmemmap or usemap allocation fails, sparse_init_nid() currently marks
the section non-present and continues.  Later boot-time code can still
walk PFNs in that section without checking for this partial setup, which
leads to invalid accesses.  subsection_map_init() can also touch an
unallocated usemap.

Auditing and fixing all early PFN walkers for this case is not worth the
complexity.  These allocation failures are expected to be fatal anyway,
and other memory models already treat them that way.

Make memmap and usemap allocation failures panic immediately instead of
trying to recover and crashing later in less obvious ways.  This is also
consistent with how other memory model configurations handle memmap
allocation failures.

Link: https://lore.kernel.org/20260612035903.2468601-7-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   44 +++++++++-----------------------------------
 1 file changed, 9 insertions(+), 35 deletions(-)

--- a/mm/sparse.c~mm-sparse-panic-on-memmap-and-usemap-allocation-failure
+++ a/mm/sparse.c
@@ -239,15 +239,8 @@ struct page __init *__populate_section_m
 		struct dev_pagemap *pgmap)
 {
 	unsigned long size = section_map_size();
-	struct page *map;
-	phys_addr_t addr = __pa(MAX_DMA_ADDRESS);
 
-	map = memmap_alloc(size, size, addr, nid, false);
-	if (!map)
-		panic("%s: Failed to allocate %lu bytes align=0x%lx nid=%d from=%pa\n",
-		      __func__, size, PAGE_SIZE, nid, &addr);
-
-	return map;
+	return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), nid, false);
 }
 #endif /* !CONFIG_SPARSEMEM_VMEMMAP */
 
@@ -300,17 +293,14 @@ static void __init sparse_init_nid(int n
 				   unsigned long map_count)
 {
 	unsigned long pnum;
-	struct page *map;
-	struct mem_section *ms;
 
-	if (sparse_usage_init(nid, map_count)) {
-		pr_err("%s: node[%d] usemap allocation failed", __func__, nid);
-		goto failed;
-	}
+	if (sparse_usage_init(nid, map_count))
+		panic("Failed to allocate usemap for node %d\n", nid);
 
 	sparse_vmemmap_init_nid_early(nid);
 
 	for_each_present_section_nr(pnum_begin, pnum) {
+		struct mem_section *ms;
 		unsigned long pfn = section_nr_to_pfn(pnum);
 
 		if (pnum >= pnum_end)
@@ -318,34 +308,18 @@ static void __init sparse_init_nid(int n
 
 		ms = __nr_to_section(pnum);
 		if (!preinited_vmemmap_section(ms)) {
+			struct page *map;
+
 			map = __populate_section_memmap(pfn, PAGES_PER_SECTION,
-					nid, NULL, NULL);
-			if (!map) {
-				pr_err("%s: node[%d] memory map backing failed. Some memory will not be available.",
-				       __func__, nid);
-				pnum_begin = pnum;
-				sparse_usage_fini();
-				goto failed;
-			}
+							nid, NULL, NULL);
+			if (!map)
+				panic("Failed to allocate memmap for section %lu\n", pnum);
 			memmap_boot_pages_add(DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
 							   PAGE_SIZE));
 			sparse_init_early_section(nid, map, pnum, 0);
 		}
 	}
 	sparse_usage_fini();
-	return;
-failed:
-	/*
-	 * We failed to allocate, mark all the following pnums as not present,
-	 * except the ones already initialized earlier.
-	 */
-	for_each_present_section_nr(pnum_begin, pnum) {
-		if (pnum >= pnum_end)
-			break;
-		ms = __nr_to_section(pnum);
-		if (!preinited_vmemmap_section(ms))
-			ms->section_mem_map = 0;
-	}
 }
 
 /*
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

selftests-mm-remove-obsolete-hugetlb-vmemmap-test.patch

