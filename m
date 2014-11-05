From: akpm@linux-foundation.org
Subject: + memcg-do-not-abuse-memcg_kmem_skip_account.patch added to -mm
 tree
Date: Wed, 05 Nov 2014 14:31:52 -0800
Message-ID: <545aa558.TGegwXgnTYb5/SxF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35945 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbaKEWbv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Nov 2014 17:31:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: do not abuse memcg_kmem_skip_account
has been added to the -mm tree.  Its filename is
     memcg-do-not-abuse-memcg_kmem_skip_account.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-do-not-abuse-memcg_kmem_skip_account.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/memcg-do-not-abuse-memcg_kmem_skip_account.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: memcg: do not abuse memcg_kmem_skip_account

task_struct->memcg_kmem_skip_account was initially introduced to avoid
recursion during kmem cache creation: memcg_kmem_get_cache, which is
called by kmem_cache_alloc to determine the per-memcg cache to account
allocation to, may issue lazy cache creation if the needed cache doesn't
exist, which means issuing yet another kmem_cache_alloc.  We can't just
pass a flag to the nested kmem_cache_alloc disabling kmem accounting,
because there are hidden allocations, e.g.  in INIT_WORK.  So we
introduced a flag on the task_struct, memcg_kmem_skip_account, making
memcg_kmem_get_cache return immediately.

By its nature, the flag may also be used to disable accounting for
allocations shared among different cgroups, and currently it is used this
way in memcg_activate_kmem.  Using it like this looks like abusing it to
me.  If we want to disable accounting for some allocations (which we will
definitely want one day), we should either add GFP_NO_MEMCG or GFP_MEMCG
flag in order to blacklist/whitelist some allocations.

For now, let's simply remove memcg_stop/resume_kmem_account from
memcg_activate_kmem.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN mm/memcontrol.c~memcg-do-not-abuse-memcg_kmem_skip_account mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-do-not-abuse-memcg_kmem_skip_account
+++ a/mm/memcontrol.c
@@ -3428,12 +3428,6 @@ static int memcg_activate_kmem(struct me
 		return 0;
 
 	/*
-	 * We are going to allocate memory for data shared by all memory
-	 * cgroups so let's stop accounting here.
-	 */
-	memcg_stop_kmem_account();
-
-	/*
 	 * For simplicity, we won't allow this to be disabled.  It also can't
 	 * be changed if the cgroup has children already, or if tasks had
 	 * already joined.
@@ -3475,7 +3469,6 @@ static int memcg_activate_kmem(struct me
 	 */
 	memcg->kmemcg_id = memcg_id;
 out:
-	memcg_resume_kmem_account();
 	return err;
 }
 
_

Patches currently in -mm which might be from vdavydov@parallels.com are

slab-print-slabinfo-header-in-seq-show.patch
mm-memcontrol-lockless-page-counters.patch
mm-hugetlb_cgroup-convert-to-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-memcontrol-convert-reclaim-iterator-to-simple-css-refcounting.patch
mm-memcontrol-take-a-css-reference-for-each-charged-page.patch
mm-memcontrol-remove-obsolete-kmemcg-pinning-tricks.patch
mm-memcontrol-continue-cache-reclaim-from-offlined-groups.patch
mm-memcontrol-remove-synchroneous-stock-draining-code.patch
mm-introduce-single-zone-pcplists-drain.patch
mm-page_isolation-drain-single-zone-pcplists.patch
mm-cma-drain-single-zone-pcplists.patch
mm-memory_hotplug-failure-drain-single-zone-pcplists.patch
memcg-simplify-unreclaimable-groups-handling-in-soft-limit-reclaim.patch
memcg-remove-activate_kmem_mutex.patch
mm-memcontrol-micro-optimize-mem_cgroup_split_huge_fixup.patch
mm-memcontrol-uncharge-pages-on-swapout.patch
mm-memcontrol-uncharge-pages-on-swapout-fix.patch
mm-memcontrol-remove-unnecessary-pcg_memsw-memoryswap-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_mem-memory-charge-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-inline-memcg-move_lock-locking.patch
mm-memcontrol-dont-pass-a-null-memcg-to-mem_cgroup_end_move.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
memcg-remove-mem_cgroup_reclaimable-check-from-soft-reclaim.patch
memcg-use-generic-slab-iterators-for-showing-slabinfo.patch
mm-memcontrol-shorten-the-page-statistics-update-slowpath.patch
mm-memcontrol-remove-bogus-null-check-after-mem_cgroup_from_task.patch
mm-memcontrol-pull-the-null-check-from-__mem_cgroup_same_or_subtree.patch
mm-memcontrol-drop-bogus-rcu-locking-from-mem_cgroup_same_or_subtree.patch
mm-embed-the-memcg-pointer-directly-into-struct-page.patch
mm-embed-the-memcg-pointer-directly-into-struct-page-fix.patch
mm-page_cgroup-rename-file-to-mm-swap_cgroupc.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix.patch
mm-move-page-mem_cgroup-bad-page-handling-into-generic-code-fix-2.patch
memcg-do-not-destroy-kmem-caches-on-css-offline.patch
slab-charge-slab-pages-to-the-current-memory-cgroup.patch
memcg-decouple-per-memcg-kmem-cache-from-the-owner-memcg.patch
memcg-zap-memcg_unregister_cache.patch
memcg-free-kmem-cache-id-on-css-offline.patch
memcg-introduce-memcg_kmem_should_charge-helper.patch
slab-introduce-slab_free-helper.patch
slab-recharge-slab-pages-to-the-allocating-memory-cgroup.patch
memcg-zap-kmem_account_flags.patch
memcg-__mem_cgroup_free-remove-stale-disarm_static_keys-comment.patch
memcg-dont-check-mm-in-__memcg_kmem_get_cachenewpage_charge.patch
memcg-do-not-abuse-memcg_kmem_skip_account.patch
memcg-turn-memcg_kmem_skip_account-into-a-bit-field.patch
memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache.patch
linux-next.patch
slab-fix-cpuset-check-in-fallback_alloc.patch
slub-fix-cpuset-check-in-get_any_partial.patch

