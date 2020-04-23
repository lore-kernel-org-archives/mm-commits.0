From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged]
 memcg-optimize-memorynuma_stat-like-memorystat-fix.patch removed from -mm
 tree
Date: Thu, 23 Apr 2020 16:09:06 -0700
Message-ID: <20200423230906.J31-SA-IQ%akpm@linux-foundation.org>
References: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729041AbgDWXJI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Apr 2020 19:09:08 -0400
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com


The patch titled
     Subject: memcg-optimize-memorynuma_stat-like-memorystat-fix
has been removed from the -mm tree.  Its filename was
     memcg-optimize-memorynuma_stat-like-memorystat-fix.patch

This patch was dropped because it was folded into memcg-optimize-memorynuma_stat-like-memorystat.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-optimize-memorynuma_stat-like-memorystat-fix

avoid forcing out-of-line code generation

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/mm/memcontrol.c~memcg-optimize-memorynuma_stat-like-memorystat-fix
+++ a/mm/memcontrol.c
@@ -3693,17 +3693,16 @@ static unsigned long mem_cgroup_node_nr_
 	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 	unsigned long nr = 0;
 	enum lru_list lru;
-	unsigned long (*page_state)(struct lruvec *lruvec,
-				    enum node_stat_item idx);
 
 	VM_BUG_ON((unsigned)nid >= nr_node_ids);
 
-	page_state = tree ? lruvec_page_state : lruvec_page_state_local;
-
 	for_each_lru(lru) {
 		if (!(BIT(lru) & lru_mask))
 			continue;
-		nr += page_state(lruvec, NR_LRU_BASE + lru);
+		if (tree)
+			nr += lruvec_page_state(lruvec, NR_LRU_BASE + lru);
+		else
+			nr += lruvec_page_state_local(lruvec, NR_LRU_BASE + lru);
 	}
 	return nr;
 }
@@ -3714,14 +3713,14 @@ static unsigned long mem_cgroup_nr_lru_p
 {
 	unsigned long nr = 0;
 	enum lru_list lru;
-	unsigned long (*page_state)(struct mem_cgroup *memcg, int idx);
-
-	page_state = tree ? memcg_page_state : memcg_page_state_local;
 
 	for_each_lru(lru) {
 		if (!(BIT(lru) & lru_mask))
 			continue;
-		nr += page_state(memcg, NR_LRU_BASE + lru);
+		if (tree)
+			nr += memcg_page_state(memcg, NR_LRU_BASE + lru);
+		else
+			nr += memcg_page_state_local(memcg, NR_LRU_BASE + lru);
 	}
 	return nr;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc-fix.patch
squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
memcg-optimize-memorynuma_stat-like-memorystat.patch
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
initrdmem=-option-to-specify-initrd-physical-address-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
