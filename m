From: akpm@linux-foundation.org
Subject: [merged] memcg-clear-pc-mem_cgorup-if-necessary.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:34:17 -0800
Message-ID: <20120113203417.B4C3D1E0058@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:60293 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759096Ab2AMUeS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:34:18 -0500
Received: by ghrr18 with SMTP id r18so207216ghr.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:34:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, mszeredi@suse.cz, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: clear pc->mem_cgroup if necessary.
has been removed from the -mm tree.  Its filename was
     memcg-clear-pc-mem_cgorup-if-necessary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: memcg: clear pc->mem_cgroup if necessary.

This is a preparation before removing a flag PCG_ACCT_LRU in page_cgroup
and reducing atomic ops/complexity in memcg LRU handling.

In some cases, pages are added to lru before charge to memcg and pages are
not classfied to memory cgroup at lru addtion.  Now, the lru where the
page should be added is determined a bit in page_cgroup->flags and
pc->mem_cgroup.  I'd like to remove the check of flag.

To handle the case pc->mem_cgroup may contain stale pointers if pages are
added to LRU before classification.  This patch resets pc->mem_cgroup to
root_mem_cgroup before lru additions.

[akpm@linux-foundation.org: fix CONFIG_CGROUP_MEM_CONT=n build]
[hughd@google.com: fix CONFIG_CGROUP_MEM_RES_CTLR=y CONFIG_CGROUP_MEM_RES_CTLR_SWAP=n build]
[akpm@linux-foundation.org: ksm.c needs memcontrol.h, per Michal]
[hughd@google.com: stop oops in mem_cgroup_reset_owner()]
[hughd@google.com: fix page migration to reset_owner]
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 +++++
 mm/ksm.c                   |   11 +++++++++++
 mm/memcontrol.c            |   17 +++++++++++++++++
 mm/migrate.c               |    2 ++
 mm/swap_state.c            |   10 ++++++++++
 5 files changed, 45 insertions(+)

diff -puN include/linux/memcontrol.h~memcg-clear-pc-mem_cgorup-if-necessary include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-clear-pc-mem_cgorup-if-necessary
+++ a/include/linux/memcontrol.h
@@ -129,6 +129,7 @@ extern void mem_cgroup_print_oom_info(st
 extern void mem_cgroup_replace_page_cache(struct page *oldpage,
 					struct page *newpage);
 
+extern void mem_cgroup_reset_owner(struct page *page);
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 extern int do_swap_account;
 #endif
@@ -391,6 +392,10 @@ static inline void mem_cgroup_replace_pa
 				struct page *newpage)
 {
 }
+
+static inline void mem_cgroup_reset_owner(struct page *page)
+{
+}
 #endif /* CONFIG_CGROUP_MEM_CONT */
 
 #if !defined(CONFIG_CGROUP_MEM_RES_CTLR) || !defined(CONFIG_DEBUG_VM)
diff -puN mm/ksm.c~memcg-clear-pc-mem_cgorup-if-necessary mm/ksm.c
--- a/mm/ksm.c~memcg-clear-pc-mem_cgorup-if-necessary
+++ a/mm/ksm.c
@@ -28,6 +28,7 @@
 #include <linux/kthread.h>
 #include <linux/wait.h>
 #include <linux/slab.h>
+#include <linux/memcontrol.h>
 #include <linux/rbtree.h>
 #include <linux/memory.h>
 #include <linux/mmu_notifier.h>
@@ -1571,6 +1572,16 @@ struct page *ksm_does_need_to_copy(struc
 
 	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
 	if (new_page) {
+		/*
+		 * The memcg-specific accounting when moving
+		 * pages around the LRU lists relies on the
+		 * page's owner (memcg) to be valid.  Usually,
+		 * pages are assigned to a new owner before
+		 * being put on the LRU list, but since this
+		 * is not the case here, the stale owner from
+		 * a previous allocation cycle must be reset.
+		 */
+		mem_cgroup_reset_owner(new_page);
 		copy_user_highpage(new_page, page, address, vma);
 
 		SetPageDirty(new_page);
diff -puN mm/memcontrol.c~memcg-clear-pc-mem_cgorup-if-necessary mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-clear-pc-mem_cgorup-if-necessary
+++ a/mm/memcontrol.c
@@ -3050,6 +3050,23 @@ void mem_cgroup_uncharge_end(void)
 	batch->memcg = NULL;
 }
 
+/*
+ * A function for resetting pc->mem_cgroup for newly allocated pages.
+ * This function should be called if the newpage will be added to LRU
+ * before start accounting.
+ */
+void mem_cgroup_reset_owner(struct page *newpage)
+{
+	struct page_cgroup *pc;
+
+	if (mem_cgroup_disabled())
+		return;
+
+	pc = lookup_page_cgroup(newpage);
+	VM_BUG_ON(PageCgroupUsed(pc));
+	pc->mem_cgroup = root_mem_cgroup;
+}
+
 #ifdef CONFIG_SWAP
 /*
  * called after __delete_from_swap_cache() and drop "page" account.
diff -puN mm/migrate.c~memcg-clear-pc-mem_cgorup-if-necessary mm/migrate.c
--- a/mm/migrate.c~memcg-clear-pc-mem_cgorup-if-necessary
+++ a/mm/migrate.c
@@ -777,6 +777,8 @@ static int unmap_and_move(new_page_t get
 	if (!newpage)
 		return -ENOMEM;
 
+	mem_cgroup_reset_owner(newpage);
+
 	if (page_count(page) == 1) {
 		/* page was freed from under us. So we are done. */
 		goto out;
diff -puN mm/swap_state.c~memcg-clear-pc-mem_cgorup-if-necessary mm/swap_state.c
--- a/mm/swap_state.c~memcg-clear-pc-mem_cgorup-if-necessary
+++ a/mm/swap_state.c
@@ -300,6 +300,16 @@ struct page *read_swap_cache_async(swp_e
 			new_page = alloc_page_vma(gfp_mask, vma, addr);
 			if (!new_page)
 				break;		/* Out of memory */
+			/*
+			 * The memcg-specific accounting when moving
+			 * pages around the LRU lists relies on the
+			 * page's owner (memcg) to be valid.  Usually,
+			 * pages are assigned to a new owner before
+			 * being put on the LRU list, but since this
+			 * is not the case here, the stale owner from
+			 * a previous allocation cycle must be reset.
+			 */
+			mem_cgroup_reset_owner(new_page);
 		}
 
 		/*
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
mm-fix-null-ptr-dereference-in-__count_immobile_pages.patch
mm-__count_immobile_pages-make-sure-the-node-is-online.patch
mm-hugetlb-undo-change-to-page-mapcount-in-fault-handler.patch

