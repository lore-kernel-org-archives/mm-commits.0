Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17B2142658
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291606; cv=none; b=kMOC1zLWm+NLo+b0GWfodCD1hCDysWwkH6dbjZbWrHLyMIVCO+SuB4iXBua/6FKqo8CSTkRnOZyzVdvWZ0ixy2ZQo8siqUjj2LfAnVgXy/DppZQ0PPUNZvcnmDHhTN9FxqibSpUzqIuVcWz7YOHLZEPtHJuaaeB8I5dAourqLWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291606; c=relaxed/simple;
	bh=iKcZnP+s4g3wOT/QvGs01X3pEWc9tzYiUoADjhSx68s=;
	h=Date:To:From:Subject:Message-Id; b=EDuHMys3GyLaQQ6oyMHf7y8mCem8jTGhiu3mt2pgXZ4y2WMtSGgSzhCzG3hGHjjF0F6Zwe3WXI+aD4vlebPHN+fbC916BHCZ3olbnvsCEHqCd/zZuHaZ1DpwrrZarExhAH64nAUEv3/uarkzaUY7sqpznz08UNWHF2GohQXgKr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u8muLEWg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u8muLEWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6507DC32782;
	Tue, 25 Jun 2024 05:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291605;
	bh=iKcZnP+s4g3wOT/QvGs01X3pEWc9tzYiUoADjhSx68s=;
	h=Date:To:From:Subject:From;
	b=u8muLEWgkrQ3e3J1YvX9Gnaq5MXLGJLPkbeJOXF2nbaQ8/GJ9eiVzpM51ot0edBrJ
	 PFQFRntoUjuUqAKGr/6IIQ/3946rpUx44KOS4Zf0no/hGBG3kyjLzjIOOoy7zhh0Fs
	 GdQerdKjWHZa2WjIdydaWMWelkiFtmyCHdOxRLYs=
Date: Mon, 24 Jun 2024 22:00:04 -0700
To: mm-commits@vger.kernel.org,hughd@google.com,david@redhat.com,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-abstract-updating-per-node-and-per-memcg-stats.patch removed from -mm tree
Message-Id: <20240625050005.6507DC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: rmap: abstract updating per-node and per-memcg stats
has been removed from the -mm tree.  Its filename was
     mm-rmap-abstract-updating-per-node-and-per-memcg-stats.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: mm: rmap: abstract updating per-node and per-memcg stats
Date: Mon, 6 May 2024 21:13:33 +0000

A lot of intricacies go into updating the stats when adding or removing
mappings: which stat index to use and which function.  Abstract this away
into a new static helper in rmap.c, __folio_mod_stat().

This adds an unnecessary call to folio_test_anon() in
__folio_add_anon_rmap() and __folio_add_file_rmap().  However, the folio
struct should already be in the cache at this point, so it shouldn't cause
any noticeable overhead.

No functional change intended.

[hughd@google.com: fix /proc/meminfo]
  Link: https://lkml.kernel.org/r/49914517-dfc7-e784-fde0-0e08fafbecc2@google.com
Link: https://lkml.kernel.org/r/20240506211333.346605-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   56 ++++++++++++++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 27 deletions(-)

--- a/mm/rmap.c~mm-rmap-abstract-updating-per-node-and-per-memcg-stats
+++ a/mm/rmap.c
@@ -1269,6 +1269,28 @@ static void __page_check_anon_rmap(struc
 		       page);
 }
 
+static void __folio_mod_stat(struct folio *folio, int nr, int nr_pmdmapped)
+{
+	int idx;
+
+	if (nr) {
+		idx = folio_test_anon(folio) ? NR_ANON_MAPPED : NR_FILE_MAPPED;
+		__lruvec_stat_mod_folio(folio, idx, nr);
+	}
+	if (nr_pmdmapped) {
+		if (folio_test_anon(folio)) {
+			idx = NR_ANON_THPS;
+			__lruvec_stat_mod_folio(folio, idx, nr_pmdmapped);
+		} else {
+			/* NR_*_PMDMAPPED are not maintained per-memcg */
+			idx = folio_test_swapbacked(folio) ?
+				NR_SHMEM_PMDMAPPED : NR_FILE_PMDMAPPED;
+			__mod_node_page_state(folio_pgdat(folio), idx,
+					      nr_pmdmapped);
+		}
+	}
+}
+
 static __always_inline void __folio_add_anon_rmap(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *vma,
 		unsigned long address, rmap_t flags, enum rmap_level level)
@@ -1276,10 +1298,6 @@ static __always_inline void __folio_add_
 	int i, nr, nr_pmdmapped = 0;
 
 	nr = __folio_add_rmap(folio, page, nr_pages, level, &nr_pmdmapped);
-	if (nr_pmdmapped)
-		__lruvec_stat_mod_folio(folio, NR_ANON_THPS, nr_pmdmapped);
-	if (nr)
-		__lruvec_stat_mod_folio(folio, NR_ANON_MAPPED, nr);
 
 	if (unlikely(!folio_test_anon(folio))) {
 		VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
@@ -1297,6 +1315,8 @@ static __always_inline void __folio_add_
 		__page_check_anon_rmap(folio, page, vma, address);
 	}
 
+	__folio_mod_stat(folio, nr, nr_pmdmapped);
+
 	if (flags & RMAP_EXCLUSIVE) {
 		switch (level) {
 		case RMAP_LEVEL_PTE:
@@ -1393,6 +1413,7 @@ void folio_add_new_anon_rmap(struct foli
 		unsigned long address)
 {
 	int nr = folio_nr_pages(folio);
+	int nr_pmdmapped = 0;
 
 	VM_WARN_ON_FOLIO(folio_test_hugetlb(folio), folio);
 	VM_BUG_ON_VMA(address < vma->vm_start ||
@@ -1425,27 +1446,22 @@ void folio_add_new_anon_rmap(struct foli
 		atomic_set(&folio->_large_mapcount, 0);
 		atomic_set(&folio->_nr_pages_mapped, ENTIRELY_MAPPED);
 		SetPageAnonExclusive(&folio->page);
-		__lruvec_stat_mod_folio(folio, NR_ANON_THPS, nr);
+		nr_pmdmapped = nr;
 	}
 
-	__lruvec_stat_mod_folio(folio, NR_ANON_MAPPED, nr);
+	__folio_mod_stat(folio, nr, nr_pmdmapped);
 }
 
 static __always_inline void __folio_add_file_rmap(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *vma,
 		enum rmap_level level)
 {
-	pg_data_t *pgdat = folio_pgdat(folio);
 	int nr, nr_pmdmapped = 0;
 
 	VM_WARN_ON_FOLIO(folio_test_anon(folio), folio);
 
 	nr = __folio_add_rmap(folio, page, nr_pages, level, &nr_pmdmapped);
-	if (nr_pmdmapped)
-		__mod_node_page_state(pgdat, folio_test_swapbacked(folio) ?
-			NR_SHMEM_PMDMAPPED : NR_FILE_PMDMAPPED, nr_pmdmapped);
-	if (nr)
-		__lruvec_stat_mod_folio(folio, NR_FILE_MAPPED, nr);
+	__folio_mod_stat(folio, nr, nr_pmdmapped);
 
 	/* See comments in folio_add_anon_rmap_*() */
 	if (!folio_test_large(folio))
@@ -1494,10 +1510,8 @@ static __always_inline void __folio_remo
 		enum rmap_level level)
 {
 	atomic_t *mapped = &folio->_nr_pages_mapped;
-	pg_data_t *pgdat = folio_pgdat(folio);
 	int last, nr = 0, nr_pmdmapped = 0;
 	bool partially_mapped = false;
-	enum node_stat_item idx;
 
 	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
 
@@ -1541,20 +1555,7 @@ static __always_inline void __folio_remo
 		break;
 	}
 
-	if (nr_pmdmapped) {
-		/* NR_{FILE/SHMEM}_PMDMAPPED are not maintained per-memcg */
-		if (folio_test_anon(folio))
-			__lruvec_stat_mod_folio(folio, NR_ANON_THPS, -nr_pmdmapped);
-		else
-			__mod_node_page_state(pgdat,
-					folio_test_swapbacked(folio) ?
-					NR_SHMEM_PMDMAPPED : NR_FILE_PMDMAPPED,
-					-nr_pmdmapped);
-	}
 	if (nr) {
-		idx = folio_test_anon(folio) ? NR_ANON_MAPPED : NR_FILE_MAPPED;
-		__lruvec_stat_mod_folio(folio, idx, -nr);
-
 		/*
 		 * Queue anon large folio for deferred split if at least one
 		 * page of the folio is unmapped and at least one page
@@ -1566,6 +1567,7 @@ static __always_inline void __folio_remo
 		    list_empty(&folio->_deferred_list))
 			deferred_split_folio(folio);
 	}
+	__folio_mod_stat(folio, -nr, -nr_pmdmapped);
 
 	/*
 	 * It would be tidy to reset folio_test_anon mapping when fully
_

Patches currently in -mm which might be from yosryahmed@google.com are


