Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DCDF9E8
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 18:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763402869; cv=none; b=nqHB1q6HCbwBOTvYJcIuU+7xD/mfToMza3DIaGHqVnxzn6mMTf4ASvqEah05AvbwC6bmw7EMvUcwjO2s7CMvgRjAkVmU5vj1Gdm0ktRmHsfz9afk2wz70tJz4AQSU/plvRrYw4GaZ5eMPBFBLAa6YcdJcpsH8iN7bzlYSpcZEEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763402869; c=relaxed/simple;
	bh=7sCHvRFTPxiNqihDN9+Esv37YukzLyK8CdTanFsZaqU=;
	h=Date:To:From:Subject:Message-Id; b=Ku00IkVNnWKGfjJuv5hvB5IWGHmBkzuW00z0kaY8wmn+XqxrtwgjkQcbiXgfOYjwbbJ1OcEjsaLM+h2dwviZPkfHI4jp7hkdYHDcWvBeAFaRE+Xjq4GhQFyOlYwKOeJpF6u6Hfa7tGoBCrnNIhTw5JB98H/3XTIJwzCKYV02qc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pBeKDjBf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pBeKDjBf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA623C113D0;
	Mon, 17 Nov 2025 18:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763402869;
	bh=7sCHvRFTPxiNqihDN9+Esv37YukzLyK8CdTanFsZaqU=;
	h=Date:To:From:Subject:From;
	b=pBeKDjBfgFooAbmXbBrHrQHb/2/jKdY7SBugDakJbCi6/1U69qiZ5woS4UCawzkFa
	 m2fkHRk6Nzn0Jx/rhUS9Dc6x7RXAaT8iOPHvMLRWKrtgzC8tppvo5jEzOf9GjLFddW
	 0vV9g5jeOdU7smfO0jq9f/qDC+W86zE5fr7ySV+w=
Date: Mon, 17 Nov 2025 10:07:47 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,harry.yoo@oracle.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-remove-__lruvec_stat_mod_folio.patch added to mm-new branch
Message-Id: <20251117180748.BA623C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: remove __lruvec_stat_mod_folio
has been added to the -mm mm-new branch.  Its filename is
     memcg-remove-__lruvec_stat_mod_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-remove-__lruvec_stat_mod_folio.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: remove __lruvec_stat_mod_folio
Date: Mon, 10 Nov 2025 15:20:08 -0800

__lruvec_stat_mod_folio() is already safe against irqs, so there is no
need to have a separate interface (i.e.  lruvec_stat_mod_folio) which
wraps calls to it with irq disabling and reenabling.  Let's rename
__lruvec_stat_mod_folio() to lruvec_stat_mod_folio().

Link: https://lkml.kernel.org/r/20251110232008.1352063-5-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |   30 +-----------------------------
 mm/filemap.c           |   20 ++++++++++----------
 mm/huge_memory.c       |    4 ++--
 mm/khugepaged.c        |    8 ++++----
 mm/memcontrol.c        |    4 ++--
 mm/page-writeback.c    |    2 +-
 mm/rmap.c              |    4 ++--
 mm/shmem.c             |    6 +++---
 8 files changed, 25 insertions(+), 53 deletions(-)

--- a/include/linux/vmstat.h~memcg-remove-__lruvec_stat_mod_folio
+++ a/include/linux/vmstat.h
@@ -523,19 +523,9 @@ static inline const char *vm_event_name(
 void mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			int val);
 
-void __lruvec_stat_mod_folio(struct folio *folio,
+void lruvec_stat_mod_folio(struct folio *folio,
 			     enum node_stat_item idx, int val);
 
-static inline void lruvec_stat_mod_folio(struct folio *folio,
-					 enum node_stat_item idx, int val)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__lruvec_stat_mod_folio(folio, idx, val);
-	local_irq_restore(flags);
-}
-
 static inline void mod_lruvec_page_state(struct page *page,
 					 enum node_stat_item idx, int val)
 {
@@ -550,12 +540,6 @@ static inline void mod_lruvec_state(stru
 	mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
 }
 
-static inline void __lruvec_stat_mod_folio(struct folio *folio,
-					 enum node_stat_item idx, int val)
-{
-	mod_node_page_state(folio_pgdat(folio), idx, val);
-}
-
 static inline void lruvec_stat_mod_folio(struct folio *folio,
 					 enum node_stat_item idx, int val)
 {
@@ -570,18 +554,6 @@ static inline void mod_lruvec_page_state
 
 #endif /* CONFIG_MEMCG */
 
-static inline void __lruvec_stat_add_folio(struct folio *folio,
-					   enum node_stat_item idx)
-{
-	__lruvec_stat_mod_folio(folio, idx, folio_nr_pages(folio));
-}
-
-static inline void __lruvec_stat_sub_folio(struct folio *folio,
-					   enum node_stat_item idx)
-{
-	__lruvec_stat_mod_folio(folio, idx, -folio_nr_pages(folio));
-}
-
 static inline void lruvec_stat_add_folio(struct folio *folio,
 					 enum node_stat_item idx)
 {
--- a/mm/filemap.c~memcg-remove-__lruvec_stat_mod_folio
+++ a/mm/filemap.c
@@ -182,13 +182,13 @@ static void filemap_unaccount_folio(stru
 
 	nr = folio_nr_pages(folio);
 
-	__lruvec_stat_mod_folio(folio, NR_FILE_PAGES, -nr);
+	lruvec_stat_mod_folio(folio, NR_FILE_PAGES, -nr);
 	if (folio_test_swapbacked(folio)) {
-		__lruvec_stat_mod_folio(folio, NR_SHMEM, -nr);
+		lruvec_stat_mod_folio(folio, NR_SHMEM, -nr);
 		if (folio_test_pmd_mappable(folio))
-			__lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, -nr);
+			lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, -nr);
 	} else if (folio_test_pmd_mappable(folio)) {
-		__lruvec_stat_mod_folio(folio, NR_FILE_THPS, -nr);
+		lruvec_stat_mod_folio(folio, NR_FILE_THPS, -nr);
 		filemap_nr_thps_dec(mapping);
 	}
 	if (test_bit(AS_KERNEL_FILE, &folio->mapping->flags))
@@ -844,13 +844,13 @@ void replace_page_cache_folio(struct fol
 	old->mapping = NULL;
 	/* hugetlb pages do not participate in page cache accounting. */
 	if (!folio_test_hugetlb(old))
-		__lruvec_stat_sub_folio(old, NR_FILE_PAGES);
+		lruvec_stat_sub_folio(old, NR_FILE_PAGES);
 	if (!folio_test_hugetlb(new))
-		__lruvec_stat_add_folio(new, NR_FILE_PAGES);
+		lruvec_stat_add_folio(new, NR_FILE_PAGES);
 	if (folio_test_swapbacked(old))
-		__lruvec_stat_sub_folio(old, NR_SHMEM);
+		lruvec_stat_sub_folio(old, NR_SHMEM);
 	if (folio_test_swapbacked(new))
-		__lruvec_stat_add_folio(new, NR_SHMEM);
+		lruvec_stat_add_folio(new, NR_SHMEM);
 	xas_unlock_irq(&xas);
 	if (free_folio)
 		free_folio(old);
@@ -933,9 +933,9 @@ noinline int __filemap_add_folio(struct
 
 		/* hugetlb pages do not participate in page cache accounting */
 		if (!huge) {
-			__lruvec_stat_mod_folio(folio, NR_FILE_PAGES, nr);
+			lruvec_stat_mod_folio(folio, NR_FILE_PAGES, nr);
 			if (folio_test_pmd_mappable(folio))
-				__lruvec_stat_mod_folio(folio,
+				lruvec_stat_mod_folio(folio,
 						NR_FILE_THPS, nr);
 		}
 
--- a/mm/huge_memory.c~memcg-remove-__lruvec_stat_mod_folio
+++ a/mm/huge_memory.c
@@ -3783,10 +3783,10 @@ static int __folio_freeze_and_split_unma
 			if (folio_test_pmd_mappable(folio) &&
 			    new_order < HPAGE_PMD_ORDER) {
 				if (folio_test_swapbacked(folio)) {
-					__lruvec_stat_mod_folio(folio,
+					lruvec_stat_mod_folio(folio,
 							NR_SHMEM_THPS, -nr);
 				} else {
-					__lruvec_stat_mod_folio(folio,
+					lruvec_stat_mod_folio(folio,
 							NR_FILE_THPS, -nr);
 					filemap_nr_thps_dec(mapping);
 				}
--- a/mm/khugepaged.c~memcg-remove-__lruvec_stat_mod_folio
+++ a/mm/khugepaged.c
@@ -2195,14 +2195,14 @@ immap_locked:
 	}
 
 	if (is_shmem)
-		__lruvec_stat_mod_folio(new_folio, NR_SHMEM_THPS, HPAGE_PMD_NR);
+		lruvec_stat_mod_folio(new_folio, NR_SHMEM_THPS, HPAGE_PMD_NR);
 	else
-		__lruvec_stat_mod_folio(new_folio, NR_FILE_THPS, HPAGE_PMD_NR);
+		lruvec_stat_mod_folio(new_folio, NR_FILE_THPS, HPAGE_PMD_NR);
 
 	if (nr_none) {
-		__lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, nr_none);
+		lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, nr_none);
 		/* nr_none is always 0 for non-shmem. */
-		__lruvec_stat_mod_folio(new_folio, NR_SHMEM, nr_none);
+		lruvec_stat_mod_folio(new_folio, NR_SHMEM, nr_none);
 	}
 
 	/*
--- a/mm/memcontrol.c~memcg-remove-__lruvec_stat_mod_folio
+++ a/mm/memcontrol.c
@@ -777,7 +777,7 @@ void mod_lruvec_state(struct lruvec *lru
 		mod_memcg_lruvec_state(lruvec, idx, val);
 }
 
-void __lruvec_stat_mod_folio(struct folio *folio, enum node_stat_item idx,
+void lruvec_stat_mod_folio(struct folio *folio, enum node_stat_item idx,
 			     int val)
 {
 	struct mem_cgroup *memcg;
@@ -797,7 +797,7 @@ void __lruvec_stat_mod_folio(struct foli
 	mod_lruvec_state(lruvec, idx, val);
 	rcu_read_unlock();
 }
-EXPORT_SYMBOL(__lruvec_stat_mod_folio);
+EXPORT_SYMBOL(lruvec_stat_mod_folio);
 
 void mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
 {
--- a/mm/page-writeback.c~memcg-remove-__lruvec_stat_mod_folio
+++ a/mm/page-writeback.c
@@ -2658,7 +2658,7 @@ static void folio_account_dirtied(struct
 		inode_attach_wb(inode, folio);
 		wb = inode_to_wb(inode);
 
-		__lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, nr);
+		lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, nr);
 		__zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
 		__node_stat_mod_folio(folio, NR_DIRTIED, nr);
 		wb_stat_mod(wb, WB_RECLAIMABLE, nr);
--- a/mm/rmap.c~memcg-remove-__lruvec_stat_mod_folio
+++ a/mm/rmap.c
@@ -1212,12 +1212,12 @@ static void __folio_mod_stat(struct foli
 
 	if (nr) {
 		idx = folio_test_anon(folio) ? NR_ANON_MAPPED : NR_FILE_MAPPED;
-		__lruvec_stat_mod_folio(folio, idx, nr);
+		lruvec_stat_mod_folio(folio, idx, nr);
 	}
 	if (nr_pmdmapped) {
 		if (folio_test_anon(folio)) {
 			idx = NR_ANON_THPS;
-			__lruvec_stat_mod_folio(folio, idx, nr_pmdmapped);
+			lruvec_stat_mod_folio(folio, idx, nr_pmdmapped);
 		} else {
 			/* NR_*_PMDMAPPED are not maintained per-memcg */
 			idx = folio_test_swapbacked(folio) ?
--- a/mm/shmem.c~memcg-remove-__lruvec_stat_mod_folio
+++ a/mm/shmem.c
@@ -871,9 +871,9 @@ static unsigned int shmem_huge_global_en
 static void shmem_update_stats(struct folio *folio, int nr_pages)
 {
 	if (folio_test_pmd_mappable(folio))
-		__lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, nr_pages);
-	__lruvec_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
-	__lruvec_stat_mod_folio(folio, NR_SHMEM, nr_pages);
+		lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, nr_pages);
+	lruvec_stat_mod_folio(folio, NR_FILE_PAGES, nr_pages);
+	lruvec_stat_mod_folio(folio, NR_SHMEM, nr_pages);
 }
 
 /*
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

mm-memcg-dump-memcg-protection-info-on-oom-or-alloc-failures.patch
memcg-use-mod_node_page_state-to-update-stats.patch
memcg-remove-__mod_lruvec_kmem_state.patch
memcg-remove-__mod_lruvec_state.patch
memcg-remove-__lruvec_stat_mod_folio.patch

