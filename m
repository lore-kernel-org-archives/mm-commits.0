From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-kmem-switch-to-nr_pages-in-__memcg_kmem_charge_memcg.patch added to -mm
 tree
Date: Mon, 24 Feb 2020 16:48:07 -0800
Message-ID: <20200225004807.nLknDeU2Z%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727976AbgBYAsI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Feb 2020 19:48:08 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com, vdavydov.dev@gmail.com


The patch titled
     Subject: mm: kmem: switch to nr_pages in (__)memcg_kmem_charge_memcg()
has been added to the -mm tree.  Its filename is
     mm-kmem-switch-to-nr_pages-in-__memcg_kmem_charge_memcg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kmem-switch-to-nr_pages-in-__memcg_kmem_charge_memcg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kmem-switch-to-nr_pages-in-__memcg_kmem_charge_memcg.patch

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
Subject: mm: kmem: switch to nr_pages in (__)memcg_kmem_charge_memcg()

These functions are charging the given number of kernel pages to the given
memory cgroup.  The number doesn't have to be a power of two.  Let's make
them to take the unsigned int nr_pages as an argument instead of the page
order.

It makes them look consistent with the corresponding uncharge functions
and functions like: mem_cgroup_charge_skmem(memcg, nr_pages).

Link: http://lkml.kernel.org/r/20200109202659.752357-5-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   11 ++++++-----
 mm/memcontrol.c            |    8 ++++----
 mm/slab.h                  |    2 +-
 3 files changed, 11 insertions(+), 10 deletions(-)

--- a/include/linux/memcontrol.h~mm-kmem-switch-to-nr_pages-in-__memcg_kmem_charge_memcg
+++ a/include/linux/memcontrol.h
@@ -1371,7 +1371,8 @@ void memcg_kmem_put_cache(struct kmem_ca
 #ifdef CONFIG_MEMCG_KMEM
 int __memcg_kmem_charge_page(struct page *page, gfp_t gfp, int order);
 void __memcg_kmem_uncharge_page(struct page *page, int order);
-int __memcg_kmem_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp, int order);
+int __memcg_kmem_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp,
+			      unsigned int nr_pages);
 void __memcg_kmem_uncharge_memcg(struct mem_cgroup *memcg,
 				 unsigned int nr_pages);
 
@@ -1410,18 +1411,18 @@ static inline void memcg_kmem_uncharge_p
 }
 
 static inline int memcg_kmem_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp,
-					  int order)
+					  unsigned int nr_pages)
 {
 	if (memcg_kmem_enabled())
-		return __memcg_kmem_charge_memcg(memcg, gfp, order);
+		return __memcg_kmem_charge_memcg(memcg, gfp, nr_pages);
 	return 0;
 }
 
 static inline void memcg_kmem_uncharge_memcg(struct mem_cgroup *memcg,
-					     int order)
+					     unsigned int nr_pages)
 {
 	if (memcg_kmem_enabled())
-		__memcg_kmem_uncharge_memcg(memcg, 1 << order);
+		__memcg_kmem_uncharge_memcg(memcg, nr_pages);
 }
 
 /*
--- a/mm/memcontrol.c~mm-kmem-switch-to-nr_pages-in-__memcg_kmem_charge_memcg
+++ a/mm/memcontrol.c
@@ -2850,13 +2850,13 @@ void memcg_kmem_put_cache(struct kmem_ca
  * __memcg_kmem_charge_memcg: charge a kmem page
  * @memcg: memory cgroup to charge
  * @gfp: reclaim mode
- * @order: allocation order
+ * @nr_pages: number of pages to charge
  *
  * Returns 0 on success, an error code on failure.
  */
-int __memcg_kmem_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp, int order)
+int __memcg_kmem_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp,
+			      unsigned int nr_pages)
 {
-	unsigned int nr_pages = 1 << order;
 	struct page_counter *counter;
 	int ret;
 
@@ -2900,7 +2900,7 @@ int __memcg_kmem_charge_page(struct page
 
 	memcg = get_mem_cgroup_from_current();
 	if (!mem_cgroup_is_root(memcg)) {
-		ret = __memcg_kmem_charge_memcg(memcg, gfp, order);
+		ret = __memcg_kmem_charge_memcg(memcg, gfp, 1 << order);
 		if (!ret) {
 			page->mem_cgroup = memcg;
 			__SetPageKmemcg(page);
--- a/mm/slab.h~mm-kmem-switch-to-nr_pages-in-__memcg_kmem_charge_memcg
+++ a/mm/slab.h
@@ -365,7 +365,7 @@ static __always_inline int memcg_charge_
 		return 0;
 	}
 
-	ret = memcg_kmem_charge_memcg(memcg, gfp, order);
+	ret = memcg_kmem_charge_memcg(memcg, gfp, 1 << order);
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
