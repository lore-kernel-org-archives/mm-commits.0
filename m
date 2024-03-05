Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74FC28833
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600583; cv=none; b=E0g9sKbwe9xjvGVL5wFX7NheLkOHf0rxUfkc1+Gvpofh15zpbaTnI/IvSjg/wMOjs6Pdl6JSu6z383+CcF506uTUrlu5735Q/23PEGmwdYMAg0wUnl+NfO34olUkOZ7XpxU0+zWCBe1mDjE4520kXjcnTjVL3ghD5PlZ/IaqUCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600583; c=relaxed/simple;
	bh=QE3DtHsyISyreD6EbSJF9qGX0FsqolEZ0orLK2yq1QU=;
	h=Date:To:From:Subject:Message-Id; b=YwbLixKt2pRDUs7DJPIhuoXa9GmsNAOrL7UX24CUZIgTjoZAcKbEhs2Z1xgDaAVW7nYjVGhQZgDdM5dkvqF3wO+8iBAHLyF/6pDlPZNleEaT2XcUBs/7AlQ9BS57lBqSMGV5BR3GJ22koZPfK3cEj4I3EJYO8RSJgY6gp/jHpM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y72x1JpR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y72x1JpR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3D5C433C7;
	Tue,  5 Mar 2024 01:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600582;
	bh=QE3DtHsyISyreD6EbSJF9qGX0FsqolEZ0orLK2yq1QU=;
	h=Date:To:From:Subject:From;
	b=y72x1JpRWfH46i/C10H26VoLX58BSKl94RT/qRtsBhD5z3uPMllGLN32vh1s+de9I
	 JKGS8gYANmrE9XIcys6fkY37rFoqSgQdAVEqU4CANhsv8aGRMOg7a7JAigqkkTZdtG
	 biR5G1y28mMmwUN+nDFnPrfbxlp/6Lr0BDg1fcKw=
Date: Mon, 04 Mar 2024 17:03:01 -0800
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-folio-more-widely-in-__split_huge_page.patch removed from -mm tree
Message-Id: <20240305010302.0B3D5C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use folio more widely in __split_huge_page
has been removed from the -mm tree.  Its filename was
     mm-use-folio-more-widely-in-__split_huge_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: use folio more widely in __split_huge_page
Date: Wed, 28 Feb 2024 16:42:36 +0000

We already have a folio; use it instead of the head page where reasonable.
Saves a couple of calls to compound_head() and elimimnates a few
references to page->mapping.

Link: https://lkml.kernel.org/r/20240228164326.1355045-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/mm/huge_memory.c~mm-use-folio-more-widely-in-__split_huge_page
+++ a/mm/huge_memory.c
@@ -2919,7 +2919,7 @@ static void __split_huge_page(struct pag
 		if (head[i].index >= end) {
 			struct folio *tail = page_folio(head + i);
 
-			if (shmem_mapping(head->mapping))
+			if (shmem_mapping(folio->mapping))
 				nr_dropped++;
 			else if (folio_test_clear_dirty(tail))
 				folio_account_cleaned(tail,
@@ -2927,7 +2927,7 @@ static void __split_huge_page(struct pag
 			__filemap_remove_folio(tail, NULL);
 			folio_put(tail);
 		} else if (!PageAnon(page)) {
-			__xa_store(&head->mapping->i_pages, head[i].index,
+			__xa_store(&folio->mapping->i_pages, head[i].index,
 					head + i, 0);
 		} else if (swap_cache) {
 			__xa_store(&swap_cache->i_pages, offset + i,
@@ -2948,23 +2948,23 @@ static void __split_huge_page(struct pag
 	split_page_owner(head, order, new_order);
 
 	/* See comment in __split_huge_page_tail() */
-	if (PageAnon(head)) {
+	if (folio_test_anon(folio)) {
 		/* Additional pin to swap cache */
-		if (PageSwapCache(head)) {
-			page_ref_add(head, 1 + new_nr);
+		if (folio_test_swapcache(folio)) {
+			folio_ref_add(folio, 1 + new_nr);
 			xa_unlock(&swap_cache->i_pages);
 		} else {
-			page_ref_inc(head);
+			folio_ref_inc(folio);
 		}
 	} else {
 		/* Additional pin to page cache */
-		page_ref_add(head, 1 + new_nr);
-		xa_unlock(&head->mapping->i_pages);
+		folio_ref_add(folio, 1 + new_nr);
+		xa_unlock(&folio->mapping->i_pages);
 	}
 	local_irq_enable();
 
 	if (nr_dropped)
-		shmem_uncharge(head->mapping->host, nr_dropped);
+		shmem_uncharge(folio->mapping->host, nr_dropped);
 	remap_page(folio, nr);
 
 	if (folio_test_swapcache(folio))
@@ -2980,9 +2980,10 @@ static void __split_huge_page(struct pag
 
 	for (i = 0; i < nr; i += new_nr) {
 		struct page *subpage = head + i;
+		struct folio *new_folio = page_folio(subpage);
 		if (subpage == page)
 			continue;
-		unlock_page(subpage);
+		folio_unlock(new_folio);
 
 		/*
 		 * Subpages may be freed if there wasn't any mapping
_

Patches currently in -mm which might be from willy@infradead.org are

mm-separate-out-folio_flags-from-pageflags.patch
mm-remove-pagewaiters-pagesetwaiters-and-pageclearwaiters.patch
mm-remove-pageyoung-and-pageidle-definitions.patch
mm-add-__dump_folio.patch
mm-add-__dump_folio-fix.patch
mm-add-__dump_folio-fix-2.patch
mm-add-__dump_folio-fix-3.patch
mm-make-dump_page-take-a-const-argument.patch
mm-constify-testing-page-folio-flags.patch
mm-constify-more-page-folio-tests.patch
mm-remove-cast-from-page_to_nid.patch
mm-mempolicy-use-a-folio-in-do_mbind.patch

