Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00BE010949
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600577; cv=none; b=nghi/exUj+5bOgejaf9hXmd1zBpk73h83Bo5sCVVjpRrqKPS/XRx0WF+dFl2xgttuZ4Y88U8oxn8R85pJoq127ejpVf85QctHxxM9CXjN9zO5y8toOeD/D2elAnhU63Mh3uWDqxF88xE/I0ocTeU4Ij70un+kguU6VbxzXXCTCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600577; c=relaxed/simple;
	bh=Vixuj/p4vl99XnT/YCwbikgiAA5Wx2Fj8+Ep8spYYZ8=;
	h=Date:To:From:Subject:Message-Id; b=VIkjxz6FGrzaM+VSO1Zjk4LMmRGJgDK8vLWIzWZGnN3oGY0mP6eQeq5+A9grKZZgCGssiVxlowzGbR3PRnreWvKv+3Hug6hHV9gKawwtNLGPciiQVAozN3xx+glBZhqIBYSsxhZU3vtScgMnAYcQdF7DzrbOsUJw8cB3bjisrWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OC0+WVUX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OC0+WVUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1431C43390;
	Tue,  5 Mar 2024 01:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600576;
	bh=Vixuj/p4vl99XnT/YCwbikgiAA5Wx2Fj8+Ep8spYYZ8=;
	h=Date:To:From:Subject:From;
	b=OC0+WVUXFsTmzTD74PY8LP4NRy9QshW8Jr2U9p09b9R+FXfDr6eia2kPeSg29KebA
	 jhP+PqjHRuErDkt+xewOFnw413qNyY3utP+KKwuFrJ8mONX2ovzPUhYyJ1/RtoOVmz
	 fXZvr2TUBWg66Cm4DEttpUT3aDGmNNh8rYCEQ1z0=
Date: Mon, 04 Mar 2024 17:02:56 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-free_pages_and_swap_cache-to-use-folios_put.patch removed from -mm tree
Message-Id: <20240305010256.C1431C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert free_pages_and_swap_cache() to use folios_put()
has been removed from the -mm tree.  Its filename was
     mm-convert-free_pages_and_swap_cache-to-use-folios_put.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

