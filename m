Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF649337699
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498611; cv=none; b=FhlKYdcE1dc9LoZB2gBGIYjW5ydWIwBFiXHJWR0GCFyyhi5u4R0873uk/HBxfjl09+Uu6YBHgE++mMd5Xr54ULvNjZzUDhZgt8yCRvmr97lU0w4vhaYlGJNsiSUYCpagZKWIg8SP2/ykag50w94hdheCDKJIq6EYi1HFAKHNaLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498611; c=relaxed/simple;
	bh=EYPfDQsrmh3FxVv/hRvk1Vuo9F08t+vjFWuyR5pyKd4=;
	h=Date:To:From:Subject:Message-Id; b=FZqmq5zfXP5Qr1ZokweRlqetDsJwupw7zbWU64cdzL3CWuQlMP6fdXwiSGRQ05ipAQWGB2zLPjeaktp9FZEMXwsZep+jqsItHk0COS0yjtoEEw77OI3dhuXhqj9jfdCH6MmNg2vzEksiKjyQLqC9ud176mqbBkvnSDkpuC6wVD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AWM9pWp6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AWM9pWp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF154C19424;
	Sat, 18 Apr 2026 07:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498611;
	bh=EYPfDQsrmh3FxVv/hRvk1Vuo9F08t+vjFWuyR5pyKd4=;
	h=Date:To:From:Subject:From;
	b=AWM9pWp6/9PyXsCrm6/n+YG87Qk3ERvdnnCvotW7ChC7qSSbbJriaBlLeiguXDS+G
	 CCTJK8YMJfDSnBMqsvMznu23pvyjurMEfj1jgejTW+JO4VoUSh0vgIF+4btDQr+/Br
	 nHJgHAoxL6E/TLP2YGrG26i/RLfTCriHqyVo5MgI=
Date: Sat, 18 Apr 2026 00:50:07 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,yosry@kernel.org,weixugc@google.com,vbabka@kernel.org,usamaarif642@gmail.com,surenb@google.com,songmuchun@bytedance.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,chenridong@huawei.com,chengming.zhou@linux.dev,bhe@redhat.com,axelrasmussen@google.com,apais@linux.microsoft.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmscan-prepare-for-reparenting-traditional-lru-folios.patch removed from -mm tree
Message-Id: <20260418075010.AF154C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: vmscan: prepare for reparenting traditional LRU folios
has been removed from the -mm tree.  Its filename was
     mm-vmscan-prepare-for-reparenting-traditional-lru-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: vmscan: prepare for reparenting traditional LRU folios
Date: Thu, 5 Mar 2026 19:52:43 +0800

To resolve the dying memcg issue, we need to reparent LRU folios of child
memcg to its parent memcg.  For traditional LRU list, each lruvec of every
memcg comprises four LRU lists.  Due to the symmetry of the LRU lists, it
is feasible to transfer the LRU lists from a memcg to its parent memcg
during the reparenting process.

This commit implements the specific function, which will be used during
the reparenting process.

Link: https://lore.kernel.org/a92d217a9fc82bd0c401210204a095caaf615b1c.1772711148.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Allen Pais <apais@linux.microsoft.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chen Ridong <chenridong@huawei.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Imran Khan <imran.f.khan@oracle.com>
Cc: Kamalesh Babulal <kamalesh.babulal@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   21 +++++++++++++++++++++
 mm/swap.c            |   33 +++++++++++++++++++++++++++++++++
 mm/vmscan.c          |   19 -------------------
 3 files changed, 54 insertions(+), 19 deletions(-)

--- a/include/linux/swap.h~mm-vmscan-prepare-for-reparenting-traditional-lru-folios
+++ a/include/linux/swap.h
@@ -546,6 +546,8 @@ static inline int mem_cgroup_swappiness(
 
 	return READ_ONCE(memcg->swappiness);
 }
+
+void lru_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid);
 #else
 static inline int mem_cgroup_swappiness(struct mem_cgroup *mem)
 {
@@ -610,5 +612,24 @@ static inline bool mem_cgroup_swap_full(
 }
 #endif
 
+/* for_each_managed_zone_pgdat - helper macro to iterate over all managed zones in a pgdat up to
+ * and including the specified highidx
+ * @zone: The current zone in the iterator
+ * @pgdat: The pgdat which node_zones are being iterated
+ * @idx: The index variable
+ * @highidx: The index of the highest zone to return
+ *
+ * This macro iterates through all managed zones up to and including the specified highidx.
+ * The zone iterator enters an invalid state after macro call and must be reinitialized
+ * before it can be used again.
+ */
+#define for_each_managed_zone_pgdat(zone, pgdat, idx, highidx)	\
+	for ((idx) = 0, (zone) = (pgdat)->node_zones;		\
+	    (idx) <= (highidx);					\
+	    (idx)++, (zone)++)					\
+		if (!managed_zone(zone))			\
+			continue;				\
+		else
+
 #endif /* __KERNEL__*/
 #endif /* _LINUX_SWAP_H */
--- a/mm/swap.c~mm-vmscan-prepare-for-reparenting-traditional-lru-folios
+++ a/mm/swap.c
@@ -1090,6 +1090,39 @@ void folio_batch_remove_exceptionals(str
 	fbatch->nr = j;
 }
 
+#ifdef CONFIG_MEMCG
+static void lruvec_reparent_lru(struct lruvec *child_lruvec,
+				struct lruvec *parent_lruvec,
+				enum lru_list lru, int nid)
+{
+	int zid;
+	struct zone *zone;
+
+	if (lru != LRU_UNEVICTABLE)
+		list_splice_tail_init(&child_lruvec->lists[lru], &parent_lruvec->lists[lru]);
+
+	for_each_managed_zone_pgdat(zone, NODE_DATA(nid), zid, MAX_NR_ZONES - 1) {
+		unsigned long size = mem_cgroup_get_zone_lru_size(child_lruvec, lru, zid);
+
+		mem_cgroup_update_lru_size(parent_lruvec, lru, zid, size);
+	}
+}
+
+void lru_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid)
+{
+	enum lru_list lru;
+	struct lruvec *child_lruvec, *parent_lruvec;
+
+	child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
+	parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
+	parent_lruvec->anon_cost += child_lruvec->anon_cost;
+	parent_lruvec->file_cost += child_lruvec->file_cost;
+
+	for_each_lru(lru)
+		lruvec_reparent_lru(child_lruvec, parent_lruvec, lru, nid);
+}
+#endif
+
 static const struct ctl_table swap_sysctl_table[] = {
 	{
 		.procname	= "page-cluster",
--- a/mm/vmscan.c~mm-vmscan-prepare-for-reparenting-traditional-lru-folios
+++ a/mm/vmscan.c
@@ -269,25 +269,6 @@ static int sc_swappiness(struct scan_con
 }
 #endif
 
-/* for_each_managed_zone_pgdat - helper macro to iterate over all managed zones in a pgdat up to
- * and including the specified highidx
- * @zone: The current zone in the iterator
- * @pgdat: The pgdat which node_zones are being iterated
- * @idx: The index variable
- * @highidx: The index of the highest zone to return
- *
- * This macro iterates through all managed zones up to and including the specified highidx.
- * The zone iterator enters an invalid state after macro call and must be reinitialized
- * before it can be used again.
- */
-#define for_each_managed_zone_pgdat(zone, pgdat, idx, highidx)	\
-	for ((idx) = 0, (zone) = (pgdat)->node_zones;		\
-	    (idx) <= (highidx);					\
-	    (idx)++, (zone)++)					\
-		if (!managed_zone(zone))			\
-			continue;				\
-		else
-
 static void set_task_reclaim_state(struct task_struct *task,
 				   struct reclaim_state *rs)
 {
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


