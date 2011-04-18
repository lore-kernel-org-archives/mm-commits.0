From: akpm@linux-foundation.org
Subject: + cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch added to -mm tree
Date: Mon, 18 Apr 2011 13:42:46 -0700
Message-ID: <201104182042.p3IKgklL023787@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751579Ab1DRUnE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Apr 2011 16:43:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhocko@suse.cz, cl@linux-foundation.org, holt@sgi.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, menage@google.com, penberg@cs.helsinki.fi, rientjes@google.com, steiner@sgi.com


The patch titled
     cpusets: initialize spread rotor lazily
has been added to the -mm tree.  Its filename is
     cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch

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
Cc: David Rientjes <rientjes@google.com>
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
@@ -1126,8 +1126,8 @@ static struct task_struct *copy_process(
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

memsw-remove-noswapaccount-kernel-parameter.patch
memcg-remove-pointless-next_mz-nullification-in-mem_cgroup_soft_limit_reclaim.patch
memcg-mark-init_section_page_cgroup-properly.patch
memcg-fix-off-by-one-when-calculating-swap-cgroup-map-length.patch
memcg-move-page-freeing-code-out-of-lock.patch
maintainers-add-mm-page_cgroupc-into-memcg-subsystem.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch

