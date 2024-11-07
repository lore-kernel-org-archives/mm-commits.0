Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830C92194B3
	for <mm-commits@vger.kernel.org>; Thu,  7 Nov 2024 22:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731019117; cv=none; b=PnX1/l9KSA45QG08h7+DMzWvr+OLHH/xt1nP5ffxBGb6zz17x9g0kBM1wNwe0u4H2h5P/XsPNHfRs09zrYbU6voYkAvx0mG16AiVbiUMUFqehJ+vtpfstja3e1MdscNiGH6BlVrSWtRAH26C/XzDWWrAPkrEParPuG1HzRCoFIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731019117; c=relaxed/simple;
	bh=i0ydwxLxy8RtpfT+uoigUN2Mmj3zL7B7HFNJXRF/Wm4=;
	h=Date:To:From:Subject:Message-Id; b=uewYifFVXvw57MBBtlGiCgKmh15OtU8WUn3oNzXkwZmBqXS0bUmTuR1RWYei2oYtz3Uw+i7VLNHqvBLCGzbxUcZQVo8BRf9dO6rYOPwaWL8krADy8YdWCq74v+tHIR9ZTY93kZEkEFY/L6vR3Brbnp+shSAb0zoj9kE6zfdBBn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pRXDlTWR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pRXDlTWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4543EC4CECC;
	Thu,  7 Nov 2024 22:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731019117;
	bh=i0ydwxLxy8RtpfT+uoigUN2Mmj3zL7B7HFNJXRF/Wm4=;
	h=Date:To:From:Subject:From;
	b=pRXDlTWRw7UlobET7pi44CU0lPQ/deYU7d17EXsz0A3svW5cQ/TPv/hEbBHZIu9C2
	 lBnsptyS4jAnebcNqBD1KTHJ1KkBV0FSDqUfwp7SuRxKLvD1t7pwcE5aoHeGhBaTZH
	 4tyzOZHtOUUe5f4TrwpmS3RNJcAYW/rwEcXS11iA=
Date: Thu, 07 Nov 2024 14:38:36 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-page_pgoff-in-more-places.patch removed from -mm tree
Message-Id: <20241107223837.4543EC4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use page_pgoff() in more places
has been removed from the -mm tree.  Its filename was
     mm-use-page_pgoff-in-more-places.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: use page_pgoff() in more places
Date: Sat, 5 Oct 2024 21:01:13 +0100

There are several places which currently open-code page_pgoff(), convert
them to call it.

Link: https://lkml.kernel.org/r/20241005200121.3231142-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex/core.c  |    2 +-
 mm/page_vma_mapped.c |    3 +--
 mm/rmap.c            |    4 +---
 3 files changed, 3 insertions(+), 6 deletions(-)

--- a/kernel/futex/core.c~mm-use-page_pgoff-in-more-places
+++ a/kernel/futex/core.c
@@ -399,7 +399,7 @@ again:
 
 		key->both.offset |= FUT_OFF_INODE; /* inode-based key */
 		key->shared.i_seq = get_inode_sequence_number(inode);
-		key->shared.pgoff = folio->index + folio_page_idx(folio, page);
+		key->shared.pgoff = page_pgoff(folio, page);
 		rcu_read_unlock();
 	}
 
--- a/mm/page_vma_mapped.c~mm-use-page_pgoff-in-more-places
+++ a/mm/page_vma_mapped.c
@@ -340,7 +340,6 @@ next_pte:
 unsigned long page_mapped_in_vma(struct page *page, struct vm_area_struct *vma)
 {
 	struct folio *folio = page_folio(page);
-	pgoff_t pgoff = folio->index + folio_page_idx(folio, page);
 	struct page_vma_mapped_walk pvmw = {
 		.pfn = page_to_pfn(page),
 		.nr_pages = 1,
@@ -348,7 +347,7 @@ unsigned long page_mapped_in_vma(struct
 		.flags = PVMW_SYNC,
 	};
 
-	pvmw.address = vma_address(vma, pgoff, 1);
+	pvmw.address = vma_address(vma, page_pgoff(folio, page), 1);
 	if (pvmw.address == -EFAULT)
 		goto out;
 	if (!page_vma_mapped_walk(&pvmw))
--- a/mm/rmap.c~mm-use-page_pgoff-in-more-places
+++ a/mm/rmap.c
@@ -774,7 +774,6 @@ static bool should_defer_flush(struct mm
 unsigned long page_address_in_vma(struct page *page, struct vm_area_struct *vma)
 {
 	struct folio *folio = page_folio(page);
-	pgoff_t pgoff;
 
 	if (folio_test_anon(folio)) {
 		struct anon_vma *page__anon_vma = folio_anon_vma(folio);
@@ -792,8 +791,7 @@ unsigned long page_address_in_vma(struct
 	}
 
 	/* The !page__anon_vma above handles KSM folios */
-	pgoff = folio->index + folio_page_idx(folio, page);
-	return vma_address(vma, pgoff, 1);
+	return vma_address(vma, page_pgoff(folio, page), 1);
 }
 
 /*
_

Patches currently in -mm which might be from willy@infradead.org are


