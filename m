From: akpm@linux-foundation.org
Subject: + fix-x86_64-splat.patch added to -mm tree
Date: Mon, 09 Jun 2008 02:18:37 -0700
Message-ID: <200806090918.m599Ib0G012837@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758155AbYFIJTD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2008 05:19:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vegard.nossum@gmail.com, mingo@elte.hu, travis@sgi.com


The patch titled
     fix x86_64 splat
has been added to the -mm tree.  Its filename is
     fix-x86_64-splat.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 arch/x86/kernel/setup.c |    2 ++
 kernel/sched.c          |   10 +++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff -puN arch/x86/kernel/setup.c~fix-x86_64-splat arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~fix-x86_64-splat
+++ a/arch/x86/kernel/setup.c
@@ -385,6 +385,7 @@ cpumask_t *_node_to_cpumask_ptr(int node
 		dump_stack();
 		return &cpu_online_map;
 	}
+	BUG_ON(node >= nr_node_ids);
 	return &node_to_cpumask_map[node];
 }
 EXPORT_SYMBOL(_node_to_cpumask_ptr);
@@ -400,6 +401,7 @@ cpumask_t node_to_cpumask(int node)
 		dump_stack();
 		return cpu_online_map;
 	}
+	BUG_ON(node >= nr_node_ids);
 	return node_to_cpumask_map[node];
 }
 EXPORT_SYMBOL(node_to_cpumask);
diff -puN kernel/sched.c~fix-x86_64-splat kernel/sched.c
--- a/kernel/sched.c~fix-x86_64-splat
+++ a/kernel/sched.c
@@ -6770,7 +6770,7 @@ static void free_sched_groups(const cpum
 		if (!sched_group_nodes)
 			continue;
 
-		for (i = 0; i < MAX_NUMNODES; i++) {
+		for (i = 0; i < nr_node_ids; i++) {
 			struct sched_group *oldsg, *sg = sched_group_nodes[i];
 
 			*nodemask = node_to_cpumask(i);
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
_

Patches currently in -mm which might be from vegard.nossum@gmail.com are

origin.patch
linux-next.patch
fix-x86_64-splat.patch
arm-fix-header-guards.patch
parisc-fix-incomplete-header-guard.patch
kallsyms-fix-potential-overflow-in-binary-search.patch
cputopology-always-define-cpu-topology-information.patch
cputopology-always-define-cpu-topology-information-cleanup.patch
quota-cleanup-loop-in-sync_dquots.patch

