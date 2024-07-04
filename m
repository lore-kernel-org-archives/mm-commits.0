Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B611442FC
	for <mm-commits@vger.kernel.org>; Thu,  4 Jul 2024 23:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720136703; cv=none; b=TuGKt+dZMeFHibkToI8PApzQu6j4EbmmrVT48rr2LymIAGqIM9+Xnvodikv3ehlN8WroSYqzS3INSVKW+cHh3yT7l5AJqp/EuqZduOv8KCpYZy0m6KXEHKPgtg27JmRrNmhJg1Xdb11XLc3KbS0Xki4j9Wv7KXXKLhWCQ0cesjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720136703; c=relaxed/simple;
	bh=l75V4MbrgYs2d7WSp0qYdtZojMsk5/Dr2BeFMubx7sQ=;
	h=Date:To:From:Subject:Message-Id; b=aPWz0/wAJiWhr2YY1Z8a1K57nLP6TnWQLG72kUQxciblWN8kssYMul3Sl/mFMTsc3cNHg3YoDWbi5/tpiOgat7HbXUmZIYwMvTYlM8a1DTasF5UOJM/4KHTMlvvWTjMLMouDNvMI9Iu5LBU66vZ7wm9jcwN+bGdo336qywWoaZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vbK6FDEq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vbK6FDEq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81634C3277B;
	Thu,  4 Jul 2024 23:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720136702;
	bh=l75V4MbrgYs2d7WSp0qYdtZojMsk5/Dr2BeFMubx7sQ=;
	h=Date:To:From:Subject:From;
	b=vbK6FDEq1YDnLnEvKbKGxDbHfJTgyY2EYm+Wqib5n8Yz4mLDlyH6Rai23QMQmuuVX
	 l7H5uBfM+1LmjT6L64iMMMkC0fz3LZkZ1+pTKvmsdgJFidQ/Kc19dUIVDCb0CtF9Ya
	 jh3t43XHFPZAmC4Yr9R4xdl0bTSoMArvupapHnZQ=
Date: Thu, 04 Jul 2024 16:45:01 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memcg-move-cgroup-v1-interface-files-to-memcontrol-v1c-fix.patch removed from -mm tree
Message-Id: <20240704234502.81634C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-memcg-move-cgroup-v1-interface-files-to-memcontrol-v1c-fix
has been removed from the -mm tree.  Its filename was
     mm-memcg-move-cgroup-v1-interface-files-to-memcontrol-v1c-fix.patch

This patch was dropped because it was folded into mm-memcg-move-cgroup-v1-interface-files-to-memcontrol-v1c.patch

------------------------------------------------------
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm-memcg-move-cgroup-v1-interface-files-to-memcontrol-v1c-fix
Date: Thu, 4 Jul 2024 00:27:12 +0000

I forgot to actually move two functions mem_cgroup_node_nr_lru_pages()
and mem_cgroup_nr_lru_pages() into mm/memcontrol-v1.c, so that they remain
in mm/memcontrol.c and their commented out duplicated versions in
mm/memcontrol-v1.c.

Link: https://lkml.kernel.org/r/20240704002712.2077812-1-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |   74 +++++++++++++++++++++----------------------
 mm/memcontrol-v1.h |    5 --
 mm/memcontrol.c    |   38 ----------------------
 3 files changed, 37 insertions(+), 80 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-move-cgroup-v1-interface-files-to-memcontrol-v1c-fix
+++ a/mm/memcontrol.c
@@ -3188,44 +3188,6 @@ static void memcg_offline_kmem(struct me
 }
 #endif /* CONFIG_MEMCG_KMEM */
 
-unsigned long mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
-					   int nid, unsigned int lru_mask,
-					   bool tree)
-{
-	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
-	unsigned long nr = 0;
-	enum lru_list lru;
-
-	VM_BUG_ON((unsigned)nid >= nr_node_ids);
-
-	for_each_lru(lru) {
-		if (!(BIT(lru) & lru_mask))
-			continue;
-		if (tree)
-			nr += lruvec_page_state(lruvec, NR_LRU_BASE + lru);
-		else
-			nr += lruvec_page_state_local(lruvec, NR_LRU_BASE + lru);
-	}
-	return nr;
-}
-
-unsigned long mem_cgroup_nr_lru_pages(struct mem_cgroup *memcg,
-				      unsigned int lru_mask, bool tree)
-{
-	unsigned long nr = 0;
-	enum lru_list lru;
-
-	for_each_lru(lru) {
-		if (!(BIT(lru) & lru_mask))
-			continue;
-		if (tree)
-			nr += memcg_page_state(memcg, NR_LRU_BASE + lru);
-		else
-			nr += memcg_page_state_local(memcg, NR_LRU_BASE + lru);
-	}
-	return nr;
-}
-
 #ifdef CONFIG_CGROUP_WRITEBACK
 
 #include <trace/events/writeback.h>
--- a/mm/memcontrol-v1.c~mm-memcg-move-cgroup-v1-interface-files-to-memcontrol-v1c-fix
+++ a/mm/memcontrol-v1.c
@@ -2494,43 +2494,43 @@ static ssize_t mem_cgroup_reset(struct k
 #define LRU_ALL_ANON (BIT(LRU_INACTIVE_ANON) | BIT(LRU_ACTIVE_ANON))
 #define LRU_ALL	     ((1 << NR_LRU_LISTS) - 1)
 
-/* static unsigned long mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg, */
-/* 				int nid, unsigned int lru_mask, bool tree) */
-/* { */
-/* 	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid)); */
-/* 	unsigned long nr = 0; */
-/* 	enum lru_list lru; */
-
-/* 	VM_BUG_ON((unsigned)nid >= nr_node_ids); */
-
-/* 	for_each_lru(lru) { */
-/* 		if (!(BIT(lru) & lru_mask)) */
-/* 			continue; */
-/* 		if (tree) */
-/* 			nr += lruvec_page_state(lruvec, NR_LRU_BASE + lru); */
-/* 		else */
-/* 			nr += lruvec_page_state_local(lruvec, NR_LRU_BASE + lru); */
-/* 	} */
-/* 	return nr; */
-/* } */
-
-/* static unsigned long mem_cgroup_nr_lru_pages(struct mem_cgroup *memcg, */
-/* 					     unsigned int lru_mask, */
-/* 					     bool tree) */
-/* { */
-/* 	unsigned long nr = 0; */
-/* 	enum lru_list lru; */
-
-/* 	for_each_lru(lru) { */
-/* 		if (!(BIT(lru) & lru_mask)) */
-/* 			continue; */
-/* 		if (tree) */
-/* 			nr += memcg_page_state(memcg, NR_LRU_BASE + lru); */
-/* 		else */
-/* 			nr += memcg_page_state_local(memcg, NR_LRU_BASE + lru); */
-/* 	} */
-/* 	return nr; */
-/* } */
+static unsigned long mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
+				int nid, unsigned int lru_mask, bool tree)
+{
+	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
+	unsigned long nr = 0;
+	enum lru_list lru;
+
+	VM_BUG_ON((unsigned)nid >= nr_node_ids);
+
+	for_each_lru(lru) {
+		if (!(BIT(lru) & lru_mask))
+			continue;
+		if (tree)
+			nr += lruvec_page_state(lruvec, NR_LRU_BASE + lru);
+		else
+			nr += lruvec_page_state_local(lruvec, NR_LRU_BASE + lru);
+	}
+	return nr;
+}
+
+static unsigned long mem_cgroup_nr_lru_pages(struct mem_cgroup *memcg,
+					     unsigned int lru_mask,
+					     bool tree)
+{
+	unsigned long nr = 0;
+	enum lru_list lru;
+
+	for_each_lru(lru) {
+		if (!(BIT(lru) & lru_mask))
+			continue;
+		if (tree)
+			nr += memcg_page_state(memcg, NR_LRU_BASE + lru);
+		else
+			nr += memcg_page_state_local(memcg, NR_LRU_BASE + lru);
+	}
+	return nr;
+}
 
 static int memcg_numa_stat_show(struct seq_file *m, void *v)
 {
--- a/mm/memcontrol-v1.h~mm-memcg-move-cgroup-v1-interface-files-to-memcontrol-v1c-fix
+++ a/mm/memcontrol-v1.h
@@ -88,11 +88,6 @@ void memcg1_oom_finish(struct mem_cgroup
 void memcg1_oom_recover(struct mem_cgroup *memcg);
 
 void drain_all_stock(struct mem_cgroup *root_memcg);
-unsigned long mem_cgroup_nr_lru_pages(struct mem_cgroup *memcg,
-				      unsigned int lru_mask, bool tree);
-unsigned long mem_cgroup_node_nr_lru_pages(struct mem_cgroup *memcg,
-					   int nid, unsigned int lru_mask,
-					   bool tree);
 
 unsigned long memcg_events(struct mem_cgroup *memcg, int event);
 unsigned long memcg_events_local(struct mem_cgroup *memcg, int event);
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcg-introduce-memcontrol-v1c.patch
mm-memcg-move-soft-limit-reclaim-code-to-memcontrol-v1c.patch
mm-memcg-rename-soft-limit-reclaim-related-functions.patch
mm-memcg-move-charge-migration-code-to-memcontrol-v1c.patch
mm-memcg-rename-charge-move-related-functions.patch
mm-memcg-move-legacy-memcg-event-code-into-memcontrol-v1c.patch
mm-memcg-rename-memcg_check_events.patch
mm-memcg-move-cgroup-v1-oom-handling-code-into-memcontrol-v1c.patch
mm-memcg-rename-memcg_oom_recover.patch
mm-memcg-move-cgroup-v1-interface-files-to-memcontrol-v1c.patch
mm-memcg-make-memcg1_update_tree-static.patch
mm-memcg-group-cgroup-v1-memcg-related-declarations.patch
mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option.patch
mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option-fix.patch
maintainers-add-mm-memcontrol-v1c-h-to-the-list-of-maintained-files.patch
mm-memcg-move-memcg_account_kmem-to-memcontrol-v1c.patch
mm-memcg-factor-out-legacy-socket-memory-accounting-code.patch
mm-memcg-guard-cgroup-v1-specific-code-in-mem_cgroup_print_oom_meminfo.patch
mm-memcg-gather-memcg1-specific-fields-initialization-in-memcg1_memcg_init.patch
mm-memcg-guard-memcg1-specific-fields-accesses-in-mm-memcontrolc.patch
mm-memcg-put-memcg1-specific-struct-mem_cgroups-members-under-config_memcg_v1.patch
mm-memcg-guard-memcg1-specific-members-of-struct-mem_cgroup_per_node.patch
mm-memcg-put-struct-task_struct-memcg_in_oom-under-config_memcg_v1.patch
mm-memcg-put-struct-task_struct-in_user_fault-under-config_memcg_v1.patch
mm-memcg-drop-obsolete-cache-line-padding-in-struct-mem_cgroup.patch
mm-memcg-add-cache-line-padding-to-mem_cgroup_per_node.patch

