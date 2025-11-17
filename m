Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC9625333F
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 18:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763402860; cv=none; b=itkZAQVU0qeVMRrajIFTu4uCQ15NIHXeRnI0y5mwXxyBDR3eXW3hPC0SvaC/0Q5Vg5ZJpwU+19ovFNHy6weElg/k8+wsTfnL9K5AekEP/cxsXmZQ28p9TVcj+vUYLvcBmnnudSC11tTG9Mgw4ISrUOWoz1oTZqn8G3THGdCCMq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763402860; c=relaxed/simple;
	bh=qCn27xo0y5RwDVIAbeZzTOHRoNGcuNvKuqG0m3fvtvY=;
	h=Date:To:From:Subject:Message-Id; b=Y8PCkYfLJc1G9TuZMGGSVeEtKk/H1eT7t4WErU/U753ijjyqODhKVsnGOJf9Pp9Cn1b9nJD5/b4Syr5ren7HvFVRuU6AtP3nNRnIHAfGFeoJcpSkEaSvt+Q6p3B7NTJMhw2uVzDJ3TJtMSIgv9i8tWrB4IIAeL46yU0tDJXC/jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b0YnW/wv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b0YnW/wv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D049C19424;
	Mon, 17 Nov 2025 18:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763402859;
	bh=qCn27xo0y5RwDVIAbeZzTOHRoNGcuNvKuqG0m3fvtvY=;
	h=Date:To:From:Subject:From;
	b=b0YnW/wvYDs/EjvY0CGDKsGdkwvgLyZvpbSvutOvMCcwUus+hT6pYLKSXMHFahZbJ
	 9tPr6yNOx+y+vEvpzmOMAORx+wynkbEoEhptozfxlpp45Kdq4L9PshQCic5pTbWsx6
	 GMNSRR65hMc6Se4k7R/QSPmVCm3sxULnE0uEwIMk=
Date: Mon, 17 Nov 2025 10:07:38 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,vbabka@suse.cz,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,harry.yoo@oracle.com,hannes@cmpxchg.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-remove-__mod_lruvec_kmem_state.patch added to mm-new branch
Message-Id: <20251117180739.8D049C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: remove __mod_lruvec_kmem_state
has been added to the -mm mm-new branch.  Its filename is
     memcg-remove-__mod_lruvec_kmem_state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-remove-__mod_lruvec_kmem_state.patch

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

mm-memcg-dump-memcg-protection-info-on-oom-or-alloc-failures.patch
memcg-use-mod_node_page_state-to-update-stats.patch
memcg-remove-__mod_lruvec_kmem_state.patch
memcg-remove-__mod_lruvec_state.patch
memcg-remove-__lruvec_stat_mod_folio.patch

