From: akpm@linux-foundation.org
Subject: [merged]
 mm-oom-ensure-memoryless-node-zonelist-always-includes-zones.patch removed
 from -mm tree
Date: Thu, 07 Aug 2014 13:06:15 -0700
Message-ID: <53e3dc37.jMQWdkx8qq8HpE8k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:57493 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbaHGUGQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:06:16 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so1176421pab.3
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:06:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: ensure memoryless node zonelist always includes zones
has been removed from the -mm tree.  Its filename was
     mm-oom-ensure-memoryless-node-zonelist-always-includes-zones.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: fix non-numa build]
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/sysrq.c      |    2 +-
 include/linux/nodemask.h |   11 ++++++++++-
 mm/oom_kill.c            |    2 +-
 3 files changed, 12 insertions(+), 3 deletions(-)

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
@@ -471,6 +479,7 @@ static inline int num_node_state(enum no
 	for ( (node) = 0; (node) == 0; (node) = 1)
 
 #define first_online_node	0
+#define first_memory_node	0
 #define next_online_node(nid)	(MAX_NUMNODES)
 #define nr_node_ids		1
 #define nr_online_nodes		1
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
x86-numa-setup_node_data-drop-dead-code-and-rename-function.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function-v2.patch
mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-use-get_page_unless_zero-in-hugetlb_fault.patch
mm-hugetlb-add-migration-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch
mm-utilc-add-kstrimdup.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
fork-exec-cleanup-mm-initialization.patch
fork-reset-mm-pinned_vm.patch
fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
linux-next.patch

