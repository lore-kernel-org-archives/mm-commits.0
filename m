From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-account-kmem-consumers-in-cgroup2-memory-controller.patch
 added to -mm tree
Date: Tue, 08 Dec 2015 15:06:48 -0800
Message-ID: <56676288.o+j/yob/As3Oq/AO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35275 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbbLHXGu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2015 18:06:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, tj@kernel.org, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: account "kmem" consumers in cgroup2 memory controller
has been added to the -mm tree.  Its filename is
     mm-memcontrol-account-kmem-consumers-in-cgroup2-memory-controller.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-account-kmem-consumers-in-cgroup2-memory-controller.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-account-kmem-consumers-in-cgroup2-memory-controller.patch

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
Subject: mm: memcontrol: account "kmem" consumers in cgroup2 memory controller

The original cgroup memory controller has an extension to account slab
memory (and other "kernel memory" consumers) in a separate "kmem" counter,
once the user set an explicit limit on that "kmem" pool.

However, this includes various consumers whose sizes are directly
linked to userspace activity. Accounting them as an optional "kmem"
extension is problematic for several reasons:

1. It leaves the main memory interface with incomplete semantics. A
   user who puts their workload into a cgroup and configures a memory
   limit does not expect us to leave holes in the containment as big
   as the dentry and inode cache, or the kernel stack pages.

2. If the limit set on this random historical subgroup of consumers is
   reached, subsequent allocations will fail even when the main memory
   pool available to the cgroup is not yet exhausted and/or has
   reclaimable memory in it.

3. Calling it 'kernel memory' is misleading. The dentry and inode
   caches are no more 'kernel' (or no less 'user') memory than the
   page cache itself. Treating these consumers as different classes is
   a historical implementation detail that should not leak to users.

So, in addition to page cache, anonymous memory, and network socket
memory, account the following memory consumers per default in the
cgroup2 memory controller:

     - threadinfo
     - task_struct
     - task_delay_info
     - pid
     - cred
     - mm_struct
     - vm_area_struct and vm_region (nommu)
     - anon_vma and anon_vma_chain
     - signal_struct
     - sighand_struct
     - fs_struct
     - files_struct
     - fdtable and fdtable->full_fds_bits
     - dentry and external_name
     - inode for all filesystems.

This should give us reasonable memory isolation for most common
workloads out of the box.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-account-kmem-consumers-in-cgroup2-memory-controller mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-account-kmem-consumers-in-cgroup2-memory-controller
+++ a/mm/memcontrol.c
@@ -2356,13 +2356,14 @@ int __memcg_kmem_charge_memcg(struct pag
 	if (!memcg_kmem_online(memcg))
 		return 0;
 
-	if (!page_counter_try_charge(&memcg->kmem, nr_pages, &counter))
-		return -ENOMEM;
-
 	ret = try_charge(memcg, gfp, nr_pages);
-	if (ret) {
-		page_counter_uncharge(&memcg->kmem, nr_pages);
+	if (ret)
 		return ret;
+
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) &&
+	    !page_counter_try_charge(&memcg->kmem, nr_pages, &counter)) {
+		cancel_charge(memcg, nr_pages);
+		return -ENOMEM;
 	}
 
 	page->mem_cgroup = memcg;
@@ -2391,7 +2392,9 @@ void __memcg_kmem_uncharge(struct page *
 
 	VM_BUG_ON_PAGE(mem_cgroup_is_root(memcg), page);
 
-	page_counter_uncharge(&memcg->kmem, nr_pages);
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		page_counter_uncharge(&memcg->kmem, nr_pages);
+
 	page_counter_uncharge(&memcg->memory, nr_pages);
 	if (do_memsw_account())
 		page_counter_uncharge(&memcg->memsw, nr_pages);
@@ -2895,7 +2898,8 @@ static int memcg_propagate_kmem(struct m
 	 * onlined after this point, because it has at least one child
 	 * already.
 	 */
-	if (memcg_kmem_online(parent))
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) ||
+	    memcg_kmem_online(parent))
 		ret = memcg_online_kmem(memcg);
 	mutex_unlock(&memcg_limit_mutex);
 	return ret;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

maintainers-make-vladimir-co-maintainer-of-the-memory-controller.patch
mm-page_alloc-generalize-the-dirty-balance-reserve.patch
proc-meminfo-estimate-available-memory-more-conservatively.patch
mm-memcontrol-export-root_mem_cgroup.patch
net-tcp_memcontrol-properly-detect-ancestor-socket-pressure.patch
net-tcp_memcontrol-remove-bogus-hierarchy-pressure-propagation.patch
net-tcp_memcontrol-protect-all-tcp_memcontrol-calls-by-jump-label.patch
net-tcp_memcontrol-remove-dead-per-memcg-count-of-allocated-sockets.patch
net-tcp_memcontrol-simplify-the-per-memcg-limit-access.patch
net-tcp_memcontrol-sanitize-tcp-memory-accounting-callbacks.patch
net-tcp_memcontrol-simplify-linkage-between-socket-and-page-counter.patch
mm-memcontrol-generalize-the-socket-accounting-jump-label.patch
mm-memcontrol-do-not-account-memoryswap-on-unified-hierarchy.patch
mm-memcontrol-move-socket-code-for-unified-hierarchy-accounting.patch
mm-memcontrol-account-socket-memory-in-unified-hierarchy-memory-controller.patch
mm-memcontrol-hook-up-vmpressure-to-socket-pressure.patch
mm-memcontrol-switch-to-the-updated-jump-label-api.patch
mm-memcontrol-drop-unused-css-argument-in-memcg_init_kmem.patch
mm-memcontrol-remove-double-kmem-page_counter-init.patch
mm-memcontrol-give-the-kmem-states-more-descriptive-names.patch
mm-memcontrol-group-kmem-init-and-exit-functions-together.patch
mm-memcontrol-separate-kmem-code-from-legacy-tcp-accounting-code.patch
mm-memcontrol-move-kmem-accounting-code-to-config_memcg.patch
mm-memcontrol-account-kmem-consumers-in-cgroup2-memory-controller.patch
mm-memcontrol-introduce-config_memcg_legacy_kmem.patch

