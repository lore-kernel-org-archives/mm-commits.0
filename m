From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 04/10] mm, memcg: fix corruption on 64-bit divisor
 in memory.high throttling
Date: Sat, 21 Mar 2020 18:22:20 -0700
Message-ID: <20200322012220.Y-EvF7Agt%akpm@linux-foundation.org>
References: <20200321181954.c0564dfd5514cd742b534884@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726859AbgCVBWV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 21 Mar 2020 21:22:21 -0400
In-Reply-To: <20200321181954.c0564dfd5514cd742b534884@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org, natechancellor@gmail.com, stable@vger.kernel.org, tj@kernel.org, torvalds@linux-foundation.org

From: Chris Down <chris@chrisdown.name>
Subject: mm, memcg: fix corruption on 64-bit divisor in memory.high throttling

0e4b01df8659 had a bunch of fixups to use the right division method. 
However, it seems that after all that it still wasn't right -- div_u64
takes a 32-bit divisor.

The headroom is still large (2^32 pages), so on mundane systems you won't
hit this, but this should definitely be fixed.

Link: http://lkml.kernel.org/r/80780887060514967d414b3cd91f9a316a16ab98.1584036142.git.chris@chrisdown.name
Fixes: 0e4b01df8659 ("mm, memcg: throttle allocators when failing reclaim over memory.high")
Signed-off-by: Chris Down <chris@chrisdown.name>
Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: <stable@vger.kernel.org>	[5.4.x+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-fix-corruption-on-64-bit-divisor-in-memoryhigh-throttling
+++ a/mm/memcontrol.c
@@ -2339,7 +2339,7 @@ void mem_cgroup_handle_over_high(void)
 	 */
 	clamped_high = max(high, 1UL);
 
-	overage = div_u64((u64)(usage - high) << MEMCG_DELAY_PRECISION_SHIFT,
+	overage = div64_u64((u64)(usage - high) << MEMCG_DELAY_PRECISION_SHIFT,
 			  clamped_high);
 
 	penalty_jiffies = ((u64)overage * overage * HZ)
_
