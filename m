Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424B13E9C17
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 05:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789621324; cv=none; b=RsngL99IRGTpEjKzDoSis1ZrQ8KNNGsvSiVUoDzofCS5Unbe1ebXBt4ZbS5S+DqXPqzFW3eDwZRL/8tGueUTmazdB9NQ5clKNGRL/DcSkgVIagKMbBRFNtJDcMgNgjkZ7DEept5iVCK2Qu69chMeC8rBNrPbfrUTwzgNvFUnbqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789621324; c=relaxed/simple;
	bh=wxGV4QW2MZuH12P4quHnhTpWF6duSzETKJkUh7DjL+o=;
	h=Date:To:From:Subject:Message-Id; b=gTWqjqLYYlXxU9zHtefx6Ou83CuBaR4rskGbJ8YIr69h0lc5FsEq9qrkjYVkOIO8zNWsAwGe0kAgTadPFSImHEzPXfaVJ0hP6fPY6MOqSULZVJ5nJn+BAwj/crf3mHEiaOVfKIluhOjxRBxQmTOAWb/sw1tbbLau24sVXIhc/Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tEdYpFtS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tEdYpFtS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80571F00893;
	Thu, 17 Sep 2026 05:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789621322;
	bh=0CG3CYd2faDVZBcpe5uActHldrPxZqRw4L95W8nwaKw=;
	h=Date:To:From:Subject;
	b=tEdYpFtSp2HjG+6gEu9OguxyUhg4+TEnsXpMB6Hy6Yyn95HyrqMsxMPF+x5q401Od
	 WqzI13uhZjoTU9TdhnNIe7J60q+AW1oqPKsMAnskFjG/C4heNEMwbzYVtJiKM1JApl
	 Pk69RdMmSEujFB21fw93r+L0QMvi7S+WBqmTvWNU=
Date: Wed, 16 Sep 2026 22:02:02 -0700
To: mm-commits@vger.kernel.org,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-workingset-use-lruvec_page_state_local-to-count-lru-pages.patch removed from -mm tree
Message-Id: <20260917050202.B80571F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: workingset: use lruvec_page_state_local() to count lru pages
has been removed from the -mm tree.  Its filename was
     mm-workingset-use-lruvec_page_state_local-to-count-lru-pages.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Hui Zhu <zhuhui@kylinos.cn>
Subject: mm: workingset: use lruvec_page_state_local() to count lru pages
Date: Fri, 4 Sep 2026 17:45:55 +0800

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
race this re-exposes on cgroup v2 is closed by the follow-up patch that
redirects dying-memcg stat updates for all hierarchies.

Link: https://lore.kernel.org/2ec3a7f73e85ee5f5739c9dc2e58e9a0e2091925.1788514750.git.zhuhui@kylinos.cn
Fixes: 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the number of lru pages")
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
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

mm-vmstat-annotate-data-race-for-per-cpu-pageset-fields.patch
mm-memcg-skip-the-rcu-lock-when-the-memcg-is-not-dying.patch

