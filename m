Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA5621C173
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343151; cv=none; b=hGxVOvxUqgrgUB/rXJxPwePJ8kksjIJeUhbyJ8J+kESPptb38UkJt+M86YE7blOsQT8dJUzywlhTpgy3XFkKrXNB26Tk/Z9CwHdI2oXurh1cM4B+HPrB8FCuh1+jjsS9Hqd+IVNqtXeXpkHG3TG6VroJvhYn4PMLwIbsckd++Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343151; c=relaxed/simple;
	bh=luHUslKgp49w7JxURR+a2loikhHsN2LrABQgjDNyNA4=;
	h=Date:To:From:Subject:Message-Id; b=cmEXOP1R7dal2QkvvOCo4t1jgQ3IyS6Tr9al3pc0odQZwx5KCqIbmHg7dSTuDYucMTs8HuUXGs/+mgniM7hrYL3f4SZw4kFzJqAA388fv8r1TEC/hZQbQSzxi/CY9jt6fTbjFwpOsl9jAmSF/ych8nJKE3XdunaJenz91PNIxvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PSrUMyXy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PSrUMyXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C21AC113D0;
	Mon, 17 Nov 2025 01:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343151;
	bh=luHUslKgp49w7JxURR+a2loikhHsN2LrABQgjDNyNA4=;
	h=Date:To:From:Subject:From;
	b=PSrUMyXyQkOpKk1s2YCgpiZV2N20/ApcbKTWXDyWKKMhHKfyqGk8HfKZ7b/Akgfhd
	 mq+BHw8adqJYrGSCzBRoAulsHTFre5phuc3b9XNPwsuhlrXR5V79hn1sPmbBi1JoC9
	 h4pRKA1Thp4Jl9zNT2KJ7Swg5uskFrDX+1//djEM=
Date: Sun, 16 Nov 2025 17:32:30 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,willy@infradead.org,shakeel.butt@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-filter-out-the-dirty-file-folios-for-node_reclaim.patch removed from -mm tree
Message-Id: <20251117013231.7C21AC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan: filter out the dirty file folios for node_reclaim()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-filter-out-the-dirty-file-folios-for-node_reclaim.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: vmscan: filter out the dirty file folios for node_reclaim()
Date: Fri, 17 Oct 2025 15:53:06 +0800

Patch series "optimize the logic for handling dirty file folios during
reclaim", v2.

Since we no longer attempt to write back filesystem folios during reclaim,
some logic for handling dirty file folios in the reclaim process also
needs to be updated.  Please check the details in each patch.  


This patch (of 2):

After commit 6b0dfabb3555 ("fs: Remove aops->writepage"), we no longer
attempt to write back filesystem folios in pageout(), and only tmpfs/shmem
folios and anonymous swapcache folios can be written back.  Therefore, we
should also filter out the dirty filesystem folios for node_reclaim() to
avoid unnecessary LRU scans.

Link: https://lkml.kernel.org/r/cover.1760687075.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/c91f5ecc5152b647904c7503618a01885d913928.1760687075.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-filter-out-the-dirty-file-folios-for-node_reclaim
+++ a/mm/vmscan.c
@@ -7623,9 +7623,11 @@ static unsigned long node_pagecache_recl
 	else
 		nr_pagecache_reclaimable = node_unmapped_file_pages(pgdat);
 
-	/* If we can't clean pages, remove dirty pages from consideration */
-	if (!(node_reclaim_mode & RECLAIM_WRITE))
-		delta += node_page_state(pgdat, NR_FILE_DIRTY);
+	/*
+	 * Since we can't clean folios through reclaim, remove dirty file
+	 * folios from consideration.
+	 */
+	delta += node_page_state(pgdat, NR_FILE_DIRTY);
 
 	/* Watch for any possible underflows due to delta */
 	if (unlikely(delta > nr_pagecache_reclaimable))
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-vmscan-remove-folio_test_private-check-in-pageout.patch
mm-vmscan-remove-folio_test_private-check-in-pageout-fix-2.patch
mm-vmscan-simplify-the-folio-refcount-check-in-pageout.patch
mm-shmem-allow-fallback-to-smaller-large-orders-for-tmpfs-mmap-access.patch

