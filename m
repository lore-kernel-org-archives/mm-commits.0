Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F10F3090D7
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 18:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774636956; cv=none; b=VbuxTJ0wCnk6BOadOoZHFn5kJgTshO46rPu0a2aLRkUFmc0sudSKpO6ZqwnDhFen0LXlE9Zo7UUD3pXeMZnj5vYQiLnFWVpE2+3aSlZIgFM+vNTw8Rw5tsK4ZXqw5igA7mfzB2VH/rAlSFiRx+jnSww3goYIXAz030i1VW26FPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774636956; c=relaxed/simple;
	bh=IFejJdkfYg/suIM4GP3qLV4FTWDMSzvN6vCFgAyFLQo=;
	h=Date:To:From:Subject:Message-Id; b=pIc5bZnvqgPIKpE3cyJP8aUiIZhs5a7HRW0DgVIVeiJ68j0tEzjsDxmq3woHeT/EfpJ6lmRUbRp7c9bfytfYI4oLb0g+7XCSjJCeg7ekqdTmlysUGeIatvz506/boPyS5Zw1DyQNHxJZ0NI5w/Eb70+tdv7skWMDZVKkNghypTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m4hbKnVz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m4hbKnVz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B06C19423;
	Fri, 27 Mar 2026 18:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774636955;
	bh=IFejJdkfYg/suIM4GP3qLV4FTWDMSzvN6vCFgAyFLQo=;
	h=Date:To:From:Subject:From;
	b=m4hbKnVzl/eFOZRm5zmJRaHHfjxk9w5nClE3RRUQ/Z3yl++QA/P5EeerjAP4COVDe
	 sSJkCCGtXkrCfrYxzW/zxrbZCFzRJeHhSuVS/9KApTRN0858Xork9v4RaeKsjlOB57
	 35mFlDXVxpG9RiuE/0WjTE2GtVSo6B8c61I/RKfE=
Date: Fri, 27 Mar 2026 11:42:35 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,usamaarif642@gmail.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,ljs@kernel.org,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry@kernel.org,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,bhe@redhat.com,axelrasmussen@google.com,apais@linux.microsoft.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-correct-the-nr_pages-parameter-type-of-mem_cgroup_update_lru_size.patch added to mm-unstable branch
Message-Id: <20260327184235.98B06C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcontrol: correct the nr_pages parameter type of mem_cgroup_update_lru_size()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-correct-the-nr_pages-parameter-type-of-mem_cgroup_update_lru_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-correct-the-nr_pages-parameter-type-of-mem_cgroup_update_lru_size.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: memcontrol: correct the nr_pages parameter type of mem_cgroup_update_lru_size()
Date: Fri, 27 Mar 2026 18:16:30 +0800

The nr_pages parameter of mem_cgroup_update_lru_size() represents a page
count.  During the reparenting of LRU folios, the value passed to it can
potentially exceed the maximum value of a 32-bit integer.  It should be
declared as long instead of int to match the types used in lruvec size
accounting and to prevent possible overflow.

Update the parameter type to long to ensure correctness.

Link: https://lkml.kernel.org/r/fd4140de44fa0a3978e4e2426731187fe8625f0b.1774604356.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Allen Pais <apais@linux.microsoft.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: Harry Yoo (Oracle) <harry@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Imran Khan <imran.f.khan@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kamalesh Babulal <kamalesh.babulal@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 mm/memcontrol.c            |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-correct-the-nr_pages-parameter-type-of-mem_cgroup_update_lru_size
+++ a/include/linux/memcontrol.h
@@ -878,7 +878,7 @@ static inline bool mem_cgroup_online(str
 }
 
 void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
-		int zid, int nr_pages);
+		int zid, long nr_pages);
 
 static inline
 unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
--- a/mm/memcontrol.c~mm-memcontrol-correct-the-nr_pages-parameter-type-of-mem_cgroup_update_lru_size
+++ a/mm/memcontrol.c
@@ -1472,7 +1472,7 @@ retry:
  * to or just after a page is removed from an lru list.
  */
 void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
-				int zid, int nr_pages)
+				int zid, long nr_pages)
 {
 	struct mem_cgroup_per_node *mz;
 	unsigned long *lru_size;
@@ -1489,7 +1489,7 @@ void mem_cgroup_update_lru_size(struct l
 
 	size = *lru_size;
 	if (WARN_ONCE(size < 0,
-		"%s(%p, %d, %d): lru_size %ld\n",
+		"%s(%p, %d, %ld): lru_size %ld\n",
 		__func__, lruvec, lru, nr_pages, size)) {
 		VM_BUG_ON(1);
 		*lru_size = 0;
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-vmscan-prepare-for-the-refactoring-the-move_folios_to_lru.patch
mm-thp-prevent-memory-cgroup-release-in-folio_split_queue_lock_irqsave.patch
mm-zswap-prevent-memory-cgroup-release-in-zswap_compress.patch
mm-do-not-open-code-lruvec-lock.patch
mm-vmscan-prepare-for-reparenting-traditional-lru-folios.patch
mm-vmscan-prepare-for-reparenting-mglru-folios.patch
mm-memcontrol-refactor-memcg_reparent_objcgs.patch
mm-workingset-use-lruvec_lru_size-to-get-the-number-of-lru-pages.patch
mm-memcontrol-refactor-mod_memcg_state-and-mod_memcg_lruvec_state.patch
mm-memcontrol-prepare-for-reparenting-non-hierarchical-stats.patch
mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type.patch
mm-memcontrol-correct-the-type-of-stats_updates-to-unsigned-long.patch
mm-memcontrol-change-val-type-to-long-in-__mod_memcg_lruvec_state.patch
mm-memcontrol-correct-the-nr_pages-parameter-type-of-mem_cgroup_update_lru_size.patch

