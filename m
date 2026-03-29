Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA3213AD1C
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744936; cv=none; b=A2l9zu8leB0FaW+WR4E29IehAeAaqu5HSeYo/sj95lAY14CHBeZTJGIUnQ/SAwqVO7v8Lpg26jNz4EmvuQiXiHHqHGqUvqRIvoRvuvNxIOv8AiWNiFEs+NMKBL8FKlPuz5qenWBZjyroNlHoCi7yji6QmIsQ341MOToShNMD/uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744936; c=relaxed/simple;
	bh=oi4eP1dNOtobbHI8+oWToTL/utCjk0UlNvkzIYJlC2o=;
	h=Date:To:From:Subject:Message-Id; b=AR8et5HOPRs4LZzGYZjW7IzxyQ68bKcL04a+z4eo/pu0vM1qyl7Zcc9AcHFc9SVTcEudEexE4xH2jAJM1SfCx/VpOwt09bIBkCWyuJOATz5YYwKopyNV+fIhTjKm+XgkF6pOsMQZBa/IN02zziq4//uwDcP44yczLeHACwbsQd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sdfls3S0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sdfls3S0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C24C4CEF7;
	Sun, 29 Mar 2026 00:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744936;
	bh=oi4eP1dNOtobbHI8+oWToTL/utCjk0UlNvkzIYJlC2o=;
	h=Date:To:From:Subject:From;
	b=Sdfls3S0IQP6PYK+tGB4WD7vu3JzqBM6o9Ddup4R9LfjDLjq0MSeYMM1uuGtIdKF3
	 TBH9jKt0OOsuWBQZIhZK/nnQDSeKcT3yUN7FThj42y5m0HC2MaTaaoT2o0X3z3Or6d
	 7N11ll4dGFTc+V8jDA+HOjwd4BZTQOqu8LQ+kunY=
Date: Sat, 28 Mar 2026 17:42:15 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,sidhartha.kumar@oracle.com,rppt@kernel.org,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,axelrasmussen@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-prepare-to-move-subsection_map_init-to-mm-sparse-vmemmapc.patch removed from -mm tree
Message-Id: <20260329004216.36C24C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: prepare to move subsection_map_init() to mm/sparse-vmemmap.c
has been removed from the -mm tree.  Its filename was
     mm-prepare-to-move-subsection_map_init-to-mm-sparse-vmemmapc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm: prepare to move subsection_map_init() to mm/sparse-vmemmap.c
Date: Fri, 20 Mar 2026 23:13:43 +0100

We want to move subsection_map_init() to mm/sparse-vmemmap.c.

To prepare for getting rid of subsection_map_init() in mm/sparse.c
completely, use a static inline function for !CONFIG_SPARSEMEM_VMEMMAP.

While at it, move the declaration to internal.h and rename it to
"sparse_init_subsection_map()".

Link: https://lkml.kernel.org/r/20260320-sparsemem_cleanups-v2-11-096addc8800d@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 ---
 mm/internal.h          |   12 ++++++++++++
 mm/mm_init.c           |    2 +-
 mm/sparse.c            |    6 +-----
 4 files changed, 14 insertions(+), 9 deletions(-)

--- a/include/linux/mmzone.h~mm-prepare-to-move-subsection_map_init-to-mm-sparse-vmemmapc
+++ a/include/linux/mmzone.h
@@ -1982,8 +1982,6 @@ struct mem_section_usage {
 	unsigned long pageblock_flags[0];
 };
 
-void subsection_map_init(unsigned long pfn, unsigned long nr_pages);
-
 struct page;
 struct page_ext;
 struct mem_section {
@@ -2376,7 +2374,6 @@ static inline unsigned long next_present
 #define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
 #define sparse_vmemmap_init_nid_late(_nid) do {} while (0)
 #define pfn_in_present_section pfn_valid
-#define subsection_map_init(_pfn, _nr_pages) do {} while (0)
 #endif /* CONFIG_SPARSEMEM */
 
 /*
--- a/mm/internal.h~mm-prepare-to-move-subsection_map_init-to-mm-sparse-vmemmapc
+++ a/mm/internal.h
@@ -959,12 +959,24 @@ void memmap_init_range(unsigned long, in
 		unsigned long, enum meminit_context, struct vmem_altmap *, int,
 		bool);
 
+/*
+ * mm/sparse.c
+ */
 #ifdef CONFIG_SPARSEMEM
 void sparse_init(void);
 #else
 static inline void sparse_init(void) {}
 #endif /* CONFIG_SPARSEMEM */
 
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+void sparse_init_subsection_map(unsigned long pfn, unsigned long nr_pages);
+#else
+static inline void sparse_init_subsection_map(unsigned long pfn,
+		unsigned long nr_pages)
+{
+}
+#endif /* CONFIG_SPARSEMEM_VMEMMAP */
+
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 
 /*
--- a/mm/mm_init.c~mm-prepare-to-move-subsection_map_init-to-mm-sparse-vmemmapc
+++ a/mm/mm_init.c
@@ -1896,7 +1896,7 @@ static void __init free_area_init(void)
 		pr_info("  node %3d: [mem %#018Lx-%#018Lx]\n", nid,
 			(u64)start_pfn << PAGE_SHIFT,
 			((u64)end_pfn << PAGE_SHIFT) - 1);
-		subsection_map_init(start_pfn, end_pfn - start_pfn);
+		sparse_init_subsection_map(start_pfn, end_pfn - start_pfn);
 	}
 
 	/* Initialise every node */
--- a/mm/sparse.c~mm-prepare-to-move-subsection_map_init-to-mm-sparse-vmemmapc
+++ a/mm/sparse.c
@@ -185,7 +185,7 @@ static void subsection_mask_set(unsigned
 	bitmap_set(map, idx, end - idx + 1);
 }
 
-void __init subsection_map_init(unsigned long pfn, unsigned long nr_pages)
+void __init sparse_init_subsection_map(unsigned long pfn, unsigned long nr_pages)
 {
 	int end_sec_nr = pfn_to_section_nr(pfn + nr_pages - 1);
 	unsigned long nr, start_sec_nr = pfn_to_section_nr(pfn);
@@ -207,10 +207,6 @@ void __init subsection_map_init(unsigned
 		nr_pages -= pfns;
 	}
 }
-#else
-void __init subsection_map_init(unsigned long pfn, unsigned long nr_pages)
-{
-}
 #endif
 
 /* Record a memory area against a node. */
_

Patches currently in -mm which might be from david@kernel.org are


