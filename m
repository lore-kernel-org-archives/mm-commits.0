From: akpm@linux-foundation.org
Subject: + memcg-add-mem_cgroup_disabled.patch added to -mm tree
Date: Fri, 14 Nov 2008 17:06:46 -0800
Message-ID: <200811150106.mAF16kkq006705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752041AbYKOBHD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 20:07:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: taka@valinux.co.jp, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, xemul@openvz.org


The patch titled
     memcg: add mem_cgroup_disabled()
has been added to the -mm tree.  Its filename is
     memcg-add-mem_cgroup_disabled.patch

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

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   13 +++++++++++++
 mm/memcontrol.c            |   28 ++++++++++++++--------------
 mm/page_cgroup.c           |    4 ++--
 3 files changed, 29 insertions(+), 16 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-add-mem_cgroup_disabled include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-add-mem_cgroup_disabled
+++ a/include/linux/memcontrol.h
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
@@ -278,7 +278,7 @@ void mem_cgroup_del_lru_list(struct page
 	struct mem_cgroup *mem;
 	struct mem_cgroup_per_zone *mz;
 
-	if (mem_cgroup_subsys.disabled)
+	if (mem_cgroup_disabled())
 		return;
 	pc = lookup_page_cgroup(page);
 	/* can happen while we handle swapcache. */
@@ -301,7 +301,7 @@ void mem_cgroup_rotate_lru_list(struct p
 	struct mem_cgroup_per_zone *mz;
 	struct page_cgroup *pc;
 
-	if (mem_cgroup_subsys.disabled)
+	if (mem_cgroup_diabled())
 		return;
 
 	pc = lookup_page_cgroup(page);
@@ -318,7 +318,7 @@ void mem_cgroup_add_lru_list(struct page
 	struct page_cgroup *pc;
 	struct mem_cgroup_per_zone *mz;
 
-	if (mem_cgroup_subsys.disabled)
+	if (mem_cgroup_disabled())
 		return;
 	pc = lookup_page_cgroup(page);
 	/* barrier to sync with "charge" */
@@ -343,7 +343,7 @@ static void mem_cgroup_lru_fixup(struct 
 void mem_cgroup_move_lists(struct page *page,
 			   enum lru_list from, enum lru_list to)
 {
-	if (mem_cgroup_subsys.disabled)
+	if (mem_cgroup_disabled())
 		return;
 	mem_cgroup_del_lru_list(page, from);
 	mem_cgroup_add_lru_list(page, to);
@@ -730,7 +730,7 @@ static int mem_cgroup_charge_common(stru
 int mem_cgroup_newpage_charge(struct page *page,
 			      struct mm_struct *mm, gfp_t gfp_mask)
 {
-	if (mem_cgroup_subsys.disabled)
+	if (mem_cgroup_disabled())
 		return 0;
 	if (PageCompound(page))
 		return 0;
@@ -752,7 +752,7 @@ int mem_cgroup_newpage_charge(struct pag
 int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask)
 {
-	if (mem_cgroup_subsys.disabled)
+	if (mem_cgroup_disabled())
 		return 0;
 	if (PageCompound(page))
 		return 0;
@@ -798,7 +798,7 @@ int mem_cgroup_try_charge_swapin(struct 
 	struct mem_cgroup *mem;
 	swp_entry_t     ent;
 
-	if (mem_cgroup_subsys.disabled)
+	if (mem_cgroup_disabled())
 		return 0;
 
 	if (!do_swap_account)
@@ -824,7 +824,7 @@ int mem_cgroup_cache_charge_swapin(struc
 {
 	int ret = 0;
 
-	if (mem_cgroup_subsys.disabled)
+	if (mem_cgroup_disabled())
 		return 0;
 	if (unlikely(!mm))
 		mm = &init_mm;
@@ -871,7 +871,7 @@ void mem_cgroup_commit_charge_swapin(str
 {
 	struct page_cgroup *pc;
 
-	if (mem_cgroup_subsys.disabled)
+	if (mem_cgroup_disabled())
 		return;
 	if (!ptr)
 		return;
@@ -900,7 +900,7 @@ void mem_cgroup_commit_charge_swapin(str
 
 void mem_cgroup_cancel_charge_swapin(struct mem_cgroup *mem)
 {
-	if (mem_cgroup_subsys.disabled)
+	if (mem_cgroup_disabled())
 		return;
 	if (!mem)
 		return;
@@ -921,7 +921,7 @@ __mem_cgroup_uncharge_common(struct page
 	struct mem_cgroup *mem = NULL;
 	struct mem_cgroup_per_zone *mz;
 
-	if (mem_cgroup_subsys.disabled)
+	if (mem_cgroup_disabled())
 		return NULL;
 
 	if (PageSwapCache(page))
@@ -1040,7 +1040,7 @@ int mem_cgroup_prepare_migration(struct 
 	struct mem_cgroup *mem = NULL;
 	int ret = 0;
 
-	if (mem_cgroup_subsys.disabled)
+	if (mem_cgroup_disabled())
 		return 0;
 
 	pc = lookup_page_cgroup(page);
@@ -1122,7 +1122,7 @@ int mem_cgroup_shrink_usage(struct mm_st
 	int progress = 0;
 	int retry = MEM_CGROUP_RECLAIM_RETRIES;
 
-	if (mem_cgroup_subsys.disabled)
+	if (mem_cgroup_disabled())
 		return 0;
 	if (!mm)
 		return 0;
@@ -1675,7 +1675,7 @@ static void mem_cgroup_put(struct mem_cg
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
@@ -72,7 +72,7 @@ void __init page_cgroup_init(void)
 
 	int nid, fail;
 
-	if (mem_cgroup_subsys.disabled)
+	if (mem_cgroup_disabled())
 		return;
 
 	for_each_online_node(nid)  {
@@ -244,7 +244,7 @@ void __init page_cgroup_init(void)
 	unsigned long pfn;
 	int fail = 0;
 
-	if (mem_cgroup_subsys.disabled)
+	if (mem_cgroup_disabled())
 		return;
 
 	for (pfn = 0; !fail && pfn < max_pfn; pfn += PAGES_PER_SECTION) {
_

Patches currently in -mm which might be from taka@valinux.co.jp are

memcg-add-mem_cgroup_disabled.patch

