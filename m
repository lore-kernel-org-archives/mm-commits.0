Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1323F7E86
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 18:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774636953; cv=none; b=mCDTLz8KEToqzH+VJvG2c69jI7lSFYkjh3OcRbrUTfCz+X7BY+MQ3vF1uZ2uasoXqDqUIGJgJhsyu+ECunBjLUTePFYIJkVPV00w2Zm2QOZJzOquHRfZypiCSLKPlscN7kCSzbEAIvuXERJk6ViCI+0q+s7veGSKPmENmTC4AWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774636953; c=relaxed/simple;
	bh=t4j3m3phCROWW5cbJUEqArPl0niJZPC6SvVIa1WjAsI=;
	h=Date:To:From:Subject:Message-Id; b=Fheq8xy8UdmR5cK8kCk3xs6Uwxyq/22IvudACHyduxxkYc+qDRLAmZU2mVbUawM8vKiw2s8hw+ZWh6tWkAWUl51fifBfhjOKuLFKPkZEAhjE/DTzSZFaMCVLgY5mHE9Ai9aU3A4TRLEDa6k5+yTOqb2oWjOehLeh4r5gJyX2yBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ugghtJ1E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ugghtJ1E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3718C19423;
	Fri, 27 Mar 2026 18:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774636953;
	bh=t4j3m3phCROWW5cbJUEqArPl0niJZPC6SvVIa1WjAsI=;
	h=Date:To:From:Subject:From;
	b=ugghtJ1EdnPdLJAlpS043RdcvCEiLwaOVmTzA4gWLCAVYDzqezTL2TsZY0ZncDaqb
	 XrQeYjPFScodK6uusVgdTck9Z827LG+7jwDixvrCfRHaVmp1TsCqtmtScTefYnjBVd
	 BMVm09n4v9/HdppA3sAeFepZjMjfeAbVc98RTBMY=
Date: Fri, 27 Mar 2026 11:42:32 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,usamaarif642@gmail.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,ljs@kernel.org,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry@kernel.org,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,bhe@redhat.com,axelrasmussen@google.com,apais@linux.microsoft.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-change-val-type-to-long-in-__mod_memcg_lruvec_state.patch added to mm-unstable branch
Message-Id: <20260327184232.E3718C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcontrol: change val type to long in __mod_memcg_{lruvec_}state()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-change-val-type-to-long-in-__mod_memcg_lruvec_state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-change-val-type-to-long-in-__mod_memcg_lruvec_state.patch

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
Subject: mm: memcontrol: change val type to long in __mod_memcg_{lruvec_}state()
Date: Fri, 27 Mar 2026 18:16:29 +0800

The __mod_memcg_state() and __mod_memcg_lruvec_state() functions are also
used to reparent non-hierarchical stats.  In this scenario, the values
passed to them are accumulated statistics that might be extremely large
and exceed the upper limit of a 32-bit integer.

Change the val parameter type from int to long in these functions and
their corresponding tracepoints (memcg_rstat_stats) to prevent potential
overflow issues.

After that, in memcg_state_val_in_pages(), if the passed val is negative,
the expression val * unit / PAGE_SIZE could be implicitly converted to a
massive positive number when compared with 1UL in the max() macro.  This
leads to returning an incorrect massive positive value.

Fix this by using abs(val) to calculate the magnitude first, and then
restoring the sign of the value before returning the result. 
Additionally, use mult_frac() to prevent potential overflow during the
multiplication of val and unit.

Link: https://lkml.kernel.org/r/70a9440e49c464b4dca88bcabc6b491bd335c9f0.1774604356.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reported-by: Harry Yoo (Oracle) <harry@kernel.org>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/memcg.h |   10 +++++-----
 mm/memcontrol.c              |   18 ++++++++++++------
 2 files changed, 17 insertions(+), 11 deletions(-)

--- a/include/trace/events/memcg.h~mm-memcontrol-change-val-type-to-long-in-__mod_memcg_lruvec_state
+++ a/include/trace/events/memcg.h
@@ -11,14 +11,14 @@
 
 DECLARE_EVENT_CLASS(memcg_rstat_stats,
 
-	TP_PROTO(struct mem_cgroup *memcg, int item, int val),
+	TP_PROTO(struct mem_cgroup *memcg, int item, long val),
 
 	TP_ARGS(memcg, item, val),
 
 	TP_STRUCT__entry(
 		__field(u64, id)
 		__field(int, item)
-		__field(int, val)
+		__field(long, val)
 	),
 
 	TP_fast_assign(
@@ -27,20 +27,20 @@ DECLARE_EVENT_CLASS(memcg_rstat_stats,
 		__entry->val = val;
 	),
 
-	TP_printk("memcg_id=%llu item=%d val=%d",
+	TP_printk("memcg_id=%llu item=%d val=%ld",
 		  __entry->id, __entry->item, __entry->val)
 );
 
 DEFINE_EVENT(memcg_rstat_stats, mod_memcg_state,
 
-	TP_PROTO(struct mem_cgroup *memcg, int item, int val),
+	TP_PROTO(struct mem_cgroup *memcg, int item, long val),
 
 	TP_ARGS(memcg, item, val)
 );
 
 DEFINE_EVENT(memcg_rstat_stats, mod_memcg_lruvec_state,
 
-	TP_PROTO(struct mem_cgroup *memcg, int item, int val),
+	TP_PROTO(struct mem_cgroup *memcg, int item, long val),
 
 	TP_ARGS(memcg, item, val)
 );
--- a/mm/memcontrol.c~mm-memcontrol-change-val-type-to-long-in-__mod_memcg_lruvec_state
+++ a/mm/memcontrol.c
@@ -527,7 +527,7 @@ unsigned long lruvec_page_state_local(st
 
 #ifdef CONFIG_MEMCG_V1
 static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
-				     enum node_stat_item idx, int val);
+				     enum node_stat_item idx, long val);
 
 void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
 				       struct mem_cgroup *parent, int idx)
@@ -784,14 +784,20 @@ static int memcg_page_state_unit(int ite
  * Normalize the value passed into memcg_rstat_updated() to be in pages. Round
  * up non-zero sub-page updates to 1 page as zero page updates are ignored.
  */
-static int memcg_state_val_in_pages(int idx, int val)
+static long memcg_state_val_in_pages(int idx, long val)
 {
 	int unit = memcg_page_state_unit(idx);
+	long res;
 
 	if (!val || unit == PAGE_SIZE)
 		return val;
-	else
-		return max(val * unit / PAGE_SIZE, 1UL);
+
+	/* Get the absolute value of (val * unit / PAGE_SIZE). */
+	res = mult_frac(abs(val), unit, PAGE_SIZE);
+	/* Round up zero values. */
+	res = res ? : 1;
+
+	return val < 0 ? -res : res;
 }
 
 #ifdef CONFIG_MEMCG_V1
@@ -831,7 +837,7 @@ static inline void get_non_dying_memcg_e
 #endif
 
 static void __mod_memcg_state(struct mem_cgroup *memcg,
-			      enum memcg_stat_item idx, int val)
+			      enum memcg_stat_item idx, long val)
 {
 	int i = memcg_stats_index(idx);
 	int cpu;
@@ -896,7 +902,7 @@ void reparent_memcg_state_local(struct m
 #endif
 
 static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
-				     enum node_stat_item idx, int val)
+				     enum node_stat_item idx, long val)
 {
 	struct mem_cgroup *memcg = pn->memcg;
 	int i = memcg_stats_index(idx);
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

