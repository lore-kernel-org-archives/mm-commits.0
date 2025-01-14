Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103AA23C6E5
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836982; cv=none; b=AfjgX3WOZW/LaeQFTH+Hv4l1e6n43b6z2TcpO+ChFPWjt/GyCsdGMtgI2Sio0hAuDeUK8qUfx06nQFziSCesqMUHk9TjQE6XItcEo7A5ElDasME+BoBFJmd6rO2akbVqMhQrijaJ4hihGpFnST7qgM+qJPU58Xswrygv4lsrumQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836982; c=relaxed/simple;
	bh=s56i+mkgsUVcCXHyxKiNHnSxQrAj5ZouVCNUxf6yZQU=;
	h=Date:To:From:Subject:Message-Id; b=YSKwFFS+ikbnrUQlCkNLc37zmB+p6KH1HDpZtulDnejBR1nTBkFOe88+Q6TCBMMPsuzAeM3oEWofKPVV9GmsjLi/463w9ssqN9SKAFYCcE2/SDFNCKZKF6u6dmxigAAasx3bM0cfGlYywg6/zj4ecNeoB9XJojDzRh7Qs2h6Sns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=djZyrTRW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="djZyrTRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA835C4CEDD;
	Tue, 14 Jan 2025 06:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836981;
	bh=s56i+mkgsUVcCXHyxKiNHnSxQrAj5ZouVCNUxf6yZQU=;
	h=Date:To:From:Subject:From;
	b=djZyrTRWguEBEAel8e/Y2avaoB2akbANQWMceS4AsrJGe4HeA8pSh9I4E7HSRd6cb
	 BwUfGFzlDGgPidOwwHDmdh0Ok1+AjGRb0ThUomEM4aAeGzb7Ve3oE0SfFP45DrT31r
	 RvqTjEZ/+sYJF2HocjTMJJWpzC99lzLJC1SkFYAM=
Date: Mon, 13 Jan 2025 22:43:01 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vishal.moola@gmail.com,vbabka@suse.cz,osalvador@suse.de,npiggin@gmail.com,naveen@kernel.org,mpe@ellerman.id.au,maddy@linux.ibm.com,christophe.leroy@csgroup.eu,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_isolation-dont-pass-gfp-flags-to-isolate_single_pageblock.patch removed from -mm tree
Message-Id: <20250114064301.DA835C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_isolation: don't pass gfp flags to isolate_single_pageblock()
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-dont-pass-gfp-flags-to-isolate_single_pageblock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/page_isolation: don't pass gfp flags to isolate_single_pageblock()
Date: Tue, 3 Dec 2024 10:47:27 +0100

Patch series "mm/page_alloc: gfp flags cleanups for alloc_contig_*()", v2.

Let's clean up the gfp flags handling, and support __GFP_ZERO, such that we
can finally remove the TODO in memtrace code.


This patch (of 6):

The flags are no longer used, we can stop passing them to
isolate_single_pageblock().

Link: https://lkml.kernel.org/r/20241203094732.200195-1-david@redhat.com
Link: https://lkml.kernel.org/r/20241203094732.200195-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N Rao <naveen@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/page_isolation.c~mm-page_isolation-dont-pass-gfp-flags-to-isolate_single_pageblock
+++ a/mm/page_isolation.c
@@ -286,7 +286,6 @@ __first_valid_page(unsigned long pfn, un
  * within a free or in-use page.
  * @boundary_pfn:		pageblock-aligned pfn that a page might cross
  * @flags:			isolation flags
- * @gfp_flags:			GFP flags used for migrating pages
  * @isolate_before:	isolate the pageblock before the boundary_pfn
  * @skip_isolation:	the flag to skip the pageblock isolation in second
  *			isolate_single_pageblock()
@@ -306,8 +305,7 @@ __first_valid_page(unsigned long pfn, un
  * the in-use page then splitting the free page.
  */
 static int isolate_single_pageblock(unsigned long boundary_pfn, int flags,
-			gfp_t gfp_flags, bool isolate_before, bool skip_isolation,
-			int migratetype)
+		bool isolate_before, bool skip_isolation, int migratetype)
 {
 	unsigned long start_pfn;
 	unsigned long isolate_pageblock;
@@ -489,7 +487,7 @@ int start_isolate_page_range(unsigned lo
 	bool skip_isolation = false;
 
 	/* isolate [isolate_start, isolate_start + pageblock_nr_pages) pageblock */
-	ret = isolate_single_pageblock(isolate_start, flags, gfp_flags, false,
+	ret = isolate_single_pageblock(isolate_start, flags, false,
 			skip_isolation, migratetype);
 	if (ret)
 		return ret;
@@ -498,7 +496,7 @@ int start_isolate_page_range(unsigned lo
 		skip_isolation = true;
 
 	/* isolate [isolate_end - pageblock_nr_pages, isolate_end) pageblock */
-	ret = isolate_single_pageblock(isolate_end, flags, gfp_flags, true,
+	ret = isolate_single_pageblock(isolate_end, flags, true,
 			skip_isolation, migratetype);
 	if (ret) {
 		unset_migratetype_isolate(pfn_to_page(isolate_start), migratetype);
_

Patches currently in -mm which might be from david@redhat.com are

mm-huge_memory-convert-has_hwpoisoned-into-a-pure-folio-flag.patch
mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb.patch
mm-migrate-dont-call-folio_putback_active_hugetlb-on-dst-hugetlb-folio.patch
mm-hugetlb-rename-folio_putback_active_hugetlb-to-folio_putback_hugetlb.patch
mm-hugetlb-cgroup-convert-hugetlb_cgroup_css_offline-to-work-on-folios.patch
mm-hugetlb-use-folio-lru-int-demote_free_hugetlb_folios.patch

