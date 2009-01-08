From: akpm@linux-foundation.org
Subject: - memcg-add-mem_cgroup_disabled.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:48:31 -0800
Message-ID: <200901082248.n08MmVI7027850@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39455 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751811AbZAHWtN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:49:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: taka@valinux.co.jp, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     memcg: add mem_cgroup_disabled()
has been removed from the -mm tree.  Its filename was
     memcg-add-mem_cgroup_disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: add mem_cgroup_disabled()
From: Hirokazu Takahashi <taka@valinux.co.jp>

We check mem_cgroup is disabled or not by checking
mem_cgroup_subsys.disabled.  I think it has more references than expected,
now.

replacing
   if (mem_cgroup_subsys.disabled)
with
   if (mem_cgroup_disabled())

give us good look, I think.

[kamezawa.hiroyu@jp.fujitsu.com: fix typo]
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   15 ++++++++++++++-
 mm/memcontrol.c            |   28 ++++++++++++++--------------
 mm/page_cgroup.c           |    4 ++--
 3 files changed, 30 insertions(+), 17 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-add-mem_cgroup_disabled include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-add-mem_cgroup_disabled
+++ a/include/linux/memcontrol.h
@@ -19,7 +19,7 @@
 
 #ifndef _LINUX_MEMCONTROL_H
 #define _LINUX_MEMCONTROL_H
-
+#include <linux/cgroup.h>
 struct mem_cgroup;
 struct page_cgroup;
 struct page;
@@ -87,6 +87,14 @@ extern long mem_cgroup_calc_reclaim(stru
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 extern int do_swap_account;
 #endif
+
+static inline bool mem_cgroup_disabled(void)
+{
+	if (mem_cgroup_subsys.disabled)
+		return true;
+	return false;
+}
+
 #else /* CONFIG_CGROUP_MEM_RES_CTLR */
 struct mem_cgroup;
 
@@ -214,6 +222,11 @@ static inline long mem_cgroup_calc_recla
 {
 	return 0;
 }
+
+static inline bool mem_cgroup_disabled(void)
+{
+	return true;
+}
 #endif /* CONFIG_CGROUP_MEM_CONT */
 
 #endif /* _LINUX_MEMCONTROL_H */
diff -puN mm/memcontrol.c~memcg-add-mem_cgroup_disabled mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-mem_cgroup_disabled
+++ a/mm/memcontrol.c
@@ -279,7 +279,7 @@ void mem_cgroup_del_lru_list(struct page
 	struct mem_cgroup *mem;
 	struct mem_cgroup_per_zone *mz;
 
-	if (mem_cgroup_subsys.disabled)
+	if (mem_cgroup_disabled())
 		return;
 	pc = lookup_page_cgroup(page);
 	/* can happen while we handle swapcache. */
@@ -302,7 +302,7 @@ void mem_cgroup_rotate_lru_list(struct p
 	struct mem_cgroup_per_zone *mz;
 	struct page_cgroup *pc;
 
-	if (mem_cgroup_subsys.disabled)
+	if (mem_cgroup_disabled())
 		return;
 
 	pc = lookup_page_cgroup(page);
@@ -319,7 +319,7 @@ void mem_cgroup_add_lru_list(struct page
 	struct page_cgroup *pc;
 	struct mem_cgroup_per_zone *mz;
 
-	if (mem_cgroup_subsys.disabled)
+	if (mem_cgroup_disabled())
 		return;
 	pc = lookup_page_cgroup(page);
 	/* barrier to sync with "charge" */
@@ -344,7 +344,7 @@ static void mem_cgroup_lru_fixup(struct 
 void mem_cgroup_move_lists(struct page *page,
 			   enum lru_list from, enum lru_list to)
 {
-	if (mem_cgroup_subsys.disabled)
+	if (mem_cgroup_disabled())
 		return;
 	mem_cgroup_del_lru_list(page, from);
 	mem_cgroup_add_lru_list(page, to);
@@ -731,7 +731,7 @@ static int mem_cgroup_charge_common(stru
 int mem_cgroup_newpage_charge(struct page *page,
 			      struct mm_struct *mm, gfp_t gfp_mask)
 {
-	if (mem_cgroup_subsys.disabled)
+	if (mem_cgroup_disabled())
 		return 0;
 	if (PageCompound(page))
 		return 0;
@@ -753,7 +753,7 @@ int mem_cgroup_newpage_charge(struct pag
 int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask)
 {
-	if (mem_cgroup_subsys.disabled)
+	if (mem_cgroup_disabled())
 		return 0;
 	if (PageCompound(page))
 		return 0;
@@ -799,7 +799,7 @@ int mem_cgroup_try_charge_swapin(struct 
 	struct mem_cgroup *mem;
 	swp_entry_t     ent;
 
-	if (mem_cgroup_subsys.disabled)
+	if (mem_cgroup_disabled())
 		return 0;
 
 	if (!do_swap_account)
@@ -833,7 +833,7 @@ int mem_cgroup_cache_charge_swapin(struc
 {
 	int ret = 0;
 
-	if (mem_cgroup_subsys.disabled)
+	if (mem_cgroup_disabled())
 		return 0;
 	if (unlikely(!mm))
 		mm = &init_mm;
@@ -880,7 +880,7 @@ void mem_cgroup_commit_charge_swapin(str
 {
 	struct page_cgroup *pc;
 
-	if (mem_cgroup_subsys.disabled)
+	if (mem_cgroup_disabled())
 		return;
 	if (!ptr)
 		return;
@@ -909,7 +909,7 @@ void mem_cgroup_commit_charge_swapin(str
 
 void mem_cgroup_cancel_charge_swapin(struct mem_cgroup *mem)
 {
-	if (mem_cgroup_subsys.disabled)
+	if (mem_cgroup_disabled())
 		return;
 	if (!mem)
 		return;
@@ -930,7 +930,7 @@ __mem_cgroup_uncharge_common(struct page
 	struct mem_cgroup *mem = NULL;
 	struct mem_cgroup_per_zone *mz;
 
-	if (mem_cgroup_subsys.disabled)
+	if (mem_cgroup_disabled())
 		return NULL;
 
 	if (PageSwapCache(page))
@@ -1049,7 +1049,7 @@ int mem_cgroup_prepare_migration(struct 
 	struct mem_cgroup *mem = NULL;
 	int ret = 0;
 
-	if (mem_cgroup_subsys.disabled)
+	if (mem_cgroup_disabled())
 		return 0;
 
 	pc = lookup_page_cgroup(page);
@@ -1131,7 +1131,7 @@ int mem_cgroup_shrink_usage(struct mm_st
 	int progress = 0;
 	int retry = MEM_CGROUP_RECLAIM_RETRIES;
 
-	if (mem_cgroup_subsys.disabled)
+	if (mem_cgroup_disabled())
 		return 0;
 	if (!mm)
 		return 0;
@@ -1697,7 +1697,7 @@ static void mem_cgroup_put(struct mem_cg
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 static void __init enable_swap_cgroup(void)
 {
-	if (!mem_cgroup_subsys.disabled && really_do_swap_account)
+	if (!mem_cgroup_disabled() && really_do_swap_account)
 		do_swap_account = 1;
 }
 #else
diff -puN mm/page_cgroup.c~memcg-add-mem_cgroup_disabled mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcg-add-mem_cgroup_disabled
+++ a/mm/page_cgroup.c
@@ -74,7 +74,7 @@ void __init page_cgroup_init(void)
 
 	int nid, fail;
 
-	if (mem_cgroup_subsys.disabled)
+	if (mem_cgroup_disabled())
 		return;
 
 	for_each_online_node(nid)  {
@@ -247,7 +247,7 @@ void __init page_cgroup_init(void)
 	unsigned long pfn;
 	int fail = 0;
 
-	if (mem_cgroup_subsys.disabled)
+	if (mem_cgroup_disabled())
 		return;
 
 	for (pfn = 0; !fail && pfn < max_pfn; pfn += PAGES_PER_SECTION) {
_

Patches currently in -mm which might be from taka@valinux.co.jp are

origin.patch

