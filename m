Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AE38BE5
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600575; cv=none; b=J0S/gZPvijlcufdnTmh5mYCj03bPGMeg1/hSG+L4QhGkIh/gCcxvFLaLoYkSDpBvYqMXKNJ0SyijHT9zIkfPBo7X9cRzrFdY8M8mdyQ8y8FIYdRJ8bhI6kjFzC4Uxt7GormF6p2ZynuRbLYvHwR/KGRiOpAZMSzlPOZhK+Wravk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600575; c=relaxed/simple;
	bh=1QzswODT1OY0+yKESxo04cNGhWCR4N1k36BzHVTCojQ=;
	h=Date:To:From:Subject:Message-Id; b=YWqrsljm9bU3VVL3e5irsHZRpRPJAVxpGb7GuiBEXrEJU5GLJkPlalGVAz/tGAeolRaN7wagjTPT4qcRrxt6Y3Ws6nmfE6zaMpOrgqXv9v71/+W+iEv9dRpDduVuC6E2BexRDkAhKCvA6rlzZzDj1EY78ClCN07fwsqC3WWR4qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=in+1BXGI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="in+1BXGI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1FB8C43390;
	Tue,  5 Mar 2024 01:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600575;
	bh=1QzswODT1OY0+yKESxo04cNGhWCR4N1k36BzHVTCojQ=;
	h=Date:To:From:Subject:From;
	b=in+1BXGI9R4rTqB5J/5900QLPqcGR0eHdggTEp5yuNjBCkG9YbnWdwHiie7evCKnD
	 N3q69qNMAGirK5+8D4SwPD4A7BwwIYe3tt7fQlOr0oISbaGjSaDuvgo4uorkrAqEWd
	 Az88VF0yIgcayeeY6G0YHhVMxRUjBH6Hvf0e4qCU=
Date: Mon, 04 Mar 2024 17:02:54 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-free_unref_page_list.patch removed from -mm tree
Message-Id: <20240305010254.E1FB8C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove free_unref_page_list()
has been removed from the -mm tree.  Its filename was
     mm-remove-free_unref_page_list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove free_unref_page_list()
Date: Tue, 27 Feb 2024 17:42:48 +0000

All callers now use free_unref_folios() so we can delete this function.

Link: https://lkml.kernel.org/r/20240227174254.710559-15-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    1 -
 mm/page_alloc.c |   18 ------------------
 2 files changed, 19 deletions(-)

--- a/mm/internal.h~mm-remove-free_unref_page_list
+++ a/mm/internal.h
@@ -453,7 +453,6 @@ extern int user_min_free_kbytes;
 
 void free_unref_page(struct page *page, unsigned int order);
 void free_unref_folios(struct folio_batch *fbatch);
-void free_unref_page_list(struct list_head *list);
 
 extern void zone_pcp_reset(struct zone *zone);
 extern void zone_pcp_disable(struct zone *zone);
--- a/mm/page_alloc.c~mm-remove-free_unref_page_list
+++ a/mm/page_alloc.c
@@ -2605,24 +2605,6 @@ void free_unref_folios(struct folio_batc
 	folio_batch_reinit(folios);
 }
 
-void free_unref_page_list(struct list_head *list)
-{
-	struct folio_batch fbatch;
-
-	folio_batch_init(&fbatch);
-	while (!list_empty(list)) {
-		struct folio *folio = list_first_entry(list, struct folio, lru);
-
-		list_del(&folio->lru);
-		if (folio_batch_add(&fbatch, folio) > 0)
-			continue;
-		free_unref_folios(&fbatch);
-	}
-
-	if (fbatch.nr)
-		free_unref_folios(&fbatch);
-}
-
 /*
  * split_page takes a non-compound higher-order page, and splits it into
  * n (1<<order) sub-pages: page[0..n]
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

