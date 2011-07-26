From: akpm@linux-foundation.org
Subject: [folded] cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch removed from -mm tree
Date: Tue, 26 Jul 2011 15:55:16 -0700
Message-ID: <201107262255.p6QMtHBT014534@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753699Ab1GZW4H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 18:56:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.cz, cl@linux-foundation.org, holt@sgi.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, menage@google.com, penberg@cs.helsinki.fi, rientjes@google.com, steiner


The patch titled
     cpusets: initialize spread rotor lazily
has been removed from the -mm tree.  Its filename was
     cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch

This patch was dropped because it was folded into cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpusets: initialize spread rotor lazily
From: Michal Hocko <mhocko@suse.cz>

Kosaki Motohiro raised a concern that copy_process is hot path and we do
not want to initialize cpuset_{mem,slab}_spread_rotor if they are not used
most of the time.

I think that we should rather intialize it lazily when rotors are used for
the first time.  This will also catch the case when we set up spread
mem/slab later.

Also do not use -1 for unitialized nodes and rather use NUMA_NO_NODE
instead.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Paul Menage <menage@google.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    8 ++++++++
 kernel/fork.c   |    4 ++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff -puN kernel/cpuset.c~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily kernel/cpuset.c
--- a/kernel/cpuset.c~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily
+++ a/kernel/cpuset.c
@@ -2460,11 +2460,19 @@ static int cpuset_spread_node(int *rotor
 
 int cpuset_mem_spread_node(void)
 {
+	if (current->cpuset_mem_spread_rotor == NUMA_NO_NODE)
+		current->cpuset_mem_spread_rotor =
+			node_random(&current->mems_allowed);
+
 	return cpuset_spread_node(&current->cpuset_mem_spread_rotor);
 }
 
 int cpuset_slab_spread_node(void)
 {
+	if (current->cpuset_slab_spread_rotor == NUMA_NO_NODE)
+		current->cpuset_slab_spread_rotor
+			= node_random(&current->mems_allowed);
+
 	return cpuset_spread_node(&current->cpuset_slab_spread_rotor);
 }
 
diff -puN kernel/fork.c~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily kernel/fork.c
--- a/kernel/fork.c~cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily
+++ a/kernel/fork.c
@@ -1174,8 +1174,8 @@ static struct task_struct *copy_process(
 	mpol_fix_fork_child_flag(p);
 #endif
 #ifdef CONFIG_CPUSETS
-	p->cpuset_mem_spread_rotor = node_random(&p->mems_allowed);
-	p->cpuset_slab_spread_rotor = node_random(&p->mems_allowed);
+	p->cpuset_mem_spread_rotor = NUMA_NO_NODE;
+	p->cpuset_slab_spread_rotor = NUMA_NO_NODE;
 #endif
 #ifdef CONFIG_TRACE_IRQFLAGS
 	p->irq_events = 0;
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
memcg-export-memory-cgroups-swappiness-with-mem_cgroup_swappiness.patch
memcg-consolidates-memory-cgroup-lru-stat-functions.patch
memcg-make-oom_lock-0-and-1-based-rather-than-counter.patch
memcg-change-memcg_oom_mutex-to-spinlock.patch
memcg-fix-vmscan-count-in-small-memcgs.patch
memcg-fix-behavior-of-mem_cgroup_resize_limit.patch
memcg-add-memoryvmscan_stat.patch
memcg-do-not-try-to-drain-per-cpu-caches-without-pages.patch
memcg-unify-sync-and-async-per-cpu-charge-cache-draining.patch
memcg-add-mem_cgroup_same_or_subtree-helper.patch
memcg-get-rid-of-percpu_charge_mutex-lock.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
fs-execc-use-build_bug_on-for-vm_stack_flags-vm_stack_incomplete_setup.patch

