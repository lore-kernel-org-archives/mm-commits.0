From: akpm@linux-foundation.org
Subject: [folded] page_cgroup-add-helper-function-to-get-swap_cgroup-cleanup.patch removed from -mm tree
Date: Thu, 12 Jan 2012 16:48:31 -0800
Message-ID: <20120113004831.EEA7910004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:47307 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424Ab2AMAsd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2012 19:48:33 -0500
Received: by yenm2 with SMTP id m2so2478yen.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2012 16:48:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lliubbo@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: page_cgroup: cleanup lookup_swap_cgroup()
has been removed from the -mm tree.  Its filename was
     page_cgroup-add-helper-function-to-get-swap_cgroup-cleanup.patch

This patch was dropped because it was folded into page_cgroup-add-helper-function-to-get-swap_cgroup.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Bob Liu <lliubbo@gmail.com>
Subject: page_cgroup: cleanup lookup_swap_cgroup()

This patch is based on my previous patch:
page_cgroup: add helper function to get swap_cgroup

As Johannes suggested, change the public interface to
lookup_swap_cgroup_id(), replace swap_cgroup_getsc() with
lookup_swap_cgroup() and do some extra cleanup.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_cgroup.h |    4 +--
 mm/memcontrol.c             |    4 +--
 mm/page_cgroup.c            |   37 +++++++++++++---------------------
 3 files changed, 19 insertions(+), 26 deletions(-)

diff -puN include/linux/page_cgroup.h~page_cgroup-add-helper-function-to-get-swap_cgroup-cleanup include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~page_cgroup-add-helper-function-to-get-swap_cgroup-cleanup
+++ a/include/linux/page_cgroup.h
@@ -149,7 +149,7 @@ static inline void __init page_cgroup_in
 extern unsigned short swap_cgroup_cmpxchg(swp_entry_t ent,
 					unsigned short old, unsigned short new);
 extern unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id);
-extern unsigned short lookup_swap_cgroup(swp_entry_t ent);
+extern unsigned short lookup_swap_cgroup_id(swp_entry_t ent);
 extern int swap_cgroup_swapon(int type, unsigned long max_pages);
 extern void swap_cgroup_swapoff(int type);
 #else
@@ -161,7 +161,7 @@ unsigned short swap_cgroup_record(swp_en
 }
 
 static inline
-unsigned short lookup_swap_cgroup(swp_entry_t ent)
+unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
 {
 	return 0;
 }
diff -puN mm/memcontrol.c~page_cgroup-add-helper-function-to-get-swap_cgroup-cleanup mm/memcontrol.c
--- a/mm/memcontrol.c~page_cgroup-add-helper-function-to-get-swap_cgroup-cleanup
+++ a/mm/memcontrol.c
@@ -2474,7 +2474,7 @@ struct mem_cgroup *try_get_mem_cgroup_fr
 			memcg = NULL;
 	} else if (PageSwapCache(page)) {
 		ent.val = page_private(page);
-		id = lookup_swap_cgroup(ent);
+		id = lookup_swap_cgroup_id(ent);
 		rcu_read_lock();
 		memcg = mem_cgroup_lookup(id);
 		if (memcg && !css_tryget(&memcg->css))
@@ -5264,7 +5264,7 @@ static int is_target_pte_for_mc(struct v
 	}
 	/* There is a swap entry and a page doesn't exist or isn't charged */
 	if (ent.val && !ret &&
-			css_id(&mc.from->css) == lookup_swap_cgroup(ent)) {
+			css_id(&mc.from->css) == lookup_swap_cgroup_id(ent)) {
 		ret = MC_TARGET_SWAP;
 		if (target)
 			target->ent = ent;
diff -puN mm/page_cgroup.c~page_cgroup-add-helper-function-to-get-swap_cgroup-cleanup mm/page_cgroup.c
--- a/mm/page_cgroup.c~page_cgroup-add-helper-function-to-get-swap_cgroup-cleanup
+++ a/mm/page_cgroup.c
@@ -334,7 +334,6 @@ struct swap_cgroup {
 	unsigned short		id;
 };
 #define SC_PER_PAGE	(PAGE_SIZE/sizeof(struct swap_cgroup))
-#define SC_POS_MASK	(SC_PER_PAGE - 1)
 
 /*
  * SwapCgroup implements "lookup" and "exchange" operations.
@@ -376,25 +375,19 @@ not_enough_page:
 	return -ENOMEM;
 }
 
-static struct swap_cgroup *swap_cgroup_getsc(swp_entry_t ent,
-					struct swap_cgroup_ctrl **ctrl)
+static struct swap_cgroup *lookup_swap_cgroup(swp_entry_t ent,
+					struct swap_cgroup_ctrl **ctrlp)
 {
-	int type = swp_type(ent);
-	unsigned long offset = swp_offset(ent);
-	unsigned long idx = offset / SC_PER_PAGE;
-	unsigned long pos = offset & SC_POS_MASK;
-	struct swap_cgroup_ctrl *temp_ctrl;
+	pgoff_t offset = swp_offset(ent);
+	struct swap_cgroup_ctrl *ctrl;
 	struct page *mappage;
-	struct swap_cgroup *sc;
 
-	temp_ctrl = &swap_cgroup_ctrl[type];
-	if (ctrl)
-		*ctrl = temp_ctrl;
-
-	mappage = temp_ctrl->map[idx];
-	sc = page_address(mappage);
-	sc += pos;
-	return sc;
+	ctrl = &swap_cgroup_ctrl[swp_type(ent)];
+	if (ctrlp)
+		*ctrlp = ctrl;
+
+	mappage = ctrl->map[offset / SC_PER_PAGE];
+	return page_address(mappage) + offset % SC_PER_PAGE;
 }
 
 /**
@@ -414,7 +407,7 @@ unsigned short swap_cgroup_cmpxchg(swp_e
 	unsigned long flags;
 	unsigned short retval;
 
-	sc = swap_cgroup_getsc(ent, &ctrl);
+	sc = lookup_swap_cgroup(ent, &ctrl);
 
 	spin_lock_irqsave(&ctrl->lock, flags);
 	retval = sc->id;
@@ -441,7 +434,7 @@ unsigned short swap_cgroup_record(swp_en
 	unsigned short old;
 	unsigned long flags;
 
-	sc = swap_cgroup_getsc(ent, &ctrl);
+	sc = lookup_swap_cgroup(ent, &ctrl);
 
 	spin_lock_irqsave(&ctrl->lock, flags);
 	old = sc->id;
@@ -452,14 +445,14 @@ unsigned short swap_cgroup_record(swp_en
 }
 
 /**
- * lookup_swap_cgroup - lookup mem_cgroup tied to swap entry
+ * lookup_swap_cgroup_id - lookup mem_cgroup id tied to swap entry
  * @ent: swap entry to be looked up.
  *
  * Returns CSS ID of mem_cgroup at success. 0 at failure. (0 is invalid ID)
  */
-unsigned short lookup_swap_cgroup(swp_entry_t ent)
+unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
 {
-	return swap_cgroup_getsc(ent, NULL)->id;
+	return lookup_swap_cgroup(ent, NULL)->id;
 }
 
 int swap_cgroup_swapon(int type, unsigned long max_pages)
_

Patches currently in -mm which might be from lliubbo@gmail.com are

origin.patch
page_cgroup-add-helper-function-to-get-swap_cgroup.patch
memcg-cleanup-for_each_node_state.patch
page_alloc-break-early-in-check_for_regular_memory.patch
page_cgroup-drop-multi-config_memory_hotplug.patch

