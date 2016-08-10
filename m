From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-fix-swap-counter-leak-on-swapout-from-offline-cgroup.patch
 added to -mm tree
Date: Wed, 10 Aug 2016 15:25:33 -0700
Message-ID: <57aba9dd.7n1YG+V4DS+gELtA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53410 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933321AbcHJWZe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Aug 2016 18:25:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@suse.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: fix swap counter leak on swapout from offline cgroup
has been added to the -mm tree.  Its filename is
     mm-memcontrol-fix-swap-counter-leak-on-swapout-from-offline-cgroup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fix-swap-counter-leak-on-swapout-from-offline-cgroup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fix-swap-counter-leak-on-swapout-from-offline-cgroup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
+		if (memcg == root_mem_cgroup) {
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

mm-memcontrol-fix-swap-counter-leak-on-swapout-from-offline-cgroup.patch
mm-memcontrol-fix-memcg-id-ref-counter-on-swap-charge-move.patch
mm-oom-deduplicate-victim-selection-code-for-memcg-and-global-oom.patch
mm-memcontrol-add-sanity-checks-for-memcg-idref-on-get-put.patch

