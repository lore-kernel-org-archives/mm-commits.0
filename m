From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 02/15] mm, memcg: fix error return value of
 mem_cgroup_css_alloc()
Date: Thu, 07 May 2020 18:35:43 -0700
Message-ID: <20200508013543.BrvifuQWp%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbgEHBfo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 May 2020 21:35:44 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, laoar.shao@gmail.com, linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, vdavydov.dev@gmail.com, willy@infradead.org

From: Yafang Shao <laoar.shao@gmail.com>
Subject: mm, memcg: fix error return value of mem_cgroup_css_alloc()

When I run my memcg testcase which creates lots of memcgs, I found
there're unexpected out of memory logs while there're still enough
available free memory.  The error log is, mkdir: cannot create directory
'foo.65533': Cannot allocate memory

The reason is when we try to create more than MEM_CGROUP_ID_MAX memcgs, an
-ENOMEM errno will be set by mem_cgroup_css_alloc(), but the right errno
should be -ENOSPC "No space left on device", which is an appropriate errno
for userspace's failed mkdir.

As the errno really misled me, we should make it right.  After this patch,
the error log will be "mkdir: cannot create directory 'foo.65533': No
space left on device"

[akpm@linux-foundation.org: s/EBUSY/ENOSPC/, per Michal]
[akpm@linux-foundation.org: s/EBUSY/ENOSPC/, per Michal]
Link: http://lkml.kernel.org/r/20200407063621.GA18914@dhcp22.suse.cz
Link: http://lkml.kernel.org/r/1586192163-20099-1-git-send-email-laoar.shao@gmail.com
Fixes: 73f576c04b94 ("mm: memcontrol: fix cgroup creation failure after many small jobs")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Acked-by: Michal Hocko <mhocko@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc
+++ a/mm/memcontrol.c
@@ -4990,19 +4990,22 @@ static struct mem_cgroup *mem_cgroup_all
 	unsigned int size;
 	int node;
 	int __maybe_unused i;
+	long error = -ENOMEM;
 
 	size = sizeof(struct mem_cgroup);
 	size += nr_node_ids * sizeof(struct mem_cgroup_per_node *);
 
 	memcg = kzalloc(size, GFP_KERNEL);
 	if (!memcg)
-		return NULL;
+		return ERR_PTR(error);
 
 	memcg->id.id = idr_alloc(&mem_cgroup_idr, NULL,
 				 1, MEM_CGROUP_ID_MAX,
 				 GFP_KERNEL);
-	if (memcg->id.id < 0)
+	if (memcg->id.id < 0) {
+		error = memcg->id.id;
 		goto fail;
+	}
 
 	memcg->vmstats_local = alloc_percpu(struct memcg_vmstats_percpu);
 	if (!memcg->vmstats_local)
@@ -5046,7 +5049,7 @@ static struct mem_cgroup *mem_cgroup_all
 fail:
 	mem_cgroup_id_remove(memcg);
 	__mem_cgroup_free(memcg);
-	return NULL;
+	return ERR_PTR(error);
 }
 
 static struct cgroup_subsys_state * __ref
@@ -5057,8 +5060,8 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 	long error = -ENOMEM;
 
 	memcg = mem_cgroup_alloc();
-	if (!memcg)
-		return ERR_PTR(error);
+	if (IS_ERR(memcg))
+		return ERR_CAST(memcg);
 
 	WRITE_ONCE(memcg->high, PAGE_COUNTER_MAX);
 	memcg->soft_limit = PAGE_COUNTER_MAX;
@@ -5108,7 +5111,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 fail:
 	mem_cgroup_id_remove(memcg);
 	mem_cgroup_free(memcg);
-	return ERR_PTR(-ENOMEM);
+	return ERR_PTR(error);
 }
 
 static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
_
