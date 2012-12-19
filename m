From: akpm@linux-foundation.org
Subject: [merged] mm-allocate-kernel-pages-to-the-right-memcg.patch removed from -mm tree
Date: Wed, 19 Dec 2012 12:40:24 -0800
Message-ID: <20121219204024.EEB8F100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:63560 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab2LSUk1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Dec 2012 15:40:27 -0500
Received: by mail-vc0-f201.google.com with SMTP id p1so277598vcq.4
        for <mm-commits@vger.kernel.org>; Wed, 19 Dec 2012 12:40:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glommer@parallels.com, cl@linux.com, fweisbec@redhat.com, gthelen@google.com, hannes@cmpxchg.org, js1304@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mgorman@suse.de, mhocko@suse.cz, penberg@cs.helsinki.fi, riel@redhat.com, rientjes@google.com, suleiman@google.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: allocate kernel pages to the right memcg
has been removed from the -mm tree.  Its filename was
     mm-allocate-kernel-pages-to-the-right-memcg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Glauber Costa <glommer@parallels.com>
Subject: mm: allocate kernel pages to the right memcg

When a process tries to allocate a page with the __GFP_KMEMCG flag, the
page allocator will call the corresponding memcg functions to validate the
allocation.  Tasks in the root memcg can always proceed.

To avoid adding markers to the page - and a kmem flag that would
necessarily follow, as much as doing page_cgroup lookups for no reason,
whoever is marking its allocations with __GFP_KMEMCG flag is responsible
for telling the page allocator that this is such an allocation at
free_pages() time.  This is done by the invocation of
__free_accounted_pages() and free_accounted_pages().

Signed-off-by: Glauber Costa <glommer@parallels.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Frederic Weisbecker <fweisbec@redhat.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: JoonSoo Kim <js1304@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    3 +++
 mm/page_alloc.c     |   35 +++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff -puN include/linux/gfp.h~mm-allocate-kernel-pages-to-the-right-memcg include/linux/gfp.h
--- a/include/linux/gfp.h~mm-allocate-kernel-pages-to-the-right-memcg
+++ a/include/linux/gfp.h
@@ -367,6 +367,9 @@ extern void free_pages(unsigned long add
 extern void free_hot_cold_page(struct page *page, int cold);
 extern void free_hot_cold_page_list(struct list_head *list, int cold);
 
+extern void __free_memcg_kmem_pages(struct page *page, unsigned int order);
+extern void free_memcg_kmem_pages(unsigned long addr, unsigned int order);
+
 #define __free_page(page) __free_pages((page), 0)
 #define free_page(addr) free_pages((addr), 0)
 
diff -puN mm/page_alloc.c~mm-allocate-kernel-pages-to-the-right-memcg mm/page_alloc.c
--- a/mm/page_alloc.c~mm-allocate-kernel-pages-to-the-right-memcg
+++ a/mm/page_alloc.c
@@ -2612,6 +2612,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	int migratetype = allocflags_to_migratetype(gfp_mask);
 	unsigned int cpuset_mems_cookie;
 	int alloc_flags = ALLOC_WMARK_LOW|ALLOC_CPUSET;
+	struct mem_cgroup *memcg = NULL;
 
 	gfp_mask &= gfp_allowed_mask;
 
@@ -2630,6 +2631,13 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	if (unlikely(!zonelist->_zonerefs->zone))
 		return NULL;
 
+	/*
+	 * Will only have any effect when __GFP_KMEMCG is set.  This is
+	 * verified in the (always inline) callee
+	 */
+	if (!memcg_kmem_newpage_charge(gfp_mask, &memcg, order))
+		return NULL;
+
 retry_cpuset:
 	cpuset_mems_cookie = get_mems_allowed();
 
@@ -2665,6 +2673,8 @@ out:
 	if (unlikely(!put_mems_allowed(cpuset_mems_cookie) && !page))
 		goto retry_cpuset;
 
+	memcg_kmem_commit_charge(page, memcg, order);
+
 	return page;
 }
 EXPORT_SYMBOL(__alloc_pages_nodemask);
@@ -2717,6 +2727,31 @@ void free_pages(unsigned long addr, unsi
 
 EXPORT_SYMBOL(free_pages);
 
+/*
+ * __free_memcg_kmem_pages and free_memcg_kmem_pages will free
+ * pages allocated with __GFP_KMEMCG.
+ *
+ * Those pages are accounted to a particular memcg, embedded in the
+ * corresponding page_cgroup. To avoid adding a hit in the allocator to search
+ * for that information only to find out that it is NULL for users who have no
+ * interest in that whatsoever, we provide these functions.
+ *
+ * The caller knows better which flags it relies on.
+ */
+void __free_memcg_kmem_pages(struct page *page, unsigned int order)
+{
+	memcg_kmem_uncharge_pages(page, order);
+	__free_pages(page, order);
+}
+
+void free_memcg_kmem_pages(unsigned long addr, unsigned int order)
+{
+	if (addr != 0) {
+		VM_BUG_ON(!virt_addr_valid((void *)addr));
+		__free_memcg_kmem_pages(virt_to_page((void *)addr), order);
+	}
+}
+
 static void *make_alloc_exact(unsigned long addr, unsigned order, size_t size)
 {
 	if (addr) {
_

Patches currently in -mm which might be from glommer@parallels.com are

origin.patch
memcg-debugging-facility-to-access-dangling-memcgs.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch

