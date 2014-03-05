From: akpm@linux-foundation.org
Subject: + mm-mempolicy-rename-slab_node-for-clarity.patch added to -mm
 tree
Date: Wed, 05 Mar 2014 13:21:35 -0800
Message-ID: <5317955f.FD2BzZ6FtyxqpMtO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54511 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298AbaCEVVh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2014 16:21:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wujianguo@huawei.com, tj@kernel.org, thockin@google.com, riel@redhat.com, penberg@kernel.org, oleg@redhat.com, mhocko@suse.cz, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, cl@linux.com, cl@linux-foundation.org, rientjes@google.com

Subject: + mm-mempolicy-rename-slab_node-for-clarity.patch added to -mm tree
To: rientjes@google.com,cl@linux-foundation.org,cl@linux.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mgorman@suse.de,mhocko@suse.cz,oleg@redhat.com,penberg@kernel.org,riel@redhat.com,thockin@google.com,tj@kernel.org,wujianguo@huawei.com
From: akpm@linux-foundation.org
Date: Wed, 05 Mar 2014 13:21:35 -0800


The patch titled
     Subject: mm, mempolicy: rename slab_node for clarity
has been added to the -mm tree.  Its filename is
     mm-mempolicy-rename-slab_node-for-clarity.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicy-rename-slab_node-for-clarity.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicy-rename-slab_node-for-clarity.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, mempolicy: rename slab_node for clarity

slab_node() is actually a mempolicy function, so rename it to
mempolicy_slab_node() to make it clearer that it used for processes with
mempolicies.

At the same time, cleanup its code by saving numa_mem_id() in a local
variable (since we require a node with memory, not just any node) and
remove an obsolete comment that assumes the mempolicy is actually passed
into the function.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Tim Hockin <thockin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    2 +-
 mm/mempolicy.c            |   15 ++++++---------
 mm/slab.c                 |    4 ++--
 mm/slub.c                 |    2 +-
 4 files changed, 10 insertions(+), 13 deletions(-)

diff -puN include/linux/mempolicy.h~mm-mempolicy-rename-slab_node-for-clarity include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mm-mempolicy-rename-slab_node-for-clarity
+++ a/include/linux/mempolicy.h
@@ -151,7 +151,7 @@ extern struct zonelist *huge_zonelist(st
 extern bool init_nodemask_of_mempolicy(nodemask_t *mask);
 extern bool mempolicy_nodemask_intersects(struct task_struct *tsk,
 				const nodemask_t *mask);
-extern unsigned slab_node(void);
+extern unsigned int mempolicy_slab_node(void);
 
 extern enum zone_type policy_zone;
 
diff -puN mm/mempolicy.c~mm-mempolicy-rename-slab_node-for-clarity mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-rename-slab_node-for-clarity
+++ a/mm/mempolicy.c
@@ -1725,21 +1725,18 @@ static unsigned interleave_nodes(struct
 /*
  * Depending on the memory policy provide a node from which to allocate the
  * next slab entry.
- * @policy must be protected by freeing by the caller.  If @policy is
- * the current task's mempolicy, this protection is implicit, as only the
- * task can change it's policy.  The system default policy requires no
- * such protection.
  */
-unsigned slab_node(void)
+unsigned int mempolicy_slab_node(void)
 {
 	struct mempolicy *policy;
+	int node = numa_mem_id();
 
 	if (in_interrupt())
-		return numa_node_id();
+		return node;
 
 	policy = current->mempolicy;
 	if (!policy || policy->flags & MPOL_F_LOCAL)
-		return numa_node_id();
+		return node;
 
 	switch (policy->mode) {
 	case MPOL_PREFERRED:
@@ -1759,11 +1756,11 @@ unsigned slab_node(void)
 		struct zonelist *zonelist;
 		struct zone *zone;
 		enum zone_type highest_zoneidx = gfp_zone(GFP_KERNEL);
-		zonelist = &NODE_DATA(numa_node_id())->node_zonelists[0];
+		zonelist = &NODE_DATA(node)->node_zonelists[0];
 		(void)first_zones_zonelist(zonelist, highest_zoneidx,
 							&policy->v.nodes,
 							&zone);
-		return zone ? zone->node : numa_node_id();
+		return zone ? zone->node : node;
 	}
 
 	default:
diff -puN mm/slab.c~mm-mempolicy-rename-slab_node-for-clarity mm/slab.c
--- a/mm/slab.c~mm-mempolicy-rename-slab_node-for-clarity
+++ a/mm/slab.c
@@ -3042,7 +3042,7 @@ static void *alternate_node_alloc(struct
 	if (cpuset_do_slab_mem_spread() && (cachep->flags & SLAB_MEM_SPREAD))
 		nid_alloc = cpuset_slab_spread_node();
 	else if (current->mempolicy)
-		nid_alloc = slab_node();
+		nid_alloc = mempolicy_slab_node();
 	if (nid_alloc != nid_here)
 		return ____cache_alloc_node(cachep, flags, nid_alloc);
 	return NULL;
@@ -3074,7 +3074,7 @@ static void *fallback_alloc(struct kmem_
 
 retry_cpuset:
 	cpuset_mems_cookie = read_mems_allowed_begin();
-	zonelist = node_zonelist(slab_node(), flags);
+	zonelist = node_zonelist(mempolicy_slab_node(), flags);
 
 retry:
 	/*
diff -puN mm/slub.c~mm-mempolicy-rename-slab_node-for-clarity mm/slub.c
--- a/mm/slub.c~mm-mempolicy-rename-slab_node-for-clarity
+++ a/mm/slub.c
@@ -1685,7 +1685,7 @@ static void *get_any_partial(struct kmem
 
 	do {
 		cpuset_mems_cookie = read_mems_allowed_begin();
-		zonelist = node_zonelist(slab_node(), flags);
+		zonelist = node_zonelist(mempolicy_slab_node(), flags);
 		for_each_zone_zonelist(zone, z, zonelist, high_zoneidx) {
 			struct kmem_cache_node *n;
 
_

Patches currently in -mm which might be from rientjes@google.com are

mm-close-pagetail-race.patch
mm-page_alloc-make-first_page-visible-before-pagetail.patch
kthread-ensure-locality-of-task_struct-allocations.patch
arch-x86-mm-kmemcheck-kmemcheckc-use-kstrtoint-instead-of-sscanf.patch
mm-slab-slub-use-page-list-consistently-instead-of-page-lru.patch
mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch
mm-vmscan-shrink_slab-rename-max_pass-freeable.patch
mm-hugetlb-mark-some-bootstrap-functions-as-__init.patch
mm-compaction-avoid-isolating-pinned-pages.patch
mm-compactionc-mark-function-as-static.patch
mm-memoryc-mark-functions-as-static.patch
mm-mmapc-mark-function-as-static.patch
mm-process_vm_accessc-mark-function-as-static.patch
mm-process_vm_accessc-mark-function-as-static-fix.patch
mm-page_cgroupc-mark-functions-as-static.patch
mm-nobootmemc-mark-function-as-static.patch
include-linux-mmh-remove-ifdef-condition.patch
mm-readaheadc-fix-readahead-failure-for-memoryless-numa-nodes-and-limit-readahead-pages.patch
mmnuma-reorganize-change_pmd_range.patch
mmnuma-reorganize-change_pmd_range-fix.patch
move-mmu-notifier-call-from-change_protection-to-change_pmd_range.patch
mm-exclude-memory-less-nodes-from-zone_reclaim.patch
memcg-slab-never-try-to-merge-memcg-caches.patch
memcg-slab-cleanup-memcg-cache-creation.patch
memcg-slab-separate-memcg-vs-root-cache-creation-paths.patch
memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it.patch
memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases.patch
slub-adjust-memcg-caches-when-creating-cache-alias.patch
slub-rework-sysfs-layout-for-memcg-caches.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags-ignore-madv_hugepage-on-s390-to-prevent-sigsegv-in-qemu.patch
mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch
exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch
fork-collapse-copy_flags-into-copy_process.patch
mm-mempolicy-rename-slab_node-for-clarity.patch
mm-mempolicy-remove-per-process-flag.patch
res_counter-remove-interface-for-locked-charging-and-uncharging.patch
kernel-resourcec-make-reallocate_resource-static.patch
mm-utilc-add-kstrimdup.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
linux-next.patch

