Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36FA3ED3B4
	for <mm-commits@vger.kernel.org>; Mon, 21 Sep 2026 22:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790030974; cv=none; b=K/4bRbuxD74gF9uG6uvCcx/MJrhByR4d1NrxSozjI+U2QbXkKaMHm5jMb6gp0j6ZmM7q3Qeufx2JprJT/brMiUFTydA/VwGh+nSJ/EmpDquLFaL0slzxWQzaIIdOg47Ha2SfzwpJ+orRchdHvYxUeUpXikAr9tHW3MGuFhB5lTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790030974; c=relaxed/simple;
	bh=ie59aupRYZl2w3gPN7uoXn2Ulv+DyEWwzjrC/bZK+HI=;
	h=Date:To:From:Subject:Message-Id; b=excb5GN1rm6Hdtgvipyea6koz2u/V/1dmxeDjfGd0+VBE4ep4WCy3gi/XFcVhkCaFrUAfRvwiyvWp1l067RMGW/QI5GEPBgB7K7nbFNZtHflYdLa71Vp1H/BLjakq+s3UgBoGpGcv0ARCaK8fK8ewB1pj2ZkRcBTvUtooH5UXK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pscOJZTh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pscOJZTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A6F1F000FF;
	Mon, 21 Sep 2026 22:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790030972;
	bh=vPv7jbYlj5mD3Y6213XO/xUG2uiuGHW5wD8GyvzmUDY=;
	h=Date:To:From:Subject;
	b=pscOJZTh/kDM9G79bifKvDN2y0eeId+LIKjDem5MUhL5wxdFqKM9fMg38iXxthdC/
	 xXmdYVuHwWWn/NOXtGhTnfHx8BtpyIvHrf6IxNwsBAmuRx208X3QPyFTiqOrYZz9jx
	 5Jt0cdnUt9yluROw7sBhC+lWcsAlE+My6+9Nha4Q=
Date: Mon, 21 Sep 2026 15:49:32 -0700
To: mm-commits@vger.kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-refactor-sparse_sections_init.patch added to mm-new branch
Message-Id: <20260921224932.85A6F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse: refactor sparse_sections_init()
has been added to the -mm mm-new branch.  Its filename is
     mm-sparse-refactor-sparse_sections_init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-refactor-sparse_sections_init.patch

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
Subject: mm/sparse: refactor sparse_sections_init()
Date: Mon, 21 Sep 2026 21:58:54 +0200

memory_present() really identifies+prepares all early sections so the
initialization in sparse_init() can properly iterating them to initialize
metadata.

Let's just inline memory_present() into sparse_sections_init() and
cleaning up the code a bit while at it: make it clear that we are
operating on pfns.

Note that we call set_section_nid() now only if the section was not
already created earlier.  Now, there is no more inconsistency between what
we (temporarily) store in ms->section_mem_map and what we store in our
section->nid array.

Link: https://lore.kernel.org/20260921-b4-sparsemem_cleanups-v2-2-54d81d65e125@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
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

 mm/sparse.c |   41 +++++++++++++++++------------------------
 1 file changed, 17 insertions(+), 24 deletions(-)

--- a/mm/sparse.c~mm-sparse-refactor-sparse_sections_init
+++ a/mm/sparse.c
@@ -179,40 +179,33 @@ static inline unsigned long first_presen
 	return next_present_section_nr(-1);
 }
 
-/* Record a memory area against a node. */
-static void __init memory_present(int nid, unsigned long start, unsigned long end)
+void __init sparse_sections_init(void)
 {
-	unsigned long pfn;
+	unsigned long pfn, start_pfn, end_pfn;
+	int i, nid;
 
-	start &= PAGE_SECTION_MASK;
-	mminit_validate_memmodel_limits(&start, &end);
-	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION) {
-		unsigned long section_nr = pfn_to_section_nr(pfn);
-		struct mem_section *ms;
+	sparse_extreme_init();
 
-		sparse_index_init(section_nr, nid);
-		set_section_nid(section_nr, nid);
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
+		start_pfn &= PAGE_SECTION_MASK;
+		mminit_validate_memmodel_limits(&start_pfn, &end_pfn);
+
+		for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
+			unsigned long section_nr = pfn_to_section_nr(pfn);
+			struct mem_section *ms;
+
+			sparse_index_init(section_nr, nid);
+			ms = __nr_to_section(section_nr);
+			if (ms->section_mem_map)
+				continue;
 
-		ms = __nr_to_section(section_nr);
-		if (!ms->section_mem_map) {
+			set_section_nid(section_nr, nid);
 			ms->section_mem_map = sparse_encode_early_nid(nid) |
 							SECTION_IS_ONLINE;
 			__section_mark_present(ms, section_nr);
 		}
 	}
 }
-
-void __init sparse_sections_init(void)
-{
-	unsigned long start, end;
-	int i, nid;
-
-	sparse_extreme_init();
-
-	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid)
-		memory_present(nid, start, end);
-}
-
 #ifndef CONFIG_SPARSEMEM_VMEMMAP
 struct page __init *__populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
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

