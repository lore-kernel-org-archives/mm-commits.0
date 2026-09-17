Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701D03ED3BA
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 05:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789621870; cv=none; b=FJ8bJIYVDn3YUEt1+LyDR37WLIqVR7AAkBvnjQVwS4yR8AzIq79g90dMD1W/TuoRXONx7Kjk1x6LRzyH7QVevK5xsPptEoUbYxDGD15d/Hd9XkyS/2esRhIDTomuksp0uWavjd7qiBT3UBwG/z2jGKk8sU0Kkvd/JtheW8GGH1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789621870; c=relaxed/simple;
	bh=+bpfaFHiF9rga5nHwo6s+ifz9pNPHu5pSfHrf7ZsEsk=;
	h=Date:To:From:Subject:Message-Id; b=VCGHgy8LyOCW1fxzXDSifRZVue0TnVZhn+RCuPWzat5m4VhE/sMoE9CHvor2ZYGEgImnVUswvcpG9tG/CytPf1ukQd/HIE03T5bt2+aKUIAYddClPzSdA20arHLojJxYnWqxDleJ2T1JhB7XUHkM8QJHq6oYkg2Gds/68o/y2Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b0xNX7SD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b0xNX7SD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F961F00893;
	Thu, 17 Sep 2026 05:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789621869;
	bh=rRMydavbim72cwVkZD3xLyH+bllBAhUqwi2P2/XxfS4=;
	h=Date:To:From:Subject;
	b=b0xNX7SDvgHMBgT1Ht2YLjSwpT2S16x0LAFWqa+EfFsmtDS2nJqBA2KAg7h7P3Qe1
	 TWwEHs98ohFEv27tQhtSSL3llfsV9KzpsITiYe1c38rXbOKlx8vkHHuGQumbZe1A+A
	 gD1O7fzVMsBPDn8x47ofQqjURl4wFOA8KEOjWIfA=
Date: Wed, 16 Sep 2026 22:11:08 -0700
To: mm-commits@vger.kernel.org,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-workingset-use-lruvec_page_state_local-to-count-lru-pages.patch added to mm-unstable branch
Message-Id: <20260917051109.00F961F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: workingset: use lruvec_page_state_local() to count lru pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-workingset-use-lruvec_page_state_local-to-count-lru-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-workingset-use-lruvec_page_state_local-to-count-lru-pages.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-vmstat-annotate-data-race-for-per-cpu-pageset-fields.patch
mm-memcg-redirect-stats-updates-of-dying-memcgs-for-all-hierarchies.patch
mm-workingset-use-lruvec_page_state_local-to-count-lru-pages.patch
mm-memcg-skip-the-rcu-lock-when-the-memcg-is-not-dying.patch
mm-memcg-reparent-non-hierarchical-lruvec-stats-on-cgroup-v2.patch

