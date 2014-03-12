From: akpm@linux-foundation.org
Subject: +
 memcg-do-not-replicate-get_mem_cgroup_from_mm-in-__mem_cgroup_try_charge.patch added to -mm tree
Date: Wed, 12 Mar 2014 14:04:02 -0700
Message-ID: <5320cbc2.s+a93bn8G9Ph03f2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58045 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbaCLVED (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Mar 2014 17:04:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hannes@cmpxchg.org, mhocko@suse.cz

Subject: + memcg-do-not-replicate-get_mem_cgroup_from_mm-in-__mem_cgroup_try_charge.patch added to -mm tree
To: mhocko@suse.cz,hannes@cmpxchg.org
From: akpm@linux-foundation.org
Date: Wed, 12 Mar 2014 14:04:02 -0700


The patch titled
     Subject: memcg: do not replicate get_mem_cgroup_from_mm in __mem_cgroup_try_charge
has been added to the -mm tree.  Its filename is
     memcg-do-not-replicate-get_mem_cgroup_from_mm-in-__mem_cgroup_try_charge.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-do-not-replicate-get_mem_cgroup_from_mm-in-__mem_cgroup_try_charge.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-do-not-replicate-get_mem_cgroup_from_mm-in-__mem_cgroup_try_charge.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg: do not replicate get_mem_cgroup_from_mm in __mem_cgroup_try_charge

__mem_cgroup_try_charge duplicates get_mem_cgroup_from_mm for charges
which came without a memcg.  The only reason seems to be a tiny
optimization when css_tryget is not called if the charge can be consumed
from the stock.  Nevertheless css_tryget is very cheap since it has been
reworked to use per-cpu counting so this optimization doesn't give us
anything these days.

So let's drop the code duplication so that the code is more readable.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   50 +++++-----------------------------------------
 1 file changed, 6 insertions(+), 44 deletions(-)

diff -puN mm/memcontrol.c~memcg-do-not-replicate-get_mem_cgroup_from_mm-in-__mem_cgroup_try_charge mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-do-not-replicate-get_mem_cgroup_from_mm-in-__mem_cgroup_try_charge
+++ a/mm/memcontrol.c
@@ -2731,52 +2731,14 @@ static int __mem_cgroup_try_charge(struc
 again:
 	if (*ptr) { /* css should be a valid one */
 		memcg = *ptr;
-		if (mem_cgroup_is_root(memcg))
-			goto done;
-		if (consume_stock(memcg, nr_pages))
-			goto done;
 		css_get(&memcg->css);
 	} else {
-		struct task_struct *p;
-
-		rcu_read_lock();
-		p = rcu_dereference(mm->owner);
-		/*
-		 * Because we don't have task_lock(), "p" can exit.
-		 * In that case, "memcg" can point to root or p can be NULL with
-		 * race with swapoff. Then, we have small risk of mis-accouning.
-		 * But such kind of mis-account by race always happens because
-		 * we don't have cgroup_mutex(). It's overkill and we allo that
-		 * small race, here.
-		 * (*) swapoff at el will charge against mm-struct not against
-		 * task-struct. So, mm->owner can be NULL.
-		 */
-		memcg = mem_cgroup_from_task(p);
-		if (!memcg)
-			memcg = root_mem_cgroup;
-		if (mem_cgroup_is_root(memcg)) {
-			rcu_read_unlock();
-			goto done;
-		}
-		if (consume_stock(memcg, nr_pages)) {
-			/*
-			 * It seems dagerous to access memcg without css_get().
-			 * But considering how consume_stok works, it's not
-			 * necessary. If consume_stock success, some charges
-			 * from this memcg are cached on this cpu. So, we
-			 * don't need to call css_get()/css_tryget() before
-			 * calling consume_stock().
-			 */
-			rcu_read_unlock();
-			goto done;
-		}
-		/* after here, we may be blocked. we need to get refcnt */
-		if (!css_tryget(&memcg->css)) {
-			rcu_read_unlock();
-			goto again;
-		}
-		rcu_read_unlock();
+		memcg = get_mem_cgroup_from_mm(mm);
 	}
+	if (mem_cgroup_is_root(memcg))
+		goto done;
+	if (consume_stock(memcg, nr_pages))
+		goto done;
 
 	do {
 		bool invoke_oom = oom && !nr_oom_retries;
@@ -2812,8 +2774,8 @@ again:
 
 	if (batch > nr_pages)
 		refill_stock(memcg, batch - nr_pages);
-	css_put(&memcg->css);
 done:
+	css_put(&memcg->css);
 	*ptr = memcg;
 	return 0;
 nomem:
_

Patches currently in -mm which might be from mhocko@suse.cz are

mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-hugetlb-mark-some-bootstrap-functions-as-__init.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
madvise-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
drop_caches-add-some-documentation-and-info-message.patch
mm-exclude-memory-less-nodes-from-zone_reclaim.patch
fork-collapse-copy_flags-into-copy_process.patch
mm-mempolicy-rename-slab_node-for-clarity.patch
mm-mempolicy-remove-per-process-flag.patch
res_counter-remove-interface-for-locked-charging-and-uncharging.patch
mm-memcg-remove-unnecessary-preemption-disabling.patch
mm-memcg-remove-mem_cgroup_move_account_page_stat.patch
mm-memcg-inline-mem_cgroup_charge_common.patch
mm-memcg-push-mm-handling-out-to-page-cache-charge-function.patch
memcg-remove-unnecessary-mm-check-from-try_get_mem_cgroup_from_mm.patch
memcg-get_mem_cgroup_from_mm.patch
memcg-do-not-replicate-get_mem_cgroup_from_mm-in-__mem_cgroup_try_charge.patch
memcg-sanitize-__mem_cgroup_try_charge-call-protocol.patch
memcg-sanitize-__mem_cgroup_try_charge-call-protocol-fix.patch
memcg-rename-high-level-charging-functions.patch
printk-remove-duplicated-check-for-log-level.patch
printk-remove-obsolete-check-for-log-level-c.patch
printk-add-comment-about-tricky-check-for-text-buffer-size.patch
printk-use-also-the-last-bytes-in-the-ring-buffer.patch
printk-do-not-compute-the-size-of-the-message-twice.patch
linux-next.patch
memcg-slab-never-try-to-merge-memcg-caches.patch
memcg-slab-cleanup-memcg-cache-creation.patch
memcg-slab-separate-memcg-vs-root-cache-creation-paths.patch
memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it.patch
memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases.patch
slub-adjust-memcg-caches-when-creating-cache-alias.patch
slub-rework-sysfs-layout-for-memcg-caches.patch

