From: akpm@linux-foundation.org
Subject: + memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling.patch added to -mm tree
Date: Fri, 04 Sep 2009 13:57:49 -0700
Message-ID: <200909042057.n84KvntL019241@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933903AbZIDU6D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Sep 2009 16:58:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: fix softlimit css refcnt handling
has been added to the -mm tree.  Its filename is
     memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling.patch

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
Subject: memcg: fix softlimit css refcnt handling
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

SoftLimit tree 'find next one' loop uses next_mz to remember next one to
be visited if reclaimd==0.

But css'refcnt handling for next_mz is not enough and it makes css->refcnt
leak.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling mm/memcontrol.c
--- a/mm/memcontrol.c~memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling
+++ a/mm/memcontrol.c
@@ -2226,6 +2226,8 @@ unsigned long mem_cgroup_soft_limit_recl
 		if (!reclaimed) {
 			do {
 				/*
+				 * Loop until we find yet another one.
+				 *
 				 * By the time we get the soft_limit lock
 				 * again, someone might have aded the
 				 * group back on the RB tree. Iterate to
@@ -2236,7 +2238,12 @@ unsigned long mem_cgroup_soft_limit_recl
 				 */
 				next_mz =
 				__mem_cgroup_largest_soft_limit_node(mctz);
-			} while (next_mz == mz);
+				if (next_mz == mz) {
+					css_put(&next_mz->mem->css);
+					next_mz = NULL;
+				} else /* next_mz == NULL or other memcg */
+					break;
+			} while (1);
 		}
 		mz->usage_in_excess =
 			res_counter_soft_limit_excess(&mz->mem->res);
@@ -2264,6 +2271,8 @@ unsigned long mem_cgroup_soft_limit_recl
 			loop > MEM_CGROUP_MAX_SOFT_LIMIT_RECLAIM_LOOPS))
 			break;
 	} while (!nr_reclaimed);
+	if (next_mz)
+		css_put(&next_mz->mem->css);
 	return nr_reclaimed;
 }
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

mm-clean-up-page_remove_rmap.patch
vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already.patch
mm-remove-__addsub_zone_page_state.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
vmalloc-unmap-vmalloc-area-after-hiding-it.patch
kcore-fix-vread-vwrite-to-be-aware-of-holes.patch
kcore-fix-vread-vwrite-to-be-aware-of-holes-update.patch
kcore-proc-kcore-should-use-vread.patch
mm-add_to_swap_cache-must-not-sleep.patch
mm-add_to_swap_cache-does-not-return-eexist.patch
memory-hotplug-fix-updating-of-num_physpages-for-hot-plugged-memory.patch
mm-vmscan-rename-zone_nr_pages-to-zone_lru_nr_pages.patch
mm-do-batched-scans-for-mem_cgroup.patch
oom-move-oom_adj-value-from-task_struct-to-signal_struct.patch
oom-make-oom_score-to-per-process-value.patch
oom-oom_kill-doesnt-kill-vfork-parentor-child.patch
oom-fix-oom_adjust_write-input-sanity-check.patch
mm-fix-numa-accounting-in-numastattxt.patch
kcore-fix-proc-kcores-statst_size.patch
kcore-use-usual-list-for-kclist.patch
kcore-add-kclist-types.patch
kcore-register-vmalloc-area-in-generic-way.patch
kcore-register-text-area-in-generic-way.patch
walk-system-ram-range.patch
kcore-use-registerd-physmem-information.patch
kcore-register-vmemmap-range.patch
kcore-register-module-area-in-generic-way.patch
cgroups-support-named-cgroups-hierarchies.patch
cgroups-move-the-cgroup-debug-subsys-into-cgroupc-to-access-internal-state.patch
cgroups-add-a-back-pointer-from-struct-cg_cgroup_link-to-struct-cgroup.patch
cgroups-allow-cgroup-hierarchies-to-be-created-with-no-bound-subsystems.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
memcg-add-comments-explaining-memory-barriers.patch
memcg-add-comments-explaining-memory-barriers-checkpatch-fixes.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix-softlimit-css-refcnt-handling.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch
memcg-show-swap-usage-in-stat-file.patch
memcg-show-swap-usage-in-stat-file-fix.patch
do_wait-wakeup-optimization-fix-child_wait_callback-eligible_child-usage.patch
do_wait-wakeup-optimization-simplify-task_pid_type.patch

