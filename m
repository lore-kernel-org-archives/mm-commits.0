Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74A91FC3
	for <mm-commits@vger.kernel.org>; Thu,  7 Aug 2025 00:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754526547; cv=none; b=VNXyjSkgqnY3S+RnowmbgSDCHFNPcQMuWQoO7kP8A9PobOE2S4M8KctGPDqrpsim+al/Nt7SfLg5maTpOj3K94lDQOSDfPnZfqBUF+X84V/7+SoYEg3/CiTC+OhFRODHrEb9z8THLRwhANrLj6FbDhZ0T6DiSryYuE8259YFEbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754526547; c=relaxed/simple;
	bh=aXFlx+uEgExrQc0CAXD6QXCMQPF+yHT9xPuWIXyC77Y=;
	h=Date:To:From:Subject:Message-Id; b=kcXiDiSHNPnja7+d9PJPrXq4HMFE7tTOiRu2/7bQd3S/Sa1yXgNWYPNdcU6dlktUKuCJnFxmlh+h1f3udvoL/j9BVM3mgGHkGGDVgEG3iEdN+7w4q+DoLUw7h9iYLt5fXxRHQh8S4PICzAq5J7xAqvovBiyjgEDK088yYEASLFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z6Om34Q+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z6Om34Q+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234E9C4CEE7;
	Thu,  7 Aug 2025 00:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754526547;
	bh=aXFlx+uEgExrQc0CAXD6QXCMQPF+yHT9xPuWIXyC77Y=;
	h=Date:To:From:Subject:From;
	b=Z6Om34Q+cZPMioqFghlEh8NoBWT6kZ9U0XR391YJZUcRk2SvwyR2HeZKGYlIsQzH6
	 C0A80jVfoPOfY13YFKUyTgjBTuqOHFkufiE0UNofdNO7HuNy44fhJLzHZqkC0D7lNx
	 aHQw2ooQewn79WiT3Gg+FXH8giKcrShqAjYck/S8=
Date: Wed, 06 Aug 2025 17:29:06 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,riel@surriel.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,harry.yoo@oracle.com,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-do-__folio_mod_stat-in-__folio_add_rmap.patch added to mm-new branch
Message-Id: <20250807002907.234E9C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: do __folio_mod_stat() in __folio_add_rmap()
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-do-__folio_mod_stat-in-__folio_add_rmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-do-__folio_mod_stat-in-__folio_add_rmap.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/rmap: do __folio_mod_stat() in __folio_add_rmap()
Date: Mon, 4 Aug 2025 06:41:06 +0000

It is required to modify folio statistic after rmap changes, so it looks
reasonable to do it in __folio_add_rmap(), which is the current behavior
of __folio_remove_rmap() and folio_add_new_anon_rmap().

Call __folio_mod_stat() in __folio_add_rmap(), so that rmap adjustment
family shares the same pattern.

Link: https://lkml.kernel.org/r/20250804064106.21269-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   67 ++++++++++++++++++++++++----------------------------
 1 file changed, 31 insertions(+), 36 deletions(-)

--- a/mm/rmap.c~mm-rmap-do-__folio_mod_stat-in-__folio_add_rmap
+++ a/mm/rmap.c
@@ -1241,13 +1241,35 @@ int pfn_mkclean_range(unsigned long pfn,
 	return page_vma_mkclean_one(&pvmw);
 }
 
-static __always_inline unsigned int __folio_add_rmap(struct folio *folio,
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
+static __always_inline void __folio_add_rmap(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *vma,
-		enum rmap_level level, int *nr_pmdmapped)
+		enum rmap_level level)
 {
 	atomic_t *mapped = &folio->_nr_pages_mapped;
 	const int orig_nr_pages = nr_pages;
-	int first = 0, nr = 0;
+	int first = 0, nr = 0, nr_pmdmapped = 0;
 
 	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
 
@@ -1283,7 +1305,7 @@ static __always_inline unsigned int __fo
 		first = atomic_inc_and_test(&folio->_entire_mapcount);
 		if (IS_ENABLED(CONFIG_NO_PAGE_MAPCOUNT)) {
 			if (level == RMAP_LEVEL_PMD && first)
-				*nr_pmdmapped = folio_large_nr_pages(folio);
+				nr_pmdmapped = folio_large_nr_pages(folio);
 			nr = folio_inc_return_large_mapcount(folio, vma);
 			if (nr == 1)
 				/* Was completely unmapped. */
@@ -1302,7 +1324,7 @@ static __always_inline unsigned int __fo
 				 * folios separately.
 				 */
 				if (level == RMAP_LEVEL_PMD)
-					*nr_pmdmapped = nr_pages;
+					nr_pmdmapped = nr_pages;
 				nr = nr_pages - (nr & FOLIO_PAGES_MAPPED);
 				/* Raced ahead of a remove and another add? */
 				if (unlikely(nr < 0))
@@ -1315,7 +1337,7 @@ static __always_inline unsigned int __fo
 		folio_inc_large_mapcount(folio, vma);
 		break;
 	}
-	return nr;
+	__folio_mod_stat(folio, nr, nr_pmdmapped);
 }
 
 /**
@@ -1403,43 +1425,19 @@ static void __page_check_anon_rmap(const
 		       page);
 }
 
-static void __folio_mod_stat(struct folio *folio, int nr, int nr_pmdmapped)
-{
-	int idx;
-
-	if (nr) {
-		idx = folio_test_anon(folio) ? NR_ANON_MAPPED : NR_FILE_MAPPED;
-		__lruvec_stat_mod_folio(folio, idx, nr);
-	}
-	if (nr_pmdmapped) {
-		if (folio_test_anon(folio)) {
-			idx = NR_ANON_THPS;
-			__lruvec_stat_mod_folio(folio, idx, nr_pmdmapped);
-		} else {
-			/* NR_*_PMDMAPPED are not maintained per-memcg */
-			idx = folio_test_swapbacked(folio) ?
-				NR_SHMEM_PMDMAPPED : NR_FILE_PMDMAPPED;
-			__mod_node_page_state(folio_pgdat(folio), idx,
-					      nr_pmdmapped);
-		}
-	}
-}
-
 static __always_inline void __folio_add_anon_rmap(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *vma,
 		unsigned long address, rmap_t flags, enum rmap_level level)
 {
-	int i, nr, nr_pmdmapped = 0;
+	int i;
 
 	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
 
-	nr = __folio_add_rmap(folio, page, nr_pages, vma, level, &nr_pmdmapped);
+	__folio_add_rmap(folio, page, nr_pages, vma, level);
 
 	if (likely(!folio_test_ksm(folio)))
 		__page_check_anon_rmap(folio, page, vma, address);
 
-	__folio_mod_stat(folio, nr, nr_pmdmapped);
-
 	if (flags & RMAP_EXCLUSIVE) {
 		switch (level) {
 		case RMAP_LEVEL_PTE:
@@ -1613,12 +1611,9 @@ static __always_inline void __folio_add_
 		struct page *page, int nr_pages, struct vm_area_struct *vma,
 		enum rmap_level level)
 {
-	int nr, nr_pmdmapped = 0;
-
 	VM_WARN_ON_FOLIO(folio_test_anon(folio), folio);
 
-	nr = __folio_add_rmap(folio, page, nr_pages, vma, level, &nr_pmdmapped);
-	__folio_mod_stat(folio, nr, nr_pmdmapped);
+	__folio_add_rmap(folio, page, nr_pages, vma, level);
 
 	/* See comments in folio_add_anon_rmap_*() */
 	if (!folio_test_large(folio))
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-rmap-do-__folio_mod_stat-in-__folio_add_rmap.patch

