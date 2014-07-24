From: akpm@linux-foundation.org
Subject: +
 mm-oom-ensure-memoryless-node-zonelist-always-includes-zones.patch added to -mm tree
Date: Thu, 24 Jul 2014 15:23:21 -0700
Message-ID: <53d18759.7qFm7+/AjeBjAWjN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:45278 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaGXWXX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Jul 2014 18:23:23 -0400
Received: by mail-vc0-f201.google.com with SMTP id hu12so606100vcb.0
        for <mm-commits@vger.kernel.org>; Thu, 24 Jul 2014 15:23:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: ensure memoryless node zonelist always includes zones
has been added to the -mm tree.  Its filename is
     mm-oom-ensure-memoryless-node-zonelist-always-includes-zones.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-ensure-memoryless-node-zonelist-always-includes-zones.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-ensure-memoryless-node-zonelist-always-includes-zones.patch

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
Subject: mm, oom: ensure memoryless node zonelist always includes zones

With memoryless node support being worked on, it's possible that for
optimizations that a node may not have a non-NULL zonelist.  When
CONFIG_NUMA is enabled and node 0 is memoryless, this means the zonelist
for first_online_node may become NULL.

The oom killer requires a zonelist that includes all memory zones for the
sysrq trigger and pagefault out of memory handler.

Ensure that a non-NULL zonelist is always passed to the oom killer.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/sysrq.c      |    2 +-
 include/linux/nodemask.h |   10 +++++++++-
 mm/oom_kill.c            |    2 +-
 3 files changed, 11 insertions(+), 3 deletions(-)

diff -puN drivers/tty/sysrq.c~mm-oom-ensure-memoryless-node-zonelist-always-includes-zones drivers/tty/sysrq.c
--- a/drivers/tty/sysrq.c~mm-oom-ensure-memoryless-node-zonelist-always-includes-zones
+++ a/drivers/tty/sysrq.c
@@ -355,7 +355,7 @@ static struct sysrq_key_op sysrq_term_op
 
 static void moom_callback(struct work_struct *ignored)
 {
-	out_of_memory(node_zonelist(first_online_node, GFP_KERNEL), GFP_KERNEL,
+	out_of_memory(node_zonelist(first_memory_node, GFP_KERNEL), GFP_KERNEL,
 		      0, NULL, true);
 }
 
diff -puN include/linux/nodemask.h~mm-oom-ensure-memoryless-node-zonelist-always-includes-zones include/linux/nodemask.h
--- a/include/linux/nodemask.h~mm-oom-ensure-memoryless-node-zonelist-always-includes-zones
+++ a/include/linux/nodemask.h
@@ -430,7 +430,15 @@ static inline int num_node_state(enum no
 	for_each_node_mask((__node), node_states[__state])
 
 #define first_online_node	first_node(node_states[N_ONLINE])
-#define next_online_node(nid)	next_node((nid), node_states[N_ONLINE])
+#define first_memory_node	first_node(node_states[N_MEMORY])
+static inline int next_online_node(int nid)
+{
+	return next_node(nid, node_states[N_ONLINE]);
+}
+static inline int next_memory_node(int nid)
+{
+	return next_node(nid, node_states[N_MEMORY]);
+}
 
 extern int nr_node_ids;
 extern int nr_online_nodes;
diff -puN mm/oom_kill.c~mm-oom-ensure-memoryless-node-zonelist-always-includes-zones mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-ensure-memoryless-node-zonelist-always-includes-zones
+++ a/mm/oom_kill.c
@@ -694,7 +694,7 @@ void pagefault_out_of_memory(void)
 	if (mem_cgroup_oom_synchronize(true))
 		return;
 
-	zonelist = node_zonelist(first_online_node, GFP_KERNEL);
+	zonelist = node_zonelist(first_memory_node, GFP_KERNEL);
 	if (try_set_zonelist_oom(zonelist, GFP_KERNEL)) {
 		out_of_memory(NULL, 0, 0, NULL, false);
 		clear_zonelist_oom(zonelist, GFP_KERNEL);
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
mm-thp-do-not-allow-thp-faults-to-avoid-cpuset-restrictions.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function-v2.patch
score-ptrace-remove-the-macros-which-not-be-used-currently.patch
mm-slabc-add-__init-to-init_lock_keys.patch
slab-common-add-functions-for-kmem_cache_node-access.patch
slab-common-add-functions-for-kmem_cache_node-access-fix.patch
slub-use-new-node-functions.patch
slub-use-new-node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions.patch
slab-use-get_node-and-kmem_cache_node-functions-fix.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
mm-slabh-wrap-the-whole-file-with-guarding-macro.patch
mm-slub-mark-resiliency_test-as-init-text.patch
mm-slub-slub_debug=n-use-the-same-alloc-free-hooks-as-for-slub_debug=y.patch
slab-add-unlikely-macro-to-help-compiler.patch
slab-move-up-code-to-get-kmem_cache_node-in-free_block.patch
slab-defer-slab_destroy-in-free_block.patch
slab-defer-slab_destroy-in-free_block-v4.patch
slab-factor-out-initialization-of-arracy-cache.patch
slab-introduce-alien_cache.patch
slab-use-the-lock-on-alien_cache-instead-of-the-lock-on-array_cache.patch
slab-destroy-a-slab-without-holding-any-alien-cache-lock.patch
slab-remove-a-useless-lockdep-annotation.patch
slab-remove-bad_alien_magic.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
slub-reduce-duplicate-creation-on-the-first-object.patch
mm-move-slab-related-stuff-from-utilc-to-slab_commonc.patch
mm-trivial-comment-cleanup-in-slabc.patch
mm-slub-fix-false-positive-lockdep-warning-in-free_partial.patch
mm-slub-fix-some-indenting-in-cmpxchg_double_slab.patch
slab-fix-the-alias-countvia-sysfs-of-slab-cache.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
mm-page_alloc-simplify-drain_zone_pages-by-using-min.patch
mm-mem-hotplug-replace-simple_strtoull-with-kstrtoull.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
mm-vmalloc-constify-allocation-mask.patch
mmhugetlb-make-unmap_ref_private-return-void.patch
mmhugetlb-simplify-error-handling-in-hugetlb_cow.patch
mm-hugetlb-generalize-writes-to-nr_hugepages.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity.patch
mm-make-copy_pte_range-static-again.patch
mm-thp-only-collapse-hugepages-to-nodes-with-affinity-for-zone_reclaim_mode.patch
mm-writeback-prevent-race-when-calculating-dirty-limits.patch
slub-remove-kmemcg-id-from-create_unique_id.patch
mm-refactor-page-index-offset-getters.patch
mm-refactor-page-index-offset-getters-fix.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones.patch
mm-oom-remove-unnecessary-check-for-null-zonelist.patch
mm-oom-rename-zonelist-locking-functions.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch
lib-add-size-unit-t-p-e-to-memparse.patch
mm-utilc-add-kstrimdup.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
fork-exec-cleanup-mm-initialization.patch
fork-reset-mm-pinned_vm.patch
fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
linux-next.patch

