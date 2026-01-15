Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B173BFE5F
	for <mm-commits@vger.kernel.org>; Thu, 15 Jan 2026 17:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499246; cv=none; b=RtMhk7t2efSmsg00/0cEs6Hv2EQd6ZZlrYHGjEx2E92N7psCK19rDACWMAhB3AuUQxauYNt42JOvo6OMqC1dbpKquXZQsiVxd3PkoKUbBl1eOAMCGoekzQ1Un6UwKuNy6EwPCTMJCRoGiNG01GFbEhUkH5aaiTTeLASUq2qAWbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499246; c=relaxed/simple;
	bh=/btCbCzVklBCVWT9l9e6WFtKy3Ttcs9sC8R5p9aUj00=;
	h=Date:To:From:Subject:Message-Id; b=Z27gLIkB35PYyfnMERejR80RZ0iMNa59RAWy6ebDnz1SSVkzmbP8Zc6yOxQydKNAwKJaxBrgA1nx47x2dmY6MgM8UAP3ZmH7dkTPfyihZc2QH2oveA/UqSkoONSdpef+uoggiMIVBPlQYu4FypHQPEXhr+sjt3qTtwhsHbBzCXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sZfcfscB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sZfcfscB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28618C116D0;
	Thu, 15 Jan 2026 17:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768499246;
	bh=/btCbCzVklBCVWT9l9e6WFtKy3Ttcs9sC8R5p9aUj00=;
	h=Date:To:From:Subject:From;
	b=sZfcfscBetgOo+phlh9RJLw6K3Plaq8Q9KPR4wo02INhBExCsTucZ7RRP8tqpbnHz
	 IT53ZaeYcObKP/EPHnSUj5P8bVgCjrnnQxdPKRHUwmFyo1I9iz6zxr7teu4vb7zsuC
	 RRxlnzXsWgiU0VuHRA/RtFRIJIEspzOdukDA46KE=
Date: Thu, 15 Jan 2026 09:47:25 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,mkoutny@suse.com,mhocko@kernel.org,lorenzo.stoakes@oracle.com,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,david@fromorbit.com,chenridong@huawei.com,chengming.zhou@linux.dev,axelrasmussen@google.com,apais@linux.microsoft.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-prepare-for-reparenting-state_local-fix-2.patch added to mm-new branch
Message-Id: <20260115174726.28618C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcontrol: change state_locals to atomic_long_t type
has been added to the -mm mm-new branch.  Its filename is
     mm-memcontrol-prepare-for-reparenting-state_local-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-prepare-for-reparenting-state_local-fix-2.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
Subject: mm: memcontrol: change state_locals to atomic_long_t type
Date: Thu, 15 Jan 2026 18:41:39 +0800

Link: https://lkml.kernel.org/r/4aad240fe536ce024c002087b2c395a197928e8a.1768473427.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Allen Pais <apais@linux.microsoft.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chen Ridong <chenridong@huawei.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Imran Khan <imran.f.khan@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kamalesh Babulal <kamalesh.babulal@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-prepare-for-reparenting-state_local-fix-2
+++ a/mm/memcontrol.c
@@ -424,7 +424,7 @@ struct lruvec_stats {
 	long state[NR_MEMCG_NODE_STAT_ITEMS];
 
 	/* Non-hierarchical (CPU aggregated) state */
-	long state_local[NR_MEMCG_NODE_STAT_ITEMS];
+	atomic_long_t state_local[NR_MEMCG_NODE_STAT_ITEMS];
 
 	/* Pending child counts during tree propagation */
 	long state_pending[NR_MEMCG_NODE_STAT_ITEMS];
@@ -467,7 +467,7 @@ unsigned long lruvec_page_state_local(st
 		return 0;
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	x = READ_ONCE(pn->lruvec_stats->state_local[i]);
+	x = atomic_long_read(&(pn->lruvec_stats->state_local[i]));
 #ifdef CONFIG_SMP
 	if (x < 0)
 		x = 0;
@@ -492,8 +492,7 @@ static void reparent_memcg_lruvec_state_
 
 		parent_pn = container_of(parent_lruvec, struct mem_cgroup_per_node, lruvec);
 
-		WRITE_ONCE(parent_pn->lruvec_stats->state_local[i],
-			   parent_pn->lruvec_stats->state_local[i] + value);
+		atomic_long_add(value, &(parent_pn->lruvec_stats->state_local[i]));
 	}
 }
 
@@ -588,8 +587,8 @@ struct memcg_vmstats {
 	unsigned long		events[NR_MEMCG_EVENTS];
 
 	/* Non-hierarchical (CPU aggregated) page state & events */
-	long			state_local[MEMCG_VMSTAT_SIZE];
-	unsigned long		events_local[NR_MEMCG_EVENTS];
+	atomic_long_t		state_local[MEMCG_VMSTAT_SIZE];
+	atomic_long_t		events_local[NR_MEMCG_EVENTS];
 
 	/* Pending child counts during tree propagation */
 	long			state_pending[MEMCG_VMSTAT_SIZE];
@@ -781,7 +780,7 @@ unsigned long memcg_page_state_local(str
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return 0;
 
-	x = READ_ONCE(memcg->vmstats->state_local[i]);
+	x = atomic_long_read(&(memcg->vmstats->state_local[i]));
 #ifdef CONFIG_SMP
 	if (x < 0)
 		x = 0;
@@ -798,7 +797,7 @@ void reparent_memcg_state_local(struct m
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return;
 
-	WRITE_ONCE(parent->vmstats->state_local[i], parent->vmstats->state_local[i] + value);
+	atomic_long_add(value, &(parent->vmstats->state_local[i]));
 }
 #endif
 
@@ -944,7 +943,7 @@ unsigned long memcg_events_local(struct
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, event))
 		return 0;
 
-	return READ_ONCE(memcg->vmstats->events_local[i]);
+	return atomic_long_read(&(memcg->vmstats->events_local[i]));
 }
 #endif
 
@@ -4033,7 +4032,7 @@ struct aggregate_control {
 	/* pointer to the aggregated (CPU and subtree aggregated) counters */
 	long *aggregate;
 	/* pointer to the non-hierarchichal (CPU aggregated) counters */
-	long *local;
+	atomic_long_t *local;
 	/* pointer to the pending child counters during tree propagation */
 	long *pending;
 	/* pointer to the parent's pending counters, could be NULL */
@@ -4072,7 +4071,7 @@ static void mem_cgroup_stat_aggregate(st
 
 		/* Aggregate counts on this level and propagate upwards */
 		if (delta_cpu)
-			ac->local[i] += delta_cpu;
+			atomic_long_add(delta_cpu, &(ac->local[i]));
 
 		if (delta) {
 			ac->aggregate[i] += delta;
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-change-mm-pt_reclaimc-to-use-asm-tlbh-instead-of-asm-generic-tlbh.patch
alpha-mm-enable-mmu_gather_rcu_table_free.patch
loongarch-mm-enable-mmu_gather_rcu_table_free.patch
mips-mm-enable-mmu_gather_rcu_table_free.patch
parisc-mm-enable-mmu_gather_rcu_table_free.patch
um-mm-enable-mmu_gather_rcu_table_free.patch
mm-make-pt_reclaim-depends-on-mmu_gather_rcu_table_free.patch
mm-vmscan-prepare-for-the-refactoring-the-move_folios_to_lru.patch
mm-thp-prevent-memory-cgroup-release-in-folio_split_queue_lock_irqsave.patch
mm-zswap-prevent-memory-cgroup-release-in-zswap_compress.patch
mm-do-not-open-code-lruvec-lock.patch
mm-vmscan-prepare-for-reparenting-traditional-lru-folios.patch
mm-vmscan-prepare-for-reparenting-mglru-folios.patch
mm-vmscan-prepare-for-reparenting-mglru-folios-fix.patch
mm-memcontrol-refactor-memcg_reparent_objcgs.patch
mm-memcontrol-prepare-for-reparenting-state_local.patch
mm-memcontrol-prepare-for-reparenting-state_local-fix.patch
mm-memcontrol-prepare-for-reparenting-state_local-fix-2.patch

