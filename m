Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6892402B99;
	Fri,  9 Oct 2026 05:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525425; cv=none; b=Ouvl7EjCDe2pQx5ZoeWOe19LSm2XB/Ko/uCxCeiG/f49f9JgFfTw86X3YgbNpzd834bEDIhpqdHDxzg6aom6dezJRfCHzJPSNxJQjN+jCEYzzPwn/qhLl0yF0m5/CfjSQHGiZvR2Pv3YZjzXnzsIsU40wDIwIBwUTr2q3aE1re4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525425; c=relaxed/simple;
	bh=ChrohwRan0vZpfdJ1vOWlMGwNp/jhkO+Lm+w7phq5MA=;
	h=Date:To:From:Subject:Message-Id; b=qRuMlWv9alTrKcgo+lZkGdGUb98d2XQblL7BO2sm3uIUZ5KviEN0aZg5xORlpejKGBknnGhPGT6AlgnCgaVq23H94RTY8/u/2XdgSbc8TnjD44lq+8rNrEiKSjHoaKWyK0fIZMDUipO9te/XRug4U9uwUKe92egNm3HT49T3BcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BRh28cC3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BRh28cC3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481B01F00893;
	Fri,  9 Oct 2026 05:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525424;
	bh=5tLaU8xYCnWlF7ydjeZmjpsb/jzpJn/sWK/qmRhWW4w=;
	h=Date:To:From:Subject;
	b=BRh28cC3QaOmWM3kC17ZJKyW8Xo9SZMEomOSXMXzD6qPqwyPhACy9iJ+U+3uf8/mS
	 S3Em+vSuLVoY3hlPprYyG+9XA0mN8l5GyUJhqRSy49goL7o2freEyumvPQT9emESE3
	 8hebswv/NTDkfXPpXqQtNErQ11UqQt3P+281oC/g=
Date: Thu, 08 Oct 2026 22:57:03 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-workingset-use-lruvec_page_state_local-to-count-lru-pages.patch removed from -mm tree
Message-Id: <20261009055704.481B01F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: workingset: use lruvec_page_state_local() to count lru pages
has been removed from the -mm tree.  Its filename was
     mm-workingset-use-lruvec_page_state_local-to-count-lru-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hui Zhu <zhuhui@kylinos.cn>
Subject: mm: workingset: use lruvec_page_state_local() to count lru pages
Date: Fri, 11 Sep 2026 16:00:49 +0800

Commit 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the
number of lru pages") switched count_shadow_nodes() to lruvec_lru_size(). 
With CONFIG_MEMCG enabled, lruvec_lru_size() reads mz->lru_zone_size,
which only the classic LRU paths maintain.  MGLRU accounts its pages
through __update_lru_size(), which skips that array, so with MGLRU on the
four evictable LRU lists are always seen as empty.  The shadow node budget
(pages >> 3) then collapses to slab plus unevictable pages, and the
workingset shadow shrinker reclaims eviction tokens almost as fast as they
are created, losing thrashing protection.

lruvec_page_state_local() reads lruvec_stats->state_local instead, which
both classic LRU and MGLRU maintain.  Switch back to it.  The reparenting
race this re-exposes on cgroup v2 is closed by the preceding patch that
redirects dying-memcg stat updates for all hierarchies.

Link: https://lore.kernel.org/2ed42f96aca124856ea30f774afb55cbe6d8ba58.1789096175.git.zhuhui@kylinos.cn
Fixes: 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the number of lru pages")
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: <stable@vger.kernel.org>
---

 mm/workingset.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/workingset.c~mm-workingset-use-lruvec_page_state_local-to-count-lru-pages
+++ a/mm/workingset.c
@@ -688,10 +688,9 @@ static unsigned long count_shadow_nodes(
 
 		mem_cgroup_flush_stats_ratelimited(sc->memcg);
 		lruvec = mem_cgroup_lruvec(sc->memcg, NODE_DATA(sc->nid));
-
 		for (pages = 0, i = 0; i < NR_LRU_LISTS; i++)
-			pages += lruvec_lru_size(lruvec, i, MAX_NR_ZONES - 1);
-
+			pages += lruvec_page_state_local(lruvec,
+							 NR_LRU_BASE + i);
 		pages += lruvec_page_state_local(
 			lruvec, NR_SLAB_RECLAIMABLE_B) >> PAGE_SHIFT;
 		pages += lruvec_page_state_local(
_

Patches currently in -mm which might be from zhuhui@kylinos.cn are


