Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9879A13AD1C
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744939; cv=none; b=D4RJJPyNjneqUM1xSncj/Bij7XG4dmi6/+MdbCZy0/wfIonZOoQq1h2fzMAyORo2IU7/fv6ItkWnRWtURJzxKr4MSIyiktgjv/qBZ451gQIerws5HMUgWtR/UirMjkQw5LXsJufTawSiydB2gf0i0vXX9pNPqC1d/rqh5A4UyaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744939; c=relaxed/simple;
	bh=zjqSa78W7tbz5d3JBA98fTGnwhFRKvkhdM+SHYUIvT4=;
	h=Date:To:From:Subject:Message-Id; b=NeaoPW+vGdtgqUHnm0v6iT/ARkObAiMXBcSRneGdErDoraSZgOrH1KrutghuJfA04p1hnk2dBWLBIk/BGzBAcHfBHc1hwSD6VTxsVMegO0HLIYGhNilVnlqDymoFsXtTQVJf/sDpJssA4den9Lk7SqDsH5Dra81Djl0HWNDaENw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sMdno3P8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sMdno3P8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711EDC4CEF7;
	Sun, 29 Mar 2026 00:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744939;
	bh=zjqSa78W7tbz5d3JBA98fTGnwhFRKvkhdM+SHYUIvT4=;
	h=Date:To:From:Subject:From;
	b=sMdno3P8fmcw9dWQkSOO0K5h780Gs9/6qCf8awItHRqF/m+vTLnG+83zF0hb5+mqH
	 9lLforD14qNzlQ6Hvbm6ivn/pGPMHyGjNxqAP0BesLqyxg7tF3gnccdjLHJS9Sa+nM
	 ychiFrKBmJKT4I/OxYUVM6hUZGxZ4/bVZxhzGYz8=
Date: Sat, 28 Mar 2026 17:42:18 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,vbabka@kernel.org,surenb@google.com,sidhartha.kumar@oracle.com,rppt@kernel.org,osalvador@suse.de,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,axelrasmussen@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-sparse-move-sparse_init_one_section-to-internalh.patch removed from -mm tree
Message-Id: <20260329004219.711EDC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/sparse: move sparse_init_one_section() to internal.h
has been removed from the -mm tree.  Its filename was
     mm-sparse-move-sparse_init_one_section-to-internalh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/sparse: move sparse_init_one_section() to internal.h
Date: Fri, 20 Mar 2026 23:13:45 +0100

While at it, convert the BUG_ON to a VM_WARN_ON_ONCE, avoid long lines,
and merge sparse_encode_mem_map() into its only caller
sparse_init_one_section().

Clarify the comment a bit, pointing at page_to_pfn().

[david@kernel.org: s/VM_WARN_ON/VM_WARN_ON_ONCE/]
  Link: https://lkml.kernel.org/r/6b04c1a1-74e7-42e8-8523-a40802e5dacc@kernel.org
Link: https://lkml.kernel.org/r/20260320-sparsemem_cleanups-v2-13-096addc8800d@kernel.org
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

 include/linux/mmzone.h |    2 +-
 mm/internal.h          |   22 ++++++++++++++++++++++
 mm/sparse.c            |   24 ------------------------
 3 files changed, 23 insertions(+), 25 deletions(-)

--- a/include/linux/mmzone.h~mm-sparse-move-sparse_init_one_section-to-internalh
+++ a/include/linux/mmzone.h
@@ -1988,7 +1988,7 @@ struct mem_section {
 	/*
 	 * This is, logically, a pointer to an array of struct
 	 * pages.  However, it is stored with some other magic.
-	 * (see sparse.c::sparse_init_one_section())
+	 * (see sparse_init_one_section())
 	 *
 	 * Additionally during early boot we encode node id of
 	 * the location of the section here to guide allocation.
--- a/mm/internal.h~mm-sparse-move-sparse_init_one_section-to-internalh
+++ a/mm/internal.h
@@ -964,6 +964,28 @@ void memmap_init_range(unsigned long, in
  */
 #ifdef CONFIG_SPARSEMEM
 void sparse_init(void);
+
+static inline void sparse_init_one_section(struct mem_section *ms,
+		unsigned long pnum, struct page *mem_map,
+		struct mem_section_usage *usage, unsigned long flags)
+{
+	unsigned long coded_mem_map;
+
+	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
+
+	/*
+	 * We encode the start PFN of the section into the mem_map such that
+	 * page_to_pfn() on !CONFIG_SPARSEMEM_VMEMMAP can simply subtract it
+	 * from the page pointer to obtain the PFN.
+	 */
+	coded_mem_map = (unsigned long)(mem_map - section_nr_to_pfn(pnum));
+	VM_WARN_ON_ONCE(coded_mem_map & ~SECTION_MAP_MASK);
+
+	ms->section_mem_map &= ~SECTION_MAP_MASK;
+	ms->section_mem_map |= coded_mem_map;
+	ms->section_mem_map |= flags | SECTION_HAS_MEM_MAP;
+	ms->usage = usage;
+}
 #else
 static inline void sparse_init(void) {}
 #endif /* CONFIG_SPARSEMEM */
--- a/mm/sparse.c~mm-sparse-move-sparse_init_one_section-to-internalh
+++ a/mm/sparse.c
@@ -256,30 +256,6 @@ static void __init memblocks_present(voi
 		memory_present(nid, start, end);
 }
 
-/*
- * Subtle, we encode the real pfn into the mem_map such that
- * the identity pfn - section_mem_map will return the actual
- * physical page frame number.
- */
-static unsigned long sparse_encode_mem_map(struct page *mem_map, unsigned long pnum)
-{
-	unsigned long coded_mem_map =
-		(unsigned long)(mem_map - (section_nr_to_pfn(pnum)));
-	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
-	BUG_ON(coded_mem_map & ~SECTION_MAP_MASK);
-	return coded_mem_map;
-}
-
-static void __meminit sparse_init_one_section(struct mem_section *ms,
-		unsigned long pnum, struct page *mem_map,
-		struct mem_section_usage *usage, unsigned long flags)
-{
-	ms->section_mem_map &= ~SECTION_MAP_MASK;
-	ms->section_mem_map |= sparse_encode_mem_map(mem_map, pnum)
-		| SECTION_HAS_MEM_MAP | flags;
-	ms->usage = usage;
-}
-
 static unsigned long usemap_size(void)
 {
 	return BITS_TO_LONGS(SECTION_BLOCKFLAGS_BITS) * sizeof(unsigned long);
_

Patches currently in -mm which might be from david@kernel.org are


