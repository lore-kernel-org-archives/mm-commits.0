Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2CBA2557E
	for <mm-commits@vger.kernel.org>; Tue, 27 Feb 2024 18:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709059677; cv=none; b=V5s+HP4+qZasbBzXO7ftP2HK5P+at/LQqO9k9YUsuJRPyMCqApNCOpRtY5qqBQvv9WpKzIDyB07o3sowh+vEArGFSx94LX6ZmilBNmAVvYIl6Fi7o/IBJF2TbA8OuszHJq6zjG6A9w/tXoAjii+wG1uUgWn5MKw8Bnn3nnnaKmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709059677; c=relaxed/simple;
	bh=qCKa8kYEntgf3FNq5OWnVvGdKPjEt6zNoV/EgzCYNaU=;
	h=Date:To:From:Subject:Message-Id; b=uOmk7U5+yQg+H5K0Lu0FDFaAUJPrnYIPpV2JrUrKmWQA8FpQZxynIr26wxW02ONVov1zIbI4XZaret+X00KETd8BaXU6F8niYr9T1pp/WjJaFhywfnxRuHuhx/jIlzVTN12s1049Q2w+xXClDbOSHA0Bja8OpLO78ijdJFatvF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fTdYRaD/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fTdYRaD/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF17C43390;
	Tue, 27 Feb 2024 18:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709059677;
	bh=qCKa8kYEntgf3FNq5OWnVvGdKPjEt6zNoV/EgzCYNaU=;
	h=Date:To:From:Subject:From;
	b=fTdYRaD/ZWHAHG0kQPobHGCowO1inoWa2urEx77Z+9sNwh3rRsetZ1z3/jDxi+Ed6
	 gJ83NBA2jVrRwOVZoRlWRQiHN31aFkk3rRVqtqLWhI9EiUp6fFy/mawms5AbPfsBpG
	 U1bEdTZJCGVGbmZSFfh7898DysNxjUtS9n3PMSe0=
Date: Tue, 27 Feb 2024 10:47:56 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-free_unref_folios-in-put_pages_list.patch added to mm-unstable branch
Message-Id: <20240227184757.2AF17C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use free_unref_folios() in put_pages_list()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-free_unref_folios-in-put_pages_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-free_unref_folios-in-put_pages_list.patch

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
Subject: mm: use free_unref_folios() in put_pages_list()
Date: Tue, 27 Feb 2024 17:42:41 +0000

Break up the list of folios into batches here so that the folios are more
likely to be cache hot when doing the rest of the processing.

Link: https://lkml.kernel.org/r/20240227174254.710559-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/mm/swap.c~mm-use-free_unref_folios-in-put_pages_list
+++ a/mm/swap.c
@@ -138,22 +138,25 @@ EXPORT_SYMBOL(__folio_put);
  */
 void put_pages_list(struct list_head *pages)
 {
-	struct folio *folio, *next;
+	struct folio_batch fbatch;
+	struct folio *folio;
 
-	list_for_each_entry_safe(folio, next, pages, lru) {
-		if (!folio_put_testzero(folio)) {
-			list_del(&folio->lru);
+	folio_batch_init(&fbatch);
+	list_for_each_entry(folio, pages, lru) {
+		if (!folio_put_testzero(folio))
 			continue;
-		}
 		if (folio_test_large(folio)) {
-			list_del(&folio->lru);
 			__folio_put_large(folio);
 			continue;
 		}
 		/* LRU flag must be clear because it's passed using the lru */
+		if (folio_batch_add(&fbatch, folio) > 0)
+			continue;
+		free_unref_folios(&fbatch);
 	}
 
-	free_unref_page_list(pages);
+	if (fbatch.nr)
+		free_unref_folios(&fbatch);
 	INIT_LIST_HEAD(pages);
 }
 EXPORT_SYMBOL(put_pages_list);
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

