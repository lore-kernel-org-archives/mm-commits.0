Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92472F7AAC
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025855; cv=none; b=qAXJ+t/RNj17RtvMvJCkCoJAbN395YpUf/T6fTADtncF2HpttuH6Gw4yyzuXou0+dPBb18JDpLbrxcga/EuIXgXFGVF+1gKJzUwoxiAjNSeg+/BVo90S5YTpz+ddc81LrwdzXM48ZTNw3lgUX2gYP/qv+DttlNkbupFb6YYyGEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025855; c=relaxed/simple;
	bh=9EDFKHCVApOtcaNMQdD12rViAJpct2XqTBdusmsNBQw=;
	h=Date:To:From:Subject:Message-Id; b=IdcCdsizvn2iurV+NVRo6O2sSC0k0Ym4oSIrGCjebZ934eSRSNZXg9MJ06L01fefL0kJWJR6F0JFKMKs9q5uLVik4ncFPGXCaZ7Pj4aRksIlxXLcRc6oaYy/q8Z71/ZjGpa1O78SXOU0VrMFxyqGXbopNw7npJNhVa4K2uZ9eNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i3xOKI7+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i3xOKI7+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAEE6C4CEF1;
	Mon, 24 Nov 2025 23:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025855;
	bh=9EDFKHCVApOtcaNMQdD12rViAJpct2XqTBdusmsNBQw=;
	h=Date:To:From:Subject:From;
	b=i3xOKI7+b0wwhoIZ+83SiTaKYKLErCs3da/+Ww8Yx3Sb91u9DwrCPeYO9gLOWCWIK
	 YzTrVAyyaJQDIuZJCSiWeQIMKylssPg0QBVfCr+RPdvVwBBtYQUji1DmaSnCHDmzhZ
	 meE0tZMtyz197bc2fX+7gEg+ceCAPBlT5bEZKxFk=
Date: Mon, 24 Nov 2025 15:10:55 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,harry.yoo@oracle.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-remove-__mod_lruvec_kmem_state.patch removed from -mm tree
Message-Id: <20251124231055.AAEE6C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: remove __mod_lruvec_kmem_state
has been removed from the -mm tree.  Its filename was
     memcg-remove-__mod_lruvec_kmem_state.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: remove __mod_lruvec_kmem_state
Date: Mon, 10 Nov 2025 15:20:06 -0800

__mod_lruvec_kmem_state() is already safe against irqs, so there is no
need to have a separate interface (i.e.  mod_lruvec_kmem_state) which
wraps calls to it with irq disabling and reenabling.  Let's rename
__mod_lruvec_kmem_state() to mod_lruvec_kmem_state().

Link: https://lkml.kernel.org/r/20251110232008.1352063-3-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   28 +++++-----------------------
 mm/memcontrol.c            |    2 +-
 mm/workingset.c            |    2 +-
 3 files changed, 7 insertions(+), 25 deletions(-)

--- a/include/linux/memcontrol.h~memcg-remove-__mod_lruvec_kmem_state
+++ a/include/linux/memcontrol.h
@@ -957,17 +957,7 @@ unsigned long lruvec_page_state_local(st
 void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
 void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg);
 
-void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val);
-
-static inline void mod_lruvec_kmem_state(void *p, enum node_stat_item idx,
-					 int val)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__mod_lruvec_kmem_state(p, idx, val);
-	local_irq_restore(flags);
-}
+void mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val);
 
 void count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
 			unsigned long count);
@@ -1403,14 +1393,6 @@ static inline void mem_cgroup_flush_stat
 {
 }
 
-static inline void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx,
-					   int val)
-{
-	struct page *page = virt_to_head_page(p);
-
-	mod_node_page_state(page_pgdat(page), idx, val);
-}
-
 static inline void mod_lruvec_kmem_state(void *p, enum node_stat_item idx,
 					 int val)
 {
@@ -1470,14 +1452,14 @@ struct slabobj_ext {
 #endif
 } __aligned(8);
 
-static inline void __inc_lruvec_kmem_state(void *p, enum node_stat_item idx)
+static inline void inc_lruvec_kmem_state(void *p, enum node_stat_item idx)
 {
-	__mod_lruvec_kmem_state(p, idx, 1);
+	mod_lruvec_kmem_state(p, idx, 1);
 }
 
-static inline void __dec_lruvec_kmem_state(void *p, enum node_stat_item idx)
+static inline void dec_lruvec_kmem_state(void *p, enum node_stat_item idx)
 {
-	__mod_lruvec_kmem_state(p, idx, -1);
+	mod_lruvec_kmem_state(p, idx, -1);
 }
 
 static inline struct lruvec *parent_lruvec(struct lruvec *lruvec)
--- a/mm/memcontrol.c~memcg-remove-__mod_lruvec_kmem_state
+++ a/mm/memcontrol.c
@@ -799,7 +799,7 @@ void __lruvec_stat_mod_folio(struct foli
 }
 EXPORT_SYMBOL(__lruvec_stat_mod_folio);
 
-void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
+void mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
 {
 	pg_data_t *pgdat = page_pgdat(virt_to_page(p));
 	struct mem_cgroup *memcg;
--- a/mm/workingset.c~memcg-remove-__mod_lruvec_kmem_state
+++ a/mm/workingset.c
@@ -749,7 +749,7 @@ static enum lru_status shadow_lru_isolat
 	if (WARN_ON_ONCE(node->count != node->nr_values))
 		goto out_invalid;
 	xa_delete_node(node, workingset_update_node);
-	__inc_lruvec_kmem_state(node, WORKINGSET_NODERECLAIM);
+	inc_lruvec_kmem_state(node, WORKINGSET_NODERECLAIM);
 
 out_invalid:
 	xa_unlock_irq(&mapping->i_pages);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


