From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrol-fold-move_anon-and-move_file.patch removed from -mm tree
Date: Thu, 12 Feb 2015 11:36:57 -0800
Message-ID: <54dd00d9.VJRHiCyP2sGTkMcf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbbBLTg6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:36:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, gthelen@google.com, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fold move_anon() and move_file()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fold-move_anon-and-move_file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: fold move_anon() and move_file()

Turn the move type enum into flags and give the flags field a shorter
name.  Once that is done, move_anon() and move_file() are simple enough to
just fold them into the callsites.

[akpm@linux-foundation.org: tweak MOVE_MASK definition, per Michal]
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   49 ++++++++++++++++------------------------------
 1 file changed, 18 insertions(+), 31 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-fold-move_anon-and-move_file mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fold-move_anon-and-move_file
+++ a/mm/memcontrol.c
@@ -369,21 +369,18 @@ static bool memcg_kmem_is_active(struct
 
 /* Stuffs for move charges at task migration. */
 /*
- * Types of charges to be moved. "move_charge_at_immitgrate" and
- * "immigrate_flags" are treated as a left-shifted bitmap of these types.
+ * Types of charges to be moved.
  */
-enum move_type {
-	MOVE_CHARGE_TYPE_ANON,	/* private anonymous page and swap of it */
-	MOVE_CHARGE_TYPE_FILE,	/* file page(including tmpfs) and swap of it */
-	NR_MOVE_TYPE,
-};
+#define MOVE_ANON	0x1U
+#define MOVE_FILE	0x2U
+#define MOVE_MASK	(MOVE_ANON | MOVE_FILE)
 
 /* "mc" and its members are protected by cgroup_mutex */
 static struct move_charge_struct {
 	spinlock_t	  lock; /* for from, to */
 	struct mem_cgroup *from;
 	struct mem_cgroup *to;
-	unsigned long immigrate_flags;
+	unsigned long flags;
 	unsigned long precharge;
 	unsigned long moved_charge;
 	unsigned long moved_swap;
@@ -394,16 +391,6 @@ static struct move_charge_struct {
 	.waitq = __WAIT_QUEUE_HEAD_INITIALIZER(mc.waitq),
 };
 
-static bool move_anon(void)
-{
-	return test_bit(MOVE_CHARGE_TYPE_ANON, &mc.immigrate_flags);
-}
-
-static bool move_file(void)
-{
-	return test_bit(MOVE_CHARGE_TYPE_FILE, &mc.immigrate_flags);
-}
-
 /*
  * Maximum loops in mem_cgroup_hierarchical_reclaim(), used for soft
  * limit reclaim to prevent infinite loops, if they ever occur.
@@ -3500,7 +3487,7 @@ static int mem_cgroup_move_charge_write(
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
-	if (val >= (1 << NR_MOVE_TYPE))
+	if (val & ~MOVE_MASK)
 		return -EINVAL;
 
 	/*
@@ -4773,12 +4760,12 @@ static struct page *mc_handle_present_pt
 	if (!page || !page_mapped(page))
 		return NULL;
 	if (PageAnon(page)) {
-		/* we don't move shared anon */
-		if (!move_anon())
+		if (!(mc.flags & MOVE_ANON))
 			return NULL;
-	} else if (!move_file())
-		/* we ignore mapcount for file pages */
-		return NULL;
+	} else {
+		if (!(mc.flags & MOVE_FILE))
+			return NULL;
+	}
 	if (!get_page_unless_zero(page))
 		return NULL;
 
@@ -4792,7 +4779,7 @@ static struct page *mc_handle_swap_pte(s
 	struct page *page = NULL;
 	swp_entry_t ent = pte_to_swp_entry(ptent);
 
-	if (!move_anon() || non_swap_entry(ent))
+	if (!(mc.flags & MOVE_ANON) || non_swap_entry(ent))
 		return NULL;
 	/*
 	 * Because lookup_swap_cache() updates some statistics counter,
@@ -4821,7 +4808,7 @@ static struct page *mc_handle_file_pte(s
 
 	if (!vma->vm_file) /* anonymous vma */
 		return NULL;
-	if (!move_file())
+	if (!(mc.flags & MOVE_FILE))
 		return NULL;
 
 	mapping = vma->vm_file->f_mapping;
@@ -4900,7 +4887,7 @@ static enum mc_target_type get_mctgt_typ
 
 	page = pmd_page(pmd);
 	VM_BUG_ON_PAGE(!page || !PageHead(page), page);
-	if (!move_anon())
+	if (!(mc.flags & MOVE_ANON))
 		return ret;
 	if (page->mem_cgroup == mc.from) {
 		ret = MC_TARGET_PAGE;
@@ -5042,15 +5029,15 @@ static int mem_cgroup_can_attach(struct
 	struct task_struct *p = cgroup_taskset_first(tset);
 	int ret = 0;
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
-	unsigned long move_charge_at_immigrate;
+	unsigned long move_flags;
 
 	/*
 	 * We are now commited to this value whatever it is. Changes in this
 	 * tunable will only affect upcoming migrations, not the current one.
 	 * So we need to save it, and keep it going.
 	 */
-	move_charge_at_immigrate  = memcg->move_charge_at_immigrate;
-	if (move_charge_at_immigrate) {
+	move_flags = ACCESS_ONCE(memcg->move_charge_at_immigrate);
+	if (move_flags) {
 		struct mm_struct *mm;
 		struct mem_cgroup *from = mem_cgroup_from_task(p);
 
@@ -5070,7 +5057,7 @@ static int mem_cgroup_can_attach(struct
 			spin_lock(&mc.lock);
 			mc.from = from;
 			mc.to = memcg;
-			mc.immigrate_flags = move_charge_at_immigrate;
+			mc.flags = move_flags;
 			spin_unlock(&mc.lock);
 			/* We set mc.moving_task later */
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
slab-embed-memcg_cache_params-to-kmem_cache.patch
slab-link-memcg-caches-of-the-same-kind-into-a-list.patch
cgroup-release-css-id-after-css_free.patch
slab-use-css-id-for-naming-per-memcg-caches.patch
memcg-free-memcg_caches-slot-on-css-offline.patch
list_lru-add-helpers-to-isolate-items.patch
memcg-reparent-list_lrus-and-free-kmemcg_id-on-css-offline.patch
memcg-cleanup-static-keys-decrement.patch
documentation-proc-add-proc-pid-numa_maps-interface-explanation-snippet.patch
fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps.patch
fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps-fix.patch

