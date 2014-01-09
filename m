From: akpm@linux-foundation.org
Subject: +
 memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch added to -mm tree
Date: Thu, 09 Jan 2014 13:57:54 -0800
Message-ID: <52cf1b62.8DNvGlxpYZb2WQgt%akpm__27046.011950779$1389304686$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52557 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaAIV5z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jan 2014 16:57:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, ebiederm@xmission.com, mhocko@suse.cz

Subject: + memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch added to -mm tree
To: mhocko@suse.cz,ebiederm@xmission.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,rientjes@google.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 09 Jan 2014 13:57:54 -0800


The patch titled
     Subject: memcg: do not hang on OOM when killed by userspace OOM access to memory reserves
has been added to the -mm tree.  Its filename is
     memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch

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
Subject: memcg: do not hang on OOM when killed by userspace OOM access to memory reserves

Eric has reported that he can see task(s) stuck in memcg OOM handler
regularly.  The only way out is to

	echo 0 > $GROUP/memory.oom_controll

His usecase is:

- Setup a hierarchy with memory and the freezer (disable kernel oom and
  have a process watch for oom).

- In that memory cgroup add a process with one thread per cpu.

- In one thread slowly allocate once per second I think it is 16M of ram
  and mlock and dirty it (just to force the pages into ram and stay
  there).

- When oom is achieved loop:
  * attempt to freeze all of the tasks.
  * if frozen send every task SIGKILL, unfreeze, remove the directory in
    cgroupfs.

Eric has then pinpointed the issue to be memcg specific.

All tasks are sitting on the memcg_oom_waitq when memcg oom is disabled. 
Those that have received fatal signal will bypass the charge and should
continue on their way out.  The tricky part is that the exit path might
trigger a page fault (e.g.  exit_robust_list), thus the memcg charge,
while its memcg is still under OOM because nobody has released any charges
yet.

Unlike with the in-kernel OOM handler the exiting task doesn't get
TIF_MEMDIE set so it doesn't shortcut futher charges of the killed task
and falls to the memcg OOM again without any way out of it as there are no
fatal signals pending anymore.

This patch fixes the issue by checking PF_EXITING early in
__mem_cgroup_try_charge and bypass the charge same as if it had fatal
signal pending or TIF_MEMDIE set.

Normally exiting tasks (aka not killed) will bypass the charge now but
this should be OK as the task is leaving and will release memory and
increasing the memory pressure just to release it in a moment seems
dubious wasting of cycles.  Besides that charges after exit_signals should
be rare.

Reported-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves
+++ a/mm/memcontrol.c
@@ -2670,7 +2670,8 @@ static int __mem_cgroup_try_charge(struc
 	 * MEMDIE process.
 	 */
 	if (unlikely(test_thread_flag(TIF_MEMDIE)
-		     || fatal_signal_pending(current)))
+		     || fatal_signal_pending(current))
+		     || current->flags & PF_EXITING)
 		goto bypass;
 
 	if (unlikely(task_in_memcg_oom(current)))
_

Patches currently in -mm which might be from mhocko@suse.cz are

mm-mempolicy-remove-unneeded-functions-for-uma-configs.patch
mm-memblock-debug-correct-displaying-of-upper-memory-boundary.patch
memcg-fix-kmem_account_flags-check-in-memcg_can_account_kmem.patch
memcg-make-memcg_update_cache_sizes-static.patch
introduce-for_each_thread-to-replace-the-buggy-while_each_thread.patch
oom_kill-change-oom_killc-to-use-for_each_thread.patch
oom_kill-has_intersects_mems_allowed-needs-rcu_read_lock.patch
oom_kill-add-rcu_read_lock-into-find_lock_task_mm.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
x86-memblock-set-current-limit-to-max-low-memory-address.patch
mm-memblock-debug-dont-free-reserved-array-if-arch_discard_memblock.patch
mm-bootmem-remove-duplicated-declaration-of-__free_pages_bootmem.patch
mm-memblock-remove-unnecessary-inclusions-of-bootmemh.patch
mm-memblock-drop-warn-and-use-smp_cache_bytes-as-a-default-alignment.patch
mm-memblock-reorder-parameters-of-memblock_find_in_range_node.patch
mm-memblock-switch-to-use-numa_no_node-instead-of-max_numnodes.patch
mm-memblock-add-memblock-memory-allocation-apis.patch
mm-memblock-add-memblock-memory-allocation-apis-fix.patch
mm-init-use-memblock-apis-for-early-memory-allocations.patch
mm-printk-use-memblock-apis-for-early-memory-allocations.patch
mm-page_alloc-use-memblock-apis-for-early-memory-allocations.patch
mm-power-use-memblock-apis-for-early-memory-allocations.patch
lib-swiotlbc-use-memblock-apis-for-early-memory-allocations.patch
lib-cpumaskc-use-memblock-apis-for-early-memory-allocations.patch
mm-sparse-use-memblock-apis-for-early-memory-allocations.patch
mm-hugetlb-use-memblock-apis-for-early-memory-allocations.patch
mm-page_cgroup-use-memblock-apis-for-early-memory-allocations.patch
mm-percpu-use-memblock-apis-for-early-memory-allocations.patch
mm-memory_hotplug-use-memblock-apis-for-early-memory-allocations.patch
drivers-firmware-memmapc-use-memblock-apis-for-early-memory-allocations.patch
arch-arm-kernel-use-memblock-apis-for-early-memory-allocations.patch
arch-arm-mm-initc-use-memblock-apis-for-early-memory-allocations.patch
arch-arm-mach-omap2-omap_hwmodc-use-memblock-apis-for-early-memory-allocations.patch
lib-show_memc-show-num_poisoned_pages-when-oom.patch
memcg-oom-lock-mem_cgroup_print_oom_info.patch
mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch
memcg-do-not-use-vmalloc-for-mem_cgroup-allocations.patch
slab-clean-up-kmem_cache_create_memcg-error-handling.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path.patch
memcg-slab-clean-up-memcg-cache-initialization-destruction.patch
memcg-slab-fix-barrier-usage-when-accessing-memcg_caches.patch
memcg-fix-possible-null-deref-while-traversing-memcg_slab_caches-list.patch
memcg-slab-fix-races-in-per-memcg-cache-creation-destruction.patch
memcg-get-rid-of-kmem_cache_dup.patch
slab-do-not-panic-if-we-fail-to-create-memcg-cache.patch
memcg-slab-rcu-protect-memcg_params-for-root-caches.patch
memcg-remove-kmem_accounted_activated-flag.patch
memcg-rework-memcg_update_kmem_limit-synchronization.patch
mm-new_vma_page-cannot-see-null-vma-for-hugetlb-pages.patch
mm-prevent-setting-of-a-value-less-than-0-to-min_free_kbytes.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
proc-fix-the-potential-use-after-free-in-first_tid.patch
proc-change-first_tid-to-use-while_each_thread-rather-than-next_thread.patch
proc-dont-abuse-group_leader-in-proc_task_readdir-paths.patch
proc-fix-f_pos-overflows-in-first_tid.patch
linux-next.patch

