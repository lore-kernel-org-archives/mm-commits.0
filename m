From: akpm@linux-foundation.org
Subject: + mm-memcontrol-fold-move_anon-and-move_file.patch added to -mm
 tree
Date: Tue, 13 Jan 2015 16:20:54 -0800
Message-ID: <54b5b666.xQRbBwSB5koYzEay%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbbANAUz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Jan 2015 19:20:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, gthelen@google.com, mhocko@suse.cz, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fold move_anon() and move_file()
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fold-move_anon-and-move_file.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fold-move_anon-and-move_file.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fold-move_anon-and-move_file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: fold move_anon() and move_file()

Turn the move type enum into flags and give the flags field a shorter
name.  Once that is done, move_anon() and move_file() are simple enough to
just fold them into the callsites.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   49 ++++++++++++++++------------------------------
 1 file changed, 18 insertions(+), 31 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-fold-move_anon-and-move_file mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fold-move_anon-and-move_file
+++ a/mm/memcontrol.c
@@ -369,21 +369,18 @@ bool memcg_kmem_is_active(struct mem_cgr
 
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
+#define MOVE_MASK	0x3U
 
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
@@ -3538,7 +3525,7 @@ static int mem_cgroup_move_charge_write(
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
-	if (val >= (1 << NR_MOVE_TYPE))
+	if (val & ~MOVE_MASK)
 		return -EINVAL;
 
 	/*
@@ -4815,12 +4802,12 @@ static struct page *mc_handle_present_pt
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
 
@@ -4834,7 +4821,7 @@ static struct page *mc_handle_swap_pte(s
 	struct page *page = NULL;
 	swp_entry_t ent = pte_to_swp_entry(ptent);
 
-	if (!move_anon() || non_swap_entry(ent))
+	if (!(mc.flags & MOVE_ANON) || non_swap_entry(ent))
 		return NULL;
 	/*
 	 * Because lookup_swap_cache() updates some statistics counter,
@@ -4863,7 +4850,7 @@ static struct page *mc_handle_file_pte(s
 
 	if (!vma->vm_file) /* anonymous vma */
 		return NULL;
-	if (!move_file())
+	if (!(mc.flags & MOVE_FILE))
 		return NULL;
 
 	mapping = vma->vm_file->f_mapping;
@@ -4943,7 +4930,7 @@ static enum mc_target_type get_mctgt_typ
 
 	page = pmd_page(pmd);
 	VM_BUG_ON_PAGE(!page || !PageHead(page), page);
-	if (!move_anon())
+	if (!(mc.flags & MOVE_ANON))
 		return ret;
 	if (page->mem_cgroup == mc.from) {
 		ret = MC_TARGET_PAGE;
@@ -5085,15 +5072,15 @@ static int mem_cgroup_can_attach(struct
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
 
@@ -5113,7 +5100,7 @@ static int mem_cgroup_can_attach(struct
 			spin_lock(&mc.lock);
 			mc.from = from;
 			mc.to = memcg;
-			mc.immigrate_flags = move_charge_at_immigrate;
+			mc.flags = move_flags;
 			spin_unlock(&mc.lock);
 			/* We set mc.moving_task later */
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
memcg-remove-extra-newlines-from-memcg-oom-kill-log.patch
mm-memory-remove-vm_file-check-on-shared-writable-vmas.patch
mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page.patch
mm-page_alloc-place-zone_id-check-before-vm_bug_on_page-check.patch
memcg-zap-__memcg_chargeuncharge_slab.patch
memcg-zap-memcg_name-argument-of-memcg_create_kmem_cache.patch
memcg-zap-memcg_slab_caches-and-memcg_slab_mutex.patch
mm-add-fields-for-compound-destructor-and-order-into-struct-page.patch
swap-remove-unused-mem_cgroup_uncharge_swapcache-declaration.patch
mm-memcontrol-track-move_lock-state-internally.patch
mm-memcontrol-track-move_lock-state-internally-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch
mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage.patch
mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch
mm-hugetlb-fix-suboptimal-migration-hwpoisoned-entry-check.patch
mm-hugetlb-cleanup-and-rename-is_hugetlb_entry_migrationhwpoisoned.patch
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
list_lru-introduce-list_lru_shrink_countwalk.patch
fs-consolidate-nrfree_cached_objects-args-in-shrink_control.patch
vmscan-per-memory-cgroup-slab-shrinkers.patch
memcg-rename-some-cache-id-related-variables.patch
memcg-add-rwsem-to-synchronize-against-memcg_caches-arrays-relocation.patch
list_lru-get-rid-of-active_nodes.patch
list_lru-organize-all-list_lrus-to-list.patch
list_lru-introduce-per-memcg-lists.patch
fs-make-shrinker-memcg-aware.patch
vmscan-force-scan-offline-memory-cgroups.patch
memcg-add-build_bug_on-for-string-tables.patch
mm-page_counter-pull-1-handling-out-of-page_counter_memparse.patch
mm-memcontrol-default-hierarchy-interface-for-memory.patch
mm-memcontrol-default-hierarchy-interface-for-memory-checkpatch-fixes.patch
mm-memcontrol-default-hierarchy-interface-for-memory-fix.patch
mm-memcontrol-fold-move_anon-and-move_file.patch
oom-add-helpers-for-setting-and-clearing-tif_memdie.patch
oom-thaw-the-oom-victim-if-it-is-frozen.patch
pm-convert-printk-to-pr_-equivalent.patch
sysrq-convert-printk-to-pr_-equivalent.patch
oom-pm-make-oom-detection-in-the-freezer-path-raceless.patch
mm-memcontrol-remove-unnecessary-soft-limit-tree-node-test.patch
mm-memcontrol-consolidate-memory-controller-initialization.patch
mm-memcontrol-consolidate-swap-controller-code.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type.patch
fs-shrinker-always-scan-at-least-one-object-of-each-type-fix.patch
fs-proc-task_mmu-show-page-size-in-proc-pid-numa_maps.patch

