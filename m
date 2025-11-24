Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C562F6566
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025838; cv=none; b=mIS0kxBH469Cb9M0F2EH5fAEQlfQNg1EQHhyedmrqbdmxT6jncDqHpQ4SRuS1cShWKn3nyOVdncqaMkEc+3AN/T7Dmyvivp1rw3E0emNdn42dattBDbb20GCV9vNmaqXPltHByG+wtjBikouakNx3elJ4FMQGGWWynzd+xBQub0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025838; c=relaxed/simple;
	bh=9hpeGj7OcZFecnddECGfaX6IBJYUL6cSZbk/CguxSuE=;
	h=Date:To:From:Subject:Message-Id; b=pyJvqN1QAKbnB+8tOzCrxx5Yr7v+O9MMhGTKT4NeMuibw+3amqupA4m34j/KnjhuDwy50GzzIt30T106Ta71/w0Ou/UnHDzZIV9DIcjxisusODPez3C81OZrp+jZYC4/TrgnhsK+2JlrlMhoYvsH3HbOj7tnl5iVt8Jnia6ljNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XCZ1bQDg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XCZ1bQDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C09AC4CEF1;
	Mon, 24 Nov 2025 23:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025838;
	bh=9hpeGj7OcZFecnddECGfaX6IBJYUL6cSZbk/CguxSuE=;
	h=Date:To:From:Subject:From;
	b=XCZ1bQDgIaATS/uFFK/gH9wiecirS8YQog8kbu3Uoos93fwwUGIUWOONNylXoX0DN
	 JKPzywlwmS5CI6QkanRFQF5kRSRpCQlkWDCJzzAExCDhSJAwBQmMMob/9XGtWHZWOs
	 MHhWPCJwpPt7d5pCoF0qty2wq/wHEL6qHxlzMtZs=
Date: Mon, 24 Nov 2025 15:10:38 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,songmuchun@bytedance.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,roman.gushchin@linux.dev,richard.weiyang@gmail.com,npache@redhat.com,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-thp-reparent-the-split-queue-during-memcg-offline.patch removed from -mm tree
Message-Id: <20251124231038.9C09AC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: thp: reparent the split queue during memcg offline
has been removed from the -mm tree.  Its filename was
     mm-thp-reparent-the-split-queue-during-memcg-offline.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: thp: reparent the split queue during memcg offline
Date: Mon, 10 Nov 2025 16:17:58 +0800

Similar to list_lru, the split queue is relatively independent and does
not need to be reparented along with objcg and LRU folios (holding objcg
lock and lru lock).  So let's apply the similar mechanism as list_lru to
reparent the split queue separately when memcg is offine.

This is also a preparation for reparenting LRU folios.

Link: https://lkml.kernel.org/r/8703f907c4d1f7e8a2ef2bfed3036a84fa53028b.1762762324.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h    |    4 +++
 include/linux/memcontrol.h |   11 ++++++++
 mm/huge_memory.c           |   44 +++++++++++++++++++++++++++++++++++
 mm/memcontrol.c            |    1 
 4 files changed, 60 insertions(+)

--- a/include/linux/huge_mm.h~mm-thp-reparent-the-split-queue-during-memcg-offline
+++ a/include/linux/huge_mm.h
@@ -415,6 +415,9 @@ static inline int split_huge_page(struct
 	return split_huge_page_to_list_to_order(page, NULL, 0);
 }
 void deferred_split_folio(struct folio *folio, bool partially_mapped);
+#ifdef CONFIG_MEMCG
+void reparent_deferred_split_queue(struct mem_cgroup *memcg);
+#endif
 
 void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long address, bool freeze);
@@ -647,6 +650,7 @@ static inline int try_folio_split_to_ord
 }
 
 static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
+static inline void reparent_deferred_split_queue(struct mem_cgroup *memcg) {}
 #define split_huge_pmd(__vma, __pmd, __address)	\
 	do { } while (0)
 
--- a/include/linux/memcontrol.h~mm-thp-reparent-the-split-queue-during-memcg-offline
+++ a/include/linux/memcontrol.h
@@ -1775,6 +1775,12 @@ static inline void count_objcg_events(st
 bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid);
 
 void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg);
+
+static inline bool memcg_is_dying(struct mem_cgroup *memcg)
+{
+	return memcg ? css_is_dying(&memcg->css) : false;
+}
+
 #else
 static inline bool mem_cgroup_kmem_disabled(void)
 {
@@ -1845,6 +1851,11 @@ static inline bool mem_cgroup_node_allow
 static inline void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
 {
 }
+
+static inline bool memcg_is_dying(struct mem_cgroup *memcg)
+{
+	return false;
+}
 #endif /* CONFIG_MEMCG */
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
--- a/mm/huge_memory.c~mm-thp-reparent-the-split-queue-during-memcg-offline
+++ a/mm/huge_memory.c
@@ -1118,8 +1118,19 @@ static struct deferred_split *split_queu
 {
 	struct deferred_split *queue;
 
+retry:
 	queue = memcg_split_queue(nid, memcg);
 	spin_lock(&queue->split_queue_lock);
+	/*
+	 * There is a period between setting memcg to dying and reparenting
+	 * deferred split queue, and during this period the THPs in the deferred
+	 * split queue will be hidden from the shrinker side.
+	 */
+	if (unlikely(memcg_is_dying(memcg))) {
+		spin_unlock(&queue->split_queue_lock);
+		memcg = parent_mem_cgroup(memcg);
+		goto retry;
+	}
 
 	return queue;
 }
@@ -1129,8 +1140,14 @@ split_queue_lock_irqsave(int nid, struct
 {
 	struct deferred_split *queue;
 
+retry:
 	queue = memcg_split_queue(nid, memcg);
 	spin_lock_irqsave(&queue->split_queue_lock, *flags);
+	if (unlikely(memcg_is_dying(memcg))) {
+		spin_unlock_irqrestore(&queue->split_queue_lock, *flags);
+		memcg = parent_mem_cgroup(memcg);
+		goto retry;
+	}
 
 	return queue;
 }
@@ -4389,6 +4406,33 @@ next:
 	return split;
 }
 
+#ifdef CONFIG_MEMCG
+void reparent_deferred_split_queue(struct mem_cgroup *memcg)
+{
+	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
+	struct deferred_split *ds_queue = &memcg->deferred_split_queue;
+	struct deferred_split *parent_ds_queue = &parent->deferred_split_queue;
+	int nid;
+
+	spin_lock_irq(&ds_queue->split_queue_lock);
+	spin_lock_nested(&parent_ds_queue->split_queue_lock, SINGLE_DEPTH_NESTING);
+
+	if (!ds_queue->split_queue_len)
+		goto unlock;
+
+	list_splice_tail_init(&ds_queue->split_queue, &parent_ds_queue->split_queue);
+	parent_ds_queue->split_queue_len += ds_queue->split_queue_len;
+	ds_queue->split_queue_len = 0;
+
+	for_each_node(nid)
+		set_shrinker_bit(parent, nid, shrinker_id(deferred_split_shrinker));
+
+unlock:
+	spin_unlock(&parent_ds_queue->split_queue_lock);
+	spin_unlock_irq(&ds_queue->split_queue_lock);
+}
+#endif
+
 #ifdef CONFIG_DEBUG_FS
 static void split_huge_pages_all(void)
 {
--- a/mm/memcontrol.c~mm-thp-reparent-the-split-queue-during-memcg-offline
+++ a/mm/memcontrol.c
@@ -3920,6 +3920,7 @@ static void mem_cgroup_css_offline(struc
 	zswap_memcg_offline_cleanup(memcg);
 
 	memcg_offline_kmem(memcg);
+	reparent_deferred_split_queue(memcg);
 	reparent_shrinker_deferred(memcg);
 	wb_memcg_offline(memcg);
 	lru_gen_offline_memcg(memcg);
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


