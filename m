From: akpm@linux-foundation.org
Subject: [merged]
 mm-make-mem_cgroup_id_get_many-__maybe_unused.patch removed from -mm tree
Date: Fri, 03 Apr 2020 13:37:51 -0700
Message-ID: <20200403203751.wkSZo9iue%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727879AbgDCUhw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:37:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chris@chrisdown.name, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org, vdavydov.dev@gmail.com, vincenzo.frascino@arm.com


The patch titled
     Subject: mm/memcontrol.c: make mem_cgroup_id_get_many() __maybe_unused
has been removed from the -mm tree.  Its filename was
     mm-make-mem_cgroup_id_get_many-__maybe_unused.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: mm/memcontrol.c: make mem_cgroup_id_get_many() __maybe_unused

mem_cgroup_id_get_many() is currently used only when MMU or MEMCG_SWAP
configuration options are enabled.  Having them disabled triggers the
following warning at compile time:

linux/mm/memcontrol.c:4797:13: warning: `mem_cgroup_id_get_many' defined
but not used [-Wunused-function]
 static void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned
 int n)

Make mem_cgroup_id_get_many() __maybe_unused to address the issue.

Link: http://lkml.kernel.org/r/20200305164354.48147-1-vincenzo.frascino@arm.com
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Chris Down <chris@chrisdown.name>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-make-mem_cgroup_id_get_many-__maybe_unused
+++ a/mm/memcontrol.c
@@ -4863,7 +4863,8 @@ static void mem_cgroup_id_remove(struct
 	}
 }
 
-static void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n)
+static void __maybe_unused mem_cgroup_id_get_many(struct mem_cgroup *memcg,
+						  unsigned int n)
 {
 	refcount_add(n, &memcg->id.ref);
 }
_

Patches currently in -mm which might be from vincenzo.frascino@arm.com are
