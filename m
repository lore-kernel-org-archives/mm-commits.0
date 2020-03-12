From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-memcg-prevent-mem_cgroup_protected-store-tearing.patch added to -mm tree
Date: Thu, 12 Mar 2020 15:45:13 -0700
Message-ID: <20200312224513.M5Xfwab9e%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726608AbgCLWpO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Mar 2020 18:45:14 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org, tj@kernel.org


The patch titled
     Subject: mm, memcg: prevent mem_cgroup_protected store tearing
has been added to the -mm tree.  Its filename is
     mm-memcg-prevent-mem_cgroup_protected-store-tearing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-prevent-mem_cgroup_protected-store-tearing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-prevent-mem_cgroup_protected-store-tearing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chris Down <chris@chrisdown.name>
Subject: mm, memcg: prevent mem_cgroup_protected store tearing

The read side of this is all protected, but we can still tear if multiple
iterations of mem_cgroup_protected are going at the same time.

There's some intentional racing in mem_cgroup_protected which is ok, but
load/store tearing should be avoided.

Link: http://lkml.kernel.org/r/d1e9fbc0379fe8db475d82c8b6fbe048876e12ae.1584034301.git.chris@chrisdown.name
Signed-off-by: Chris Down <chris@chrisdown.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-prevent-mem_cgroup_protected-store-tearing
+++ a/mm/memcontrol.c
@@ -6397,14 +6397,14 @@ enum mem_cgroup_protection mem_cgroup_pr
 
 	parent_usage = page_counter_read(&parent->memory);
 
-	memcg->memory.emin = effective_protection(usage, parent_usage,
+	WRITE_ONCE(memcg->memory.emin, effective_protection(usage, parent_usage,
 			READ_ONCE(memcg->memory.min),
 			READ_ONCE(parent->memory.emin),
-			atomic_long_read(&parent->memory.children_min_usage));
+			atomic_long_read(&parent->memory.children_min_usage)));
 
-	memcg->memory.elow = effective_protection(usage, parent_usage,
+	WRITE_ONCE(memcg->memory.elow, effective_protection(usage, parent_usage,
 			memcg->memory.low, READ_ONCE(parent->memory.elow),
-			atomic_long_read(&parent->memory.children_low_usage));
+			atomic_long_read(&parent->memory.children_low_usage)));
 
 out:
 	if (usage <= memcg->memory.emin)
_

Patches currently in -mm which might be from chris@chrisdown.name are

mm-memcg-fix-corruption-on-64-bit-divisor-in-memoryhigh-throttling.patch
mm-memcg-throttle-allocators-based-on-ancestral-memoryhigh.patch
mm-memcg-prevent-memoryhigh-load-store-tearing.patch
mm-memcg-prevent-memorymax-load-tearing.patch
mm-memcg-prevent-memorylow-load-store-tearing.patch
mm-memcg-prevent-memorymin-load-store-tearing.patch
mm-memcg-prevent-memoryswapmax-load-tearing.patch
mm-memcg-prevent-mem_cgroup_protected-store-tearing.patch
