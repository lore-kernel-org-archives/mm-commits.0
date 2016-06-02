From: akpm@linux-foundation.org
Subject: +
 mm-charge-uncharge-kmemcg-from-generic-page-allocator-paths.patch added to
 -mm tree
Date: Thu, 02 Jun 2016 16:09:09 -0700
Message-ID: <5750bc95.G5qSWZaB61/t97Rf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52863 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933090AbcFBXJK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2016 19:09:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, eric.dumazet@gmail.com, hannes@cmpxchg.org, mhocko@kernel.org, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: charge/uncharge kmemcg from generic page allocator paths
has been added to the -mm tree.  Its filename is
     mm-charge-uncharge-kmemcg-from-generic-page-allocator-paths.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-charge-uncharge-kmemcg-from-generic-page-allocator-paths.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-charge-uncharge-kmemcg-from-generic-page-allocator-paths.patch

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
Subject: mm: charge/uncharge kmemcg from generic page allocator paths

Currently, to charge a non-slab allocation to kmemcg one has to use
alloc_kmem_pages helper with __GFP_ACCOUNT flag. A page allocated with
this helper should finally be freed using free_kmem_pages, otherwise it
won't be uncharged.

This API suits its current users fine, but it turns out to be impossible
to use along with page reference counting, i.e. when an allocation is
supposed to be freed with put_page, as it is the case with pipe or unix
socket buffers.

To overcome this limitation, this patch moves charging/uncharging to
generic page allocator paths, i.e. to __alloc_pages_nodemask and
free_pages_prepare, and zaps alloc/free_kmem_pages helpers. This way,
one can use any of the available page allocation functions to get the
allocated page charged to kmemcg - it's enough to pass __GFP_ACCOUNT,
just like in case of kmalloc and friends. A charged page will be
automatically uncharged on free.

To make it possible, we need to mark pages charged to kmemcg somehow. To
avoid introducing a new page flag, we make use of page->_mapcount for
marking such pages. Since pages charged to kmemcg are not supposed to be
mapped to userspace, it should work just fine. There are other (ab)users
of page->_mapcount - buddy and balloon pages - but we don't conflict
with them.

In case kmemcg is compiled out or not used at runtime, this patch
introduces no overhead to generic page allocator paths. If kmemcg is
used, it will be plus one gfp flags check on alloc and plus one
page->_mapcount check on free, which shouldn't hurt performance, because
the data accessed are hot.

Link: http://lkml.kernel.org/r/a9736d856f895bcb465d9f257b54efe32eda6f99.1464079538.git.vdavydov@virtuozzo.com
Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h        |   10 -----
 include/linux/page-flags.h |    7 +++
 kernel/fork.c              |    6 +--
 mm/page_alloc.c            |   66 ++++++-----------------------------
 mm/slab_common.c           |    2 -
 mm/slub.c                  |    6 +--
 mm/vmalloc.c               |    6 +--
 7 files changed, 31 insertions(+), 72 deletions(-)

diff -puN include/linux/gfp.h~mm-charge-uncharge-kmemcg-from-generic-page-allocator-paths include/linux/gfp.h
--- a/include/linux/gfp.h~mm-charge-uncharge-kmemcg-from-generic-page-allocator-paths
+++ a/include/linux/gfp.h
@@ -78,8 +78,7 @@ struct vm_area_struct;
  * __GFP_THISNODE forces the allocation to be satisified from the requested
  *   node with no fallbacks or placement policy enforcements.
  *
- * __GFP_ACCOUNT causes the allocation to be accounted to kmemcg (only relevant
- *   to kmem allocations).
+ * __GFP_ACCOUNT causes the allocation to be accounted to kmemcg.
  */
 #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE)
 #define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)
@@ -486,10 +485,6 @@ extern struct page *alloc_pages_vma(gfp_
 #define alloc_page_vma_node(gfp_mask, vma, addr, node)		\
 	alloc_pages_vma(gfp_mask, 0, vma, addr, node, false)
 
-extern struct page *alloc_kmem_pages(gfp_t gfp_mask, unsigned int order);
-extern struct page *alloc_kmem_pages_node(int nid, gfp_t gfp_mask,
-					  unsigned int order);
-
 extern unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order);
 extern unsigned long get_zeroed_page(gfp_t gfp_mask);
 
@@ -513,9 +508,6 @@ extern void *__alloc_page_frag(struct pa
 			       unsigned int fragsz, gfp_t gfp_mask);
 extern void __free_page_frag(void *addr);
 
-extern void __free_kmem_pages(struct page *page, unsigned int order);
-extern void free_kmem_pages(unsigned long addr, unsigned int order);
-
 #define __free_page(page) __free_pages((page), 0)
 #define free_page(addr) free_pages((addr), 0)
 
diff -puN include/linux/page-flags.h~mm-charge-uncharge-kmemcg-from-generic-page-allocator-paths include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-charge-uncharge-kmemcg-from-generic-page-allocator-paths
+++ a/include/linux/page-flags.h
@@ -641,6 +641,13 @@ PAGE_MAPCOUNT_OPS(Buddy, BUDDY)
 #define PAGE_BALLOON_MAPCOUNT_VALUE		(-256)
 PAGE_MAPCOUNT_OPS(Balloon, BALLOON)
 
+/*
+ * If kmemcg is enabled, the buddy allocator will set PageKmemcg() on
+ * pages allocated with __GFP_ACCOUNT. It gets cleared on page free.
+ */
+#define PAGE_KMEMCG_MAPCOUNT_VALUE		(-512)
+PAGE_MAPCOUNT_OPS(Kmemcg, KMEMCG)
+
 extern bool is_free_buddy_page(struct page *page);
 
 __PAGEFLAG(Isolated, isolated, PF_ANY);
diff -puN kernel/fork.c~mm-charge-uncharge-kmemcg-from-generic-page-allocator-paths kernel/fork.c
--- a/kernel/fork.c~mm-charge-uncharge-kmemcg-from-generic-page-allocator-paths
+++ a/kernel/fork.c
@@ -162,8 +162,8 @@ void __weak arch_release_thread_info(str
 static struct thread_info *alloc_thread_info_node(struct task_struct *tsk,
 						  int node)
 {
-	struct page *page = alloc_kmem_pages_node(node, THREADINFO_GFP,
-						  THREAD_SIZE_ORDER);
+	struct page *page = alloc_pages_node(node, THREADINFO_GFP,
+					     THREAD_SIZE_ORDER);
 
 	if (page)
 		memcg_kmem_update_page_stat(page, MEMCG_KERNEL_STACK,
@@ -178,7 +178,7 @@ static inline void free_thread_info(stru
 
 	memcg_kmem_update_page_stat(page, MEMCG_KERNEL_STACK,
 				    -(1 << THREAD_SIZE_ORDER));
-	__free_kmem_pages(page, THREAD_SIZE_ORDER);
+	__free_pages(page, THREAD_SIZE_ORDER);
 }
 # else
 static struct kmem_cache *thread_info_cache;
diff -puN mm/page_alloc.c~mm-charge-uncharge-kmemcg-from-generic-page-allocator-paths mm/page_alloc.c
--- a/mm/page_alloc.c~mm-charge-uncharge-kmemcg-from-generic-page-allocator-paths
+++ a/mm/page_alloc.c
@@ -63,6 +63,7 @@
 #include <linux/sched/rt.h>
 #include <linux/page_owner.h>
 #include <linux/kthread.h>
+#include <linux/memcontrol.h>
 
 #include <asm/sections.h>
 #include <asm/tlbflush.h>
@@ -1016,6 +1017,10 @@ static __always_inline bool free_pages_p
 	}
 	if (PageMappingFlags(page))
 		page->mapping = NULL;
+	if (memcg_kmem_enabled() && PageKmemcg(page)) {
+		memcg_kmem_uncharge(page, order);
+		__ClearPageKmemcg(page);
+	}
 	if (check_free)
 		bad += free_pages_check(page);
 	if (bad)
@@ -3838,6 +3843,14 @@ no_zone:
 	}
 
 out:
+	if (memcg_kmem_enabled() && (gfp_mask & __GFP_ACCOUNT) && page) {
+		if (unlikely(memcg_kmem_charge(page, gfp_mask, order))) {
+			__free_pages(page, order);
+			page = NULL;
+		} else
+			__SetPageKmemcg(page);
+	}
+
 	if (kmemcheck_enabled && page)
 		kmemcheck_pagealloc_alloc(page, order, gfp_mask);
 
@@ -3993,59 +4006,6 @@ void __free_page_frag(void *addr)
 }
 EXPORT_SYMBOL(__free_page_frag);
 
-/*
- * alloc_kmem_pages charges newly allocated pages to the kmem resource counter
- * of the current memory cgroup if __GFP_ACCOUNT is set, other than that it is
- * equivalent to alloc_pages.
- *
- * It should be used when the caller would like to use kmalloc, but since the
- * allocation is large, it has to fall back to the page allocator.
- */
-struct page *alloc_kmem_pages(gfp_t gfp_mask, unsigned int order)
-{
-	struct page *page;
-
-	page = alloc_pages(gfp_mask, order);
-	if (memcg_kmem_enabled() && (gfp_mask & __GFP_ACCOUNT) &&
-	    page && memcg_kmem_charge(page, gfp_mask, order) != 0) {
-		__free_pages(page, order);
-		page = NULL;
-	}
-	return page;
-}
-
-struct page *alloc_kmem_pages_node(int nid, gfp_t gfp_mask, unsigned int order)
-{
-	struct page *page;
-
-	page = alloc_pages_node(nid, gfp_mask, order);
-	if (memcg_kmem_enabled() && (gfp_mask & __GFP_ACCOUNT) &&
-	    page && memcg_kmem_charge(page, gfp_mask, order) != 0) {
-		__free_pages(page, order);
-		page = NULL;
-	}
-	return page;
-}
-
-/*
- * __free_kmem_pages and free_kmem_pages will free pages allocated with
- * alloc_kmem_pages.
- */
-void __free_kmem_pages(struct page *page, unsigned int order)
-{
-	if (memcg_kmem_enabled())
-		memcg_kmem_uncharge(page, order);
-	__free_pages(page, order);
-}
-
-void free_kmem_pages(unsigned long addr, unsigned int order)
-{
-	if (addr != 0) {
-		VM_BUG_ON(!virt_addr_valid((void *)addr));
-		__free_kmem_pages(virt_to_page((void *)addr), order);
-	}
-}
-
 static void *make_alloc_exact(unsigned long addr, unsigned int order,
 		size_t size)
 {
diff -puN mm/slab_common.c~mm-charge-uncharge-kmemcg-from-generic-page-allocator-paths mm/slab_common.c
--- a/mm/slab_common.c~mm-charge-uncharge-kmemcg-from-generic-page-allocator-paths
+++ a/mm/slab_common.c
@@ -1012,7 +1012,7 @@ void *kmalloc_order(size_t size, gfp_t f
 	struct page *page;
 
 	flags |= __GFP_COMP;
-	page = alloc_kmem_pages(flags, order);
+	page = alloc_pages(flags, order);
 	ret = page ? page_address(page) : NULL;
 	kmemleak_alloc(ret, size, 1, flags);
 	kasan_kmalloc_large(ret, size, flags);
diff -puN mm/slub.c~mm-charge-uncharge-kmemcg-from-generic-page-allocator-paths mm/slub.c
--- a/mm/slub.c~mm-charge-uncharge-kmemcg-from-generic-page-allocator-paths
+++ a/mm/slub.c
@@ -2975,7 +2975,7 @@ int build_detached_freelist(struct kmem_
 		if (unlikely(!PageSlab(page))) {
 			BUG_ON(!PageCompound(page));
 			kfree_hook(object);
-			__free_kmem_pages(page, compound_order(page));
+			__free_pages(page, compound_order(page));
 			p[size] = NULL; /* mark object processed */
 			return size;
 		}
@@ -3691,7 +3691,7 @@ static void *kmalloc_large_node(size_t s
 	void *ptr = NULL;
 
 	flags |= __GFP_COMP | __GFP_NOTRACK;
-	page = alloc_kmem_pages_node(node, flags, get_order(size));
+	page = alloc_pages_node(node, flags, get_order(size));
 	if (page)
 		ptr = page_address(page);
 
@@ -3772,7 +3772,7 @@ void kfree(const void *x)
 	if (unlikely(!PageSlab(page))) {
 		BUG_ON(!PageCompound(page));
 		kfree_hook(x);
-		__free_kmem_pages(page, compound_order(page));
+		__free_pages(page, compound_order(page));
 		return;
 	}
 	slab_free(page->slab_cache, page, object, NULL, 1, _RET_IP_);
diff -puN mm/vmalloc.c~mm-charge-uncharge-kmemcg-from-generic-page-allocator-paths mm/vmalloc.c
--- a/mm/vmalloc.c~mm-charge-uncharge-kmemcg-from-generic-page-allocator-paths
+++ a/mm/vmalloc.c
@@ -1501,7 +1501,7 @@ static void __vunmap(const void *addr, i
 			struct page *page = area->pages[i];
 
 			BUG_ON(!page);
-			__free_kmem_pages(page, 0);
+			__free_pages(page, 0);
 		}
 
 		kvfree(area->pages);
@@ -1629,9 +1629,9 @@ static void *__vmalloc_area_node(struct
 		struct page *page;
 
 		if (node == NUMA_NO_NODE)
-			page = alloc_kmem_pages(alloc_mask, order);
+			page = alloc_pages(alloc_mask, order);
 		else
-			page = alloc_kmem_pages_node(node, alloc_mask, order);
+			page = alloc_pages_node(node, alloc_mask, order);
 
 		if (unlikely(!page)) {
 			/* Successfully allocated i pages, free them in __vunmap() */
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-zap-zone_oom_locked.patch
mm-oom-add-memcg-to-oom_control.patch
mm-remove-pointless-struct-in-struct-page-definition.patch
mm-clean-up-non-standard-page-_mapcount-users.patch
mm-memcontrol-cleanup-kmem-charge-functions.patch
mm-charge-uncharge-kmemcg-from-generic-page-allocator-paths.patch
mm-memcontrol-teach-uncharge_list-to-deal-with-kmem-pages.patch
arch-x86-charge-page-tables-to-kmemcg.patch
pipe-account-to-kmemcg.patch
af_unix-charge-buffers-to-kmemcg.patch

