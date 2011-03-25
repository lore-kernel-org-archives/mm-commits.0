From: akpm@linux-foundation.org
Subject: [merged] memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:24:39 -0700
Message-ID: <201103250724.p2P7OX7P025869@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754203Ab1CYHYn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:24:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     memcg: add memcg sanity checks at allocating and freeing pages
has been removed from the -mm tree.  Its filename was
     memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: add memcg sanity checks at allocating and freeing pages
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Add checks at allocating or freeing a page whether the page is used (iow,
charged) from the view point of memcg.

This check may be useful in debugging a problem and we did similar checks
before the commit 52d4b9ac(memcg: allocate all page_cgroup at boot).

This patch adds some overheads at allocating or freeing memory, so it's
enabled only when CONFIG_DEBUG_VM is enabled.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   17 ++++++++++++
 mm/memcontrol.c            |   46 +++++++++++++++++++++++++++++++++++
 mm/page_alloc.c            |    8 ++++--
 3 files changed, 69 insertions(+), 2 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages
+++ a/include/linux/memcontrol.h
@@ -151,6 +151,10 @@ u64 mem_cgroup_get_limit(struct mem_cgro
 void mem_cgroup_split_huge_fixup(struct page *head, struct page *tail);
 #endif
 
+#ifdef CONFIG_DEBUG_VM
+bool mem_cgroup_bad_page_check(struct page *page);
+void mem_cgroup_print_bad_page(struct page *page);
+#endif
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct mem_cgroup;
 
@@ -352,5 +356,18 @@ static inline void mem_cgroup_split_huge
 
 #endif /* CONFIG_CGROUP_MEM_CONT */
 
+#if !defined(CONFIG_CGROUP_MEM_RES_CTLR) || !defined(CONFIG_DEBUG_VM)
+static inline bool
+mem_cgroup_bad_page_check(struct page *page)
+{
+	return false;
+}
+
+static inline void
+mem_cgroup_print_bad_page(struct page *page)
+{
+}
+#endif
+
 #endif /* _LINUX_MEMCONTROL_H */
 
diff -puN mm/memcontrol.c~memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages
+++ a/mm/memcontrol.c
@@ -3046,6 +3046,52 @@ int mem_cgroup_shmem_charge_fallback(str
 	return ret;
 }
 
+#ifdef CONFIG_DEBUG_VM
+static struct page_cgroup *lookup_page_cgroup_used(struct page *page)
+{
+	struct page_cgroup *pc;
+
+	pc = lookup_page_cgroup(page);
+	if (likely(pc) && PageCgroupUsed(pc))
+		return pc;
+	return NULL;
+}
+
+bool mem_cgroup_bad_page_check(struct page *page)
+{
+	if (mem_cgroup_disabled())
+		return false;
+
+	return lookup_page_cgroup_used(page) != NULL;
+}
+
+void mem_cgroup_print_bad_page(struct page *page)
+{
+	struct page_cgroup *pc;
+
+	pc = lookup_page_cgroup_used(page);
+	if (pc) {
+		int ret = -1;
+		char *path;
+
+		printk(KERN_ALERT "pc:%p pc->flags:%lx pc->mem_cgroup:%p",
+		       pc, pc->flags, pc->mem_cgroup);
+
+		path = kmalloc(PATH_MAX, GFP_KERNEL);
+		if (path) {
+			rcu_read_lock();
+			ret = cgroup_path(pc->mem_cgroup->css.cgroup,
+							path, PATH_MAX);
+			rcu_read_unlock();
+		}
+
+		printk(KERN_CONT "(%s)\n",
+				(ret < 0) ? "cannot get the path" : path);
+		kfree(path);
+	}
+}
+#endif
+
 static DEFINE_MUTEX(set_limit_mutex);
 
 static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
diff -puN mm/page_alloc.c~memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages mm/page_alloc.c
--- a/mm/page_alloc.c~memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages
+++ a/mm/page_alloc.c
@@ -53,6 +53,7 @@
 #include <linux/compaction.h>
 #include <trace/events/kmem.h>
 #include <linux/ftrace_event.h>
+#include <linux/memcontrol.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -565,7 +566,8 @@ static inline int free_pages_check(struc
 	if (unlikely(page_mapcount(page) |
 		(page->mapping != NULL)  |
 		(atomic_read(&page->_count) != 0) |
-		(page->flags & PAGE_FLAGS_CHECK_AT_FREE))) {
+		(page->flags & PAGE_FLAGS_CHECK_AT_FREE) |
+		(mem_cgroup_bad_page_check(page)))) {
 		bad_page(page);
 		return 1;
 	}
@@ -754,7 +756,8 @@ static inline int check_new_page(struct 
 	if (unlikely(page_mapcount(page) |
 		(page->mapping != NULL)  |
 		(atomic_read(&page->_count) != 0)  |
-		(page->flags & PAGE_FLAGS_CHECK_AT_PREP))) {
+		(page->flags & PAGE_FLAGS_CHECK_AT_PREP) |
+		(mem_cgroup_bad_page_check(page)))) {
 		bad_page(page);
 		return 1;
 	}
@@ -5684,4 +5687,5 @@ void dump_page(struct page *page)
 		page, atomic_read(&page->_count), page_mapcount(page),
 		page->mapping, page->index);
 	dump_page_flags(page->flags);
+	mem_cgroup_print_bad_page(page);
 }
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

origin.patch
memsw-remove-noswapaccount-kernel-parameter.patch
memcg-document-cgroup-dirty-memory-interfaces.patch
memcg-add-page_cgroup-flags-for-dirty-page-tracking.patch
memcg-add-dirty-page-accounting-infrastructure.patch
memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-add-dirty-limiting-routines.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-make-background-writeback-memcg-aware.patch

