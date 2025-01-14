Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6647123C6EA
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837036; cv=none; b=G4spsMqZNnrn5zBzBqGvuz7XxbDxchbBya/qcGrkoMKQjNMYJ/NXRGI3cWRdxQFZ+IIV5617nT7W647omo6ygjrDrbm3Y8z73x4r2FDEUR692DvZJKGxhlvMWUxazZAHTA7CmSS04jPoPZ5s11OMbsUr7JvfpeywhoUoXYivXRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837036; c=relaxed/simple;
	bh=SvNEXC0uclfOXq9sk0rggByNz4Q1JY0rg1PVpzJZdBg=;
	h=Date:To:From:Subject:Message-Id; b=OjaagoJeHaJe8rLgXDVsFp0qW6f2A5OCSMya2uiMprzp9+ZbvyjW+vyZuokOpdBfUiaYkJlU/RKNLYwEw7dOJdDlfBNjEwnDsbTQ157QAYbgxLly7feoszxrZIh3nZzixd1aqQRBnFYWeUfow74FttCKRFxaahHJrl/9GjyTolA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ySR7svhD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ySR7svhD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5D5C4CEDD;
	Tue, 14 Jan 2025 06:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837036;
	bh=SvNEXC0uclfOXq9sk0rggByNz4Q1JY0rg1PVpzJZdBg=;
	h=Date:To:From:Subject:From;
	b=ySR7svhDLaIWt/EmFpHwz3KzeyjgOeXcMQ2O6UF2+sngJN1MB8kV1PikqqmVm0k4a
	 /RJ906Wm4OUtp5T84n8BeR64IJKRGcFvVmi/artzT6xecmp3qA7l/FP8aWAX3mcbhZ
	 ylbU9cqeC6CjHVEbWUR6F5IreQdFPvlQhh5bwzr4=
Date: Mon, 13 Jan 2025 22:43:55 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,osalvador@suse.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-dont-use-__gfp_hardwall-when-migrating-pages-via-alloc_contig.patch removed from -mm tree
Message-Id: <20250114064356.3B5D5C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: don't use __GFP_HARDWALL when migrating pages via alloc_contig*()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-dont-use-__gfp_hardwall-when-migrating-pages-via-alloc_contig.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/page_alloc: don't use __GFP_HARDWALL when migrating pages via alloc_contig*()
Date: Thu, 5 Dec 2024 10:05:07 +0100

Patch series "mm: don't use __GFP_HARDWALL when migrating remote pages".

__GFP_HARDWALL means that we will be respecting the cpuset of the caller
when allocating a page.  However, when we are migrating remote allocations
(pages allocated from other context), the cpuset of the current context is
irrelevant.

For memory offlining + alloc_contig_*(), this is rather obvious.  There
might be other such page migration users, let's start with the obvious
ones.


This patch (of 2):

We'll migrate pages allocated by other contexts; respecting the cpuset of
the alloc_contig*() caller when allocating a migration target does not
make sense.

Drop the __GFP_HARDWALL.

Note that in an ideal world, migration code could figure out the cpuset
of the original context and take that into consideration.

Link: https://lkml.kernel.org/r/20241205090508.2095225-1-david@redhat.com
Link: https://lkml.kernel.org/r/20241205090508.2095225-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-dont-use-__gfp_hardwall-when-migrating-pages-via-alloc_contig
+++ a/mm/page_alloc.c
@@ -6412,11 +6412,11 @@ static int __alloc_contig_verify_gfp_mas
 	 * page range. Migratable pages are movable, __GFP_MOVABLE is implied
 	 * for them.
 	 *
-	 * Traditionally we always had __GFP_HARDWALL|__GFP_RETRY_MAYFAIL set,
-	 * keep doing that to not degrade callers.
+	 * Traditionally we always had __GFP_RETRY_MAYFAIL set, keep doing that
+	 * to not degrade callers.
 	 */
 	*gfp_cc_mask = (gfp_mask & (reclaim_mask | cc_action_mask)) |
-			__GFP_HARDWALL | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL;
+			__GFP_MOVABLE | __GFP_RETRY_MAYFAIL;
 	return 0;
 }
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-huge_memory-convert-has_hwpoisoned-into-a-pure-folio-flag.patch
mm-hugetlb-rename-isolate_hugetlb-to-folio_isolate_hugetlb.patch
mm-migrate-dont-call-folio_putback_active_hugetlb-on-dst-hugetlb-folio.patch
mm-hugetlb-rename-folio_putback_active_hugetlb-to-folio_putback_hugetlb.patch
mm-hugetlb-cgroup-convert-hugetlb_cgroup_css_offline-to-work-on-folios.patch
mm-hugetlb-use-folio-lru-int-demote_free_hugetlb_folios.patch

