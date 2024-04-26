Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B30F7D071
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103955; cv=none; b=UbeEzBGWeTbgtpv1DHmv/BWyJY9SfXmV5djSO++pabgeUwWsCkpAFVQZpR03385J1cbSZbQPbuJ9qhaklUJhaWKnI44vBRGZZr5j/Q5/Uwavoev6iMgAXH5oZaAvS9iXQ5FrVc4+FQP9PgYCqZNvUdX4yONMGySXzCteSHRWf/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103955; c=relaxed/simple;
	bh=aZhfnwtcpZCh8rIQZcD7duWwx0i33b/pJh2DsiZ8pp4=;
	h=Date:To:From:Subject:Message-Id; b=hu6Nhy/ripfDjlm+qF5W8MqTvcR8gfL4I4N1WgGwphy46HfqKGOCeaae+EVS+eVHFg40ChqnRcoEex5QqKuDeo20dclabTVWxp2sOA0vYoK9ZI/qOYPEQOqiqJWxeajfft9WUwBaCvR91iNI6fRAMqGVtrEPPTmcuqlOL4IQCg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IS1/jYor; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IS1/jYor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011B3C113CD;
	Fri, 26 Apr 2024 03:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103955;
	bh=aZhfnwtcpZCh8rIQZcD7duWwx0i33b/pJh2DsiZ8pp4=;
	h=Date:To:From:Subject:From;
	b=IS1/jYorPa/r9u2eAaeZufgly0nP0ys1K9wyDLTwAc8cT0ylyoENZtIOFj9uk+tNP
	 RGtG9P2mur2EaQHY8k2vmi70zL3f5v80TViR4T/bgImei+mOxq6gv7eMF5IUyv0fmo
	 Z3V/YDUb4cbh5PEdQZh27687rMbZUEKmWzw3Ls9k=
Date: Thu, 25 Apr 2024 20:59:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,vbabka@suse.cz,mgorman@techsingularity.net,david@redhat.com,baolin.wang@linux.alibaba.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-move-free-pages-when-converting-block-during-isolation.patch removed from -mm tree
Message-Id: <20240426035915.011B3C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: page_alloc: move free pages when converting block during isolation
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-move-free-pages-when-converting-block-during-isolation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: move free pages when converting block during isolation
Date: Wed, 20 Mar 2024 14:02:09 -0400

When claiming a block during compaction isolation, move any remaining free
pages to the correct freelists as well, instead of stranding them on the
wrong list.  Otherwise, this encourages incompatible page mixing down the
line, and thus long-term fragmentation.

Link: https://lkml.kernel.org/r/20240320180429.678181-5-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Tested-by: "Huang, Ying" <ying.huang@intel.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-move-free-pages-when-converting-block-during-isolation
+++ a/mm/page_alloc.c
@@ -2653,9 +2653,12 @@ int __isolate_free_page(struct page *pag
 			 * Only change normal pageblocks (i.e., they can merge
 			 * with others)
 			 */
-			if (migratetype_is_mergeable(mt))
+			if (migratetype_is_mergeable(mt)) {
 				set_pageblock_migratetype(page,
 							  MIGRATE_MOVABLE);
+				move_freepages_block(zone, page,
+						     MIGRATE_MOVABLE, NULL);
+			}
 		}
 	}
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


