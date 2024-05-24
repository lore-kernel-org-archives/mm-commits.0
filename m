Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA5729429
	for <mm-commits@vger.kernel.org>; Fri, 24 May 2024 20:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716582730; cv=none; b=Rbe/rjqyDaZryfjmWIdjiVUb5QFCBVeVk8nM6r5YBBv80pKxfDPrALx/7ioDJIK/MXFaFKbs3AM7N1Bf/ndL9gdxWHDOMXAbZ8UkuW4bwwTFXuufasVq/4uRi+IWNexq7eRI9LYU0IuaEENra9Mz4EJpFrhwlTAyPB+gv/TqewQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716582730; c=relaxed/simple;
	bh=1w8CW1NMjwmh9hyo1VA9nEocDl3LxAX7iIrdqDDW/Ms=;
	h=Date:To:From:Subject:Message-Id; b=qdvRRijwcn5a9hFyHbaXhv1RmxFyEXW15P3lh+dTivt9FylF3/LHfUq88jTLNcnbmhvzDQt3PrHPwUfNqWN8cw4hh2oe0H8UzIxda7mt1QNIG46h9DGKSdb3Cjg4RPjNL6UPAx5SIG+cBRKJl2v/xHUeL/wc1DUDHDSnIxn48fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2mp3C0ij; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2mp3C0ij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5CE6C2BBFC;
	Fri, 24 May 2024 20:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716582729;
	bh=1w8CW1NMjwmh9hyo1VA9nEocDl3LxAX7iIrdqDDW/Ms=;
	h=Date:To:From:Subject:From;
	b=2mp3C0ijsCA3DvU3BDkbw1X3YidDKHmqf9eB5FS45PNbv2vazX04pqwsYOns/dtM8
	 mOxvI5WQoX/ZKdNBXAOMHF4zvbxAdLxbBTxlOYlZQkIbL07FgkG/+TxXk4Jho1Sw/v
	 FiqKyeG5bO6xdke/jX/w4HsCpCVptmeTYqecSqt0=
Date: Fri, 24 May 2024 13:32:09 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-abstract-updating-per-node-and-per-memcg-stats.patch added to mm-unstable branch
Message-Id: <20240524203209.B5CE6C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: rmap: abstract updating per-node and per-memcg stats
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-abstract-updating-per-node-and-per-memcg-stats.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-abstract-updating-per-node-and-per-memcg-stats.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lkml.kernel.org/r/20240506211333.346605-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
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
+	__folio_mod_stat(folio, nr, nr_pmdmapped);
 
 	/*
 	 * It would be tidy to reset folio_test_anon mapping when fully
_

Patches currently in -mm which might be from yosryahmed@google.com are

mm-zswap-use-sg_set_folio-in-zswap_compress-decompress.patch
mm-zswap-use-kmap_local_folio-in-zswap_load.patch
mm-zswap-make-same_filled-functions-folio-friendly.patch
mm-rmap-abstract-updating-per-node-and-per-memcg-stats.patch

