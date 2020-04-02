From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 120/155] mm: vmpressure: use mem_cgroup_is_root
 API
Date: Wed, 01 Apr 2020 21:10:02 -0700
Message-ID: <20200402041002.qYammk-U7%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgDBEKD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:10:03 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, rientjes@google.com, torvalds@linux-foundation.org, yang.shi@linux.alibaba.com

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
