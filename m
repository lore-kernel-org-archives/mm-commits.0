Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065DF23A577
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836985; cv=none; b=bwS2lwwArldxUuCRcz9aaSa6O5IBWSXlLtdcTXMhJDaLRda7tLmJxGxYAbRMakA4f3469k+8Q6Wn/T+jtO8RaO9cZTKPByqTo6VolU9kWNGa9LAGQQLiJR3pvU/Sao3atYn0RzuqKpe1SsbfV9nw3ik507nGr0laehP7kh+kv0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836985; c=relaxed/simple;
	bh=Q7KPsd/Yry5otpKoJn5sBqhFrrKALMj5+hxEiU3ZpQs=;
	h=Date:To:From:Subject:Message-Id; b=Z9fULStisvzfIOMtyQi1Ylkp2meXeW830Bh+ebYCA29vehHAzD++wg64SqyGbH31dj1ls6TNfoMJ9iM09ncnuZND3uoUHc2Uac/SxRIs6dlH7uw6f7bTjxySmKCIDgGzFn2A16zZLYpV3979UrA+YDRFhoOCy81CPk/mbDng2Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KISb0zUr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KISb0zUr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D008CC4CEE1;
	Tue, 14 Jan 2025 06:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836984;
	bh=Q7KPsd/Yry5otpKoJn5sBqhFrrKALMj5+hxEiU3ZpQs=;
	h=Date:To:From:Subject:From;
	b=KISb0zUrRE/LAchnJsj9TA2IED98XtDoWKf2roF7yuKv2pHVdu9ykku4dooRu6JBB
	 02w/irWK+z45LxW+tgmJLoklMfeF3C/5Z8OhvDntK6XVZvIywg7sjP32wj0tuhqyQk
	 8OtTMZ5BTiTWp5NOwtL2U2u9p0MRQmn6uU7S34KE=
Date: Mon, 13 Jan 2025 22:43:04 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vishal.moola@gmail.com,vbabka@suse.cz,osalvador@suse.de,npiggin@gmail.com,naveen@kernel.org,mpe@ellerman.id.au,maddy@linux.ibm.com,christophe.leroy@csgroup.eu,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-make-__alloc_contig_migrate_range-static.patch removed from -mm tree
Message-Id: <20250114064304.D008CC4CEE1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: make __alloc_contig_migrate_range() static
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-make-__alloc_contig_migrate_range-static.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/page_alloc: make __alloc_contig_migrate_range() static
Date: Tue, 3 Dec 2024 10:47:29 +0100

The single user is in page_alloc.c.

Link: https://lkml.kernel.org/r/20241203094732.200195-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N Rao <naveen@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    4 ----
 mm/page_alloc.c |    5 ++---
 2 files changed, 2 insertions(+), 7 deletions(-)

--- a/mm/internal.h~mm-page_alloc-make-__alloc_contig_migrate_range-static
+++ a/mm/internal.h
@@ -839,10 +839,6 @@ int
 isolate_migratepages_range(struct compact_control *cc,
 			   unsigned long low_pfn, unsigned long end_pfn);
 
-int __alloc_contig_migrate_range(struct compact_control *cc,
-					unsigned long start, unsigned long end,
-					int migratetype);
-
 /* Free whole pageblock and set its migration type to MIGRATE_CMA. */
 void init_cma_reserved_pageblock(struct page *page);
 
--- a/mm/page_alloc.c~mm-page_alloc-make-__alloc_contig_migrate_range-static
+++ a/mm/page_alloc.c
@@ -6280,9 +6280,8 @@ static void alloc_contig_dump_pages(stru
  * @migratetype: using migratetype to filter the type of migration in
  *		trace_mm_alloc_contig_migrate_range_info.
  */
-int __alloc_contig_migrate_range(struct compact_control *cc,
-					unsigned long start, unsigned long end,
-					int migratetype)
+static int __alloc_contig_migrate_range(struct compact_control *cc,
+		unsigned long start, unsigned long end, int migratetype)
 {
 	/* This function is based on compact_zone() from compaction.c. */
 	unsigned int nr_reclaimed;
_

Patches currently in -mm which might be from david@redhat.com are

mm-huge_memory-convert-has_hwpoisoned-into-a-pure-folio-flag.patch
mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb.patch
mm-migrate-dont-call-folio_putback_active_hugetlb-on-dst-hugetlb-folio.patch
mm-hugetlb-rename-folio_putback_active_hugetlb-to-folio_putback_hugetlb.patch
mm-hugetlb-cgroup-convert-hugetlb_cgroup_css_offline-to-work-on-folios.patch
mm-hugetlb-use-folio-lru-int-demote_free_hugetlb_folios.patch

