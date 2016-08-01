From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-fix-swap-counter-leak-on-swapout-from-offline-cgroup.patch
 added to -mm tree
Date: Mon, 01 Aug 2016 14:09:42 -0700
Message-ID: <579fba96.qi4qm8uvmQ9+sytk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42549 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbcHAVKW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2016 17:10:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, hannes@cmpxchg.org, mhocko@kernel.org, mm-commits@vger.kernel.org


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

Fixes: 73f576c04b941 ("mm: memcontrol: fix cgroup creation failure after many small jobs")
Link: http://lkml.kernel.org/r/01cbe4d1a9fd9bbd42c95e91694d8ed9c9fc2208.1470057819.git.vdavydov@virtuozzo.com
Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-fix-swap-counter-leak-on-swapout-from-offline-cgroup mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-fix-swap-counter-leak-on-swapout-from-offline-cgroup
+++ a/mm/memcontrol.c
@@ -4074,6 +4074,13 @@ static void mem_cgroup_id_get(struct mem
 	atomic_inc(&memcg->id.ref);
 }
 
+static struct mem_cgroup *mem_cgroup_id_get_active(struct mem_cgroup *memcg)
+{
+	while (!atomic_inc_not_zero(&memcg->id.ref))
+		memcg = parent_mem_cgroup(memcg);
+	return memcg;
+}
+
 static void mem_cgroup_id_put(struct mem_cgroup *memcg)
 {
 	if (atomic_dec_and_test(&memcg->id.ref)) {
@@ -5790,7 +5797,7 @@ subsys_initcall(mem_cgroup_init);
  */
 void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
 {
-	struct mem_cgroup *memcg;
+	struct mem_cgroup *memcg, *swap_memcg;
 	unsigned short oldid;
 
 	VM_BUG_ON_PAGE(PageLRU(page), page);
@@ -5805,15 +5812,20 @@ void mem_cgroup_swapout(struct page *pag
 	if (!memcg)
 		return;
 
-	mem_cgroup_id_get(memcg);
-	oldid = swap_cgroup_record(entry, mem_cgroup_id(memcg));
+	swap_memcg = mem_cgroup_id_get_active(memcg);
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
 
 	/*
 	 * Interrupts should be disabled here because the caller holds the
@@ -5853,11 +5865,14 @@ int mem_cgroup_try_charge_swap(struct pa
 	if (!memcg)
 		return 0;
 
+	memcg = mem_cgroup_id_get_active(memcg);
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

