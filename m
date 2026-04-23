Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB53A230BDB
	for <mm-commits@vger.kernel.org>; Thu, 23 Apr 2026 14:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776953004; cv=none; b=PuZXqsOMCJxBtNVQrpXfvbRVQGUFVoPgNtNXRieWidztm9P6by5Qk/ttU5iO7Doj/cgVl3KMpmKz8yW91Uwzwrm83203kCiU0im7iQiTz/Pj4P9aqd2LU1Un7Luv655IhmrH3EvMHEd4nKVHHK6CxGkMLVNikY+RDQw2uf2rG2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776953004; c=relaxed/simple;
	bh=reJw+Ju+vRZC1R4q5vdiZLSivid4uT4cz7tM6qiuLiI=;
	h=Date:To:From:Subject:Message-Id; b=tMsPYPxtALUP1LCAHgxMvDrXdI5G3dyygfBiN3hNFyh1wfpQwmIg8hk1wRJLSHSZjiXMeCcnAMsS5m65GKwn4rrKziWBiIdIp/WuJq0CubWMvm3FWPudaXbKyw0XUkot+bs/2Koi9M5hbtzgf5Qlc3iZ7sb1KW15ndmRtqC56xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fpeR6+/Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fpeR6+/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BEF5C2BCAF;
	Thu, 23 Apr 2026 14:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776953004;
	bh=reJw+Ju+vRZC1R4q5vdiZLSivid4uT4cz7tM6qiuLiI=;
	h=Date:To:From:Subject:From;
	b=fpeR6+/QSF0jNxCW8Z4vyjSjgnV4dfk0eBmx48RiBr0XPWdQ6X/UH4hGLD9C+u3vt
	 9cX9Zk/K1ojOAcfZF7qwlvb0sddbXMj22N+2FZn05Qle1W/gZG8l2zbZNmMZwMkxzz
	 ENM+vMmpVjyRbykHbpiPkZqJB1ff9E1IqS5zXNuY=
Date: Thu, 23 Apr 2026 07:03:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vishal.moola@gmail.com,vbabka@kernel.org,urezki@gmail.com,terrelln@fb.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hannes@cmpxchg.org,dsterba@suse.com,david@kernel.org,usama.anjum@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-optimize-__free_contig_frozen_range.patch added to mm-new branch
Message-Id: <20260423140324.5BEF5C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: optimize __free_contig_frozen_range()
has been added to the -mm mm-new branch.  Its filename is
     mm-page_alloc-optimize-__free_contig_frozen_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-optimize-__free_contig_frozen_range.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: mm/page_alloc: optimize __free_contig_frozen_range()
Date: Wed, 1 Apr 2026 11:16:21 +0100

Apply the same batch-freeing optimization from free_contig_range() to the
frozen page path.  The previous __free_contig_frozen_range() freed each
order-0 page individually via free_frozen_pages(), which is slow for the
same reason the old free_contig_range() was: each page goes to the order-0
pcp list rather than being coalesced into higher-order blocks.

Rewrite __free_contig_frozen_range() to call free_pages_prepare() for each
order-0 page, then batch the prepared pages into the largest possible
power-of-2 aligned chunks via free_prepared_contig_range().  If
free_pages_prepare() fails (e.g.  HWPoison, bad page) the page is
deliberately not freed; it should not be returned to the allocator.

I've tested CMA through debugfs.  The test allocates 16384 pages per
allocation for several iterations.  There is 3.5x improvement.

Before: 1406 usec per iteration
After:   402 usec per iteration

Before:

    70.89%     0.69%  cma              [kernel.kallsyms]      [.] free_contig_frozen_range
            |
            |--70.20%--free_contig_frozen_range
            |          |
            |          |--46.41%--__free_frozen_pages
            |          |          |
            |          |           --36.18%--free_frozen_page_commit
            |          |                     |
            |          |                      --29.63%--_raw_spin_unlock_irqrestore
            |          |
            |          |--8.76%--_raw_spin_trylock
            |          |
            |          |--7.03%--__preempt_count_dec_and_test
            |          |
            |          |--4.57%--_raw_spin_unlock
            |          |
            |          |--1.96%--__get_pfnblock_flags_mask.isra.0
            |          |
            |           --1.15%--free_frozen_page_commit
            |
             --0.69%--el0t_64_sync

After:

    23.57%     0.00%  cma              [kernel.kallsyms]      [.] free_contig_frozen_range
            |
            ---free_contig_frozen_range
               |
               |--20.45%--__free_contig_frozen_range
               |          |
               |          |--17.77%--free_pages_prepare
               |          |
               |           --0.72%--free_prepared_contig_range
               |                     |
               |                      --0.55%--__free_frozen_pages
               |
                --3.12%--free_pages_prepare

Link: https://lore.kernel.org/20260401101634.2868165-4-usama.anjum@arm.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Suggested-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-optimize-__free_contig_frozen_range
+++ a/mm/page_alloc.c
@@ -7022,8 +7022,7 @@ static int __alloc_contig_verify_gfp_mas
 
 static void __free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages)
 {
-	for (; nr_pages--; pfn++)
-		free_frozen_pages(pfn_to_page(pfn), 0);
+	__free_contig_range_common(pfn, nr_pages, /* is_frozen= */ true);
 }
 
 /**
_

Patches currently in -mm which might be from usama.anjum@arm.com are

mm-page_alloc-optimize-__free_contig_frozen_range.patch

