Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117971D5160
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 18:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774636951; cv=none; b=JRfxQ/QWpVD+0lZC8A6wfHc/ihrTGr2y+9g95fEkKzA9ZQusUPmCT3Wg/8UtJDjQnuzJuZRdqxoKXDXZOw9lUTTUx2voL89WDieNCQ8xpkR+GwcdvCzmIBYc9u09Wf2LSgqe29GZcX5sYQZNvZlhEXa0aOw0JFEVn3yPHQv1gts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774636951; c=relaxed/simple;
	bh=pRhf2YM88D8gsWeK8cbRREcCAs2pGQ4HPtJSAaVMJ5I=;
	h=Date:To:From:Subject:Message-Id; b=PNDvMCkVbzuNO4gCr2Q3jv9cbMAwAlcuXnmgxOGpsSM3XNes2ISI4AjbazPlPB6SNQcA0BuT6smpml18pnyUA++rG9wQRbKi79YaxVZYv0bQhiYzPRHaIXwEy6fCiAp7JQjTXSq/akxaqngryZhLl+9kY2GN7ujwMSGA1aWj4iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GHpi/eYd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GHpi/eYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90AEDC19423;
	Fri, 27 Mar 2026 18:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774636950;
	bh=pRhf2YM88D8gsWeK8cbRREcCAs2pGQ4HPtJSAaVMJ5I=;
	h=Date:To:From:Subject:From;
	b=GHpi/eYd6vnfaxTqkTCbFmflyf6MVmSnt/fBPJ5BmE48sdfT353zVoGaaH2nuiH59
	 ZgMQdqjzVpySahiBmlRkNM0Ob0G6GcSumea4XUnwmQPkr7mSd4l7R1U8vKV0IOFimz
	 VSerX61NAIcCcnudJuDhh4q4GVEET7N0JqtZofhA=
Date: Fri, 27 Mar 2026 11:42:29 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,usamaarif642@gmail.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,ljs@kernel.org,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry@kernel.org,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,bhe@redhat.com,axelrasmussen@google.com,apais@linux.microsoft.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-correct-the-type-of-stats_updates-to-unsigned-long.patch added to mm-unstable branch
Message-Id: <20260327184230.90AEDC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcontrol: correct the type of stats_updates to unsigned long
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-correct-the-type-of-stats_updates-to-unsigned-long.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-correct-the-type-of-stats_updates-to-unsigned-long.patch

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

Link: https://lkml.kernel.org/r/cover.1774604356.git.zhengqi.arch@bytedance.com
Link: https://lkml.kernel.org/r/a5b0b468e7b4fe5f26c50e36d5d016f16d92f98f.1774604356.git.zhengqi.arch@bytedance.com
Link: https://lore.kernel.org/all/acDxaEgnqPI-Z4be@hyeyoo/ [1]
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
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
Cc: Harry Yoo (Oracle) <harry@kernel.org>
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

