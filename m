Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F5223816A
	for <mm-commits@vger.kernel.org>; Fri, 17 Oct 2025 22:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760739259; cv=none; b=Tps7Fz67FmWf22PwKWKSPee4SYro4Y3PNf2WjysuhSs0oLE2nttoXXU3UKSEjY/gDyv9lGQJYXqevyOmERuNIWa5KnGQJg5fN3NvSKrss8aEMilVkgbYUKuDnIy3ku3AqCj3tOB3u9a0pC0sm0wWDnauq+WZVZRFx823/fnjbO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760739259; c=relaxed/simple;
	bh=5UcZsctXACj4yYPjSjaKdy6m49tqPSlZSRbRirhlfTA=;
	h=Date:To:From:Subject:Message-Id; b=oUrWtmnbWho3Xq4dTndPvajDaPSpQnEAFgajOm9hAuAcoBwbNEO9peeoAr9GHVmXf9DEpfSh1M5giCtS8xdtq9UHsEdor/Ab0fgNl7W1MAD+R+/3JiK/DgRTmdcpQY7IbVQkFlRfm3yRRhUX4cpJlnvpOjut8TzD1RPnAtai+Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qyO0cAbf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qyO0cAbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E87DC4CEE7;
	Fri, 17 Oct 2025 22:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760739258;
	bh=5UcZsctXACj4yYPjSjaKdy6m49tqPSlZSRbRirhlfTA=;
	h=Date:To:From:Subject:From;
	b=qyO0cAbf0di0tJ8Pua3AqK/TUIeZ+hMBeMlhfYrEJKHO9Na07LWJwt/IIomYgbmH1
	 2SdCMECrGsTTRldGjoAN3qGHyhajAUwXt1uWvFjnOj9v+8Sn7L20YzUI0Z+aR7fsdF
	 m3zrm3WK6LasjnU6rLuNCUOJMSPCfXowOsdxhU/g=
Date: Fri, 17 Oct 2025 15:14:17 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,willy@infradead.org,shakeel.butt@linux.dev,mhocko@kernel.org,lorenzo.stoakes@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-filter-out-the-dirty-file-folios-for-node_reclaim.patch added to mm-new branch
Message-Id: <20251017221418.6E87DC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: filter out the dirty file folios for node_reclaim()
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-filter-out-the-dirty-file-folios-for-node_reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-filter-out-the-dirty-file-folios-for-node_reclaim.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -7601,9 +7601,11 @@ static unsigned long node_pagecache_recl
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
mm-vmscan-simplify-the-folio-refcount-check-in-pageout.patch
mm-vmscan-simplify-the-folio-refcount-check-in-pageout-fix.patch
mm-vmscan-filter-out-the-dirty-file-folios-for-node_reclaim.patch
mm-vmscan-simplify-the-logic-for-activating-dirty-file-folios.patch

