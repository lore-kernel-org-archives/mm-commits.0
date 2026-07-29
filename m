Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD36D390CA9
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298463; cv=none; b=T3uKOiZXDR/Vl5oDa/DMuB19rDQeri/PXZNH16XXCfboioq0nxhHmBYWnFWaHXFtm4Gt1+9tvW0kvczLr17Xoel5RT956SZ/Dt8W3vgh0dAB8AM3IdPS4HPto+gUZP6ldte/LLu/mhDZENK+MgK0Ae02f+0k1S4qwCKIMkTI6Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298463; c=relaxed/simple;
	bh=A7DotJn4lQVM6y2k0WT4YCcowktDSyK9NmZM+PSOkRk=;
	h=Date:To:From:Subject:Message-Id; b=QujJOy/Laf9K9DjMLUC5uSFPLsgvxmeoWSaiEp4FuGMB8xR4IT9YCoruHdE7esaGDkc/1+GaV5qksXNklHTwJ8eJKnkS4hFgQdKzeIdw5tljTSSHJ1Q2dhGYvg4knWXGwWGKjhtWDGMNoiCWMerCYE3g/lDv1bPynRA3BNWzin8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qplhbb3Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qplhbb3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B68E1F000E9;
	Wed, 29 Jul 2026 04:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298461;
	bh=r2SJpFeQMlWKLOCfbf41X3tt5WLP3u7dLELrFnQzdeo=;
	h=Date:To:From:Subject;
	b=Qplhbb3ZY+2wCac56IXkt3JkVb4aiyCb+Za/O1GzoPazSvcnM0t8jiUXSIpLE4URx
	 +2H1sCiLNmF1vruq16L/rEHxCcD0XWLO/WBe9b5121VkJjdR1vLNb2GOkaedZgAv+1
	 vdvu9LEroH6jV9VMEOLnXYpbkkzYePVT7qObghXc=
Date: Tue, 28 Jul 2026 21:14:21 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.arif@linux.dev,rppt@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,osalvador@kernel.org,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,fvdl@google.com,david@kernel.org,aneesh.kumar@linux.ibm.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-move-subsection_map_init-into-sparse_init.patch removed from -mm tree
Message-Id: <20260729041421.7B68E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse: move subsection_map_init() into sparse_init()
has been removed from the -mm tree.  Its filename was
     mm-sparse-move-subsection_map_init-into-sparse_init.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/sparse: move subsection_map_init() into sparse_init()
Date: Fri, 12 Jun 2026 11:58:51 +0800

subsection_map_init() is part of sparse memory initialization, but it is
currently called from free_area_init().

Move it into sparse_init() so the sparse-specific setup stays together
instead of being split across the generic free_area_init() path.

Link: https://lore.kernel.org/20260612035903.2468601-8-songmuchun@bytedance.com
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

 mm/internal.h       |    5 ++---
 mm/mm_init.c        |   10 ++--------
 mm/sparse-vmemmap.c |   11 ++++++++++-
 mm/sparse.c         |    1 +
 4 files changed, 15 insertions(+), 12 deletions(-)

--- a/mm/internal.h~mm-sparse-move-subsection_map_init-into-sparse_init
+++ a/mm/internal.h
@@ -994,10 +994,9 @@ static inline void sparse_init(void) {}
  * mm/sparse-vmemmap.c
  */
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-void sparse_init_subsection_map(unsigned long pfn, unsigned long nr_pages);
+void sparse_init_subsection_map(void);
 #else
-static inline void sparse_init_subsection_map(unsigned long pfn,
-		unsigned long nr_pages)
+static inline void sparse_init_subsection_map(void)
 {
 }
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
--- a/mm/mm_init.c~mm-sparse-move-subsection_map_init-into-sparse_init
+++ a/mm/mm_init.c
@@ -1871,18 +1871,12 @@ static void __init free_area_init(void)
 			       (u64)zone_movable_pfn[i] << PAGE_SHIFT);
 	}
 
-	/*
-	 * Print out the early node map, and initialize the
-	 * subsection-map relative to active online memory ranges to
-	 * enable future "sub-section" extensions of the memory map.
-	 */
+	/* Print out the early node map. */
 	pr_info("Early memory node ranges\n");
-	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid)
 		pr_info("  node %3d: [mem %#018Lx-%#018Lx]\n", nid,
 			(u64)start_pfn << PAGE_SHIFT,
 			((u64)end_pfn << PAGE_SHIFT) - 1);
-		sparse_init_subsection_map(start_pfn, end_pfn - start_pfn);
-	}
 
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
--- a/mm/sparse.c~mm-sparse-move-subsection_map_init-into-sparse_init
+++ a/mm/sparse.c
@@ -361,5 +361,6 @@ void __init sparse_init(void)
 	}
 	/* cover the last node */
 	sparse_init_nid(nid_begin, pnum_begin, pnum_end, map_count);
+	sparse_init_subsection_map();
 	vmemmap_populate_print_last();
 }
--- a/mm/sparse-vmemmap.c~mm-sparse-move-subsection_map_init-into-sparse_init
+++ a/mm/sparse-vmemmap.c
@@ -603,7 +603,7 @@ static void subsection_mask_set(unsigned
 	bitmap_set(map, idx, end - idx + 1);
 }
 
-void __init sparse_init_subsection_map(unsigned long pfn, unsigned long nr_pages)
+static void __init sparse_init_subsection_map_range(unsigned long pfn, unsigned long nr_pages)
 {
 	int end_sec_nr = pfn_to_section_nr(pfn + nr_pages - 1);
 	unsigned long nr, start_sec_nr = pfn_to_section_nr(pfn);
@@ -626,6 +626,15 @@ void __init sparse_init_subsection_map(u
 	}
 }
 
+void __init sparse_init_subsection_map(void)
+{
+	int i, nid;
+	unsigned long start, end;
+
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid)
+		sparse_init_subsection_map_range(start, end - start);
+}
+
 #ifdef CONFIG_MEMORY_HOTPLUG
 
 /* Mark all memory sections within the pfn range as online */
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

selftests-mm-remove-obsolete-hugetlb-vmemmap-test.patch

