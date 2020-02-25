From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-kmem-cleanup-__memcg_kmem_charge_memcg-arguments.patch added to -mm tree
Date: Mon, 24 Feb 2020 16:47:58 -0800
Message-ID: <20200225004758.j0YZQ18o8%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727976AbgBYAsA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Feb 2020 19:48:00 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com, vdavydov.dev@gmail.com


The patch titled
     Subject: mm: kmem: cleanup (__)memcg_kmem_charge_memcg() arguments
has been added to the -mm tree.  Its filename is
     mm-kmem-cleanup-__memcg_kmem_charge_memcg-arguments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kmem-cleanup-__memcg_kmem_charge_memcg-arguments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kmem-cleanup-__memcg_kmem_charge_memcg-arguments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: kmem: cleanup (__)memcg_kmem_charge_memcg() arguments

Patch series "mm: memcg: kmem API cleanup", v2.

This patchset aims to clean up the kernel memory charging API.  It doesn't
bring any functional changes, just removes unused arguments, renames some
functions and fixes some comments.

Currently it's not obvious which functions are most basic
(memcg_kmem_(un)charge_memcg()) and which are based on them
(memcg_kmem_(un)charge()).  The patchset renames these functions and
removes unused arguments:

TL;DR:
was:
  memcg_kmem_charge_memcg(page, gfp, order, memcg)
  memcg_kmem_uncharge_memcg(memcg, nr_pages)
  memcg_kmem_charge(page, gfp, order)
  memcg_kmem_uncharge(page, order)

now:
  memcg_kmem_charge(memcg, gfp, nr_pages)
  memcg_kmem_uncharge(memcg, nr_pages)
  memcg_kmem_charge_page(page, gfp, order)
  memcg_kmem_uncharge_page(page, order)


This patch (of 6):

The first argument of memcg_kmem_charge_memcg() and
__memcg_kmem_charge_memcg() is the page pointer and it's not used.  Let's
drop it.

Memcg pointer is passed as the last argument.  Move it to the first place
for consistency with other memcg functions, e.g. 
__memcg_kmem_uncharge_memcg() or try_charge().

Link: http://lkml.kernel.org/r/20200109202659.752357-2-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    9 ++++-----
 mm/memcontrol.c            |    8 +++-----
 mm/slab.h                  |    2 +-
 3 files changed, 8 insertions(+), 11 deletions(-)

--- a/include/linux/memcontrol.h~mm-kmem-cleanup-__memcg_kmem_charge_memcg-arguments
+++ a/include/linux/memcontrol.h
@@ -1371,8 +1371,7 @@ void memcg_kmem_put_cache(struct kmem_ca
 #ifdef CONFIG_MEMCG_KMEM
 int __memcg_kmem_charge(struct page *page, gfp_t gfp, int order);
 void __memcg_kmem_uncharge(struct page *page, int order);
-int __memcg_kmem_charge_memcg(struct page *page, gfp_t gfp, int order,
-			      struct mem_cgroup *memcg);
+int __memcg_kmem_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp, int order);
 void __memcg_kmem_uncharge_memcg(struct mem_cgroup *memcg,
 				 unsigned int nr_pages);
 
@@ -1409,11 +1408,11 @@ static inline void memcg_kmem_uncharge(s
 		__memcg_kmem_uncharge(page, order);
 }
 
-static inline int memcg_kmem_charge_memcg(struct page *page, gfp_t gfp,
-					  int order, struct mem_cgroup *memcg)
+static inline int memcg_kmem_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp,
+					  int order)
 {
 	if (memcg_kmem_enabled())
-		return __memcg_kmem_charge_memcg(page, gfp, order, memcg);
+		return __memcg_kmem_charge_memcg(memcg, gfp, order);
 	return 0;
 }
 
--- a/mm/memcontrol.c~mm-kmem-cleanup-__memcg_kmem_charge_memcg-arguments
+++ a/mm/memcontrol.c
@@ -2848,15 +2848,13 @@ void memcg_kmem_put_cache(struct kmem_ca
 
 /**
  * __memcg_kmem_charge_memcg: charge a kmem page
- * @page: page to charge
+ * @memcg: memory cgroup to charge
  * @gfp: reclaim mode
  * @order: allocation order
- * @memcg: memory cgroup to charge
  *
  * Returns 0 on success, an error code on failure.
  */
-int __memcg_kmem_charge_memcg(struct page *page, gfp_t gfp, int order,
-			    struct mem_cgroup *memcg)
+int __memcg_kmem_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp, int order)
 {
 	unsigned int nr_pages = 1 << order;
 	struct page_counter *counter;
@@ -2902,7 +2900,7 @@ int __memcg_kmem_charge(struct page *pag
 
 	memcg = get_mem_cgroup_from_current();
 	if (!mem_cgroup_is_root(memcg)) {
-		ret = __memcg_kmem_charge_memcg(page, gfp, order, memcg);
+		ret = __memcg_kmem_charge_memcg(memcg, gfp, order);
 		if (!ret) {
 			page->mem_cgroup = memcg;
 			__SetPageKmemcg(page);
--- a/mm/slab.h~mm-kmem-cleanup-__memcg_kmem_charge_memcg-arguments
+++ a/mm/slab.h
@@ -365,7 +365,7 @@ static __always_inline int memcg_charge_
 		return 0;
 	}
 
-	ret = memcg_kmem_charge_memcg(page, gfp, order, memcg);
+	ret = memcg_kmem_charge_memcg(memcg, gfp, order);
 	if (ret)
 		goto out;
 
_

Patches currently in -mm which might be from guro@fb.com are

mm-memcg-slab-introduce-mem_cgroup_from_obj.patch
mm-kmem-cleanup-__memcg_kmem_charge_memcg-arguments.patch
mm-kmem-cleanup-memcg_kmem_uncharge_memcg-arguments.patch
mm-kmem-rename-memcg_kmem_uncharge-into-memcg_kmem_uncharge_page.patch
mm-kmem-switch-to-nr_pages-in-__memcg_kmem_charge_memcg.patch
mm-memcg-slab-cache-page-number-in-memcg_uncharge_slab.patch
mm-kmem-rename-__memcg_kmem_uncharge_memcg-to-__memcg_kmem_uncharge.patch
