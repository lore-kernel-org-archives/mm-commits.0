Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF90475341
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 22:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790030978; cv=none; b=UH61ejIm5aQ516xSTiBHu7UPUl980ON74GwMbbZ3OkPpS6mjHrJaZVrRc0KsXH1gIiy6s8X6TIJjGrUo3IndgdxzalUFnHysQK8kNI2fQbLT4FjIuMIG02wp7l2IGgBZ6scjnvbo3MrBzUr6GCe7kGkB+ALatGpTUGWObq3NioM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790030978; c=relaxed/simple;
	bh=xrWAh6j9i2TlM4XSWoo5SHLlREop0asmP7aavXS02cM=;
	h=Date:To:From:Subject:Message-Id; b=lYVhDDwBsCpv9Jo2rk6Kgmh28ad4goxtnDN66GsVZHH3vF+nLPkIIOmi76AoYgC1lv/QJj8XiqR9uTbPkQtz2PyC86rPpr66UN/7UzeMwjsQLwpEeECATcqgjTsSJYfsu6uXPrbCPJ5mTA8HmjZqw+nM1KDIJ57YDHRpwAlDKak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C1oy5ZIP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C1oy5ZIP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F3C1F00893;
	Mon, 21 Sep 2026 22:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790030976;
	bh=QHX/Hhj2mVwatTXjI9VQxTB3+irWaO0UlpvtIWVNtUM=;
	h=Date:To:From:Subject;
	b=C1oy5ZIP2j/jzHAO9sBUHkfIVT+koOZ0aAYOAQ4O4Hn0EEppU86QEHeiy935nPGxi
	 61eq/THneHiJJQJHfcxT7UTBRQG8FwU+hPJ+cFWFFhqrSDZgrNr7LBW5C+BPOX2+KN
	 0Fmuy9TEOOBTK4qRAyUil0is76vka9vYtHMaWHyw=
Date: Mon, 21 Sep 2026 15:49:35 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-rename-and-cleanup-sparse_init_nid.patch added to mm-new branch
Message-Id: <20260921224936.63F3C1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse: rename and cleanup sparse_init_nid()
has been added to the -mm mm-new branch.  Its filename is
     mm-sparse-rename-and-cleanup-sparse_init_nid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-rename-and-cleanup-sparse_init_nid.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/sparse: rename and cleanup sparse_init_nid()
Date: Mon, 21 Sep 2026 21:58:56 +0200

Let's rename it to "sparse_metadata_init_nid", avoid the "pnum"
terminology and drop the function comment.  Further, rename the "map"
variable to "mem_map" for consistency with other functions.

Link: https://lore.kernel.org/20260921-b4-sparsemem_cleanups-v2-4-54d81d65e125@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
---

 mm/sparse.c |   41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

--- a/mm/sparse.c~mm-sparse-rename-and-cleanup-sparse_init_nid
+++ a/mm/sparse.c
@@ -221,36 +221,33 @@ void __weak __meminit vmemmap_populate_p
 {
 }
 
-/*
- * Initialize sparse on a specific node. The node spans [pnum_begin, pnum_end)
- * And number of present sections in this node is map_count.
- */
-static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
-				   unsigned long pnum_end,
-				   unsigned long map_count)
+static void __init sparse_metadata_init_nid(int nid,
+		unsigned long start_section_nr, unsigned long end_section_nr,
+		unsigned long nr_sections)
 {
-	unsigned long pnum;
 	struct mem_section_usage *usage;
+	unsigned long section_nr;
 
-	usage = memblock_alloc_node(map_count * mem_section_usage_size(),
+	usage = memblock_alloc_node(nr_sections * mem_section_usage_size(),
 				    SMP_CACHE_BYTES, nid);
 	if (!usage)
 		panic("Failed to allocate usemap for node %d\n", nid);
 
-	for_each_present_section_nr(pnum_begin, pnum) {
-		unsigned long pfn = section_nr_to_pfn(pnum);
-		struct page *map;
+	for_each_present_section_nr(start_section_nr, section_nr) {
+		const unsigned long pfn = section_nr_to_pfn(section_nr);
+		struct page *mem_map;
 
-		if (pnum >= pnum_end)
+		if (section_nr >= end_section_nr)
 			break;
 
-		map = __populate_section_memmap(pfn, PAGES_PER_SECTION,
-						nid, NULL, NULL);
-		if (!map)
-			panic("Failed to allocate memmap for section %lu\n", pnum);
+		mem_map = __populate_section_memmap(pfn, PAGES_PER_SECTION, nid,
+						    NULL, NULL);
+		if (!mem_map)
+			panic("Failed to allocate memmap for section %lu\n",
+			      section_nr);
 		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION));
-		sparse_init_one_section(__nr_to_section(pnum), pnum, map, usage,
-					SECTION_IS_EARLY);
+		sparse_init_one_section(__nr_to_section(section_nr), section_nr,
+					mem_map, usage, SECTION_IS_EARLY);
 		usage = (void *)usage + mem_section_usage_size();
 	}
 }
@@ -268,12 +265,14 @@ static void __init sparse_metadata_init(
 			nr_sections++;
 			continue;
 		}
-		sparse_init_nid(nid_begin, start_section_nr, section_nr, nr_sections);
+		sparse_metadata_init_nid(nid_begin, start_section_nr,
+					 section_nr, nr_sections);
 		nid_begin = nid;
 		start_section_nr = section_nr;
 		nr_sections = 1;
 	}
-	sparse_init_nid(nid_begin, start_section_nr, section_nr, nr_sections);
+	sparse_metadata_init_nid(nid_begin, start_section_nr, section_nr,
+				 nr_sections);
 }
 
 /*
_

Patches currently in -mm which might be from david@kernel.org are

maintainers-split-up-memory-management-memory-policy-and-migration.patch
maintainers-move-memory-tiering-under-memory-management-numa-placement.patch
maintainers-make-gregory-a-co-maintainer-of-memory-management-numa-placement.patch
selftests-mm-khugepaged-remove-str_dup-usage.patch
mm-sparse-move-mem_section-init-to-sparse_extreme_init.patch
mm-sparse-refactor-sparse_sections_init.patch
mm-sparse-move-initialization-of-section-metadata-to-sparse_metadata_init.patch
mm-sparse-rename-and-cleanup-sparse_init_nid.patch
mm-sparse-cleanup-sparse_init_one_section.patch
mm-sparse-rename-__highest_present_section_nr-to-__highest_used_section_nr.patch
mm-sparse-remove-pfn_in_present_section.patch
mm-sparse-move-__highest_used_section_nr-handling.patch
scripts-gdb-mmpy-remove-fallbacks-for-section_has_mem_map-and-section_is_early.patch
mm-sparse-remove-section_marked_present.patch
mm-sparse-remove-flags-parameter-from-sparse_init_one_section.patch
fs-proc-page-clarify-comment-in-get_max_dump_pfn.patch
mm-memory_hotplug-drop-config_have_arch_pfn_valid-handling-from-pfn_to_online_page.patch

