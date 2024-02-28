Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8567D3FBB4
	for <mm-commits@vger.kernel.org>; Wed, 28 Feb 2024 18:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709144009; cv=none; b=kPjOjqk7S3k2ma9OuHf03MvaJLZR26xCRyIy4dAtX054dByILpyWUzwGN15RO2GXYiM7ljBLFHkPdhYmXTLL7z9FjuKKsrVTM+7e2s43PmqdY0UQUD/jgFrL5Jutt6bLbhHV/JUyWUbDwE/SF/yEdT7MeV/yz7wQUU3rmDC5cx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709144009; c=relaxed/simple;
	bh=3PQ9Q4JVVpc/9AKG3bI5J21D9i9YPWJVv2r5/liGOCg=;
	h=Date:To:From:Subject:Message-Id; b=PcZnzKvDXLBg5FP3d8hZ16uJdozwISp0V3qpk/JKMbbdsAZrDE2b/AykFaRGDpOiTMIHSICK2y+sC/cdddpzI7Z/rpofJFU2SjAK6YHvyKjMbxU4YyVfNhAq0s3idleOhJUYXbgDgYb4+FuGr0Cuc+DGfaUeKPpRN7HKsgZQZgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QkuDa+xG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QkuDa+xG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D76C433C7;
	Wed, 28 Feb 2024 18:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709144009;
	bh=3PQ9Q4JVVpc/9AKG3bI5J21D9i9YPWJVv2r5/liGOCg=;
	h=Date:To:From:Subject:From;
	b=QkuDa+xG7QFvkXGhjUPas28tNgQg1p1sEOoM44dFuoVYpMJuKov/d5h/MUEWaEQAW
	 Ud07XsJ5N2DcToXe/3HL9t1i7bG+VNGA1/iD7hqPGkBcwbk70tz/upZqBWDz1RK05S
	 FhGGl0YqP9rVkjm2lKNybV+Y9tlmPPZQzWcQXqV0=
Date: Wed, 28 Feb 2024 10:13:28 -0800
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-folio-more-widely-in-__split_huge_page.patch added to mm-unstable branch
Message-Id: <20240228181329.00D76C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use folio more widely in __split_huge_page
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-folio-more-widely-in-__split_huge_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-folio-more-widely-in-__split_huge_page.patch

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

mm-support-order-1-folios-in-the-page-cache.patch
mm-make-folios_put-the-basis-of-release_pages.patch
mm-convert-free_unref_page_list-to-use-folios.patch
mm-add-free_unref_folios.patch
mm-use-folios_put-in-__folio_batch_release.patch
memcg-add-mem_cgroup_uncharge_folios.patch
mm-remove-use-of-folio-list-from-folios_put.patch
mm-use-free_unref_folios-in-put_pages_list.patch
mm-use-__page_cache_release-in-folios_put.patch
mm-handle-large-folios-in-free_unref_folios.patch
mm-allow-non-hugetlb-large-folios-to-be-batch-processed.patch
mm-free-folios-in-a-batch-in-shrink_folio_list.patch
mm-free-folios-directly-in-move_folios_to_lru.patch
memcg-remove-mem_cgroup_uncharge_list.patch
mm-remove-free_unref_page_list.patch
mm-remove-lru_to_page.patch
mm-convert-free_pages_and_swap_cache-to-use-folios_put.patch
mm-use-a-folio-in-__collapse_huge_page_copy_succeeded.patch
mm-convert-free_swap_cache-to-take-a-folio.patch
mm-use-folio-more-widely-in-__split_huge_page.patch

