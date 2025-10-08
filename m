Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226D923D289
	for <mm-commits@vger.kernel.org>; Wed,  8 Oct 2025 00:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759883603; cv=none; b=pwYRU2tmx9/CXNPe9Y6pbzcLdxL8xcdxX4wsGvPsAnMxxro39bGct9E1kcOSIEg7CY/FbMRMdlNlhpnYrLwc/nXJsdFhhCvnrVMB5PQyaavES7HoQBWqJyV0UOnDqZLWild3SlTLxdClucpqhpiUWDEcRZY44TcP0mNd8CBGVTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759883603; c=relaxed/simple;
	bh=7gzskd5vcIhD47U6T3+C/BY7xZb1F3x4WgVGQ0HGjyc=;
	h=Date:To:From:Subject:Message-Id; b=BMRzgYJVVkTGODe4H6KRAl0HRJHkoP7g6H+T+C0zpoDayW3ERChu2oy0gHfhPmKv9LUMyqawNa1hMAkZRfp/PiLhAa+IBtUbyk8GaqMjx6FB966v4br9pKUkg38b94JtzAa7f5GOmjR1bAh7XbbNGqUPJOlaMQoww444fjNLRAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YTGYasaG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YTGYasaG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C640C4CEF1;
	Wed,  8 Oct 2025 00:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759883601;
	bh=7gzskd5vcIhD47U6T3+C/BY7xZb1F3x4WgVGQ0HGjyc=;
	h=Date:To:From:Subject:From;
	b=YTGYasaGm4TobFqAzHA2NqLphD2pRSICOU58P1n6prXAt8DU1u92xOKrTtOVr4LMD
	 74q7z+uAwFGSDVCZ5BpGj5y0T8Mjj+3Uk3noVHgbg1I7jQXYiSpLnAy5PSWwML03Ec
	 iOTZSjxYvIUUzf76mhxPEPps8EdpeJhAlq0r2FmY=
Date: Tue, 07 Oct 2025 17:33:20 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,harry.yoo@oracle.com,hannes@cmpxchg.org,david@redhat.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-reparent-the-split-queue-during-memcg-offline.patch added to mm-new branch
Message-Id: <20251008003321.8C640C4CEF1@smtp.kernel.org>
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
Date: Sat, 4 Oct 2025 00:53:18 +0800

Similar to list_lru, the split queue is relatively independent and does
not need to be reparented along with objcg and LRU folios (holding objcg
lock and lru lock).  So let's apply the similar mechanism as list_lru to
reparent the split queue separately when memcg is offine.

This is also a preparation for reparenting LRU folios.

Link: https://lkml.kernel.org/r/a01588414c9911f2bc912fa87f181aa5620d89d4.1759510072.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    4 ++
 mm/huge_memory.c        |   54 ++++++++++++++++++++++++++++++++++++++
 mm/memcontrol.c         |    1 
 3 files changed, 59 insertions(+)

--- a/include/linux/huge_mm.h~mm-thp-reparent-the-split-queue-during-memcg-offline
+++ a/include/linux/huge_mm.h
@@ -417,6 +417,9 @@ static inline int split_huge_page(struct
 	return split_huge_page_to_list_to_order(page, NULL, ret);
 }
 void deferred_split_folio(struct folio *folio, bool partially_mapped);
+#ifdef CONFIG_MEMCG
+void reparent_deferred_split_queue(struct mem_cgroup *memcg);
+#endif
 
 void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long address, bool freeze);
@@ -611,6 +614,7 @@ static inline int try_folio_split(struct
 }
 
 static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
+static inline void reparent_deferred_split_queue(struct mem_cgroup *memcg) {}
 #define split_huge_pmd(__vma, __pmd, __address)	\
 	do { } while (0)
 
--- a/mm/huge_memory.c~mm-thp-reparent-the-split-queue-during-memcg-offline
+++ a/mm/huge_memory.c
@@ -1099,6 +1099,11 @@ static struct deferred_split *memcg_spli
 {
 	return memcg ? &memcg->deferred_split_queue : split_queue_node(nid);
 }
+
+static bool memcg_is_dying(struct mem_cgroup *memcg)
+{
+	return memcg ? css_is_dying(&memcg->css) : false;
+}
 #else
 static inline
 struct mem_cgroup *folio_split_queue_memcg(struct folio *folio,
@@ -1111,14 +1116,30 @@ static struct deferred_split *memcg_spli
 {
 	return split_queue_node(nid);
 }
+
+static bool memcg_is_dying(struct mem_cgroup *memcg)
+{
+	return false;
+}
 #endif
 
 static struct deferred_split *split_queue_lock(int nid, struct mem_cgroup *memcg)
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
@@ -1128,8 +1149,14 @@ split_queue_lock_irqsave(int nid, struct
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
@@ -4271,6 +4298,33 @@ next:
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

