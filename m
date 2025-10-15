Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DB0302761
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 22:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760565701; cv=none; b=nvTHbQo/cfYbWOGASdStWRIvGJAoLtUhoMRteck0fl9mwbtDE6uatv6ZRt+TfLq4cpsjO1IABuV5Y9nH2iEg2vU2edye/ILLGrqd6sKj7oEvft8ZBjEzyD2ESduSIEd17O7IRk67HzCUGo3w54de2bSZ/0SOGlRTwgvDpzMTsMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760565701; c=relaxed/simple;
	bh=4yPRnwLYb25tMhi0BdgeSiJCjjrxnm3MX6VlBJBzRBM=;
	h=Date:To:From:Subject:Message-Id; b=Jeh6JzxxmMAPhEVpxqsgGR1nq/GtPtkWC8/YLBHD1QBrHumc5GWapIZuaqYK2EoRLoKT4UsLZqF7iy8j4upZMPe+I4HmVi4F36nMk7jQtjW/90uuvDR1RA7gasIxxY5xr9z2d8kpLBT7v9FJi77HWoGXbrA8NMn9Vgru0o+ut6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0qKrp6Dk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0qKrp6Dk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A94C4CEF8;
	Wed, 15 Oct 2025 22:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760565701;
	bh=4yPRnwLYb25tMhi0BdgeSiJCjjrxnm3MX6VlBJBzRBM=;
	h=Date:To:From:Subject:From;
	b=0qKrp6Dke9BGlCBjYaEaPzk55X3k95z1ar3khUxGy2SNJejPQq27hYFQHK0BTKzgh
	 3ZvzbRH0a7qW0U0cd46dvpQa/c50hS4lHEuOYkoIooYy4fgYK97mJ6MGx87/S13pCg
	 oDhbqedUqlyxlWvIZu88b6ipQVFVFudf7ps2ezVc=
Date: Wed, 15 Oct 2025 15:01:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,songmuchun@bytedance.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,roman.gushchin@linux.dev,npache@redhat.com,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,hughd@google.com,harry.yoo@oracle.com,hannes@cmpxchg.org,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-reparent-the-split-queue-during-memcg-offline.patch added to mm-new branch
Message-Id: <20251015220141.83A94C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: thp: reparent the split queue during memcg offline
has been added to the -mm mm-new branch.  Its filename is
     mm-thp-reparent-the-split-queue-during-memcg-offline.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-reparent-the-split-queue-during-memcg-offline.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: thp: reparent the split queue during memcg offline
Date: Wed, 15 Oct 2025 14:35:33 +0800

Similar to list_lru, the split queue is relatively independent and does
not need to be reparented along with objcg and LRU folios (holding objcg
lock and lru lock).  So let's apply the similar mechanism as list_lru to
reparent the split queue separately when memcg is offine.

This is also a preparation for reparenting LRU folios.

Link: https://lkml.kernel.org/r/645f537dee489faa45e611d303bf482a06f0ece7.1760509767.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h    |    4 +++
 include/linux/memcontrol.h |   10 +++++++
 mm/huge_memory.c           |   44 +++++++++++++++++++++++++++++++++++
 mm/memcontrol.c            |    1 
 4 files changed, 59 insertions(+)

--- a/include/linux/huge_mm.h~mm-thp-reparent-the-split-queue-during-memcg-offline
+++ a/include/linux/huge_mm.h
@@ -424,6 +424,9 @@ static inline int split_huge_page(struct
 	return split_huge_page_to_list_to_order(page, NULL, ret);
 }
 void deferred_split_folio(struct folio *folio, bool partially_mapped);
+#ifdef CONFIG_MEMCG
+void reparent_deferred_split_queue(struct mem_cgroup *memcg);
+#endif
 
 void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long address, bool freeze);
@@ -622,6 +625,7 @@ static inline int try_folio_split(struct
 }
 
 static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
+static inline void reparent_deferred_split_queue(struct mem_cgroup *memcg) {}
 #define split_huge_pmd(__vma, __pmd, __address)	\
 	do { } while (0)
 
--- a/include/linux/memcontrol.h~mm-thp-reparent-the-split-queue-during-memcg-offline
+++ a/include/linux/memcontrol.h
@@ -1801,6 +1801,11 @@ static inline void count_objcg_events(st
 
 bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid);
 
+static inline bool memcg_is_dying(struct mem_cgroup *memcg)
+{
+	return memcg ? css_is_dying(&memcg->css) : false;
+}
+
 #else
 static inline bool mem_cgroup_kmem_disabled(void)
 {
@@ -1867,6 +1872,11 @@ static inline bool mem_cgroup_node_allow
 {
 	return true;
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
@@ -1117,8 +1117,19 @@ static struct deferred_split *split_queu
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
@@ -1128,8 +1139,14 @@ split_queue_lock_irqsave(int nid, struct
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
@@ -4372,6 +4389,33 @@ next:
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
@@ -3888,6 +3888,7 @@ static void mem_cgroup_css_offline(struc
 	zswap_memcg_offline_cleanup(memcg);
 
 	memcg_offline_kmem(memcg);
+	reparent_deferred_split_queue(memcg);
 	reparent_shrinker_deferred(memcg);
 	wb_memcg_offline(memcg);
 	lru_gen_offline_memcg(memcg);
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-thp-reparent-the-split-queue-during-memcg-offline.patch

