Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD46FC1C
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600568; cv=none; b=kWU6y8sxWb+5Dr1cUf/+noVZGD2+AsPLkYbYIJgOOdoA31VU4DfgVFLJFYEXCcz1m1NyfndiJBWzc1utdGEi9vV/khsmJ5Y1NHjh4CjZ1W36krvQSsqAcy4VUVPOJ2YQljmR7bu1aDkZzB6PLDLg1cVeY2RuI+blz9hx3cKlleg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600568; c=relaxed/simple;
	bh=PiqlM8B/mM9zShD4ChRevfqcDZis8VTLGuGwoH01uMY=;
	h=Date:To:From:Subject:Message-Id; b=Te6LCl/e+qMK1qsAfe/zJJo5jhOdtjDcs2Fd3lZbM9XFlCodiQgxTEyGSTlmIlWKMrc2AZ24CTB7FPJKf1B9wgVikicOG+Rrz/LMt/ph3PBcpvGSTqwKHAoTYchBC+JFUljHl/P5yOBa2I1ZEtD34l8vQzLY0whqupWe4PxRjdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xbY+o8wf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xbY+o8wf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA35FC433F1;
	Tue,  5 Mar 2024 01:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600568;
	bh=PiqlM8B/mM9zShD4ChRevfqcDZis8VTLGuGwoH01uMY=;
	h=Date:To:From:Subject:From;
	b=xbY+o8wfFuSjSxMBCar4/y7eyzEu2ri87Xbcgld7Q7oVcjTmoJxeXSpOFqg0E4BVH
	 pYw/BOOCuXH/O4ZeWglxyMp6b1DR9t7ywoiJRfHXVwlkonXFQ/WBHUzQM5qCqrCfWc
	 0VRRj1QYR0HF8BEAlqSyXoyvNEJmbyZtvbHdBJc4=
Date: Mon, 04 Mar 2024 17:02:47 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-free_unref_folios-in-put_pages_list.patch removed from -mm tree
Message-Id: <20240305010247.EA35FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use free_unref_folios() in put_pages_list()
has been removed from the -mm tree.  Its filename was
     mm-use-free_unref_folios-in-put_pages_list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

