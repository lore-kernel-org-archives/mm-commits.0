From: akpm@linux-foundation.org
Subject: [merged] page_cgroup-add-helper-function-to-get-swap_cgroup.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:33:56 -0800
Message-ID: <20120113203357.1BEB05C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:37836 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759098Ab2AMUd6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:33:58 -0500
Received: by mail-ey0-f202.google.com with SMTP id d12so25396eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:33:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lliubbo@gmail.com, jweiner@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: page_cgroup: add helper function to get swap_cgroup
has been removed from the -mm tree.  Its filename was
     page_cgroup-add-helper-function-to-get-swap_cgroup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Bob Liu <lliubbo@gmail.com>
Subject: page_cgroup: add helper function to get swap_cgroup

There are multiple places which need to get the swap_cgroup address, so
add a helper function:

static struct swap_cgroup *swap_cgroup_getsc(swp_entry_t ent,
                                struct swap_cgroup_ctrl **ctrl);
to simplify the code.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_cgroup.h |    4 +-
 mm/memcontrol.c             |    4 +-
 mm/page_cgroup.c            |   56 ++++++++++++----------------------
 3 files changed, 24 insertions(+), 40 deletions(-)

diff -puN include/linux/page_cgroup.h~page_cgroup-add-helper-function-to-get-swap_cgroup include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~page_cgroup-add-helper-function-to-get-swap_cgroup
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
diff -puN mm/memcontrol.c~page_cgroup-add-helper-function-to-get-swap_cgroup mm/memcontrol.c
--- a/mm/memcontrol.c~page_cgroup-add-helper-function-to-get-swap_cgroup
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
diff -puN mm/page_cgroup.c~page_cgroup-add-helper-function-to-get-swap_cgroup mm/page_cgroup.c
--- a/mm/page_cgroup.c~page_cgroup-add-helper-function-to-get-swap_cgroup
+++ a/mm/page_cgroup.c
@@ -334,7 +334,6 @@ struct swap_cgroup {
 	unsigned short		id;
 };
 #define SC_PER_PAGE	(PAGE_SIZE/sizeof(struct swap_cgroup))
-#define SC_POS_MASK	(SC_PER_PAGE - 1)
 
 /*
  * SwapCgroup implements "lookup" and "exchange" operations.
@@ -376,6 +375,21 @@ not_enough_page:
 	return -ENOMEM;
 }
 
+static struct swap_cgroup *lookup_swap_cgroup(swp_entry_t ent,
+					struct swap_cgroup_ctrl **ctrlp)
+{
+	pgoff_t offset = swp_offset(ent);
+	struct swap_cgroup_ctrl *ctrl;
+	struct page *mappage;
+
+	ctrl = &swap_cgroup_ctrl[swp_type(ent)];
+	if (ctrlp)
+		*ctrlp = ctrl;
+
+	mappage = ctrl->map[offset / SC_PER_PAGE];
+	return page_address(mappage) + offset % SC_PER_PAGE;
+}
+
 /**
  * swap_cgroup_cmpxchg - cmpxchg mem_cgroup's id for this swp_entry.
  * @end: swap entry to be cmpxchged
@@ -388,21 +402,13 @@ not_enough_page:
 unsigned short swap_cgroup_cmpxchg(swp_entry_t ent,
 					unsigned short old, unsigned short new)
 {
-	int type = swp_type(ent);
-	unsigned long offset = swp_offset(ent);
-	unsigned long idx = offset / SC_PER_PAGE;
-	unsigned long pos = offset & SC_POS_MASK;
 	struct swap_cgroup_ctrl *ctrl;
-	struct page *mappage;
 	struct swap_cgroup *sc;
 	unsigned long flags;
 	unsigned short retval;
 
-	ctrl = &swap_cgroup_ctrl[type];
+	sc = lookup_swap_cgroup(ent, &ctrl);
 
-	mappage = ctrl->map[idx];
-	sc = page_address(mappage);
-	sc += pos;
 	spin_lock_irqsave(&ctrl->lock, flags);
 	retval = sc->id;
 	if (retval == old)
@@ -423,21 +429,13 @@ unsigned short swap_cgroup_cmpxchg(swp_e
  */
 unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id)
 {
-	int type = swp_type(ent);
-	unsigned long offset = swp_offset(ent);
-	unsigned long idx = offset / SC_PER_PAGE;
-	unsigned long pos = offset & SC_POS_MASK;
 	struct swap_cgroup_ctrl *ctrl;
-	struct page *mappage;
 	struct swap_cgroup *sc;
 	unsigned short old;
 	unsigned long flags;
 
-	ctrl = &swap_cgroup_ctrl[type];
+	sc = lookup_swap_cgroup(ent, &ctrl);
 
-	mappage = ctrl->map[idx];
-	sc = page_address(mappage);
-	sc += pos;
 	spin_lock_irqsave(&ctrl->lock, flags);
 	old = sc->id;
 	sc->id = id;
@@ -447,28 +445,14 @@ unsigned short swap_cgroup_record(swp_en
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
-	int type = swp_type(ent);
-	unsigned long offset = swp_offset(ent);
-	unsigned long idx = offset / SC_PER_PAGE;
-	unsigned long pos = offset & SC_POS_MASK;
-	struct swap_cgroup_ctrl *ctrl;
-	struct page *mappage;
-	struct swap_cgroup *sc;
-	unsigned short ret;
