Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5369735291
	for <mm-commits@vger.kernel.org>; Fri,  5 Jan 2024 18:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0i7KIvb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFC6C433C9;
	Fri,  5 Jan 2024 18:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704478726;
	bh=WGOoFj5+JXEwb8+xb9CX5LM/BC1QF28BferpLCdYCDM=;
	h=Date:To:From:Subject:From;
	b=0i7KIvb0qrdP5ZcSjihed94fAAmLkc+7/Z1Jp9PdnZrhnRt4JJSwv/drS6LSu/eEm
	 p2It7AY3BbOdhQChmqi+JFbLiUSt6WkA/pZ/P57FqRJ9U0lj8CL4fS4B8+Aq5ZMO0O
	 2XQA+KNFW/hVMynRX/msASQ0O9xxFH2KMTMVeKbc=
Date: Fri, 05 Jan 2024 10:18:45 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,hannes@cmpxchg.org,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-use-a-folio-more-in-collapse_file.patch removed from -mm tree
Message-Id: <20240105181846.1EFC6C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: use a folio more in collapse_file()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-use-a-folio-more-in-collapse_file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/khugepaged: use a folio more in collapse_file()
Date: Thu, 28 Dec 2023 08:57:47 +0000

This function is not yet fully converted to the folio API, but this
removes a few uses of old APIs.

Link: https://lkml.kernel.org/r/20231228085748.1083901-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-use-a-folio-more-in-collapse_file
+++ a/mm/khugepaged.c
@@ -2122,23 +2122,23 @@ immap_locked:
 		xas_lock_irq(&xas);
 	}
 
-	nr = thp_nr_pages(hpage);
+	folio = page_folio(hpage);
+	nr = folio_nr_pages(folio);
 	if (is_shmem)
-		__mod_lruvec_page_state(hpage, NR_SHMEM_THPS, nr);
+		__lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, nr);
 	else
-		__mod_lruvec_page_state(hpage, NR_FILE_THPS, nr);
+		__lruvec_stat_mod_folio(folio, NR_FILE_THPS, nr);
 
 	if (nr_none) {
-		__mod_lruvec_page_state(hpage, NR_FILE_PAGES, nr_none);
+		__lruvec_stat_mod_folio(folio, NR_FILE_PAGES, nr_none);
 		/* nr_none is always 0 for non-shmem. */
-		__mod_lruvec_page_state(hpage, NR_SHMEM, nr_none);
+		__lruvec_stat_mod_folio(folio, NR_SHMEM, nr_none);
 	}
 
 	/*
 	 * Mark hpage as uptodate before inserting it into the page cache so
 	 * that it isn't mistaken for an fallocated but unwritten page.
 	 */
-	folio = page_folio(hpage);
 	folio_mark_uptodate(folio);
 	folio_ref_add(folio, HPAGE_PMD_NR - 1);
 
@@ -2148,7 +2148,7 @@ immap_locked:
 
 	/* Join all the small entries into a single multi-index entry. */
 	xas_set_order(&xas, start, HPAGE_PMD_ORDER);
-	xas_store(&xas, hpage);
+	xas_store(&xas, folio);
 	WARN_ON_ONCE(xas_error(&xas));
 	xas_unlock_irq(&xas);
 
@@ -2159,7 +2159,7 @@ immap_locked:
 	retract_page_tables(mapping, start);
 	if (cc && !cc->is_khugepaged)
 		result = SCAN_PTE_MAPPED_HUGEPAGE;
-	unlock_page(hpage);
+	folio_unlock(folio);
 
 	/*
 	 * The collapse has succeeded, so free the old pages.
_

Patches currently in -mm which might be from willy@infradead.org are


