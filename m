From: akpm@linux-foundation.org
Subject: [merged] mm-vmpressure-use-mem_cgroup_is_root-api.patch
 removed from -mm tree
Date: Fri, 03 Apr 2020 13:39:46 -0700
Message-ID: <20200403203946.hmA1KCNA8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbgDCUjr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:39:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org, rientjes@google.com, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm: vmpressure: use mem_cgroup_is_root API
has been removed from the -mm tree.  Its filename was
     mm-vmpressure-use-mem_cgroup_is_root-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm: vmpressure: use mem_cgroup_is_root API

Use mem_cgroup_is_root() API to check if memcg is root memcg instead of
open coding.

Link: http://lkml.kernel.org/r/1581398649-125989-2-git-send-email-yang.shi@linux.alibaba.com
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmpressure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmpressure.c~mm-vmpressure-use-mem_cgroup_is_root-api
+++ a/mm/vmpressure.c
@@ -280,7 +280,7 @@ void vmpressure(gfp_t gfp, struct mem_cg
 		enum vmpressure_levels level;
 
 		/* For now, no users for root-level efficiency */
-		if (!memcg || memcg == root_mem_cgroup)
+		if (!memcg || mem_cgroup_is_root(memcg))
 			return;
 
 		spin_lock(&vmpr->sr_lock);
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are

mm-migratec-migrate-pg_readahead-flag.patch
