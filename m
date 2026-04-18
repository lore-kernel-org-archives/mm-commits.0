Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6762336074F
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498638; cv=none; b=KfciMt//isUof/c9wG3f5dOJQrHxJ0ZmRgRB0lkce7QwnAyZpIpK6bBYytz5ili7fRJSc8Ui/EuMb6wKjaYgJkd+/be/qzLsG27go3ZgMCuw0fBF5hMwUfxZ/GwT2JKGrSItoY4ix+tKgbPD7GWMYqtt9DXy0RZxe0YxXhkRK9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498638; c=relaxed/simple;
	bh=QLAmujRY4k7itlNKYn/P1ju2UzQ2Ev7CEYv+3iUZA2I=;
	h=Date:To:From:Subject:Message-Id; b=AcQ2Oy74+wuEiodQ/wvo8ltIuiVAaSwZL0JyJJZfZ4eM47Sulqly9oe2CD1VX1yIbS7l2lycU+HxDCLc2zjdvyUGlrk5LcKwss3YgnHAx7kXj0+TcJ+NxVcsqwnzy8y0tlT/ibGHxBzjKd2XOAy8v5Rj5Ud77N2ZUENA+lWtXYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cyBfeeoY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cyBfeeoY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31462C19424;
	Sat, 18 Apr 2026 07:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498638;
	bh=QLAmujRY4k7itlNKYn/P1ju2UzQ2Ev7CEYv+3iUZA2I=;
	h=Date:To:From:Subject:From;
	b=cyBfeeoY5tTNqoTKPa41YCtQWPAuvGjWrEYGvf5ZldzJcNxJkB3sqFRzvLOOcpYC2
	 7VmBNr4Kp1wQqwjOHayCamElZfbAo6pF7EYLWIF8MPnlCwx/hZpF94y3hKYUl2nO4q
	 IqjqxvG6pm5baUfAaOxSMAu/bUIvK0mxD/61T7pA=
Date: Sat, 18 Apr 2026 00:50:33 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuanchu@google.com,yosry@kernel.org,weixugc@google.com,vbabka@kernel.org,usamaarif642@gmail.com,surenb@google.com,songmuchun@bytedance.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mkoutny@suse.com,mhocko@suse.com,ljs@kernel.org,Liam.Howlett@oracle.com,lance.yang@linux.dev,kamalesh.babulal@oracle.com,imran.f.khan@oracle.com,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,hamzamahfooz@linux.microsoft.com,david@kernel.org,chenridong@huawei.com,chengming.zhou@linux.dev,bhe@redhat.com,axelrasmussen@google.com,apais@linux.microsoft.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcontrol-refactor-mod_memcg_state-and-mod_memcg_lruvec_state.patch removed from -mm tree
Message-Id: <20260418075037.31462C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcontrol: refactor mod_memcg_state() and mod_memcg_lruvec_state()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-refactor-mod_memcg_state-and-mod_memcg_lruvec_state.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: memcontrol: refactor mod_memcg_state() and mod_memcg_lruvec_state()
Date: Thu, 5 Mar 2026 19:52:47 +0800

Refactor the memcg_reparent_objcgs() to facilitate subsequent reparenting
non-hierarchical stats.

Link: https://lore.kernel.org/7f8bd3aacec2270b9453428fc8585cca9f10751e.1772711148.git.zhengqi.arch@bytedance.com
Co-developed-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Allen Pais <apais@linux.microsoft.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Chen Ridong <chenridong@huawei.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Imran Khan <imran.f.khan@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kamalesh Babulal <kamalesh.babulal@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   50 ++++++++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 19 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-refactor-mod_memcg_state-and-mod_memcg_lruvec_state
+++ a/mm/memcontrol.c
@@ -717,21 +717,12 @@ static int memcg_state_val_in_pages(int
 		return max(val * unit / PAGE_SIZE, 1UL);
 }
 
-/**
- * mod_memcg_state - update cgroup memory statistics
- * @memcg: the memory cgroup
- * @idx: the stat item - can be enum memcg_stat_item or enum node_stat_item
- * @val: delta to add to the counter, can be negative
- */
-void mod_memcg_state(struct mem_cgroup *memcg, enum memcg_stat_item idx,
-		       int val)
+static void __mod_memcg_state(struct mem_cgroup *memcg,
+			      enum memcg_stat_item idx, int val)
 {
 	int i = memcg_stats_index(idx);
 	int cpu;
 
-	if (mem_cgroup_disabled())
-		return;
-
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return;
 
@@ -745,6 +736,21 @@ void mod_memcg_state(struct mem_cgroup *
 	put_cpu();
 }
 
+/**
+ * mod_memcg_state - update cgroup memory statistics
+ * @memcg: the memory cgroup
+ * @idx: the stat item - can be enum memcg_stat_item or enum node_stat_item
+ * @val: delta to add to the counter, can be negative
+ */
+void mod_memcg_state(struct mem_cgroup *memcg, enum memcg_stat_item idx,
+		       int val)
+{
+	if (mem_cgroup_disabled())
+		return;
+
+	__mod_memcg_state(memcg, idx, val);
+}
+
 #ifdef CONFIG_MEMCG_V1
 /* idx can be of type enum memcg_stat_item or node_stat_item. */
 unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx)
@@ -764,21 +770,16 @@ unsigned long memcg_page_state_local(str
 }
 #endif
 
-static void mod_memcg_lruvec_state(struct lruvec *lruvec,
-				     enum node_stat_item idx,
-				     int val)
+static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
+				     enum node_stat_item idx, int val)
 {
-	struct mem_cgroup_per_node *pn;
-	struct mem_cgroup *memcg;
+	struct mem_cgroup *memcg = pn->memcg;
 	int i = memcg_stats_index(idx);
 	int cpu;
 
 	if (WARN_ONCE(BAD_STAT_IDX(i), "%s: missing stat item %d\n", __func__, idx))
 		return;
 
-	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	memcg = pn->memcg;
-
 	cpu = get_cpu();
 
 	/* Update memcg */
@@ -794,6 +795,17 @@ static void mod_memcg_lruvec_state(struc
 	put_cpu();
 }
 
+static void mod_memcg_lruvec_state(struct lruvec *lruvec,
+				     enum node_stat_item idx,
+				     int val)
+{
+	struct mem_cgroup_per_node *pn;
+
+	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
+
+	__mod_memcg_lruvec_state(pn, idx, val);
+}
+
 /**
  * mod_lruvec_state - update lruvec memory statistics
  * @lruvec: the lruvec
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


