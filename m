From: akpm@linux-foundation.org
Subject: + memcg-simplify-and-inline-__mem_cgroup_from_kmem.patch added to -mm tree
Date: Thu, 08 Oct 2015 15:30:27 -0700
Message-ID: <5616ee83.p8LT1fGfgzGy3uog%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36343 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756609AbbJHWa3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Oct 2015 18:30:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: simplify and inline __mem_cgroup_from_kmem
has been added to the -mm tree.  Its filename is
     memcg-simplify-and-inline-__mem_cgroup_from_kmem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-simplify-and-inline-__mem_cgroup_from_kmem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-simplify-and-inline-__mem_cgroup_from_kmem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: memcg: simplify and inline __mem_cgroup_from_kmem

Before the previous patch ("memcg: unify slab and other kmem pages
charging"), __mem_cgroup_from_kmem had to handle two types of kmem - slab
pages and pages allocated with alloc_kmem_pages - memcg in the page
struct.  Now we can unify it.  Since after it, this function becomes tiny
we can fold it into mem_cgroup_from_kmem.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    7 ++++---
 mm/memcontrol.c            |   18 ------------------
 2 files changed, 4 insertions(+), 21 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-simplify-and-inline-__mem_cgroup_from_kmem include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-simplify-and-inline-__mem_cgroup_from_kmem
+++ a/include/linux/memcontrol.h
@@ -767,8 +767,6 @@ static inline int memcg_cache_id(struct
 struct kmem_cache *__memcg_kmem_get_cache(struct kmem_cache *cachep);
 void __memcg_kmem_put_cache(struct kmem_cache *cachep);
 
-struct mem_cgroup *__mem_cgroup_from_kmem(void *ptr);
-
 static inline bool __memcg_kmem_bypass(gfp_t gfp)
 {
 	if (!memcg_kmem_enabled())
@@ -830,9 +828,12 @@ static __always_inline void memcg_kmem_p
 
 static __always_inline struct mem_cgroup *mem_cgroup_from_kmem(void *ptr)
 {
+	struct page *page;
+
 	if (!memcg_kmem_enabled())
 		return NULL;
-	return __mem_cgroup_from_kmem(ptr);
+	page = virt_to_head_page(ptr);
+	return page->mem_cgroup;
 }
 #else
 #define for_each_memcg_cache_index(_idx)	\
diff -puN mm/memcontrol.c~memcg-simplify-and-inline-__mem_cgroup_from_kmem mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-simplify-and-inline-__mem_cgroup_from_kmem
+++ a/mm/memcontrol.c
@@ -2430,24 +2430,6 @@ void __memcg_kmem_uncharge(struct page *
 	page->mem_cgroup = NULL;
 	css_put_many(&memcg->css, nr_pages);
 }
-
-struct mem_cgroup *__mem_cgroup_from_kmem(void *ptr)
-{
-	struct mem_cgroup *memcg = NULL;
-	struct kmem_cache *cachep;
-	struct page *page;
-
-	page = virt_to_head_page(ptr);
-	if (PageSlab(page)) {
-		cachep = page->slab_cache;
-		if (!is_root_cache(cachep))
-			memcg = cachep->memcg_params.memcg;
-	} else
-		/* page allocated by alloc_kmem_pages */
-		memcg = page->mem_cgroup;
