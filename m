Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E6E7493;
	Fri, 26 Jan 2024 02:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706235439; cv=none; b=CncaFpkovrH7nft3Z9qL6sDFfAz7njhf78y+L1NYXLteKVkpn6nHdP8SeUHmqdlxkePMoRaKjAcyQBSkhXO1UYU4J4ZUJfISOVS9qsnf1K+0/azH2DyHTuKZwQf6ZWpTkN9V9mtQyRHpcvMTsN7UHOGzj5pOX7xjeohaCWzpa1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706235439; c=relaxed/simple;
	bh=IrFhKodeQ6Ier895H9YVV85oaneDTnftgB3SBiS8TA4=;
	h=Date:To:From:Subject:Message-Id; b=UWO2tZtilh88UVOkkHk8VZP3Ve/UQC1dUe4WhE7tYmCw0smDSkcKisvUedP6tv9v05y/M4qmoQlDBT2zLwObzZhuApKX0RZxY6Sg2gawOFKyGd24VKZEr8//hBSVVZlsINf8GGVy8S0nhMzqH4I/Vm9JJ8hE68I2rKeFRJwMFuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oaUA7E+6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oaUA7E+6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AE3C43390;
	Fri, 26 Jan 2024 02:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706235439;
	bh=IrFhKodeQ6Ier895H9YVV85oaneDTnftgB3SBiS8TA4=;
	h=Date:To:From:Subject:From;
	b=oaUA7E+6EvRgVu+Wv1f78Vujm3qb04fauELgucGPq/gd24SqZgwLaYFhGUvVI27I0
	 haDDwedDEjkX/Wh3xgp0XjU9h6BdGx7tUSE0KgBT64vlagVDbL5JBAi0IUTxdpRCZ3
	 1QHHgX07wimCP1ptXHg4pevMBiL2lpsxIstdAAJo=
Date: Thu, 25 Jan 2024 18:17:16 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yangyifei03@kuaishou.com,stable@vger.kernel.org,shakeelb@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,tjmercier@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] revert-mm-vmscan-fix-inaccurate-reclaim-during-proactive-reclaim.patch removed from -mm tree
Message-Id: <20240126021718.F0AE3C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Revert "mm:vmscan: fix inaccurate reclaim during proactive reclaim"
has been removed from the -mm tree.  Its filename was
     revert-mm-vmscan-fix-inaccurate-reclaim-during-proactive-reclaim.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "T.J. Mercier" <tjmercier@google.com>
Subject: Revert "mm:vmscan: fix inaccurate reclaim during proactive reclaim"
Date: Sun, 21 Jan 2024 21:44:12 +0000

This reverts commit 0388536ac29104a478c79b3869541524caec28eb.

Proactive reclaim on the root cgroup is 10x slower after this patch when
MGLRU is enabled, and completion times for proactive reclaim on much
smaller non-root cgroups take ~30% longer (with or without MGLRU).  With
root reclaim before the patch, I observe average reclaim rates of ~70k
pages/sec before try_to_free_mem_cgroup_pages starts to fail and the
nr_retries counter starts to decrement, eventually ending the proactive
reclaim attempt.  After the patch the reclaim rate is consistently ~6.6k
pages/sec due to the reduced nr_pages value causing scan aborts as soon as
SWAP_CLUSTER_MAX pages are reclaimed.  The proactive reclaim doesn't
complete after several minutes because try_to_free_mem_cgroup_pages is
still capable of reclaiming pages in tiny SWAP_CLUSTER_MAX page chunks and
nr_retries is never decremented.

The docs for memory.reclaim say, "the kernel can over or under reclaim
from the target cgroup" which this patch was trying to fix.  Revert it
until a less costly solution is found.

Link: https://lkml.kernel.org/r/20240121214413.833776-1-tjmercier@google.com
Fixes: 0388536ac291 ("mm:vmscan: fix inaccurate reclaim during proactive reclaim")
Signed-off-by: T.J. Mercier <tjmercier@google.com>
Cc: Efly Young <yangyifei03@kuaishou.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: T.J. Mercier <tjmercier@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~revert-mm-vmscan-fix-inaccurate-reclaim-during-proactive-reclaim
+++ a/mm/memcontrol.c
@@ -6977,8 +6977,8 @@ static ssize_t memory_reclaim(struct ker
 			lru_add_drain_all();
 
 		reclaimed = try_to_free_mem_cgroup_pages(memcg,
-					min(nr_to_reclaim - nr_reclaimed, SWAP_CLUSTER_MAX),
-					GFP_KERNEL, reclaim_options);
+						nr_to_reclaim - nr_reclaimed,
+						GFP_KERNEL, reclaim_options);
 
 		if (!reclaimed && !nr_retries--)
 			return -EAGAIN;
_

Patches currently in -mm which might be from tjmercier@google.com are


