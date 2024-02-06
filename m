Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCA617735
	for <mm-commits@vger.kernel.org>; Tue,  6 Feb 2024 19:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707249180; cv=none; b=M7ONywBK+vweT9vG06MtuvdWBpZbga/qrzxunZnuBTlwJGRX3HJRbDwWLawvDh2VI0WP/ff1LryEIf+ENWvXF/trhCgz1aoZ/4UVMB0M7n0Ps2UwAP9PszeVn1dnm+d8PxspEaE7MStZOHDBi+8oEBzhgBURaWvEAWhRn4UfA/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707249180; c=relaxed/simple;
	bh=2NcVBuCZQRwRnDeRzRTBcNKadD3GcqKjJm/BOAe5b2k=;
	h=Date:To:From:Subject:Message-Id; b=hSlxfZdoPlevTP5UVFFNel/nMKnO4Z+K3TqnRHogw/AQcRH9UGjPZGCR66rqYrpO1iC/OpYFbp57DuM3Ku8vRsgtYjGDXEG2qSx7kHYEs15ZDjmVWydaUOPUxPFuuDEzHj1W8Pk5WKrWG952aAwAk+qFH6S3k+blJ7ljNLVdiL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lKOK5G6x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lKOK5G6x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A6AC433F1;
	Tue,  6 Feb 2024 19:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707249179;
	bh=2NcVBuCZQRwRnDeRzRTBcNKadD3GcqKjJm/BOAe5b2k=;
	h=Date:To:From:Subject:From;
	b=lKOK5G6xpysx0oc8ZcSkZoY6AG2kQtZdMtnAYR2JS7sclN7mq6soPSoVbPZnrbIne
	 m+ONnVWDmX7Zg/QgUCtE5cZYqa6ZiP6xQxm7+pkc9yBxNC9r5wpe6Ih7oRGr0IkLIF
	 Ew0t/6+TF824igBwfL6u4zcNQbPLowhRzFrZD1FU=
Date: Tue, 06 Feb 2024 11:52:59 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,yangyifei03@kuaishou.com,songmuchun@bytedance.com,shakeelb@google.com,roman.gushchin@linux.dev,mkoutny@suse.com,mhocko@suse.com,hannes@cmpxchg.org,tjmercier@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-use-larger-batches-for-proactive-reclaim-v4.patch added to mm-unstable branch
Message-Id: <20240206195259.C6A6AC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memcg-use-larger-batches-for-proactive-reclaim-v4
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-use-larger-batches-for-proactive-reclaim-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-use-larger-batches-for-proactive-reclaim-v4.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "T.J. Mercier" <tjmercier@google.com>
Subject: mm-memcg-use-larger-batches-for-proactive-reclaim-v4
Date: Tue, 6 Feb 2024 17:52:50 +0000

Add additional info to commit message and move definition of batch_size
per Michal Hocko.  No functional changes.

Link: https://lkml.kernel.org/r/20240206175251.3364296-1-tjmercier@google.com
Fixes: 0388536ac291 ("mm:vmscan: fix inaccurate reclaim during proactive re=
claim")
Signed-off-by: T.J. Mercier <tjmercier@google.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Michal Koutny <mkoutny@suse.com>
Cc: Efly Young <yangyifei03@kuaishou.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-use-larger-batches-for-proactive-reclaim-v4
+++ a/mm/memcontrol.c
@@ -6981,6 +6981,8 @@ static ssize_t memory_reclaim(struct ker
 
 	reclaim_options	= MEMCG_RECLAIM_MAY_SWAP | MEMCG_RECLAIM_PROACTIVE;
 	while (nr_reclaimed < nr_to_reclaim) {
+		/* Will converge on zero, but reclaim enforces a minimum */
+		unsigned long batch_size = (nr_to_reclaim - nr_reclaimed) / 4;
 		unsigned long reclaimed;
 
 		if (signal_pending(current))
@@ -6994,9 +6996,6 @@ static ssize_t memory_reclaim(struct ker
 		if (!nr_retries)
 			lru_add_drain_all();
 
-		/* Will converge on zero, but reclaim enforces a minimum */
-		unsigned long batch_size = (nr_to_reclaim - nr_reclaimed) / 4;
-
 		reclaimed = try_to_free_mem_cgroup_pages(memcg,
 					batch_size, GFP_KERNEL, reclaim_options);
 
_

Patches currently in -mm which might be from tjmercier@google.com are

mm-memcg-dont-periodically-flush-stats-when-memcg-is-disabled.patch
mm-memcg-use-larger-batches-for-proactive-reclaim.patch
mm-memcg-use-larger-batches-for-proactive-reclaim-v4.patch

