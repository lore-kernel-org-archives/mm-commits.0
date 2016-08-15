From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-fix-swap-counter-leak-on-swapout-from-offline-cgroup.patch
 removed from -mm tree
Date: Mon, 15 Aug 2016 13:40:28 -0700
Message-ID: <57b228bc.OMSFnYRcGX7btdxW%akpm__11436.682547401$1471293654$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932393AbcHOUk3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Aug 2016 16:40:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@suse.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix swap counter leak on swapout from offline cgroup
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-swap-counter-leak-on-swapout-from-offline-cgroup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: memcontrol: fix swap counter leak on swapout from offline cgroup

An offline memory cgroup might have anonymous memory or shmem left charged
to it and no swap.  Since only swap entries pin the id of an offline
cgroup, such a cgroup will have no id and so an attempt to swapout its
anon/shmem will not store memory cgroup info in the swap cgroup map.  As a
result, memcg->swap or memcg->memsw will never get uncharged from it and
any of its ascendants.

Fix this by always charging swapout to the first ancestor cgroup that
hasn't released its id yet.

[hannes@cmpxchg.org: add comment to mem_cgroup_swapout]
[vdavydov@virtuozzo.com: use WARN_ON_ONCE() in mem_cgroup_id_get_online()]
  Link: http://lkml.kernel.org/r/20160803123445.GJ13263@esperanza
Fixes: 73f576c04b941 ("mm: memcontrol: fix cgroup creation failure after many small jobs")
Link: http://lkml.kernel.org/r/5336daa5c9a32e776067773d9da655d2dc126491.1470219853.git.vdavydov@virtuozzo.com
Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>	[3.19+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   44 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 38 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-fix-swap-counter-leak-on-swapout-from-offline-cgroup mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fix-swap-counter-leak-on-swapout-from-offline-cgroup
+++ a/mm/memcontrol.c
@@ -4082,6 +4082,24 @@ static void mem_cgroup_id_get(struct mem
 	atomic_inc(&memcg->id.ref);
 }
 
+static struct mem_cgroup *mem_cgroup_id_get_online(struct mem_cgroup *memcg)
+{
+	while (!atomic_inc_not_zero(&memcg->id.ref)) {
+		/*
+		 * The root cgroup cannot be destroyed, so it's refcount must
+		 * always be >= 1.
+		 */
+		if (WARN_ON_ONCE(memcg == root_mem_cgroup)) {
+			VM_BUG_ON(1);
+			break;
+		}
+		memcg = parent_mem_cgroup(memcg);
+		if (!memcg)
+			memcg = root_mem_cgroup;
+	}
+	return memcg;
+}
+
 static void mem_cgroup_id_put(struct mem_cgroup *memcg)
 {
 	if (atomic_dec_and_test(&memcg->id.ref)) {
@@ -5800,7 +5818,7 @@ subsys_initcall(mem_cgroup_init);
  */
 void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
 {
-	struct mem_cgroup *memcg;
+	struct mem_cgroup *memcg, *swap_memcg;
 	unsigned short oldid;
 
 	VM_BUG_ON_PAGE(PageLRU(page), page);
@@ -5815,16 +5833,27 @@ void mem_cgroup_swapout(struct page *pag
 	if (!memcg)
 		return;
 
-	mem_cgroup_id_get(memcg);
-	oldid = swap_cgroup_record(entry, mem_cgroup_id(memcg));
+	/*
+	 * In case the memcg owning these pages has been offlined and doesn't
+	 * have an ID allocated to it anymore, charge the closest online
+	 * ancestor for the swap instead and transfer the memory+swap charge.
+	 */
+	swap_memcg = mem_cgroup_id_get_online(memcg);
+	oldid = swap_cgroup_record(entry, mem_cgroup_id(swap_memcg));
 	VM_BUG_ON_PAGE(oldid, page);
-	mem_cgroup_swap_statistics(memcg, true);
+	mem_cgroup_swap_statistics(swap_memcg, true);
 
 	page->mem_cgroup = NULL;
 
 	if (!mem_cgroup_is_root(memcg))
 		page_counter_uncharge(&memcg->memory, 1);
 
+	if (memcg != swap_memcg) {
+		if (!mem_cgroup_is_root(swap_memcg))
+			page_counter_charge(&swap_memcg->memsw, 1);
+		page_counter_uncharge(&memcg->memsw, 1);
+	}
+
 	/*
 	 * Interrupts should be disabled here because the caller holds the
 	 * mapping->tree_lock lock which is taken with interrupts-off. It is
@@ -5863,11 +5892,14 @@ int mem_cgroup_try_charge_swap(struct pa
 	if (!memcg)
 		return 0;
 
+	memcg = mem_cgroup_id_get_online(memcg);
+
 	if (!mem_cgroup_is_root(memcg) &&
-	    !page_counter_try_charge(&memcg->swap, 1, &counter))
+	    !page_counter_try_charge(&memcg->swap, 1, &counter)) {
+		mem_cgroup_id_put(memcg);
 		return -ENOMEM;
+	}
 
-	mem_cgroup_id_get(memcg);
 	oldid = swap_cgroup_record(entry, mem_cgroup_id(memcg));
 	VM_BUG_ON_PAGE(oldid, page);
 	mem_cgroup_swap_statistics(memcg, true);
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-oom-deduplicate-victim-selection-code-for-memcg-and-global-oom.patch
mm-memcontrol-add-sanity-checks-for-memcg-idref-on-get-put.patch

