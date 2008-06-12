From: akpm@linux-foundation.org
Subject: - fix-x86_64-splat.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:36:27 -0700
Message-ID: <200806122036.m5CKaRMF005326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755460AbYFLUgr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:36:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vegard.nossum@gmail.com, mingo@elte.hu, travis@sgi.com, mm-commits@vger.kernel.org


The patch titled
     fix x86_64 splat
has been removed from the -mm tree.  Its filename was
     fix-x86_64-splat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix x86_64 splat
From: "Vegard Nossum" <vegard.nossum@gmail.com>

I have attached two patches. The sched one fixes Andrew's boot
problem. The x86 one is untested, but I believe it is better to BUG
than silently corrupt some arbitrary memory. (Then the callers can be
found easily and fixed at least.)

Cc: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN kernel/sched.c~fix-x86_64-splat kernel/sched.c
--- a/kernel/sched.c~fix-x86_64-splat
+++ a/kernel/sched.c
@@ -6574,9 +6574,9 @@ static int find_next_best_node(int node,
 
 	min_val = INT_MAX;
 
-	for (i = 0; i < MAX_NUMNODES; i++) {
+	for (i = 0; i < nr_node_ids; i++) {
 		/* Start at @node */
-		n = (node + i) % MAX_NUMNODES;
+		n = (node + i) % nr_node_ids;
 
 		if (!nr_cpus_node(n))
 			continue;
@@ -6770,7 +6770,7 @@ static void free_sched_groups(const cpum
 		if (!sched_group_nodes)
 			continue;
 
-		for (i = 0; i < MAX_NUMNODES; i++) {
+		for (i = 0; i < nr_node_ids; i++) {
 			struct sched_group *oldsg, *sg = sched_group_nodes[i];
 
 			*nodemask = node_to_cpumask(i);
@@ -6958,7 +6958,7 @@ static int __build_sched_domains(const c
 	/*
 	 * Allocate the per-node list of sched groups
 	 */
-	sched_group_nodes = kcalloc(MAX_NUMNODES, sizeof(struct sched_group *),
+	sched_group_nodes = kcalloc(nr_node_ids, sizeof(struct sched_group *),
 				    GFP_KERNEL);
 	if (!sched_group_nodes) {
 		printk(KERN_WARNING "Can not alloc sched group node list\n");
@@ -7097,7 +7097,7 @@ static int __build_sched_domains(const c
 #endif
 
 	/* Set up physical groups */
-	for (i = 0; i < MAX_NUMNODES; i++) {
+	for (i = 0; i < nr_node_ids; i++) {
 		SCHED_CPUMASK_VAR(nodemask, allmasks);
 		SCHED_CPUMASK_VAR(send_covered, allmasks);
 
@@ -7121,7 +7121,7 @@ static int __build_sched_domains(const c
 					send_covered, tmpmask);
 	}
 
-	for (i = 0; i < MAX_NUMNODES; i++) {
+	for (i = 0; i < nr_node_ids; i++) {
 		/* Set up node groups */
 		struct sched_group *sg, *prev;
 		SCHED_CPUMASK_VAR(nodemask, allmasks);
@@ -7160,9 +7160,9 @@ static int __build_sched_domains(const c
 		cpus_or(*covered, *covered, *nodemask);
 		prev = sg;
 
-		for (j = 0; j < MAX_NUMNODES; j++) {
+		for (j = 0; j < nr_node_ids; j++) {
 			SCHED_CPUMASK_VAR(notcovered, allmasks);
-			int n = (i + j) % MAX_NUMNODES;
+			int n = (i + j) % nr_node_ids;
 			node_to_cpumask_ptr(pnodemask, n);
 
 			cpus_complement(*notcovered, *covered);
@@ -7215,7 +7215,7 @@ static int __build_sched_domains(const c
 	}
 
 #ifdef CONFIG_NUMA
-	for (i = 0; i < MAX_NUMNODES; i++)
+	for (i = 0; i < nr_node_ids; i++)
 		init_numa_sched_groups_power(sched_group_nodes[i]);
 
 	if (sd_allnodes) {
_

Patches currently in -mm which might be from vegard.nossum@gmail.com are

origin.patch
linux-next.patch
arm-fix-header-guards.patch
parisc-fix-incomplete-header-guard.patch
kallsyms-fix-potential-overflow-in-binary-search.patch
cputopology-always-define-cpu-topology-information-cleanup.patch
quota-cleanup-loop-in-sync_dquots.patch
quota-move-function-macros-from-quotah-to-quotaopsh-fix.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-b34-fix.patch

