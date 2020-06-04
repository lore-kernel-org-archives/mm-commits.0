From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 056/127] mm/vmsan: fix some typos in comment
Date: Thu, 04 Jun 2020 16:49:10 -0700
Message-ID: <20200604234910.y7FyXNsM4%akpm@linux-foundation.org>
References: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgFDXtL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:49:11 -0400
In-Reply-To: <20200604164523.e15f3177f4b69dcb4f2534a1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ethp@qq.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, rcampbell@nvidia.com, torvalds@linux-foundation.org

From: Ethon Paul <ethp@qq.com>
Subject: mm/vmsan: fix some typos in comment

There are some typos, fix them.

s/regsitration/registration
s/santity/sanity
s/decremeting/decrementing

Link: http://lkml.kernel.org/r/20200411071544.16222-1-ethp@qq.com
Signed-off-by: Ethon Paul <ethp@qq.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-vmsan-fix-some-typos-in-comment
+++ a/mm/vmscan.c
@@ -682,7 +682,7 @@ static unsigned long shrink_slab(gfp_t g
 		freed += ret;
 		/*
 		 * Bail out if someone want to register a new shrinker to
-		 * prevent the regsitration from being stalled for long periods
+		 * prevent the registration from being stalled for long periods
 		 * by parallel ongoing shrinking.
 		 */
 		if (rwsem_is_contended(&shrinker_rwsem)) {
@@ -1613,7 +1613,7 @@ int __isolate_lru_page(struct page *page
 
 /*
  * Update LRU sizes after isolating pages. The LRU size updates must
- * be complete before mem_cgroup_update_lru_size due to a santity check.
+ * be complete before mem_cgroup_update_lru_size due to a sanity check.
  */
 static __always_inline void update_lru_sizes(struct lruvec *lruvec,
 			enum lru_list lru, unsigned long *nr_zone_taken)
@@ -2371,7 +2371,7 @@ out:
 
 			/*
 			 * Minimally target SWAP_CLUSTER_MAX pages to keep
-			 * reclaim moving forwards, avoiding decremeting
+			 * reclaim moving forwards, avoiding decrementing
 			 * sc->priority further than desirable.
 			 */
 			scan = max(scan, SWAP_CLUSTER_MAX);
_
