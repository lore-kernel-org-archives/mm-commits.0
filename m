From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 073/155] mm/memcontrol.c: make
 mem_cgroup_id_get_many() __maybe_unused
Date: Wed, 01 Apr 2020 21:07:13 -0700
Message-ID: <20200402040713.Uh_yvY9Nb%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727746AbgDBEHR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:07:17 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chris@chrisdown.name, hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, vdavydov.dev@gmail.com, vincenzo.frascino@arm.com

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
