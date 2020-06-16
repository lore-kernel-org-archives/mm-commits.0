From: akpm@linux-foundation.org
Subject: + mm-memcontrol-fix-do-not-put-the-css-reference.patch
 added to -mm tree
Date: Tue, 16 Jun 2020 12:57:13 -0700
Message-ID: <20200616195713.UahlG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730183AbgFPT5O (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Jun 2020 15:57:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vdavydov.dev@gmail.com, stable@vger.kernel.org, mhocko@suse.com, hannes@cmpxchg.org, guro@fb.com, cai@lca.pw, songmuchun@bytedance.com


The patch titled
     Subject: mm/memcontrol.c: add missed css_put()
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fix-do-not-put-the-css-reference.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fix-do-not-put-the-css-reference.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fix-do-not-put-the-css-reference.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-fix-do-not-put-the-css-reference.patch
