Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013DB8BF3
	for <mm-commits@vger.kernel.org>; Sun,  4 Feb 2024 07:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707031238; cv=none; b=mQHELOSOWwbCj1oEW2tvayv7PFYpGHsYhIIlegoMdoJC/au32cABaVSc6UtH8vZmIY4SsCNjlkTtmoi9hf4PuWpWJ5xuTnC50djilEOyImDZqZ4oir9+CwbzQzSiepNnqRIcr2HyAZrQRwGMnSJDp4iWI3oS4svR2c1KRZxILeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707031238; c=relaxed/simple;
	bh=iE+Z+0JKhcnDhv9VEzVDkM5Whx77z2KOdTu5qGNUaug=;
	h=Date:To:From:Subject:Message-Id; b=tWT8Wmedb39MdaL1I1Q9VLdE63zmyK8drrQGD8GDi8q1BJaNnFuJaRkXmsdjptA9eMi7HHoOFxcZ+QAV+qIPX/YiQcAe99SEPRqwHQcXLeks3ntCIPOeypAQ/GQPE9/Mgb/S8kx2+0gtvakGSM5Qk9yAcr8ZN/lWGYtXwBZSVtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tlod62pd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tlod62pd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B093DC433F1;
	Sun,  4 Feb 2024 07:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707031237;
	bh=iE+Z+0JKhcnDhv9VEzVDkM5Whx77z2KOdTu5qGNUaug=;
	h=Date:To:From:Subject:From;
	b=Tlod62pdVD0Z0ICU/aF6W5arETtefb58xTpR1tmKYuRZ4u82TWKTW4kW5WVqfbbml
	 pYSJb8O0rNtbsSMScPj+c/07u1ZTirgeL1JAqR2H40dMZcgwZaFB8wqr7bz56CbIAZ
	 GAK/y4BTuTYDU+LfATHkZR+Tk+LCJjj1RX8crCDw=
Date: Sat, 03 Feb 2024 23:20:37 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,yangyifei03@kuaishou.com,songmuchun@bytedance.com,shakeelb@google.com,roman.gushchin@linux.dev,mkoutny@suse.com,mhocko@suse.com,hannes@cmpxchg.org,tjmercier@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-use-larger-batches-for-proactive-reclaim.patch added to mm-unstable branch
Message-Id: <20240204072037.B093DC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: use larger batches for proactive reclaim
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcg-use-larger-batches-for-proactive-reclaim.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-use-larger-batches-for-proactive-reclaim.patch

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
Subject: mm: memcg: use larger batches for proactive reclaim
Date: Fri, 2 Feb 2024 23:38:54 +0000

Before 388536ac291 ("mm:vmscan: fix inaccurate reclaim during proactive
reclaim") we passed the number of pages for the reclaim request directly
to try_to_free_mem_cgroup_pages, which could lead to significant
overreclaim.  After 0388536ac291 the number of pages was limited to a
maximum 32 (SWAP_CLUSTER_MAX) to reduce the amount of overreclaim. 
However such a small batch size caused a regression in reclaim performance
due to many more reclaim start/stop cycles inside memory_reclaim.

Reclaim tries to balance nr_to_reclaim fidelity with fairness across nodes
and cgroups over which the pages are spread.  As such, the bigger the
request, the bigger the absolute overreclaim error.  Historic in-kernel
users of reclaim have used fixed, small sized requests to approach an
appropriate reclaim rate over time.  When we reclaim a user request of
arbitrary size, use decaying batch sizes to manage error while maintaining
reasonable throughput.

root - full reclaim       pages/sec   time (sec)
pre-0388536ac291      :    68047        10.46
post-0388536ac291     :    13742        inf
(reclaim-reclaimed)/4 :    67352        10.51

/uid_0 - 1G reclaim       pages/sec   time (sec)  overreclaim (MiB)
pre-0388536ac291      :    258822       1.12            107.8
post-0388536ac291     :    105174       2.49            3.5
(reclaim-reclaimed)/4 :    233396       1.12            -7.4

/uid_0 - full reclaim     pages/sec   time (sec)
pre-0388536ac291      :    72334        7.09
post-0388536ac291     :    38105        14.45
(reclaim-reclaimed)/4 :    72914        6.96

Link: https://lkml.kernel.org/r/20240202233855.1236422-1-tjmercier@google.com
Fixes: 0388536ac291 ("mm:vmscan: fix inaccurate reclaim during proactive re=
claim")
Signed-off-by: T.J. Mercier <tjmercier@google.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Efly Young <yangyifei03@kuaishou.com>
Cc: Michal Koutny <mkoutny@suse.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-use-larger-batches-for-proactive-reclaim
+++ a/mm/memcontrol.c
@@ -6994,9 +6994,11 @@ static ssize_t memory_reclaim(struct ker
 		if (!nr_retries)
 			lru_add_drain_all();
 
+		/* Will converge on zero, but reclaim enforces a minimum */
+		unsigned long batch_size = (nr_to_reclaim - nr_reclaimed) / 4;
+
 		reclaimed = try_to_free_mem_cgroup_pages(memcg,
-					min(nr_to_reclaim - nr_reclaimed, SWAP_CLUSTER_MAX),
-					GFP_KERNEL, reclaim_options);
+					batch_size, GFP_KERNEL, reclaim_options);
 
 		if (!reclaimed && !nr_retries--)
 			return -EAGAIN;
_

Patches currently in -mm which might be from tjmercier@google.com are

mm-memcg-dont-periodically-flush-stats-when-memcg-is-disabled.patch
mm-memcg-use-larger-batches-for-proactive-reclaim.patch

