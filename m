Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BEE524BE
	for <mm-commits@vger.kernel.org>; Tue, 27 Feb 2024 18:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709059691; cv=none; b=NSiT/LzDRmYF43G5LipzsjJp5eD1o8NoCMnTXa5WgWx9NvYS/1VfftFtW4XRnHw2ieMx3Yb8Y5hLva2A1TU8tht9uu2ZhGbN48IkZAYk9Pnwt99htM5NkBSrKrajxqyFRVLUK0tMb1ekJQ2USCQMySjsaaXJXn19VS6kFJHVkMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709059691; c=relaxed/simple;
	bh=B0rfvg7f4RRXIOhlSiQcLupJq6e/O8PTHBcPCsyUFHA=;
	h=Date:To:From:Subject:Message-Id; b=E1QS72UZQaUglyVwG+HMVA+kQ7afHBaAY3ixZAXAZno+1rHumFrJ7xUvCz9yPxQftD+yHBSZhR8wrpRPP/1lpeYSiCjBTixPA89bgWMLQ5q21nHDF0rVHqxzh/LXORcNEH+B/UtlAnsOoOnOR/CaGe2iHjdWstL/XlHy9nR70h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VXhP4swV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VXhP4swV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D47C433C7;
	Tue, 27 Feb 2024 18:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709059691;
	bh=B0rfvg7f4RRXIOhlSiQcLupJq6e/O8PTHBcPCsyUFHA=;
	h=Date:To:From:Subject:From;
	b=VXhP4swVFAIRoNAfOxZNTKqutgmcIH/lYFQxRpITAxzXwT2QJKq774E3fhtEtfCGC
	 22OP9LylJfePe7qaiwWD+FEMl1NIvcugZCuATxerQc5gzxX3d1xRbAelGVzrca8d2L
	 I0wAIQcL9lIRF7SpsoH5/+Jh3nuVjtOzKC08wewQ=
Date: Tue, 27 Feb 2024 10:48:10 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-free_pages_and_swap_cache-to-use-folios_put.patch added to mm-unstable branch
Message-Id: <20240227184811.31D47C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert free_pages_and_swap_cache() to use folios_put()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-free_pages_and_swap_cache-to-use-folios_put.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-free_pages_and_swap_cache-to-use-folios_put.patch

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
Subject: mm: convert free_pages_and_swap_cache() to use folios_put()
Date: Tue, 27 Feb 2024 17:42:50 +0000

Process the pages in batch-sized quantities instead of all-at-once.

Link: https://lkml.kernel.org/r/20240227174254.710559-17-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/mm/swap_state.c~mm-convert-free_pages_and_swap_cache-to-use-folios_put
+++ a/mm/swap_state.c
@@ -15,6 +15,7 @@
 #include <linux/swapops.h>
 #include <linux/init.h>
 #include <linux/pagemap.h>
+#include <linux/pagevec.h>
 #include <linux/backing-dev.h>
 #include <linux/blkdev.h>
 #include <linux/migrate.h>
@@ -310,21 +311,25 @@ void free_page_and_swap_cache(struct pag
  */
 void free_pages_and_swap_cache(struct encoded_page **pages, int nr)
 {
+	struct folio_batch folios;
+	unsigned int refs[PAGEVEC_SIZE];
+
 	lru_add_drain();
+	folio_batch_init(&folios);
 	for (int i = 0; i < nr; i++) {
-		struct page *page = encoded_page_ptr(pages[i]);
+		struct folio *folio = page_folio(encoded_page_ptr(pages[i]));
 
-		/*
-		 * Skip over the "nr_pages" entry. It's sufficient to call
-		 * free_swap_cache() only once per folio.
-		 */
+		free_swap_cache(&folio->page);
+		refs[folios.nr] = 1;
 		if (unlikely(encoded_page_flags(pages[i]) &
 			     ENCODED_PAGE_BIT_NR_PAGES_NEXT))
-			i++;
+			refs[folios.nr] = encoded_nr_pages(pages[++i]);
 
-		free_swap_cache(page);
+		if (folio_batch_add(&folios, folio) == 0)
+			folios_put_refs(&folios, refs);
 	}
-	release_pages(pages, nr);
+	if (folios.nr)
+		folios_put_refs(&folios, refs);
 }
 
 static inline bool swap_use_vma_readahead(void)
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

