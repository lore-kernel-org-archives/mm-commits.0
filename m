Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD77623A103
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836990; cv=none; b=cbMqNpbjRSOEK5+RkX7w78sF0domKbDwCMpHMgpT8FT7XxfZNRmu7awZqUwQgpE+1Ty84pMwYoXm23XzxR8m6zWVG8/jCFI7Jd9SsESApW68JXtlqc7LpaI2BbrpsIYqTy6LskeQdi+K9iEETFTuTRFPCjLIQFAKPqsKPrOS3Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836990; c=relaxed/simple;
	bh=xrN6AA8y0Nzw54gfjOCcIyqktyzdiOliop1ZrfUBG1M=;
	h=Date:To:From:Subject:Message-Id; b=hSbGXXuP3nn5H1j7MT9VY9/UFQmH8vR+I520Kgf+aYQdGSR/OXepW+Q/zJiBNnsBFOyXuhCjr09JdnTbSyeu6xX2kMmqYMdWmunI0mCCGDllZJrR6P8THCoJ0nvY/GlHhcZlffwIH3kolFDeFFFiekWdbVw51/eTpPYuZ+QXxKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bY5w9z7O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bY5w9z7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E96C4CEDD;
	Tue, 14 Jan 2025 06:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836990;
	bh=xrN6AA8y0Nzw54gfjOCcIyqktyzdiOliop1ZrfUBG1M=;
	h=Date:To:From:Subject:From;
	b=bY5w9z7OWfFaTUo2zAu/G25pq3xg20u4wPH6qMve5IwIKe/25K2Et8NyVwDwb+tDU
	 09JqISt5H/Jq5AWfcepSDXzYzo0JCCSFZTGdOVOcuoD1k2/bWNZBWT4t3dTcK1n4ki
	 HbK6uIYRFi8m2QnDaoe6HWh9tKIpIjK0GLUMn6+E=
Date: Mon, 13 Jan 2025 22:43:09 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vishal.moola@gmail.com,vbabka@suse.cz,osalvador@suse.de,npiggin@gmail.com,naveen@kernel.org,mpe@ellerman.id.au,maddy@linux.ibm.com,christophe.leroy@csgroup.eu,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powernv-memtrace-use-__gfp_zero-with-alloc_contig_pages.patch removed from -mm tree
Message-Id: <20250114064310.27E96C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powernv/memtrace: use __GFP_ZERO with alloc_contig_pages()
has been removed from the -mm tree.  Its filename was
     powernv-memtrace-use-__gfp_zero-with-alloc_contig_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: powernv/memtrace: use __GFP_ZERO with alloc_contig_pages()
Date: Tue, 3 Dec 2024 10:47:32 +0100

alloc_contig_pages()->alloc_contig_range() now supports __GFP_ZERO, so
let's use that instead to resolve our TODO.

Link: https://lkml.kernel.org/r/20241203094732.200195-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N Rao <naveen@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/powernv/memtrace.c |   31 +++-----------------
 1 file changed, 6 insertions(+), 25 deletions(-)

--- a/arch/powerpc/platforms/powernv/memtrace.c~powernv-memtrace-use-__gfp_zero-with-alloc_contig_pages
+++ a/arch/powerpc/platforms/powernv/memtrace.c
@@ -88,26 +88,6 @@ static void flush_dcache_range_chunked(u
 	}
 }
 
-static void memtrace_clear_range(unsigned long start_pfn,
-				 unsigned long nr_pages)
-{
-	unsigned long pfn;
-
-	/* As HIGHMEM does not apply, use clear_page() directly. */
-	for (pfn = start_pfn; pfn < start_pfn + nr_pages; pfn++) {
-		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
-			cond_resched();
-		clear_page(__va(PFN_PHYS(pfn)));
-	}
-	/*
-	 * Before we go ahead and use this range as cache inhibited range
-	 * flush the cache.
-	 */
-	flush_dcache_range_chunked((unsigned long)pfn_to_kaddr(start_pfn),
-				   (unsigned long)pfn_to_kaddr(start_pfn + nr_pages),
-				   FLUSH_CHUNK_SIZE);
-}
-
 static u64 memtrace_alloc_node(u32 nid, u64 size)
 {
 	const unsigned long nr_pages = PHYS_PFN(size);
@@ -119,17 +99,18 @@ static u64 memtrace_alloc_node(u32 nid,
 	 * by alloc_contig_pages().
 	 */
 	page = alloc_contig_pages(nr_pages, GFP_KERNEL | __GFP_THISNODE |
-				  __GFP_NOWARN, nid, NULL);
+				  __GFP_NOWARN | __GFP_ZERO, nid, NULL);
 	if (!page)
 		return 0;
 	start_pfn = page_to_pfn(page);
 
 	/*
-	 * Clear the range while we still have a linear mapping.
-	 *
-	 * TODO: use __GFP_ZERO with alloc_contig_pages() once supported.
+	 * Before we go ahead and use this range as cache inhibited range
+	 * flush the cache.
 	 */
-	memtrace_clear_range(start_pfn, nr_pages);
+	flush_dcache_range_chunked((unsigned long)pfn_to_kaddr(start_pfn),
+				   (unsigned long)pfn_to_kaddr(start_pfn + nr_pages),
+				   FLUSH_CHUNK_SIZE);
 
 	/*
 	 * Set pages PageOffline(), to indicate that nobody (e.g., hibernation,
_

Patches currently in -mm which might be from david@redhat.com are

mm-huge_memory-convert-has_hwpoisoned-into-a-pure-folio-flag.patch
mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb.patch
mm-migrate-dont-call-folio_putback_active_hugetlb-on-dst-hugetlb-folio.patch
mm-hugetlb-rename-folio_putback_active_hugetlb-to-folio_putback_hugetlb.patch
mm-hugetlb-cgroup-convert-hugetlb_cgroup_css_offline-to-work-on-folios.patch
mm-hugetlb-use-folio-lru-int-demote_free_hugetlb_folios.patch

