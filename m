Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DC9331A46
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498671; cv=none; b=aC2GjYkUtV3vzmywySY3e8c5SbGQOKTUPXuJn+2brkSzlLrRcMDM6jX9kVz9OhkWCR9iOOjaWcl/hY7ia6CnOjpTH9dVYrGG9O8d7mkQJIcmxavE4Y8Ucz3/iUV3hMMMvpoMD3lgzOAIxnG7OaiXG5ZYk8FLSDWzQme8m6W6Zsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498671; c=relaxed/simple;
	bh=D3XvbtP85R2K/gx2DUSmEEyRTkOAS81bo/Y6L1rCr+8=;
	h=Date:To:From:Subject:Message-Id; b=FLAV6qtpdpo9hHUYg+Ww1x6BUCmRZiWRNN16yIxr+b+/j7IoVfcv/YFVbNyVGCcdFK2nPN5PtVhUDmFwkgzotzqSyZkrRCAFrDw+jz0D36N7coN9qwIMkt82oGSUHLvvkYAY3b08SKw44ymHFMtR37YilW7WWZyW7XXeA2eknqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=12rqZO0Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="12rqZO0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5863C19424;
	Sat, 18 Apr 2026 07:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498671;
	bh=D3XvbtP85R2K/gx2DUSmEEyRTkOAS81bo/Y6L1rCr+8=;
	h=Date:To:From:Subject:From;
	b=12rqZO0Q/9jynQ2pVvkFxQ0pGo0D6l8Cq34x2T8vhKGP9p6s0VWtwqsHqw1EySD2x
	 TuhZkD1BcwTPP8SBmzlHk6oYrqKmXFRWyDc5CWAMhWi6MBpF4ub9UNm/MjTzZf4Fxr
	 oe0otMwha+Db8fFVPWEkixMXmIZ7TdfmIZPa2nTM=
Date: Sat, 18 Apr 2026 00:51:07 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,usamaarif642@gmail.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,ljs@kernel.org,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry@kernel.org,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,bhe@redhat.com,axelrasmussen@google.com,apais@linux.microsoft.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-correct-the-type-of-stats_updates-to-unsigned-long.patch removed from -mm tree
Message-Id: <20260418075110.C5863C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcontrol: correct the type of stats_updates to unsigned long
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-correct-the-type-of-stats_updates-to-unsigned-long.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: memcontrol: correct the type of stats_updates to unsigned long
Date: Fri, 27 Mar 2026 18:16:28 +0800

Patch series "fix unexpected type conversions and potential overflows",
v3.

As Harry Yoo pointed out [1], in scenarios where massive state updates
occur (e.g., during the reparenting of LRU folios), the values passed to
memcg stat update functions can accumulate and exceed the upper limit of a
32-bit integer.

If the parameter types are not large enough (like 'int') or are handled
incorrectly, it can lead to severe truncation, potential overflow issues,
and unexpected type conversion bugs.

This series aims to address these issues by correcting the parameter types
in the relevant functions, and by fixing an implicit conversion bug in
memcg_state_val_in_pages().


This patch (of 3):

The memcg_rstat_updated() tracks updates for vmstats_percpu->state and
lruvec_stats_percpu->state.  Since these state values are of type long,
change the val parameter passed to memcg_rstat_updated() to long as well.

Correspondingly, change the type of stats_updates in struct
memcg_vmstats_percpu and struct memcg_vmstats from unsigned int and
atomic_t to unsigned long and atomic_long_t respectively to prevent
potential overflow when handling large state updates during the
reparenting of LRU folios.

Link: https://lore.kernel.org/cover.1774604356.git.zhengqi.arch@bytedance.com
Link: https://lore.kernel.org/a5b0b468e7b4fe5f26c50e36d5d016f16d92f98f.1774604356.git.zhengqi.arch@bytedance.com
Link: https://lore.kernel.org/all/acDxaEgnqPI-Z4be@hyeyoo/ [1]
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Cc: Allen Pais <apais@linux.microsoft.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
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

 mm/memcontrol.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-correct-the-type-of-stats_updates-to-unsigned-long
+++ a/mm/memcontrol.c
@@ -608,7 +608,7 @@ static inline int memcg_events_index(enu
 
 struct memcg_vmstats_percpu {
 	/* Stats updates since the last flush */
-	unsigned int			stats_updates;
+	unsigned long			stats_updates;
 
 	/* Cached pointers for fast iteration in memcg_rstat_updated() */
 	struct memcg_vmstats_percpu __percpu	*parent_pcpu;
@@ -639,7 +639,7 @@ struct memcg_vmstats {
 	unsigned long		events_pending[NR_MEMCG_EVENTS];
 
 	/* Stats updates since the last flush */
-	atomic_t		stats_updates;
+	atomic_long_t		stats_updates;
 };
 
 /*
@@ -665,16 +665,16 @@ static u64 flush_last_time;
 
 static bool memcg_vmstats_needs_flush(struct memcg_vmstats *vmstats)
 {
-	return atomic_read(&vmstats->stats_updates) >
+	return atomic_long_read(&vmstats->stats_updates) >
 		MEMCG_CHARGE_BATCH * num_online_cpus();
 }
 
-static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val,
+static inline void memcg_rstat_updated(struct mem_cgroup *memcg, long val,
 				       int cpu)
 {
 	struct memcg_vmstats_percpu __percpu *statc_pcpu;
 	struct memcg_vmstats_percpu *statc;
-	unsigned int stats_updates;
+	unsigned long stats_updates;
 
 	if (!val)
 		return;
@@ -697,7 +697,7 @@ static inline void memcg_rstat_updated(s
 			continue;
 
 		stats_updates = this_cpu_xchg(statc_pcpu->stats_updates, 0);
-		atomic_add(stats_updates, &statc->vmstats->stats_updates);
+		atomic_long_add(stats_updates, &statc->vmstats->stats_updates);
 	}
 }
 
@@ -705,7 +705,7 @@ static void __mem_cgroup_flush_stats(str
 {
 	bool needs_flush = memcg_vmstats_needs_flush(memcg->vmstats);
 
-	trace_memcg_flush_stats(memcg, atomic_read(&memcg->vmstats->stats_updates),
+	trace_memcg_flush_stats(memcg, atomic_long_read(&memcg->vmstats->stats_updates),
 		force, needs_flush);
 
 	if (!force && !needs_flush)
@@ -4413,8 +4413,8 @@ static void mem_cgroup_css_rstat_flush(s
 	}
 	WRITE_ONCE(statc->stats_updates, 0);
 	/* We are in a per-cpu loop here, only do the atomic write once */
-	if (atomic_read(&memcg->vmstats->stats_updates))
-		atomic_set(&memcg->vmstats->stats_updates, 0);
+	if (atomic_long_read(&memcg->vmstats->stats_updates))
+		atomic_long_set(&memcg->vmstats->stats_updates, 0);
 }
 
 static void mem_cgroup_fork(struct task_struct *task)
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


