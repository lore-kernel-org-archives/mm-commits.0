Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA31D370AC8;
	Fri, 29 May 2026 04:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027634; cv=none; b=pYciqa75ytULCquWUTBOnPMpGH325wyyK0wsVn0mL5GSQJu1Qk+/K4gfLVy7v7foVmaEomE7iDllLLX2qkJC3GpP7HU/NOy54nz+ECYQHksD3zLnRZOgPxQjRh0Wp/nWMGeNrwHVANHLAslrZIKSWbSoTHWsotOqQlX5ROOa6yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027634; c=relaxed/simple;
	bh=EJO+WoAbwgDzIdkVLUU5z+zkNu0IIhDMPAFpi9LoZKA=;
	h=Date:To:From:Subject:Message-Id; b=nxSJ95GzkjEZ13lyJUEfLk2aavTUM0TI3+ePUBtrG9qFXnrslTRBp8c3mICdtWHd2r58JAXL8WN6HAN344PwdRuniQVc6ImUUtYXFhIMyyESoMwnc1Nr1goeeTzhcWatr0F68QcKb/OAhY0akxJ7WZVJOH+MpI7Bs1OLpU3vDDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0QmUAFXh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0QmUAFXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB6F1F00899;
	Fri, 29 May 2026 04:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027631;
	bh=NLbnSmQc416jEJx79fpVBepqLWVCA4ma0Ke0OrDH47k=;
	h=Date:To:From:Subject;
	b=0QmUAFXhJyFDl9yjfShNkhKqr//iK/UX8bP+3zKIqYB3cfZK/YeApKTFlXX3WoPUw
	 MtlGoW8wc3PxDgvNOFyCEK0spudj1swVcw4KvwUm9FTtzCMCw5+otQEpwr/1oyiDoa
	 HplF44m9POzBe2gJnLu97UwNxR9ytHk2m0BRGetQ=
Date: Thu, 28 May 2026 21:07:11 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,joao.m.martins@oracle.com,david@kernel.org,aneesh.kumar@linux.ibm.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-vmemmap-fix-vmemmap-accounting-underflow.patch removed from -mm tree
Message-Id: <20260529040711.9BB6F1F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse-vmemmap: fix vmemmap accounting underflow
has been removed from the -mm tree.  Its filename was
     mm-sparse-vmemmap-fix-vmemmap-accounting-underflow.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/sparse-vmemmap: fix vmemmap accounting underflow
Date: Tue, 28 Apr 2026 16:18:50 +0800

Patch series "mm: Fix vmemmap optimization accounting and initialization",
v8.

The series fixes several bugs in vmemmap optimization, mainly around
incorrect page accounting and memmap initialization in DAX and memory
hotplug paths.  It also fixes pageblock migratetype initialization and
struct page initialization for ZONE_DEVICE compound pages.

Patches 1-4 fix vmemmap accounting issues.  Patch 1 fixes an accounting
underflow in the section activation failure path by moving vmemmap page
accounting into the lower-level allocation and freeing helpers.  Patch 2
fixes incorrect altmap passing in the memory hotplug error path.  Patch 3
passes pgmap through memory deactivation paths so the teardown side can
determine whether vmemmap optimization was in effect.  Patch 4 uses that
information to account the optimized DAX vmemmap size correctly.

Patches 5-6 fix initialization issues in mm/mm_init.  One makes sure all
pageblocks in ZONE_DEVICE compound pages get their migratetype
initialized.  The other fixes a case where DAX memory hotplug reuses an
unoptimized early-section memmap while compound_nr_pages() still assumes
vmemmap optimization, leaving tail struct pages uninitialized.


This patch (of 6):

In section_activate(), if populate_section_memmap() fails, the error
handling path calls section_deactivate() to roll back the state.  This
causes a vmemmap accounting imbalance.

Since commit c3576889d87b ("mm: fix accounting of memmap pages"), memmap
pages are accounted for only after populate_section_memmap() succeeds. 
However, the failure path unconditionally calls section_deactivate(),
which decreases the vmemmap count.  Consequently, a failure in
populate_section_memmap() leads to an accounting underflow, incorrectly
reducing the system's tracked vmemmap usage.

Fix this more thoroughly by moving all accounting calls into the lower
level functions that actually perform the vmemmap allocation and freeing:

  - populate_section_memmap() accounts for newly allocated vmemmap pages -
depopulate_section_memmap() unaccounts when vmemmap is freed

This ensures proper accounting in all code paths, including error handling
and early section cases.

Link: https://lore.kernel.org/20260428081855.1249045-1-songmuchun@bytedance.com
Link: https://lore.kernel.org/20260428081855.1249045-2-songmuchun@bytedance.com
Fixes: c3576889d87b ("mm: fix accounting of memmap pages")
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

 mm/sparse-vmemmap.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/mm/sparse-vmemmap.c~mm-sparse-vmemmap-fix-vmemmap-accounting-underflow
+++ a/mm/sparse-vmemmap.c
@@ -651,7 +651,12 @@ static struct page * __meminit populate_
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
 {
-	return __populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
+	struct page *page = __populate_section_memmap(pfn, nr_pages, nid, altmap,
+						      pgmap);
+
+	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
+
+	return page;
 }
 
 static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
@@ -660,13 +665,17 @@ static void depopulate_section_memmap(un
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
+	memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
 	vmemmap_free(start, end, altmap);
 }
+
 static void free_map_bootmem(struct page *memmap)
 {
 	unsigned long start = (unsigned long)memmap;
 	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
 
+	memmap_boot_pages_add(-1L * (DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
+						  PAGE_SIZE)));
 	vmemmap_free(start, end, NULL);
 }
 
@@ -769,14 +778,10 @@ static void section_deactivate(unsigned
 	 * The memmap of early sections is always fully populated. See
 	 * section_activate() and pfn_valid() .
 	 */
-	if (!section_is_early) {
-		memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
+	if (!section_is_early)
 		depopulate_section_memmap(pfn, nr_pages, altmap);
-	} else if (memmap) {
-		memmap_boot_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page),
-							  PAGE_SIZE)));
+	else if (memmap)
 		free_map_bootmem(memmap);
-	}
 
 	if (empty)
 		ms->section_mem_map = (unsigned long)NULL;
@@ -821,7 +826,6 @@ static struct page * __meminit section_a
 		section_deactivate(pfn, nr_pages, altmap);
 		return ERR_PTR(-ENOMEM);
 	}
-	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
 
 	return memmap;
 }
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb_vmemmap-fix-incorrect-vmemmap-restore-in-rollback.patch
mm-memory_hotplug-factor-out-altmap-freeing-checks.patch
drivers-base-memory-make-memory-block-get-put-explicit.patch

