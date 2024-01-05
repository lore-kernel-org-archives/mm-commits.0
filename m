Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E236B35280
	for <mm-commits@vger.kernel.org>; Fri,  5 Jan 2024 18:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T+NZtmvj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE20C433C8;
	Fri,  5 Jan 2024 18:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1704478720;
	bh=qAzcuONo8eqXg3GrSGUjiBRbORNBT/4g84m9YuMKi+4=;
	h=Date:To:From:Subject:From;
	b=T+NZtmvjS/AD/tr+kMq/XlznDJYUgoYFd6jj6C+oagRpOSA22tRZdzAn4DvLS1XwC
	 1I4eWOEMdZoMLXw1kPk7DUfX4BI1iq3BukKtjcgdP3ngQ8eyMs6uFOiqM1to5Du0aJ
	 ShvfSwFKzLpoKQVe/aW9z8JMDmDqp836+NsNdmgY=
Date: Fri, 05 Jan 2024 10:18:40 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yosryahmed@google.com,songmuchun@bytedance.com,roman.gushchin@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,shakeelb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ratelimit-stat-flush-from-workingset-shrinker.patch removed from -mm tree
Message-Id: <20240105181840.ABE20C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: ratelimit stat flush from workingset shrinker
has been removed from the -mm tree.  Its filename was
     mm-ratelimit-stat-flush-from-workingset-shrinker.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: mm: ratelimit stat flush from workingset shrinker
Date: Thu, 28 Dec 2023 07:30:55 +0000

One of our workloads (Postgres 14 + sysbench OLTP) regressed on newer
upstream kernel and on further investigation, it seems like the cause is
the always synchronous rstat flush in the count_shadow_nodes() added by
the commit f82e6bf9bb9b ("mm: memcg: use rstat for non-hierarchical
stats").  On further inspection it seems like we don't really need
accurate stats in this function as it was already approximating the amount
of appropriate shadow entries to keep for maintaining the refault
information.  Since there is already 2 sec periodic rstat flush, we don't
need exact stats here.  Let's ratelimit the rstat flush in this code path.

Link: https://lkml.kernel.org/r/20231228073055.4046430-1-shakeelb@google.com
Fixes: f82e6bf9bb9b ("mm: memcg: use rstat for non-hierarchical stats")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/workingset.c~mm-ratelimit-stat-flush-from-workingset-shrinker
+++ a/mm/workingset.c
@@ -680,7 +680,7 @@ static unsigned long count_shadow_nodes(
 		struct lruvec *lruvec;
 		int i;
 
-		mem_cgroup_flush_stats(sc->memcg);
+		mem_cgroup_flush_stats_ratelimited(sc->memcg);
 		lruvec = mem_cgroup_lruvec(sc->memcg, NODE_DATA(sc->nid));
 		for (pages = 0, i = 0; i < NR_LRU_LISTS; i++)
 			pages += lruvec_page_state_local(lruvec,
_

Patches currently in -mm which might be from shakeelb@google.com are


