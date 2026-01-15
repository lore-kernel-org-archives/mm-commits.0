Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AE93BFE34
	for <mm-commits@vger.kernel.org>; Thu, 15 Jan 2026 17:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499242; cv=none; b=NaRhyer0KxUHHg4d5X5UXySQJ6sxiLNHDDVPGtqhYW/1DLP3qbU+NBca9g4ZmS/Jstu2100KtgCcwyRM2FjivSkSmy1WC852wjiQ7GAW0/IBgF7c3foGkjSCBPjXxDUonsVjQflqwSuwbVniJw9BwISPYQK+rAYh7Ka5e0a24SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499242; c=relaxed/simple;
	bh=bl4EzNWh2XiaKmB1k8Jw+LGqqCANWB8WlgLINDcxewc=;
	h=Date:To:From:Subject:Message-Id; b=cXR3jaJYsWM63Hv/pIjHR/aenNGjYgQIhzxz2C/x39YLNya1dclYL/oxBUvFwwn1hTpWB72mAVCavXklEzECqiypraNEK7TGvyZIBhlt25f9OUKYeN/9uED+vDO2XIYfO3jBpXmCKflEGLy172E7jJE5rlB5Ofvg7VKzhs94Ht4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kukwFEHj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kukwFEHj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0DBC116D0;
	Thu, 15 Jan 2026 17:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768499242;
	bh=bl4EzNWh2XiaKmB1k8Jw+LGqqCANWB8WlgLINDcxewc=;
	h=Date:To:From:Subject:From;
	b=kukwFEHjFyrlQE3MM3DX249MDtKmQ2Q/00XoTX9V2Gr/tm7ZKMZPk8oJt4mN8x5jx
	 VXNxy0feZQ2jG2RAMsQyFAWHEn8jCkFmnnFfI2PZ2uYtqrbjV4RbeuiJmSwXcDdsMl
	 KaEGtWYHB+nanpqROYw6lauM0+/pmTq/CG2xALH0=
Date: Thu, 15 Jan 2026 09:47:22 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,weixugc@google.com,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,mkoutny@suse.com,mhocko@kernel.org,lorenzo.stoakes@oracle.com,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,david@fromorbit.com,chenridong@huawei.com,chengming.zhou@linux.dev,axelrasmussen@google.com,apais@linux.microsoft.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-prepare-for-reparenting-state_local-fix.patch added to mm-new branch
Message-Id: <20260115174722.9D0DBC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcontrol: fix lruvec_stats->state_local reparenting
has been added to the -mm mm-new branch.  Its filename is
     mm-memcontrol-prepare-for-reparenting-state_local-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-prepare-for-reparenting-state_local-fix.patch

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
Subject: mm: memcontrol: fix lruvec_stats->state_local reparenting
Date: Thu, 15 Jan 2026 18:41:38 +0800

Link: https://lkml.kernel.org/r/e5afd1b5ae95d70f82433b9b4e13201342d16707.1768473427.git.zhengqi.arch@bytedance.com
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

 include/linux/memcontrol.h |    2 --
 mm/memcontrol-v1.c         |    8 --------
 mm/memcontrol-v1.h         |    5 ++++-
 mm/memcontrol.c            |   19 ++++++++-----------
 4 files changed, 12 insertions(+), 22 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-prepare-for-reparenting-state_local-fix
+++ a/include/linux/memcontrol.h
@@ -967,8 +967,6 @@ void reparent_memcg_state_local(struct m
 unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx);
 unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 				      enum node_stat_item idx);
-void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
-				       struct mem_cgroup *parent, int idx);
 void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
 void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg);
 
--- a/mm/memcontrol.c~mm-memcontrol-prepare-for-reparenting-state_local-fix
+++ a/mm/memcontrol.c
@@ -223,13 +223,13 @@ static inline struct obj_cgroup *__memcg
 	return objcg;
 }
 
-#ifdef CONFIG_MEMCG_V1
+static void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
+					      struct mem_cgroup *parent, int idx);
 static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force);
 
 static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 {
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		return;
+	int i;
 
 	synchronize_rcu();
 
@@ -237,13 +237,10 @@ static inline void reparent_state_local(
 
 	/* The following counts are all non-hierarchical and need to be reparented. */
 	reparent_memcg1_state_local(memcg, parent);
-	reparent_memcg1_lruvec_state_local(memcg, parent);
-}
-#else
-static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
-{
+
+	for (i = 0; i < NR_LRU_LISTS; i++)
+		reparent_memcg_lruvec_state_local(memcg, parent, i);
 }
-#endif
 
 static inline void reparent_locks(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 {
@@ -478,8 +475,8 @@ unsigned long lruvec_page_state_local(st
 	return x;
 }
 
-void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
-				       struct mem_cgroup *parent, int idx)
+static void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
+					      struct mem_cgroup *parent, int idx)
 {
 	int i = memcg_stats_index(idx);
 	int nid;
--- a/mm/memcontrol-v1.c~mm-memcontrol-prepare-for-reparenting-state_local-fix
+++ a/mm/memcontrol-v1.c
@@ -1906,14 +1906,6 @@ void reparent_memcg1_state_local(struct
 		reparent_memcg_state_local(memcg, parent, memcg1_stats[i]);
 }
 
-void reparent_memcg1_lruvec_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++)
-		reparent_memcg_lruvec_state_local(memcg, parent, memcg1_stats[i]);
-}
-
 void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 {
 	unsigned long memory, memsw;
--- a/mm/memcontrol-v1.h~mm-memcontrol-prepare-for-reparenting-state_local-fix
+++ a/mm/memcontrol-v1.h
@@ -76,7 +76,6 @@ void memcg1_uncharge_batch(struct mem_cg
 
 void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s);
 void reparent_memcg1_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent);
-void reparent_memcg1_lruvec_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent);
 
 void memcg1_account_kmem(struct mem_cgroup *memcg, int nr_pages);
 static inline bool memcg1_tcpmem_active(struct mem_cgroup *memcg)
@@ -117,6 +116,10 @@ static inline void memcg1_uncharge_batch
 
 static inline void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s) {}
 
+static inline void reparent_memcg1_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+{
+}
+
 static inline void memcg1_account_kmem(struct mem_cgroup *memcg, int nr_pages) {}
 static inline bool memcg1_tcpmem_active(struct mem_cgroup *memcg) { return false; }
 static inline bool memcg1_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
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

