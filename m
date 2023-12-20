Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E614879E
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 22:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TvA4cqRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A44C433C7;
	Wed, 20 Dec 2023 22:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703111875;
	bh=W3HitamST23cv4tOerf4JdC8yLCyh+v5D4Uqv0QwkLQ=;
	h=Date:To:From:Subject:From;
	b=TvA4cqRrZH897jpk0S5fR2n7lJNb0OvDc2WcpH008ZoFRNYfPakm71dxD6cshqcfS
	 ltavou/KsU2Q8NcOEQJVC4NSMggy6UgkQpWdRygy9810q8Cf0Y2s6Xr5yDqTWVtMRB
	 oaqnEJ564oFNEfN5UlVGD5yrfoNL5kZ5Kz5KQkTg=
Date: Wed, 20 Dec 2023 14:37:54 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,weixugc@google.com,tj@kernel.org,shakeelb@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,longman@redhat.com,ivan@cloudflare.com,hannes@cmpxchg.org,gthelen@google.com,chrisl@kernel.org,cerasuolodomenico@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memcg-restore-subtree-stats-flushing-fix.patch removed from -mm tree
Message-Id: <20231220223755.93A44C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-memcg-restore-subtree-stats-flushing-fix
has been removed from the -mm tree.  Its filename was
     mm-memcg-restore-subtree-stats-flushing-fix.patch

This patch was dropped because it was folded into mm-memcg-restore-subtree-stats-flushing.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcg-restore-subtree-stats-flushing-fix
Date: Wed Dec  6 01:09:20 PM PST 2023

fix mm/zswap.c

Cc: Chris Li <chrisl@kernel.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Ivan Babrou <ivan@cloudflare.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutny <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/zswap.c~mm-memcg-restore-subtree-stats-flushing-fix
+++ a/mm/zswap.c
@@ -641,7 +641,7 @@ static unsigned long zswap_shrinker_coun
 		return 0;
 
 #ifdef CONFIG_MEMCG_KMEM
-	mem_cgroup_flush_stats();
+	mem_cgroup_flush_stats(memcg);
 	nr_backing = memcg_page_state(memcg, MEMCG_ZSWAP_B) >> PAGE_SHIFT;
 	nr_stored = memcg_page_state(memcg, MEMCG_ZSWAPPED);
 #else
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-remove-hugetlb-maintainer-mike-kravetz-fix.patch
lib-maple_treec-fix-build-error-due-to-hotfix-alteration.patch
mm-list_lruc-remove-unused-list_lru_from_kmem.patch
mm-memcg-restore-subtree-stats-flushing.patch
mips-fix-r3k_cache_init-build-regression-fix.patch

