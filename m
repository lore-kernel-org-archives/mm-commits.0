From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrol-export-root_mem_cgroup.patch removed from
 -mm tree
Date: Fri, 15 Jan 2016 14:34:24 -0800
Message-ID: <569973f0.o2GB207UTbq9Jyc1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59576 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbcAOWeZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:34:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, davem@davemloft.net, mhocko@suse.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: export root_mem_cgroup
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-export-root_mem_cgroup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: export root_mem_cgroup

A later patch will need this symbol in files other than memcontrol.c, so
export it now and replace mem_cgroup_root_css at the same time.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: David S. Miller <davem@davemloft.net>
Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    3 ++-
 mm/backing-dev.c           |    2 +-
 mm/memcontrol.c            |    5 ++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/memcontrol.h~mm-memcontrol-export-root_mem_cgroup include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcontrol-export-root_mem_cgroup
+++ a/include/linux/memcontrol.h
@@ -265,7 +265,8 @@ struct mem_cgroup {
 	struct mem_cgroup_per_node *nodeinfo[0];
 	/* WARNING: nodeinfo must be the last member here */
 };
-extern struct cgroup_subsys_state *mem_cgroup_root_css;
+
+extern struct mem_cgroup *root_mem_cgroup;
 
 /**
  * mem_cgroup_events - count memory events against a cgroup
diff -puN mm/backing-dev.c~mm-memcontrol-export-root_mem_cgroup mm/backing-dev.c
--- a/mm/backing-dev.c~mm-memcontrol-export-root_mem_cgroup
+++ a/mm/backing-dev.c
@@ -672,7 +672,7 @@ static int cgwb_bdi_init(struct backing_
 
 	ret = wb_init(&bdi->wb, bdi, 1, GFP_KERNEL);
 	if (!ret) {
-		bdi->wb.memcg_css = mem_cgroup_root_css;
+		bdi->wb.memcg_css = &root_mem_cgroup->css;
 		bdi->wb.blkcg_css = blkcg_root_css;
 	}
 	return ret;
diff -puN mm/memcontrol.c~mm-memcontrol-export-root_mem_cgroup mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-export-root_mem_cgroup
+++ a/mm/memcontrol.c
@@ -76,9 +76,9 @@
 struct cgroup_subsys memory_cgrp_subsys __read_mostly;
 EXPORT_SYMBOL(memory_cgrp_subsys);
 
+struct mem_cgroup *root_mem_cgroup __read_mostly;
+
 #define MEM_CGROUP_RECLAIM_RETRIES	5
-static struct mem_cgroup *root_mem_cgroup __read_mostly;
-struct cgroup_subsys_state *mem_cgroup_root_css __read_mostly;
 
 /* Whether the swap controller is active */
 #ifdef CONFIG_MEMCG_SWAP
@@ -4241,7 +4241,6 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 	/* root ? */
 	if (parent_css == NULL) {
 		root_mem_cgroup = memcg;
-		mem_cgroup_root_css = &memcg->css;
 		page_counter_init(&memcg->memory, NULL);
 		memcg->high = PAGE_COUNTER_MAX;
 		memcg->soft_limit = PAGE_COUNTER_MAX;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-memcontrol-switch-to-the-updated-jump-label-api.patch
mm-oom_killc-dont-skip-pf_exiting-tasks-when-searching-for-a-victim.patch
mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem.patch
mm-memcontrol-remove-double-kmem-page_counter-init.patch
mm-memcontrol-give-the-kmem-states-more-descriptive-names.patch
mm-memcontrol-group-kmem-init-and-exit-functions-together.patch
mm-memcontrol-separate-kmem-code-from-legacy-tcp-accounting-code.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg-v2.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg-fix.patch
mm-memcontrol-account-kmem-consumers-in-cgroup2-memory-controller.patch
mm-memcontrol-introduce-config_memcg_legacy_kmem.patch
mm-memcontrol-reign-in-the-config-space-madness.patch
mm-memcontrol-flatten-struct-cg_proto.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions.patch
mm-memcontrol-clean-up-alloc-online-offline-free-functions-fix.patch
mm-memcontrol-do-not-uncharge-old-page-in-page-cache-replacement.patch
mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller.patch
mm-memcontrol-basic-memory-statistics-in-cgroup2-memory-controller-fix.patch
mm-memcontrol-add-sock-to-cgroup2-memorystat.patch

