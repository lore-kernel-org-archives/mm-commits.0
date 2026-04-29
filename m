Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A7D33BBAD
	for <mm-commits@vger.kernel.org>; Wed, 29 Apr 2026 15:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777477069; cv=none; b=D47NMKkLXrRMimVID8mUKa+u+yYX5bY0gQ0CHkYtuVlBn76BbiBFg1vdnNbYTIXsMkkQx+iqBwnoqGW4/dv/rgO3JfB3rUDtofD27TkY2FJnnjJK/3Vpfz6+JTTCb2u3ru2M+1Cq6nQglDWAAPk/oPcJCWVbxhF7PuCvMEhNPrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777477069; c=relaxed/simple;
	bh=ifKGeishedef12j4qRaymwOXZPY0bU2LiwnlY9hK2M8=;
	h=Date:To:From:Subject:Message-Id; b=JkVuWqDwAGuRVD7dvwSMnTwBRGwVfY1AlwJs1e3lNSjymZCJJYjcs60jD0nMB4dU42mPgT5+PNcGyvCG9D/m8Tz7dEIxGv2c/Nv+YiliHOyGXwf7femMTwVsw7awROlwDdNp7bfI0hc66XviqFjTu+iIkzovpW30iBiUvkIDLSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1ZE0rBCf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1ZE0rBCf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F701C19425;
	Wed, 29 Apr 2026 15:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777477069;
	bh=ifKGeishedef12j4qRaymwOXZPY0bU2LiwnlY9hK2M8=;
	h=Date:To:From:Subject:From;
	b=1ZE0rBCfIm/jSjc4wa+d8M0AhipNoz/6yssOMoXCkpeIibqK/Msw4wMs2jb/rYxiU
	 /XhwJxmVw8Sjj/rKEvE+cRzoABNNi9tj6VeX2QGpaMcIZSDf0ECXVJ/4s8SozsOhov
	 y7s5KKyubvNd4W8Yrha+cR3julef2NH9LlFKggbs=
Date: Wed, 29 Apr 2026 08:37:49 -0700
To: mm-commits@vger.kernel.org,d@ilvokhin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-zone-lock-guard-in-unreserve_highatomic_pageblock.patch added to mm-new branch
Message-Id: <20260429153749.8F701C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use zone lock guard in unreserve_highatomic_pageblock()
has been added to the -mm mm-new branch.  Its filename is
     mm-use-zone-lock-guard-in-unreserve_highatomic_pageblock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-zone-lock-guard-in-unreserve_highatomic_pageblock.patch

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
From: Dmitry Ilvokhin <d@ilvokhin.com>
Subject: mm: use zone lock guard in unreserve_highatomic_pageblock()
Date: Wed, 29 Apr 2026 12:02:08 +0000

Use spinlock_irqsave zone lock guard in unreserve_highatomic_pageblock()
to replace the explicit lock/unlock pattern with automatic scope-based
cleanup.

Link: https://lore.kernel.org/69db814cd178915cb5615334a29304678f960963.1777462630.git.d@ilvokhin.com
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c~mm-use-zone-lock-guard-in-unreserve_highatomic_pageblock
+++ a/mm/page_alloc.c
@@ -3481,7 +3481,6 @@ static bool unreserve_highatomic_pageblo
 						bool force)
 {
 	struct zonelist *zonelist = ac->zonelist;
-	unsigned long flags;
 	struct zoneref *z;
 	struct zone *zone;
 	struct page *page;
@@ -3498,7 +3497,7 @@ static bool unreserve_highatomic_pageblo
 					pageblock_nr_pages)
 			continue;
 
-		spin_lock_irqsave(&zone->lock, flags);
+		guard(spinlock_irqsave)(&zone->lock);
 		for (order = 0; order < NR_PAGE_ORDERS; order++) {
 			struct free_area *area = &(zone->free_area[order]);
 			unsigned long size;
@@ -3545,12 +3544,9 @@ static bool unreserve_highatomic_pageblo
 			 * so this should not fail on zone boundaries.
 			 */
 			WARN_ON_ONCE(ret == -1);
-			if (ret > 0) {
-				spin_unlock_irqrestore(&zone->lock, flags);
+			if (ret > 0)
 				return ret;
-			}
 		}
-		spin_unlock_irqrestore(&zone->lock, flags);
 	}
 
 	return false;
_

Patches currently in -mm which might be from d@ilvokhin.com are

mm-use-zone-lock-guard-in-reserve_highatomic_pageblock.patch
mm-use-zone-lock-guard-in-unset_migratetype_isolate.patch
mm-use-zone-lock-guard-in-unreserve_highatomic_pageblock.patch
mm-use-zone-lock-guard-in-set_migratetype_isolate.patch
mm-use-zone-lock-guard-in-take_page_off_buddy.patch
mm-use-zone-lock-guard-in-put_page_back_buddy.patch
mm-use-zone-lock-guard-in-free_pcppages_bulk.patch
mm-use-zone-lock-guard-in-__offline_isolated_pages.patch

