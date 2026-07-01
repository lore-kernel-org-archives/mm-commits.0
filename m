Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55873AE6E4;
	Wed,  1 Jul 2026 19:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782934316; cv=none; b=rsulzCWyFx/Z2kbOy3juD5etwhfYoNQN24ZVyB+i8oG5XWrpC6K3vShbA+3rUKhTAoy4IfOyDg3cw/qcEY6Sv16OlKXsPfqi5agSPMELOd9x2cPE8ZDJXPuL6lpGslaOfnqMqyzA5qj3udvAUSsGEziAscCjwTeubF4rHXNTiEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782934316; c=relaxed/simple;
	bh=mtoy1bemrt/o8Y5hQi5y2uyiWF1JfeaOio21TW76uzE=;
	h=Date:To:From:Subject:Message-Id; b=DKcmyQlw0PFstG/hjt/zGKZyu1So+Z0XMnAfVVNFqXHhad3cnTPebXofjua5//DJ6hCHU74FOKX6MqsNySrEzlpuF1/yQ41WP8hiKVBU7RoQg3Zex3BBG1fEHzR4TKXZFUjHtwB2IWp8gKnQ7XtR77MS59pkBvImdFhNl8Tkt/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qqH1xyKw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qqH1xyKw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424E11F000E9;
	Wed,  1 Jul 2026 19:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782934314;
	bh=OdaLzoOClqQkNqoF1rwEjHrEodYV7nvd4sM8AxyIPFc=;
	h=Date:To:From:Subject;
	b=qqH1xyKwwkSSrzUNh9C0s/9gAD1chX9NW+O2LXRMSj10AQ5mcCA+QXAZkTsimC2R8
	 VOvZrOmtWb7gSbIeo/91AtP7FV1hwIgaIYc1L9Fy4q3tSrrtpYHDDJqsU6g33Wls8Q
	 WrEUOULgMADu8SJmJeWOoaL+aMNtO/pZhUqMxLHQ=
Date: Wed, 01 Jul 2026 12:31:53 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,jackmanb@google.com,hannes@cmpxchg.org,david@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_alloc-free-allocated-pfns-if-the-range-does-not-match.patch removed from -mm tree
Message-Id: <20260701193154.424E11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: free allocated PFNs if the range does not match
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-free-allocated-pfns-if-the-range-does-not-match.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/page_alloc: free allocated PFNs if the range does not match
Date: Mon, 29 Jun 2026 21:35:33 -0400

When using __GFP_COMP in alloc_contig_frozen_range(), if the allocated
range does not match the requested one, the code errors out with EINVAL
without freeing the allocated PFNs and causes free page leaks.  Fix it by
calling release_free_list() in the error path.

The issue is reported by Sashiko[1].

Link: https://lore.kernel.org/20260629-free-pfn-on-alloc-contig-range-error-path-v1-1-496ff9ca22db@nvidia.com
Link: https://sashiko.dev/#/patchset/20260628-keep-subpage-private-zero-at-free-v1-0-f4ce3930d10f@nvidia.com [1]
Fixes: e98337d11bbd ("mm/contig_alloc: support __GFP_COMP")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 mm/internal.h   |    1 +
 mm/page_alloc.c |    6 ++++--
 3 files changed, 6 insertions(+), 3 deletions(-)

--- a/mm/compaction.c~mm-page_alloc-free-allocated-pfns-if-the-range-does-not-match
+++ a/mm/compaction.c
@@ -88,7 +88,7 @@ static struct page *mark_allocated_nopro
 }
 #define mark_allocated(...)	alloc_hooks(mark_allocated_noprof(__VA_ARGS__))
 
-static unsigned long release_free_list(struct list_head *freepages)
+unsigned long release_free_list(struct list_head *freepages)
 {
 	int order;
 	unsigned long high_pfn = 0;
--- a/mm/internal.h~mm-page_alloc-free-allocated-pfns-if-the-range-does-not-match
+++ a/mm/internal.h
@@ -828,6 +828,7 @@ static inline void clear_zone_contiguous
 }
 
 extern int __isolate_free_page(struct page *page, unsigned int order);
+extern unsigned long release_free_list(struct list_head *freepages);
 extern void __putback_isolated_page(struct page *page, unsigned int order,
 				    int mt);
 extern void memblock_free_pages(unsigned long pfn, unsigned int order);
--- a/mm/page_alloc.c~mm-page_alloc-free-allocated-pfns-if-the-range-does-not-match
+++ a/mm/page_alloc.c
@@ -7244,9 +7244,11 @@ int alloc_contig_frozen_range_noprof(uns
 		check_new_pages(head, order);
 		prep_new_page(head, order, gfp_mask, 0);
 	} else {
+		release_free_list(cc.freepages);
 		ret = -EINVAL;
-		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
-		     start, end, outer_start, outer_end);
+		WARN(true,
+		     "PFN range: allocated [%lu, %lu) does not match requested [%lu, %lu), freeing allocated PFNs\n",
+		     outer_start, outer_end, start, end);
 	}
 done:
 	undo_isolate_page_range(start, end);
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-compaction-handle-free_pages_prepare-properly-in-compaction_free.patch

