Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723BD1EF36C
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747119341; cv=none; b=S+zMLJuc9151GbqRfZ7FEKsaUeFAfRjxK2i6U+wxOzjJIf4xCGEpWZd3tgkT9S+aB6jxKEoOq4hqGzi+IFMkgLiPmmBusd/g9ZSicKaSJKvubXwlUBflE4RTIOlkU8VUJwFbQl0ZWUJIFl/HejHS1EzGr2A6VEZ+OaLnLhgS00Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747119341; c=relaxed/simple;
	bh=tpP96ovJHUVc68YIQazSm90OA66EtaEbjOcYsphaf2g=;
	h=Date:To:From:Subject:Message-Id; b=NWH+puUCoePd6qPeW7zviZ4JHd1UthUovqBtqzuSN/PJv58ElCKsz5+A+T3BaO0jNvAgG+TZMhkc1a8g328uqOAcOFofbbUBAkAmAWLPJx5SAUTc0NLHO34YXWmzBUNqwQNGFWfgU+IQHzlOxPpqWUz+RCEjmKtZcoPXRxgwqX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CCncCSHQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CCncCSHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4831FC4CEE4;
	Tue, 13 May 2025 06:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747119341;
	bh=tpP96ovJHUVc68YIQazSm90OA66EtaEbjOcYsphaf2g=;
	h=Date:To:From:Subject:From;
	b=CCncCSHQSCagLeJypv5UaAX85PIv7sc0c8/tREc5xmaEROiutDhj/xzTUDS3GmkjT
	 eTbfh5yGMVSpV112TC4gafJD4w6R99ukYWEYByyBWW9FCyvmPlf4mpBh3jVuOAymjw
	 SLJ+g3NHUdjyHdgX3iUR6GvqsXLpp0PVXXUpKMZg=
Date: Mon, 12 May 2025 23:55:40 -0700
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,wang.yaxin@zte.com.cn,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,david@redhat.com,chen.haonan2@zte.com.cn,xu.xin16@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcontrol-v1-add-ksm_stat-at-memcg-v1.patch removed from -mm tree
Message-Id: <20250513065541.4831FC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcontrol-v1: add ksm_stat at memcg-v1
has been removed from the -mm tree.  Its filename was
     memcontrol-v1-add-ksm_stat-at-memcg-v1.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: xu xin <xu.xin16@zte.com.cn>
Subject: memcontrol-v1: add ksm_stat at memcg-v1
Date: Thu, 1 May 2025 04:16:47 +0000

With the enablement of container-level KSM (e.g., via prctl), there is a
growing demand for container-level observability of KSM behavior. 
However, current cgroup implementations lack support for exposing
KSM-related metrics.

This patch introduces a new interface named ksm_stat at the cgroup
hierarchy level, enabling users to monitor KSM merging statistics
specifically for containers where this feature has been activated,
eliminating the need to manually inspect KSM information for each
individual process within the cgroup-v1.

Since the implementation of ksm_stat has been added into memcg-v2, this
just add it back to memcg-v1 with the same function of traversing the
process of the memcg.

Users can obtain the KSM information of a cgroup just by:

        `cat /sys/fs/cgroup/memory.ksm_stat`

Link: https://lkml.kernel.org/r/20250501041647.3324541-1-xu.xin16@zte.com.cn
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Cc: David Hildenbrand <david@redhat.com>
Cc: Haonan Chen <chen.haonan2@zte.com.cn>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    7 +++++++
 mm/memcontrol-v1.c         |    6 ++++++
 mm/memcontrol.c            |    2 +-
 3 files changed, 14 insertions(+), 1 deletion(-)

--- a/include/linux/memcontrol.h~memcontrol-v1-add-ksm_stat-at-memcg-v1
+++ a/include/linux/memcontrol.h
@@ -939,6 +939,8 @@ unsigned long lruvec_page_state(struct l
 unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 				      enum node_stat_item idx);
 
+int memcg_ksm_stat_show(struct seq_file *m, void *v);
+
 void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
 void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg);
 
@@ -1416,6 +1418,11 @@ static inline unsigned long lruvec_page_
 	return node_page_state(lruvec_pgdat(lruvec), idx);
 }
 
+static inline int memcg_ksm_stat_show(struct seq_file *m, void *v)
+{
+	return 0;
+}
+
 static inline void mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 {
 }
--- a/mm/memcontrol.c~memcontrol-v1-add-ksm_stat-at-memcg-v1
+++ a/mm/memcontrol.c
@@ -4491,7 +4491,7 @@ static int evaluate_memcg_ksm_stat(struc
 	return 0;
 }
 
-static int memcg_ksm_stat_show(struct seq_file *m, void *v)
+int memcg_ksm_stat_show(struct seq_file *m, void *v)
 {
 	struct memcg_ksm_stat ksm_stat;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
--- a/mm/memcontrol-v1.c~memcontrol-v1-add-ksm_stat-at-memcg-v1
+++ a/mm/memcontrol-v1.c
@@ -2080,6 +2080,12 @@ struct cftype mem_cgroup_legacy_files[]
 		.seq_show = memcg_numa_stat_show,
 	},
 #endif
+#ifdef CONFIG_KSM
+	{
+		.name = "ksm_stat",
+		.seq_show = memcg_ksm_stat_show,
+	},
+#endif
 	{
 		.name = "kmem.limit_in_bytes",
 		.private = MEMFILE_PRIVATE(_KMEM, RES_LIMIT),
_

Patches currently in -mm which might be from xu.xin16@zte.com.cn are


