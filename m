Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A67325CC74
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498678; cv=none; b=AR5+yHedbbE+WqFUDWOBDsdJoNsukc7GHaFQj3tYx3r5ZeatoVpF6SYFZp3ydt8Ee3HSz7lS8WLFk76Qc7gjhbfiD5XbQr45KyMUU2YyRvZ5CZmrmSRldndruFfED6jwKSiKPkaVygwdPxEGP+WTMkRP6xxBPSFNZiJYvO/6SyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498678; c=relaxed/simple;
	bh=s5hURI+TUa7a0ioYVE2KokGM4ikQNAxlPNPyDwjiY8Y=;
	h=Date:To:From:Subject:Message-Id; b=Ox38ZGA1IFTtn8jcLmsL554c4wayBoiS1rhcOAPsY/rds83xJqeL8MBRB8az5xWVD49QeyUOD+XJtwj+PK69ZvgjGZJfVtNK3vBPiuVTe7cNK8UZICJ8HV5BuBEBcrOpghR45dnc3RDa58gyFOCJcicQ+UZQB3Gc18Yuf1OA6/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D/pDDe+Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D/pDDe+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C190DC19424;
	Sat, 18 Apr 2026 07:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498678;
	bh=s5hURI+TUa7a0ioYVE2KokGM4ikQNAxlPNPyDwjiY8Y=;
	h=Date:To:From:Subject:From;
	b=D/pDDe+Yc2eoFz+KECU5Qe5SVpdztuIEHpEuQ9aHc61CtGn7CejkWHHm45BPgrZnb
	 tJexGCy2lbfxusACFYo4fQKgUZrG1Nyf4dnsIbMa+AginR58gB3AbhMLG0SXRFoJ0O
	 uG1ZW8LomGInkyZbK06f6iTyPCqG6D1zuzfDx4A4=
Date: Sat, 18 Apr 2026 00:51:12 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,usamaarif642@gmail.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,ljs@kernel.org,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry@kernel.org,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,bhe@redhat.com,axelrasmussen@google.com,apais@linux.microsoft.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-change-val-type-to-long-in-__mod_memcg_lruvec_state.patch removed from -mm tree
Message-Id: <20260418075116.C190DC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcontrol: change val type to long in __mod_memcg_{lruvec_}state()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-change-val-type-to-long-in-__mod_memcg_lruvec_state.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

Link: https://lore.kernel.org/70a9440e49c464b4dca88bcabc6b491bd335c9f0.1774604356.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reported-by: Harry Yoo (Oracle) <harry@kernel.org>
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


