From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 21/32] mm/memcontrol.c: add missed css_put()
Date: Thu, 25 Jun 2020 20:30:19 -0700
Message-ID: <20200626033019.-e_OxsAHA%akpm@linux-foundation.org>
References: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728333AbgFZDaU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Jun 2020 23:30:20 -0400
In-Reply-To: <20200625202807.b630829d6fa55388148bee7d@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cai@lca.pw, guro@fb.com, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org, songmuchun@bytedance.com, stable@vger.kernel.org, torvalds@linux-foundation.org, vdavydov.dev@gmail.com

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/memcontrol.c: add missed css_put()

We should put the css reference when memory allocation failed.

Link: http://lkml.kernel.org/r/20200614122653.98829-1-songmuchun@bytedance.com
Fixes: f0a3a24b532d ("mm: memcg/slab: rework non-root kmem_cache lifecycle management")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Qian Cai <cai@lca.pw>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-fix-do-not-put-the-css-reference
+++ a/mm/memcontrol.c
@@ -2772,8 +2772,10 @@ static void memcg_schedule_kmem_cache_cr
 		return;
 
 	cw = kmalloc(sizeof(*cw), GFP_NOWAIT | __GFP_NOWARN);
-	if (!cw)
+	if (!cw) {
+		css_put(&memcg->css);
 		return;
+	}
 
 	cw->memcg = memcg;
 	cw->cachep = cachep;
_
