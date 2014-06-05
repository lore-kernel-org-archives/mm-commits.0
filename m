From: akpm@linux-foundation.org
Subject: [merged] mm-get-rid-of-__gfp_kmemcg.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:43:22 -0700
Message-ID: <5390c85a.1XQ9BXKt+W54UIl3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55691 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaFETnX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:43:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sfr@canb.auug.org.au, penberg@kernel.org, mhocko@suse.cz, hannes@cmpxchg.org, gthelen@google.com, glommer@gmail.com, cl@linux-foundation.org, vdavydov@parallels.com

Subject: [merged] mm-get-rid-of-__gfp_kmemcg.patch removed from -mm tree
To: vdavydov@parallels.com,cl@linux-foundation.org,glommer@gmail.com,gthelen@google.com,hannes@cmpxchg.org,mhocko@suse.cz,penberg@kernel.org,sfr@canb.auug.org.au,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:43:22 -0700


The patch titled
     Subject: mm: get rid of __GFP_KMEMCG
has been removed from the -mm tree.  Its filename was
     mm-get-rid-of-__gfp_kmemcg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: mm: get rid of __GFP_KMEMCG

Currently to allocate a page that should be charged to kmemcg (e.g. 
threadinfo), we pass __GFP_KMEMCG flag to the page allocator.  The page
allocated is then to be freed by free_memcg_kmem_pages.  Apart from
looking asymmetrical, this also requires intrusion to the general
allocation path.  So let's introduce separate functions that will
alloc/free pages charged to kmemcg.

The new functions are called alloc_kmem_pages and free_kmem_pages.  They
should be used when the caller actually would like to use kmalloc, but has
to fall back to the page allocator for the allocation is large.  They only
differ from alloc_pages and free_pages in that besides allocating or
freeing pages they also charge them to the kmem resource counter of the
current memory cgroup.

[sfr@canb.auug.org.au: export kmalloc_order() to modules]
Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h             |   10 +++--
 include/linux/memcontrol.h      |    2 -
 include/linux/slab.h            |   11 -----
 include/linux/thread_info.h     |    2 -
 include/trace/events/gfpflags.h |    1 
 kernel/fork.c                   |    6 +--
 mm/memcontrol.c                 |   11 +++--
 mm/page_alloc.c                 |   56 ++++++++++++++++++------------
 mm/slab_common.c                |   13 ++++++
 mm/slub.c                       |    6 +--
 10 files changed, 68 insertions(+), 50 deletions(-)

diff -puN include/linux/gfp.h~mm-get-rid-of-__gfp_kmemcg include/linux/gfp.h
--- a/include/linux/gfp.h~mm-get-rid-of-__gfp_kmemcg
+++ a/include/linux/gfp.h
@@ -31,7 +31,6 @@ struct vm_area_struct;
 #define ___GFP_HARDWALL		0x20000u
 #define ___GFP_THISNODE		0x40000u
 #define ___GFP_RECLAIMABLE	0x80000u
-#define ___GFP_KMEMCG		0x100000u
 #define ___GFP_NOTRACK		0x200000u
 #define ___GFP_NO_KSWAPD	0x400000u
 #define ___GFP_OTHER_NODE	0x800000u
@@ -91,7 +90,6 @@ struct vm_area_struct;
 
 #define __GFP_NO_KSWAPD	((__force gfp_t)___GFP_NO_KSWAPD)
 #define __GFP_OTHER_NODE ((__force gfp_t)___GFP_OTHER_NODE) /* On behalf of other node */
-#define __GFP_KMEMCG	((__force gfp_t)___GFP_KMEMCG) /* Allocation comes from a memcg-accounted resource */
 #define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)	/* Allocator intends to dirty page */
 
 /*
@@ -353,6 +351,10 @@ extern struct page *alloc_pages_vma(gfp_
 #define alloc_page_vma_node(gfp_mask, vma, addr, node)		\
 	alloc_pages_vma(gfp_mask, 0, vma, addr, node)
 
+extern struct page *alloc_kmem_pages(gfp_t gfp_mask, unsigned int order);
+extern struct page *alloc_kmem_pages_node(int nid, gfp_t gfp_mask,
+					  unsigned int order);
+
 extern unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order);
 extern unsigned long get_zeroed_page(gfp_t gfp_mask);
 
@@ -372,8 +374,8 @@ extern void free_pages(unsigned long add
 extern void free_hot_cold_page(struct page *page, int cold);
 extern void free_hot_cold_page_list(struct list_head *list, int cold);
 
-extern void __free_memcg_kmem_pages(struct page *page, unsigned int order);
-extern void free_memcg_kmem_pages(unsigned long addr, unsigned int order);
+extern void __free_kmem_pages(struct page *page, unsigned int order);
+extern void free_kmem_pages(unsigned long addr, unsigned int order);
 
 #define __free_page(page) __free_pages((page), 0)
 #define free_page(addr) free_pages((addr), 0)
diff -puN include/linux/memcontrol.h~mm-get-rid-of-__gfp_kmemcg include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-get-rid-of-__gfp_kmemcg
+++ a/include/linux/memcontrol.h
@@ -537,7 +537,7 @@ memcg_kmem_newpage_charge(gfp_t gfp, str
 	 * res_counter_charge_nofail, but we hope those allocations are rare,
 	 * and won't be worth the trouble.
 	 */
-	if (!(gfp & __GFP_KMEMCG) || (gfp & __GFP_NOFAIL))
+	if (gfp & __GFP_NOFAIL)
 		return true;
 	if (in_interrupt() || (!current->mm) || (current->flags & PF_KTHREAD))
 		return true;
diff -puN include/linux/slab.h~mm-get-rid-of-__gfp_kmemcg include/linux/slab.h
--- a/include/linux/slab.h~mm-get-rid-of-__gfp_kmemcg
+++ a/include/linux/slab.h
@@ -369,16 +369,7 @@ kmem_cache_alloc_node_trace(struct kmem_
 #include <linux/slub_def.h>
 #endif
 
-static __always_inline void *
-kmalloc_order(size_t size, gfp_t flags, unsigned int order)
-{
-	void *ret;
-
-	flags |= (__GFP_COMP | __GFP_KMEMCG);
-	ret = (void *) __get_free_pages(flags, order);
-	kmemleak_alloc(ret, size, 1, flags);
-	return ret;
-}
+extern void *kmalloc_order(size_t size, gfp_t flags, unsigned int order);
 
 #ifdef CONFIG_TRACING
 extern void *kmalloc_order_trace(size_t size, gfp_t flags, unsigned int order);
diff -puN include/linux/thread_info.h~mm-get-rid-of-__gfp_kmemcg include/linux/thread_info.h
--- a/include/linux/thread_info.h~mm-get-rid-of-__gfp_kmemcg
+++ a/include/linux/thread_info.h
@@ -61,8 +61,6 @@ extern long do_no_restart_syscall(struct
 # define THREADINFO_GFP		(GFP_KERNEL | __GFP_NOTRACK)
 #endif
 
-#define THREADINFO_GFP_ACCOUNTED (THREADINFO_GFP | __GFP_KMEMCG)
-
 /*
  * flag set/clear/test wrappers
  * - pass TIF_xxxx constants to these functions
diff -puN include/trace/events/gfpflags.h~mm-get-rid-of-__gfp_kmemcg include/trace/events/gfpflags.h
--- a/include/trace/events/gfpflags.h~mm-get-rid-of-__gfp_kmemcg
+++ a/include/trace/events/gfpflags.h
@@ -34,7 +34,6 @@
 	{(unsigned long)__GFP_HARDWALL,		"GFP_HARDWALL"},	\
 	{(unsigned long)__GFP_THISNODE,		"GFP_THISNODE"},	\
 	{(unsigned long)__GFP_RECLAIMABLE,	"GFP_RECLAIMABLE"},	\
-	{(unsigned long)__GFP_KMEMCG,		"GFP_KMEMCG"},		\
 	{(unsigned long)__GFP_MOVABLE,		"GFP_MOVABLE"},		\
 	{(unsigned long)__GFP_NOTRACK,		"GFP_NOTRACK"},		\
 	{(unsigned long)__GFP_NO_KSWAPD,	"GFP_NO_KSWAPD"},	\
diff -puN kernel/fork.c~mm-get-rid-of-__gfp_kmemcg kernel/fork.c
--- a/kernel/fork.c~mm-get-rid-of-__gfp_kmemcg
+++ a/kernel/fork.c
@@ -150,15 +150,15 @@ void __weak arch_release_thread_info(str
 static struct thread_info *alloc_thread_info_node(struct task_struct *tsk,
 						  int node)
 {
-	struct page *page = alloc_pages_node(node, THREADINFO_GFP_ACCOUNTED,
-					     THREAD_SIZE_ORDER);
+	struct page *page = alloc_kmem_pages_node(node, THREADINFO_GFP,
+						  THREAD_SIZE_ORDER);
 
 	return page ? page_address(page) : NULL;
 }
 
 static inline void free_thread_info(struct thread_info *ti)
 {
-	free_memcg_kmem_pages((unsigned long)ti, THREAD_SIZE_ORDER);
+	free_kmem_pages((unsigned long)ti, THREAD_SIZE_ORDER);
 }
 # else
 static struct kmem_cache *thread_info_cache;
diff -puN mm/memcontrol.c~mm-get-rid-of-__gfp_kmemcg mm/memcontrol.c
--- a/mm/memcontrol.c~mm-get-rid-of-__gfp_kmemcg
+++ a/mm/memcontrol.c
@@ -3540,11 +3540,12 @@ __memcg_kmem_newpage_charge(gfp_t gfp, s
 	/*
 	 * Disabling accounting is only relevant for some specific memcg
 	 * internal allocations. Therefore we would initially not have such
-	 * check here, since direct calls to the page allocator that are marked
-	 * with GFP_KMEMCG only happen outside memcg core. We are mostly
-	 * concerned with cache allocations, and by having this test at
-	 * memcg_kmem_get_cache, we are already able to relay the allocation to
-	 * the root cache and bypass the memcg cache altogether.
+	 * check here, since direct calls to the page allocator that are
+	 * accounted to kmemcg (alloc_kmem_pages and friends) only happen
+	 * outside memcg core. We are mostly concerned with cache allocations,
+	 * and by having this test at memcg_kmem_get_cache, we are already able
+	 * to relay the allocation to the root cache and bypass the memcg cache
+	 * altogether.
 	 *
 	 * There is one exception, though: the SLUB allocator does not create
 	 * large order caches, but rather service large kmallocs directly from
diff -puN mm/page_alloc.c~mm-get-rid-of-__gfp_kmemcg mm/page_alloc.c
--- a/mm/page_alloc.c~mm-get-rid-of-__gfp_kmemcg
+++ a/mm/page_alloc.c
@@ -2697,7 +2697,6 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	int migratetype = allocflags_to_migratetype(gfp_mask);
 	unsigned int cpuset_mems_cookie;
 	int alloc_flags = ALLOC_WMARK_LOW|ALLOC_CPUSET|ALLOC_FAIR;
-	struct mem_cgroup *memcg = NULL;
 
 	gfp_mask &= gfp_allowed_mask;
 
@@ -2716,13 +2715,6 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	if (unlikely(!zonelist->_zonerefs->zone))
 		return NULL;
 
-	/*
-	 * Will only have any effect when __GFP_KMEMCG is set.  This is
-	 * verified in the (always inline) callee
-	 */
-	if (!memcg_kmem_newpage_charge(gfp_mask, &memcg, order))
-		return NULL;
-
 retry_cpuset:
 	cpuset_mems_cookie = read_mems_allowed_begin();
 
@@ -2782,8 +2774,6 @@ out:
 	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
 		goto retry_cpuset;
 
-	memcg_kmem_commit_charge(page, memcg, order);
-
 	return page;
 }
 EXPORT_SYMBOL(__alloc_pages_nodemask);
@@ -2837,27 +2827,51 @@ void free_pages(unsigned long addr, unsi
 EXPORT_SYMBOL(free_pages);
 
 /*
- * __free_memcg_kmem_pages and free_memcg_kmem_pages will free
- * pages allocated with __GFP_KMEMCG.
+ * alloc_kmem_pages charges newly allocated pages to the kmem resource counter
+ * of the current memory cgroup.
  *
- * Those pages are accounted to a particular memcg, embedded in the
- * corresponding page_cgroup. To avoid adding a hit in the allocator to search
- * for that information only to find out that it is NULL for users who have no
- * interest in that whatsoever, we provide these functions.
- *
- * The caller knows better which flags it relies on.
+ * It should be used when the caller would like to use kmalloc, but since the
+ * allocation is large, it has to fall back to the page allocator.
+ */
+struct page *alloc_kmem_pages(gfp_t gfp_mask, unsigned int order)
+{
+	struct page *page;
+	struct mem_cgroup *memcg = NULL;
+
+	if (!memcg_kmem_newpage_charge(gfp_mask, &memcg, order))
+		return NULL;
+	page = alloc_pages(gfp_mask, order);
+	memcg_kmem_commit_charge(page, memcg, order);
+	return page;
+}
+
+struct page *alloc_kmem_pages_node(int nid, gfp_t gfp_mask, unsigned int order)
+{
+	struct page *page;
+	struct mem_cgroup *memcg = NULL;
+
+	if (!memcg_kmem_newpage_charge(gfp_mask, &memcg, order))
+		return NULL;
+	page = alloc_pages_node(nid, gfp_mask, order);
+	memcg_kmem_commit_charge(page, memcg, order);
+	return page;
+}
+
+/*
+ * __free_kmem_pages and free_kmem_pages will free pages allocated with
+ * alloc_kmem_pages.
  */
-void __free_memcg_kmem_pages(struct page *page, unsigned int order)
+void __free_kmem_pages(struct page *page, unsigned int order)
 {
 	memcg_kmem_uncharge_pages(page, order);
 	__free_pages(page, order);
 }
 
-void free_memcg_kmem_pages(unsigned long addr, unsigned int order)
+void free_kmem_pages(unsigned long addr, unsigned int order)
 {
 	if (addr != 0) {
 		VM_BUG_ON(!virt_addr_valid((void *)addr));
-		__free_memcg_kmem_pages(virt_to_page((void *)addr), order);
+		__free_kmem_pages(virt_to_page((void *)addr), order);
 	}
 }
 
diff -puN mm/slab_common.c~mm-get-rid-of-__gfp_kmemcg mm/slab_common.c
--- a/mm/slab_common.c~mm-get-rid-of-__gfp_kmemcg
+++ a/mm/slab_common.c
@@ -582,6 +582,19 @@ void __init create_kmalloc_caches(unsign
 }
 #endif /* !CONFIG_SLOB */
 
+void *kmalloc_order(size_t size, gfp_t flags, unsigned int order)
+{
+	void *ret;
+	struct page *page;
+
+	flags |= __GFP_COMP;
+	page = alloc_kmem_pages(flags, order);
+	ret = page ? page_address(page) : NULL;
+	kmemleak_alloc(ret, size, 1, flags);
+	return ret;
+}
+EXPORT_SYMBOL(kmalloc_order);
+
 #ifdef CONFIG_TRACING
 void *kmalloc_order_trace(size_t size, gfp_t flags, unsigned int order)
 {
diff -puN mm/slub.c~mm-get-rid-of-__gfp_kmemcg mm/slub.c
--- a/mm/slub.c~mm-get-rid-of-__gfp_kmemcg
+++ a/mm/slub.c
@@ -3311,8 +3311,8 @@ static void *kmalloc_large_node(size_t s
 	struct page *page;
 	void *ptr = NULL;
 
-	flags |= __GFP_COMP | __GFP_NOTRACK | __GFP_KMEMCG;
-	page = alloc_pages_node(node, flags, get_order(size));
+	flags |= __GFP_COMP | __GFP_NOTRACK;
+	page = alloc_kmem_pages_node(node, flags, get_order(size));
 	if (page)
 		ptr = page_address(page);
 
@@ -3381,7 +3381,7 @@ void kfree(const void *x)
 	if (unlikely(!PageSlab(page))) {
 		BUG_ON(!PageCompound(page));
 		kfree_hook(x);
-		__free_memcg_kmem_pages(page, compound_order(page));
+		__free_kmem_pages(page, compound_order(page));
 		return;
 	}
 	slab_free(page->slab_cache, page, object, _RET_IP_);
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
linux-next.patch

