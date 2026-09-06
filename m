Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558C231B114
	for <mm-commits@vger.kernel.org>; Sun,  6 Sep 2026 01:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788659121; cv=none; b=a/D/xCOi8cBnYi5IVgDQLdmJgzZV4owlfPWBwq64etfpYG+zypP18WAlX3LRIBl2qHAmG8yIuK8Q9RTkIBbLKz3Qjahit982pAJhquJVj2ksWyQ/TZ0EHFI+1B7qaEPj+0TimA25wGGdEhWfnWa+GuEASrvNXItGOwWUPHO5hFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788659121; c=relaxed/simple;
	bh=GfUE4wn71O4+9thLkktVyYKZBLdr9Sk1f0lwMd7ZwFM=;
	h=Date:To:From:Subject:Message-Id; b=Zm0cg7HhixhLipPWF/xSq6Fw+8CwYCtsRdNYP9K7LRvdiPdwc3qo20t+jIKqNV2ZXHko+2lQYoXVotwdXV7wo6xh9C6PLZ7waDnODMXyAr8cGK0Kk2wmxKcJY4WsdcoSzmNyWaFUjGRMEhaJODJCxHylFLhQYX1Wojp3BkbMVWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B78jhAFu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B78jhAFu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2DB81F00A3A;
	Sun,  6 Sep 2026 01:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788659120;
	bh=9FQ0mr59W5z5ahYbnvNTJIXV3Qro7d4MOfp8g9nXqa8=;
	h=Date:To:From:Subject;
	b=B78jhAFuGAGfPDE+rBaIRWjCdwxp6swiT7zbk30Hkk1MVGTTwe3WMolfvXyRVv8Ue
	 w/hLC/SDpyU/vULNHKVriUWwfzz1024qMlmQMUglRlIbCCj0P8CLCoIdnuNZJI2y32
	 iLch32OmwzNovAvtE9en3WLA7Qsp+j/xXU4WBTO4=
Date: Sat, 05 Sep 2026 18:45:19 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-workingset-use-lruvec_page_state_local-to-count-lru-pages.patch added to mm-new branch
Message-Id: <20260906014519.E2DB81F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: workingset: use lruvec_page_state_local() to count lru pages
has been added to the -mm mm-new branch.  Its filename is
     mm-workingset-use-lruvec_page_state_local-to-count-lru-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-workingset-use-lruvec_page_state_local-to-count-lru-pages.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

