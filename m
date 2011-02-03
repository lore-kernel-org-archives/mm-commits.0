From: akpm@linux-foundation.org
Subject: + memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch added to -mm tree
Date: Thu, 03 Feb 2011 15:27:40 -0800
Message-ID: <201102032327.p13NRelh031124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752210Ab1BCX2W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 18:28:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com


The patch titled
     memcg: add memcg sanity checks at allocating and freeing pages
has been added to the -mm tree.  Its filename is
     memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   17 +++++++++++++++++
 mm/memcontrol.c            |   30 ++++++++++++++++++++++++++++++
 mm/page_alloc.c            |    8 ++++++--
 3 files changed, 53 insertions(+), 2 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages
+++ a/include/linux/memcontrol.h
@@ -150,6 +150,10 @@ u64 mem_cgroup_get_limit(struct mem_cgro
 void mem_cgroup_split_huge_fixup(struct page *head, struct page *tail);
 #endif
 
+#ifdef CONFIG_DEBUG_VM
+bool mem_cgroup_bad_page_check(struct page *page);
+void mem_cgroup_print_bad_page(struct page *page);
+#endif
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct mem_cgroup;
 
@@ -346,5 +350,18 @@ static inline void mem_cgroup_split_huge
 
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
@@ -3020,6 +3020,36 @@ int mem_cgroup_shmem_charge_fallback(str
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
+	if (pc)
+		printk(KERN_ALERT "pc:%p pc->flags:%ld pc->mem_cgroup:%p\n",
+		       pc, pc->flags, pc->mem_cgroup);
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
@@ -750,7 +752,8 @@ static inline int check_new_page(struct 
 	if (unlikely(page_mapcount(page) |
 		(page->mapping != NULL)  |
 		(atomic_read(&page->_count) != 0)  |
-		(page->flags & PAGE_FLAGS_CHECK_AT_PREP))) {
+		(page->flags & PAGE_FLAGS_CHECK_AT_PREP) |
+		(mem_cgroup_bad_page_check(page)))) {
 		bad_page(page);
 		return 1;
 	}
@@ -5687,4 +5690,5 @@ void dump_page(struct page *page)
 		page, atomic_read(&page->_count), page_mapcount(page),
 		page->mapping, page->index);
 	dump_page_flags(page->flags);
+	mem_cgroup_print_bad_page(page);
 }
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

origin.patch
memsw-remove-noswapaccount-kernel-parameter.patch
memcg-fix-ugly-initialization-of-return-value-is-in-caller.patch
memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch
memcg-simplify-the-way-memory-limits-are-checked.patch
memcg-remove-unused-page-flag-bitfield-defines.patch
memcg-remove-impossible-conditional-when-committing.patch
memcg-remove-null-check-from-lookup_page_cgroup-result.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch

