Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD8E3B2BA
	for <mm-commits@vger.kernel.org>; Wed, 14 Jan 2026 00:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768350096; cv=none; b=ikgUW81jjod5SAwDS6gDCpJ8b1yPIMHj/fF6ds6XBfmtDpS1TnB9W8dH68JmDdrpn602l+tXK27qKiiDTwtFKt+WCdSw9ZIgb5vCkpC3Z/gkDpO+VOiFbW10MsD6wk7gxuIegLctfoq/pNZYqi3cssybACOjeivUd5Cpa2C637A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768350096; c=relaxed/simple;
	bh=mhItFiz53cpYtejQCditysqaSHEr4NAXDLNrKrSldZ0=;
	h=Date:To:From:Subject:Message-Id; b=J7/PqT3S5xLW7zyIOmNz3GiBq60An+DA+FMlBF+mhJOaa1uSy+iZoRoIIUf3LGxM/3bEG1G1A+84m1GpwgQoFCkSEqUdll02naoUoeCNfDnrdbpQOd7QHWWtOsJyHRsgRFuoQylq3wseat1dX7t0P0/IvA/UQGkgLZqic7VKM8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oM3n88AZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oM3n88AZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDADEC19423;
	Wed, 14 Jan 2026 00:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768350096;
	bh=mhItFiz53cpYtejQCditysqaSHEr4NAXDLNrKrSldZ0=;
	h=Date:To:From:Subject:From;
	b=oM3n88AZBWsPJ5MpzDvvPAfJlfMzcG5LElqkIypiyS+CUaA+BmWxkUJGTY0Pn624j
	 AkD+zpSBkNCIIgAsveHpyv7dXHw7w9pEZy3buTq03x8acvSuBRcE+8sgnI0ermP96G
	 syCIA2WoIWHuIO51LEAagZFt2DSnGIJj3RJVO9Y0=
Date: Tue, 13 Jan 2026 16:21:35 -0800
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,tianyou.li@intel.com,tglx@linutronix.de,sagi@grimberg.me,rrendec@redhat.com,ming.lei@redhat.com,kbusch@kernel.org,hch@lst.de,dan.liang@intel.com,axboe@fb.com,wangyang.guo@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-group_cpus-make-group-cpu-cluster-aware.patch added to mm-nonmm-unstable branch
Message-Id: <20260114002135.EDADEC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/group_cpus: make group CPU cluster aware
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-group_cpus-make-group-cpu-cluster-aware.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-group_cpus-make-group-cpu-cluster-aware.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Wangyang Guo <wangyang.guo@intel.com>
Subject: lib/group_cpus: make group CPU cluster aware
Date: Tue, 13 Jan 2026 10:29:58 +0800

As CPU core counts increase, the number of NVMe IRQs may be smaller than
the total number of CPUs.  This forces multiple CPUs to share the same
IRQ.  If the IRQ affinity and the CPU's cluster do not align, a
performance penalty can be observed on some platforms.

This patch improves IRQ affinity by grouping CPUs by cluster within each
NUMA domain, ensuring better locality between CPUs and their assigned NVMe
IRQs.

Details:

Intel Xeon E platform packs 4 CPU cores as 1 module (cluster) and share
the L2 cache.  Let's say, if there are 40 CPUs in 1 NUMA domain and 11
IRQs to dispatch.  The existing algorithm will map first 7 IRQs each with
4 CPUs and remained 4 IRQs each with 3 CPUs.  The last 4 IRQs may have
cross cluster issue.  For example, the 9th IRQ which pinned to CPU32, then
for CPU31, it will have cross L2 memory access.

CPU |28 29 30 31|32 33 34 35|36 ...
     -------- -------- --------
IRQ      8        9       10

If this patch applied, then first 2 IRQs each mapped with 2 CPUs and rest
9 IRQs each mapped with 4 CPUs, which avoids the cross cluster memory
access.

CPU |00 01 02 03|04 05 06 07|08 09 10 11| ...
     ----- ----- ----------- -----------
IRQ  1      2        3           4

As a result, 15%+ performance difference is observed in FIO
libaio/randread/bs=8k.

Changes since V1:
- Add more performance details in commit messages.
- Fix endless loop when topology_cluster_cpumask return invalid mask.

History:
  v1: https://lore.kernel.org/all/20251024023038.872616-1-wangyang.guo@intel.com/
  v1 [RESEND]: https://lore.kernel.org/all/20251111020608.1501543-1-wangyang.guo@intel.com/

Link: https://lkml.kernel.org/r/20260113022958.3379650-1-wangyang.guo@intel.com
Signed-off-by: Wangyang Guo <wangyang.guo@intel.com>
Reviewed-by: Tianyou Li <tianyou.li@intel.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Tested-by: Dan Liang <dan.liang@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Radu Rendec <rrendec@redhat.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/group_cpus.c |  271 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 206 insertions(+), 65 deletions(-)

--- a/lib/group_cpus.c~lib-group_cpus-make-group-cpu-cluster-aware
+++ a/lib/group_cpus.c
@@ -114,48 +114,15 @@ static int ncpus_cmp_func(const void *l,
 	return ln->ncpus - rn->ncpus;
 }
 
-/*
- * Allocate group number for each node, so that for each node:
- *
- * 1) the allocated number is >= 1
- *
- * 2) the allocated number is <= active CPU number of this node
- *
- * The actual allocated total groups may be less than @numgrps when
- * active total CPU number is less than @numgrps.
- *
- * Active CPUs means the CPUs in '@cpu_mask AND @node_to_cpumask[]'
- * for each node.
- */
-static void alloc_nodes_groups(unsigned int numgrps,
-			       cpumask_var_t *node_to_cpumask,
-			       const struct cpumask *cpu_mask,
-			       const nodemask_t nodemsk,
-			       struct cpumask *nmsk,
-			       struct node_groups *node_groups)
+static void alloc_groups_to_nodes(unsigned int numgrps,
+				  unsigned int numcpus,
+				  struct node_groups *node_groups,
+				  unsigned int num_nodes)
 {
-	unsigned n, remaining_ncpus = 0;
-
-	for (n = 0; n < nr_node_ids; n++) {
-		node_groups[n].id = n;
-		node_groups[n].ncpus = UINT_MAX;
-	}
-
-	for_each_node_mask(n, nodemsk) {
-		unsigned ncpus;
+	unsigned int n, remaining_ncpus = numcpus;
+	unsigned int  ngroups, ncpus;
 
-		cpumask_and(nmsk, cpu_mask, node_to_cpumask[n]);
-		ncpus = cpumask_weight(nmsk);
-
-		if (!ncpus)
-			continue;
-		remaining_ncpus += ncpus;
-		node_groups[n].ncpus = ncpus;
-	}
-
-	numgrps = min_t(unsigned, remaining_ncpus, numgrps);
-
-	sort(node_groups, nr_node_ids, sizeof(node_groups[0]),
+	sort(node_groups, num_nodes, sizeof(node_groups[0]),
 	     ncpus_cmp_func, NULL);
 
 	/*
@@ -226,9 +193,8 @@ static void alloc_nodes_groups(unsigned
 	 * finally for each node X: grps(X) <= ncpu(X).
 	 *
 	 */
-	for (n = 0; n < nr_node_ids; n++) {
-		unsigned ngroups, ncpus;
 
+	for (n = 0; n < num_nodes; n++) {
 		if (node_groups[n].ncpus == UINT_MAX)
 			continue;
 
@@ -246,12 +212,201 @@ static void alloc_nodes_groups(unsigned
 	}
 }
 
+/*
+ * Allocate group number for each node, so that for each node:
+ *
+ * 1) the allocated number is >= 1
+ *
+ * 2) the allocated number is <= active CPU number of this node
+ *
+ * The actual allocated total groups may be less than @numgrps when
+ * active total CPU number is less than @numgrps.
+ *
+ * Active CPUs means the CPUs in '@cpu_mask AND @node_to_cpumask[]'
+ * for each node.
+ */
+static void alloc_nodes_groups(unsigned int numgrps,
+			       cpumask_var_t *node_to_cpumask,
+			       const struct cpumask *cpu_mask,
+			       const nodemask_t nodemsk,
+			       struct cpumask *nmsk,
+			       struct node_groups *node_groups)
+{
+	unsigned int n, numcpus = 0;
+
+	for (n = 0; n < nr_node_ids; n++) {
+		node_groups[n].id = n;
+		node_groups[n].ncpus = UINT_MAX;
+	}
+
+	for_each_node_mask(n, nodemsk) {
+		unsigned int ncpus;
+
+		cpumask_and(nmsk, cpu_mask, node_to_cpumask[n]);
+		ncpus = cpumask_weight(nmsk);
+
+		if (!ncpus)
+			continue;
+		numcpus += ncpus;
+		node_groups[n].ncpus = ncpus;
+	}
+
+	numgrps = min_t(unsigned int, numcpus, numgrps);
+	alloc_groups_to_nodes(numgrps, numcpus, node_groups, nr_node_ids);
+}
+
+static void assign_cpus_to_groups(unsigned int ncpus,
+				  struct cpumask *nmsk,
+				  struct node_groups *nv,
+				  struct cpumask *masks,
+				  unsigned int *curgrp,
+				  unsigned int last_grp)
+{
+	unsigned int v, cpus_per_grp, extra_grps;
+	/* Account for rounding errors */
+	extra_grps = ncpus - nv->ngroups * (ncpus / nv->ngroups);
+
+	/* Spread allocated groups on CPUs of the current node */
+	for (v = 0; v < nv->ngroups; v++, *curgrp += 1) {
+		cpus_per_grp = ncpus / nv->ngroups;
+
+		/* Account for extra groups to compensate rounding errors */
+		if (extra_grps) {
+			cpus_per_grp++;
+			--extra_grps;
+		}
+
+		/*
+		 * wrapping has to be considered given 'startgrp'
+		 * may start anywhere
+		 */
+		if (*curgrp >= last_grp)
+			*curgrp = 0;
+		grp_spread_init_one(&masks[*curgrp], nmsk, cpus_per_grp);
+	}
+}
+
+static int alloc_cluster_groups(unsigned int ncpus,
+				unsigned int ngroups,
+				struct cpumask *node_cpumask,
+				cpumask_var_t msk,
+				const struct cpumask ***clusters_ptr,
+				struct node_groups **cluster_groups_ptr)
+{
+	unsigned int ncluster = 0;
+	unsigned int cpu, nc, n;
+	const struct cpumask *cluster_mask;
+	const struct cpumask **clusters;
+	struct node_groups *cluster_groups;
+
+	cpumask_copy(msk, node_cpumask);
+
+	/* Probe how many clusters in this node. */
+	while (1) {
+		cpu = cpumask_first(msk);
+		if (cpu >= nr_cpu_ids)
+			break;
+
+		cluster_mask = topology_cluster_cpumask(cpu);
+		if (!cpumask_weight(cluster_mask))
+			goto no_cluster;
+		/* Clean out CPUs on the same cluster. */
+		cpumask_andnot(msk, msk, cluster_mask);
+		ncluster++;
+	}
+
+	/* If ngroups < ncluster, cross cluster is inevitable, skip. */
+	if (ncluster == 0 || ncluster > ngroups)
+		goto no_cluster;
+
+	/* Allocate memory based on cluster number. */
+	clusters = kcalloc(ncluster, sizeof(struct cpumask *), GFP_KERNEL);
+	if (!clusters)
+		goto no_cluster;
+	cluster_groups = kcalloc(ncluster, sizeof(struct node_groups), GFP_KERNEL);
+	if (!cluster_groups)
+		goto fail_cluster_groups;
+
+	/* Filling cluster info for later process. */
+	cpumask_copy(msk, node_cpumask);
+	for (n = 0; n < ncluster; n++) {
+		cpu = cpumask_first(msk);
+		cluster_mask = topology_cluster_cpumask(cpu);
+		nc = cpumask_weight_and(cluster_mask, node_cpumask);
+		clusters[n] = cluster_mask;
+		cluster_groups[n].id = n;
+		cluster_groups[n].ncpus = nc;
+		cpumask_andnot(msk, msk, cluster_mask);
+	}
+
+	alloc_groups_to_nodes(ngroups, ncpus, cluster_groups, ncluster);
+
+	*clusters_ptr = clusters;
+	*cluster_groups_ptr = cluster_groups;
+	return ncluster;
+
+ fail_cluster_groups:
+	kfree(clusters);
+ no_cluster:
+	return 0;
+}
+
+/*
+ * Try group CPUs evenly for cluster locality within a NUMA node.
+ *
+ * Return: true if success, false otherwise.
+ */
+static bool __try_group_cluster_cpus(unsigned int ncpus,
+				     unsigned int ngroups,
+				     struct cpumask *node_cpumask,
+				     struct cpumask *masks,
+				     unsigned int *curgrp,
+				     unsigned int last_grp)
+{
+	struct node_groups *cluster_groups;
+	const struct cpumask **clusters;
+	unsigned int ncluster;
+	bool ret = false;
+	cpumask_var_t nmsk;
+	unsigned int i, nc;
+
+	if (!zalloc_cpumask_var(&nmsk, GFP_KERNEL))
+		goto fail_nmsk_alloc;
+
+	ncluster = alloc_cluster_groups(ncpus, ngroups, node_cpumask, nmsk,
+					&clusters, &cluster_groups);
+
+	if (ncluster == 0)
+		goto fail_no_clusters;
+
+	for (i = 0; i < ncluster; i++) {
+		struct node_groups *nv = &cluster_groups[i];
+
+		/* Get the cpus on this cluster. */
+		cpumask_and(nmsk, node_cpumask, clusters[nv->id]);
+		nc = cpumask_weight(nmsk);
+		if (!nc)
+			continue;
+		WARN_ON_ONCE(nv->ngroups > nc);
+
+		assign_cpus_to_groups(nc, nmsk, nv, masks, curgrp, last_grp);
+	}
+
+	ret = true;
+	kfree(cluster_groups);
+	kfree(clusters);
+ fail_no_clusters:
+	free_cpumask_var(nmsk);
+ fail_nmsk_alloc:
+	return ret;
+}
+
 static int __group_cpus_evenly(unsigned int startgrp, unsigned int numgrps,
 			       cpumask_var_t *node_to_cpumask,
 			       const struct cpumask *cpu_mask,
 			       struct cpumask *nmsk, struct cpumask *masks)
 {
-	unsigned int i, n, nodes, cpus_per_grp, extra_grps, done = 0;
+	unsigned int i, n, nodes, done = 0;
 	unsigned int last_grp = numgrps;
 	unsigned int curgrp = startgrp;
 	nodemask_t nodemsk = NODE_MASK_NONE;
@@ -287,7 +442,7 @@ static int __group_cpus_evenly(unsigned
 	alloc_nodes_groups(numgrps, node_to_cpumask, cpu_mask,
 			   nodemsk, nmsk, node_groups);
 	for (i = 0; i < nr_node_ids; i++) {
-		unsigned int ncpus, v;
+		unsigned int ncpus;
 		struct node_groups *nv = &node_groups[i];
 
 		if (nv->ngroups == UINT_MAX)
@@ -301,28 +456,14 @@ static int __group_cpus_evenly(unsigned
 
 		WARN_ON_ONCE(nv->ngroups > ncpus);
 
-		/* Account for rounding errors */
-		extra_grps = ncpus - nv->ngroups * (ncpus / nv->ngroups);
-
-		/* Spread allocated groups on CPUs of the current node */
-		for (v = 0; v < nv->ngroups; v++, curgrp++) {
-			cpus_per_grp = ncpus / nv->ngroups;
-
-			/* Account for extra groups to compensate rounding errors */
-			if (extra_grps) {
-				cpus_per_grp++;
-				--extra_grps;
-			}
-
-			/*
-			 * wrapping has to be considered given 'startgrp'
-			 * may start anywhere
-			 */
-			if (curgrp >= last_grp)
-				curgrp = 0;
-			grp_spread_init_one(&masks[curgrp], nmsk,
-						cpus_per_grp);
+		if (__try_group_cluster_cpus(ncpus, nv->ngroups, nmsk,
+					     masks, &curgrp, last_grp)) {
+			done += nv->ngroups;
+			continue;
 		}
+
+		assign_cpus_to_groups(ncpus, nmsk, nv, masks, &curgrp,
+				      last_grp);
 		done += nv->ngroups;
 	}
 	kfree(node_groups);
_

Patches currently in -mm which might be from wangyang.guo@intel.com are

lib-group_cpus-make-group-cpu-cluster-aware.patch

