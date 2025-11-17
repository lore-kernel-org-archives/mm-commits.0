Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B6721D3CC
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343285; cv=none; b=bZSpIES3h05Ac4DPvOrVnXNzKc8Zdju7KjeQLl+Dwl4A1YDhqkZE6Lb6PiM0EKojVgXiOpEVfY8hG6+4sUFtNrJjBBNddKx+i3UIDOxQR2dM2ezMf5X/4s8qh5Tl9ATxqR7xIFHunWMrO4qcdtqGkE9IP0muZ3JuLRe61SBhojo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343285; c=relaxed/simple;
	bh=e0NaZ5s0vw+TcfA9xGmiEcBkUhJ0kd2puC5WEsfgSXs=;
	h=Date:To:From:Subject:Message-Id; b=PYaiMDcMYMoVEyLAhu+JAICu18NoRyX/axVWn8I5eup0LTPDwMkFeyIWPicLAOAdrL3kjHAmLLBDBN7+WW1OXzcMRpeGdhcbpYDC30qhXIKo7Skv9vDRzEVVuFRPdYBuWQ4E7v+e4bVoWexkVgQf1uOGYS0fNPr+RtTRJrnwyMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qQkI/O23; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qQkI/O23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DED1C116D0;
	Mon, 17 Nov 2025 01:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343285;
	bh=e0NaZ5s0vw+TcfA9xGmiEcBkUhJ0kd2puC5WEsfgSXs=;
	h=Date:To:From:Subject:From;
	b=qQkI/O238iLL/Trs8/7nC4Pg8FvG0XTI2dlnvGljxriMbYjJiVfYQ83Lf1xUqcZKA
	 IAGwtaE3AvTooZ8kwDQftE+hir+vilecRL8+xdgpMMcBJDPh6gPNqH4olQMQUDr8UU
	 KGeRSFBhsq55tc2Sy3SlobuWysrxUtR1Ftp1Z69U=
Date: Sun, 16 Nov 2025 17:34:44 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yi.zhang@huawei.com,yangerkun@huawei.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,mhocko@suse.com,jack@suse.cz,jackmanb@google.com,hannes@cmpxchg.org,libaokun1@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-dont-warn-about-large-allocations-with-__gfp_nofail.patch removed from -mm tree
Message-Id: <20251117013445.1DED1C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: don't warn about large allocations with __GFP_NOFAIL
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-dont-warn-about-large-allocations-with-__gfp_nofail.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baokun Li <libaokun1@huawei.com>
Subject: mm/page_alloc: don't warn about large allocations with __GFP_NOFAIL
Date: Wed, 5 Nov 2025 16:56:52 +0800

Filesystems use __GFP_NOFAIL to allocate block-sized folios for metadata
reads at critical points, since they cannot afford to go read-only, shut
down, or enter an inconsistent state due to memory pressure.

Currently, attempting to allocate page units greater than order-1 with the
__GFP_NOFAIL flag triggers a WARN_ON() in __alloc_pages_slowpath(). 
However, filesystems supporting large block sizes (blocksize > PAGE_SIZE)
can easily require allocations larger than order-1.

As Matthew Wilcox noted in [1], if we have a filesystem with 64KiB
sectors, there will be many clean folios in the page cache that are 64KiB
or larger.  He also explained in [2] why kvmalloc isn't a valid approach
here.

With gfp flags and order already included in the OOM report, both
Vlastimil Babka and Michal Hocko suggested that we can take the risk of
removing this warning first and then observe whether a large number of
related OOM reports appear.

If that happens, we can consider adding special handling in other places.

Link: https://lkml.kernel.org/r/20251105085652.4081123-1-libaokun@huaweicloud.com
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Link: https://lore.kernel.org/all/aQPX1-XWQjKaMTZB@casper.infradead.org [1]
Link: https://lore.kernel.org/all/aQTHMI3t5mNXp0M1@casper.infradead.org [2]
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Link: https://lore.kernel.org/all/188a95ba-6384-4319-bb74-c0d9ec6c4079@suse.cz
Suggested-by: Michal Hocko <mhocko@suse.com>
Link: https://lore.kernel.org/all/aQotQBjnDDeL_wHx@tiehlicka
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: ErKun Yang <yangerkun@huawei.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-dont-warn-about-large-allocations-with-__gfp_nofail
+++ a/mm/page_alloc.c
@@ -4684,11 +4684,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 
 	if (unlikely(nofail)) {
 		/*
-		 * We most definitely don't want callers attempting to
-		 * allocate greater than order-1 page units with __GFP_NOFAIL.
-		 */
-		WARN_ON_ONCE(order > 1);
-		/*
 		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
 		 * otherwise, we may result in lockup.
 		 */
_

Patches currently in -mm which might be from libaokun1@huawei.com are


