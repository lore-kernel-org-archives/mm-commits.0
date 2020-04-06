From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc.patch added to -mm
 tree
Date: Mon, 06 Apr 2020 16:22:57 -0700
Message-ID: <20200406232257.ZtqdEjB-K%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726246AbgDFXW6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 19:22:58 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, laoar.shao@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org, vdavydov.dev@gmail.com, willy@infradead.org


The patch titled
     Subject: mm, memcg: fix error return value of mem_cgroup_css_alloc()
has been added to the -mm tree.  Its filename is
     mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yafang Shao <laoar.shao@gmail.com>
Subject: mm, memcg: fix error return value of mem_cgroup_css_alloc()

When I run my memcg testcase which creates lots of memcgs, I found
there're unexpected out of memory logs while there're still enough
available free memory.  The error log is, mkdir: cannot create directory
'foo.65533': Cannot allocate memory

The reason is when we try to create more than MEM_CGROUP_ID_MAX memcgs, an
-ENOMEM errno will be set by mem_cgroup_css_alloc(), but the right errno
should be -EBUSY "Device or resource busy".  That is same with
memcg_alloc_cache_id().

As the errno really misled me, we should make it right.  After this patch,
the error log will be, mkdir: cannot create directory 'foo.65533': Device
or resource busy

Link: http://lkml.kernel.org/r/1586192163-20099-1-git-send-email-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc
+++ a/mm/memcontrol.c
@@ -2720,6 +2720,8 @@ static int memcg_alloc_cache_id(void)
 
 	id = ida_simple_get(&memcg_cache_ida,
 			    0, MEMCG_CACHES_MAX_SIZE, GFP_KERNEL);
+	if (id == -ENOSPC)
+		return -EBUSY;
 	if (id < 0)
 		return id;
 
@@ -4989,19 +4991,26 @@ static struct mem_cgroup *mem_cgroup_all
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
+	if (memcg->id.id == -ENOSPC) {
+		error = -EBUSY;
+		goto fail;
+	}
+	if (memcg->id.id < 0) {
+		error = memcg->id.id;
 		goto fail;
+	}
 
 	memcg->vmstats_local = alloc_percpu(struct memcg_vmstats_percpu);
 	if (!memcg->vmstats_local)
@@ -5045,7 +5054,7 @@ static struct mem_cgroup *mem_cgroup_all
 fail:
 	mem_cgroup_id_remove(memcg);
 	__mem_cgroup_free(memcg);
-	return NULL;
+	return ERR_PTR(error);
 }
 
 static struct cgroup_subsys_state * __ref
@@ -5056,8 +5065,8 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 	long error = -ENOMEM;
 
 	memcg = mem_cgroup_alloc();
-	if (!memcg)
-		return ERR_PTR(error);
+	if (IS_ERR(memcg))
+		return ERR_CAST(memcg);
 
 	WRITE_ONCE(memcg->high, PAGE_COUNTER_MAX);
 	memcg->soft_limit = PAGE_COUNTER_MAX;
@@ -5107,7 +5116,7 @@ mem_cgroup_css_alloc(struct cgroup_subsy
 fail:
 	mem_cgroup_id_remove(memcg);
 	mem_cgroup_free(memcg);
-	return ERR_PTR(-ENOMEM);
+	return ERR_PTR(error);
 }
 
 static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
_

Patches currently in -mm which might be from laoar.shao@gmail.com are

mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc.patch
