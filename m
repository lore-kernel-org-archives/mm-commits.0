Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752051AA1D2;
	Fri, 29 May 2026 04:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027643; cv=none; b=r/hrTjmBeKr1mQTtYiu0JVFx29G05XvuMManod0N6PQJtG4LpXUOWbEM6EA/uK5p/WLOz+5ucXXxi+np5bwnovewO0XkoO4Py7pMaYyqH5MiCd0WZLRKnMpgSlg5Pv6HX+KCErs3woKgTF3alqjb/FCHsVIIUGFq1XbhzGHF1pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027643; c=relaxed/simple;
	bh=daYyjbmO+8rCnfBpturAqtZ21ODF5R+51lqCh0ceZ0w=;
	h=Date:To:From:Subject:Message-Id; b=rnyL/rtCxTF3DrYXlHumH6pdw+8Q0n6gD4etMRvtuPT86TTS0TkxTy7T+HEWRGt7ysDxrWcZnTe2GkcpK6Ag1/PlzpnCSjsRrElIW8SMtkbsx0NP3eR+FCUyn0260tg15avmI1fC1RRj7a4shltB5iypKD3+QEo5I+hlR3QPOwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MHJz8l/G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MHJz8l/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488461F00899;
	Fri, 29 May 2026 04:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027639;
	bh=+HCvJ359cpzTvrmSKhofKFSvaq/TCcA3+4TV+apnUwY=;
	h=Date:To:From:Subject;
	b=MHJz8l/GPl/DdxH8AmSYi8+xoBXzD7/jPnfxWl3VWVSXfwFDl615+cMP4wPmCwXL1
	 /4Gu4Dw8Xja/qio7/yY9QfKWtkUj58OTbwwFPpPFdOKS4rLhrMwYIX7wejVXRg4DV3
	 6WQqajZUiNLGBND75KX+2XNTjyEKdx20w8Ig9Et0=
Date: Thu, 28 May 2026 21:07:18 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,mhocko@suse.com,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,joao.m.martins@oracle.com,david@kernel.org,aneesh.kumar@linux.ibm.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_init-fix-pageblock-migratetype-for-zone_device-compound-pages.patch removed from -mm tree
Message-Id: <20260529040719.488461F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init: fix pageblock migratetype for ZONE_DEVICE compound pages
has been removed from the -mm tree.  Its filename was
     mm-mm_init-fix-pageblock-migratetype-for-zone_device-compound-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/mm_init: fix pageblock migratetype for ZONE_DEVICE compound pages
Date: Tue, 28 Apr 2026 16:18:54 +0800

The memmap_init_zone_device() function only initializes the migratetype of
the first pageblock of a compound page.  If the compound page size exceeds
pageblock_nr_pages (e.g., 1GB hugepages with 2MB pageblocks), subsequent
pageblocks in the compound page remain uninitialized.

Move the migratetype initialization out of __init_zone_device_page() and
into a separate pageblock_migratetype_init_range() function.  This
iterates over the entire PFN range of the memory, ensuring that all
pageblocks are correctly initialized.

Also remove the stale confusing comment about MEMINIT_HOTPLUG above the
migratetype setting since it is an obsolete relic from commit 966cf44f637e
("mm: defer ZONE_DEVICE page initialization to the point where we init
pgmap") and no longer makes sense here.

Link: https://lore.kernel.org/20260428081855.1249045-6-songmuchun@bytedance.com
Fixes: c4386bd8ee3a ("mm/memremap: add ZONE_DEVICE support for compound pages")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
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

 mm/mm_init.c |   34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

--- a/mm/mm_init.c~mm-mm_init-fix-pageblock-migratetype-for-zone_device-compound-pages
+++ a/mm/mm_init.c
@@ -674,6 +674,20 @@ static inline void fixup_hashdist(void)
 static inline void fixup_hashdist(void) {}
 #endif /* CONFIG_NUMA */
 
+#ifdef CONFIG_ZONE_DEVICE
+static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
+		unsigned long nr_pages, int migratetype)
+{
+	const unsigned long end = pfn + nr_pages;
+
+	for (pfn = pageblock_align(pfn); pfn < end; pfn += pageblock_nr_pages) {
+		init_pageblock_migratetype(pfn_to_page(pfn), migratetype, false);
+		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
+			cond_resched();
+	}
+}
+#endif
+
 /*
  * Initialize a reserved page unconditionally, finding its zone first.
  */
@@ -1012,21 +1026,6 @@ static void __ref __init_zone_device_pag
 	page->zone_device_data = NULL;
 
 	/*
-	 * Mark the block movable so that blocks are reserved for
-	 * movable at startup. This will force kernel allocations
-	 * to reserve their blocks rather than leaking throughout
-	 * the address space during boot when many long-lived
-	 * kernel allocations are made.
-	 *
-	 * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
-	 * because this is done early in section_activate()
-	 */
-	if (pageblock_aligned(pfn)) {
-		init_pageblock_migratetype(page, MIGRATE_MOVABLE, false);
-		cond_resched();
-	}
-
-	/*
 	 * ZONE_DEVICE pages other than MEMORY_TYPE_GENERIC are released
 	 * directly to the driver page allocator which will set the page count
 	 * to 1 when allocating the page.
@@ -1122,6 +1121,9 @@ void __ref memmap_init_zone_device(struc
 
 		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
 
+		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
+			cond_resched();
+
 		if (pfns_per_compound == 1)
 			continue;
 
@@ -1129,6 +1131,8 @@ void __ref memmap_init_zone_device(struc
 				     compound_nr_pages(altmap, pgmap));
 	}
 
+	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE);
+
 	pr_debug("%s initialised %lu pages in %ums\n", __func__,
 		nr_pages, jiffies_to_msecs(jiffies - start));
 }
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb_vmemmap-fix-incorrect-vmemmap-restore-in-rollback.patch
mm-memory_hotplug-factor-out-altmap-freeing-checks.patch
drivers-base-memory-make-memory-block-get-put-explicit.patch

