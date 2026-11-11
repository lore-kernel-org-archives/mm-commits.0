Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794376209;
	b=mzOslr1RHi3LcST6gBAeWc8PfvH5f/WmKrYSZQ4YZvuKfHcoMpUl703G0OSdg7SwKJl0
	 tMwPjpCo/CxG0IkJnfgIINLxWkK52MikwlpJVYyIue4I/bOFiIBO+2J60sTdjN+xu3qeh
	 e9fSuX3t3Ix+efO6FzO7E/NkTtyJzqu0U3i06D/uI/9Lra88yqsmMi8szAdgYCubZLjyz
	 JY8u9mYUqKHqI0hGu6a7UrgLHCY6i4hHe9qcYGvMsXUmtlKYd4dLp58MrGhjfWEZ3vDmb
	 37ZO3yYEAffgLVtH6wpF8LktKZ4FXbJAoLj+ONMs0y1Snf8qEj3mp+sQtZEjnXgx2mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794376209;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=vEiTW+ZQgqq6LOKwwdTxoq3G81q4+7OhDE0dZBxDDHw=;
	b=gyubiGi9wPxJMDE0HrBhQLZu6eUGjppOKiKJ3sQQyKS5m9oD9qcV+3mUnHZruymVacD+
	 CfJzB9fBE8gkdH2OFTAO90qb98Sxm12ATIONP9IHFOXph+s0goIq74Ne2gA1KQesj2lti
	 d092Nm33dXvyIRk8Q0OXbu/EGy+RqEEoutEi6BpHygkVd9+ICqA/RWOdcjmpEwrTBK08r
	 qKLH08e/9DgOwJJ2kvIhf6wiWhIfnob0k2OkQJ8E4JMBj4PMJHYscQqhK8IopIc7Ap7CI
	 ckhJancN86Pk8+UpF8pAm2Iv0umYsaw30L2z+yS58chTd0825EaJUnW+X8Q7lR6iJfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=dpBRhw3i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23317606A331;
	Wed, 11 Nov 2026 05:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=dpBRhw3i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A3F1F00A06;
	Wed, 11 Nov 2026 05:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794376208;
	bh=vEiTW+ZQgqq6LOKwwdTxoq3G81q4+7OhDE0dZBxDDHw=;
	h=Date:To:From:Subject;
	b=dpBRhw3iUxAYKI3HYiHxCuEDfF4x8ehF26V5cJNGWhP0Zlh3YlMD6lYkU2iCp8aYf
	 W39sEpkLtK34FI94CMY2OrxoWGmM0voC00YEoHU+wVLMmxif3xHQySYcQGFsWLrOws
	 nrf5VD/bffhNXmNwgCZShPSu6H30wNTp/Fd6A6S0=
Date: Tue, 10 Nov 2026 21:50:07 -0800
To: mm-commits@vger.kernel.org,wangyang.guo@intel.com,
	tim.c.chen@linux.intel.com,tianyou.li@intel.com,tglx@kernel.org,
	stable@vger.kernel.org,dan.liang@intel.com,bp@alien8.de,
	Vishal.Badole@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-group_cpus-snapshot-cluster-masks-to-keep-grouping-hotplug-invariant.patch added to mm-nonmm-unstable branch
Message-Id: <20261111055008.24A3F1F00A06@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: lib/group_cpus: snapshot cluster masks to keep grouping hotplug invariant
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-group_cpus-snapshot-cluster-masks-to-keep-grouping-hotplug-invariant.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-group_cpus-snapshot-cluster-masks-to-keep-grouping-hotplug-invariant.patch

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
From: Vishal Badole <Vishal.Badole@amd.com>
Subject: lib/group_cpus: snapshot cluster masks to keep grouping hotplug invariant
Date: Tue, 10 Nov 2026 23:15:13 +0530

group_cpus_evenly() builds the managed-IRQ affinity spread used by
multi-queue devices such as NVMe.  That spread is meant to be a property
of the static CPU topology: it walks cpu_present_mask and then
cpu_possible_mask so every hardware queue owns a fixed set of CPUs,
including CPUs that are offline at the time.  A driver depends on that
partition staying stable across re-computation - the CPUs a queue is given
at probe must still describe the same queue after the device is later
reset and its affinity recomputed.

On an AMD system that stability breaks across an s2idle cycle.  CPUs 3-11
are offlined before suspend, leaving only CPUs 0-2 online.  s2idle itself
does not offline secondary CPUs.  The NVMe controller uses the
simple-suspend quirk, so resume fully re-initialises it and recomputes the
affinity spread while CPUs 3-11 remain offline.  The system then hangs for
roughly two minutes and stays sluggish afterwards, the controller only
making progress through its command-timeout poll:

  nvme nvme0: I/O tag 898 (3382) QID 9 timeout, completion polled
  nvme nvme0: I/O tag 398 (618e) QID 11 timeout, completion polled

QID 9 and QID 11 are the queues whose CPUs were offline when the spread
was recomputed.  "completion polled" means the commands did finish in
hardware, but their interrupts were never delivered to a CPU that was
watching the queue, so nothing reaped them until the timeout fired.

It happens because commit 89802ca36c96 ("lib/group_cpus: make group CPU
cluster aware") derives the cluster groups from
topology_cluster_cpumask(), which lists only the cluster siblings that are
online when it is called.  The resulting partition therefore depends on
the transient online mask rather than on the topology alone.  Recomputed
on resume while CPUs 3-11 remain offline, it no longer matches the
boot-time partition, and a queue is left with an affinity that does not
cover the CPU it is meant to serve once that CPU comes back online.  The
dependence is on the online mask, not on any AMD-specific behaviour, so
the same stall is reproducible on Intel platforms as well.

Fix this by snapshotting cluster and SMT masks together under
cpus_read_trylock() when all present CPUs are online.  Latch the first
capture attempt, permanently using CPU-order grouping if it fails, and
propagate later allocation errors instead of switching algorithms.  This
keeps successful spreads stable across CPU offline/online cycles for an
unchanged group count, present/possible CPU sets and NUMA topology.

Link: https://lore.kernel.org/20261110174513.461743-1-Vishal.Badole@amd.com
Fixes: 89802ca36c96 ("lib/group_cpus: make group CPU cluster aware")
Signed-off-by: Vishal Badole <Vishal.Badole@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: <bp@alien8.de>
Cc: Wangyang Guo <wangyang.guo@intel.com>
Cc: Tianyou Li <tianyou.li@intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Dan Liang <dan.liang@intel.com>
Cc: <stable@vger.kernel.org>
---

 lib/group_cpus.c |  125 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 106 insertions(+), 19 deletions(-)

--- a/lib/group_cpus.c~lib-group_cpus-snapshot-cluster-masks-to-keep-grouping-hotplug-invariant
+++ a/lib/group_cpus.c
@@ -6,11 +6,14 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/cpu.h>
+#include <linux/mutex.h>
 #include <linux/sort.h>
 #include <linux/group_cpus.h>
 
 #ifdef CONFIG_SMP
 
+static cpumask_var_t *sibling_snapshot;
+
 static void grp_spread_init_one(struct cpumask *irqmsk, struct cpumask *nmsk,
 				unsigned int cpus_per_grp)
 {
@@ -29,7 +32,7 @@ static void grp_spread_init_one(struct c
 		cpus_per_grp--;
 
 		/* If the cpu has siblings, use them first */
-		siblmsk = topology_sibling_cpumask(cpu);
+		siblmsk = sibling_snapshot ? sibling_snapshot[cpu] : cpumask_of(cpu);
 		for (sibl = -1; cpus_per_grp > 0; ) {
 			sibl = cpumask_next(sibl, siblmsk);
 			if (sibl >= nr_cpu_ids)
@@ -286,6 +289,84 @@ static void assign_cpus_to_groups(unsign
 	}
 }
 
+/*
+ * Cluster and SMT sibling masks change when CPUs go offline. Snapshot both
+ * on the first spread if every present CPU is online. Latch the attempt even
+ * on failure, so later spreads cannot enable a different grouping algorithm.
+ *
+ * Without a snapshot, use CPU order without cluster or SMT preference.
+ * Successful spreads remain stable for the same group count, present/possible
+ * CPU sets and NUMA topology. The snapshot is not refreshed for CPU hot-add.
+ */
+static cpumask_var_t *cluster_snapshot;
+static bool cluster_snapshot_initialized;
+static DEFINE_MUTEX(cluster_snapshot_lock);
+
+static void capture_cluster_snapshot(void)
+{
+	cpumask_var_t *snapshot, *siblings;
+	unsigned int cpu;
+
+	/* Pairs with the smp_store_release() below. */
+	if (smp_load_acquire(&cluster_snapshot_initialized))
+		return;
+
+	mutex_lock(&cluster_snapshot_lock);
+	if (cluster_snapshot_initialized)
+		goto out;
+
+	/* Only capture when all present CPUs are online. */
+	if (!data_race(cpumask_equal(cpu_present_mask, cpu_online_mask)))
+		goto done;
+
+	snapshot = kcalloc(nr_cpu_ids, sizeof(*snapshot), GFP_KERNEL);
+	if (!snapshot)
+		goto done;
+	siblings = kcalloc(nr_cpu_ids, sizeof(*siblings), GFP_KERNEL);
+	if (!siblings)
+		goto free_snapshot;
+
+	for_each_possible_cpu(cpu)
+		if (!zalloc_cpumask_var(&snapshot[cpu], GFP_KERNEL) ||
+		    !zalloc_cpumask_var(&siblings[cpu], GFP_KERNEL))
+			goto free_snapshot;
+
+	/* Trylock: a caller may hold a lock the hotplug writer needs. */
+	if (!cpus_read_trylock())
+		goto free_snapshot;
+
+	/* Recheck with CPU hotplug excluded before copying the masks. */
+	if (!data_race(cpumask_equal(cpu_present_mask, cpu_online_mask))) {
+		cpus_read_unlock();
+		goto free_snapshot;
+	}
+
+	for_each_possible_cpu(cpu) {
+		cpumask_copy(snapshot[cpu], topology_cluster_cpumask(cpu));
+		cpumask_copy(siblings[cpu], topology_sibling_cpumask(cpu));
+	}
+	cpus_read_unlock();
+
+	cluster_snapshot = snapshot;
+	sibling_snapshot = siblings;
+	goto done;
+
+free_snapshot:
+	/* Unallocated entries are NULL, which free_cpumask_var() ignores. */
+	for_each_possible_cpu(cpu) {
+		free_cpumask_var(snapshot[cpu]);
+		if (siblings)
+			free_cpumask_var(siblings[cpu]);
+	}
+	kfree(snapshot);
+	kfree(siblings);
+done:
+	/* Publish the capture outcome, including failure, before grouping. */
+	smp_store_release(&cluster_snapshot_initialized, true);
+out:
+	mutex_unlock(&cluster_snapshot_lock);
+}
+
 static int alloc_cluster_groups(unsigned int ncpus,
 				unsigned int ngroups,
 				struct cpumask *node_cpumask,
@@ -299,6 +380,9 @@ static int alloc_cluster_groups(unsigned
 	const struct cpumask **clusters;
 	struct node_groups *cluster_groups;
 
+	if (!cluster_snapshot)
+		goto no_cluster;
+
 	cpumask_copy(msk, node_cpumask);
 
 	/* Probe how many clusters in this node. */
@@ -307,7 +391,7 @@ static int alloc_cluster_groups(unsigned
 		if (cpu >= nr_cpu_ids)
 			break;
 
-		cluster_mask = topology_cluster_cpumask(cpu);
+		cluster_mask = cluster_snapshot[cpu];
 		if (!cpumask_weight(cluster_mask))
 			goto no_cluster;
 		/* Clean out CPUs on the same cluster. */
@@ -322,7 +406,7 @@ static int alloc_cluster_groups(unsigned
 	/* Allocate memory based on cluster number. */
 	clusters = kzalloc_objs(*clusters, ncluster);
 	if (!clusters)
-		goto no_cluster;
+		return -ENOMEM;
 	cluster_groups = kzalloc_objs(struct node_groups, ncluster);
 	if (!cluster_groups)
 		goto fail_cluster_groups;
@@ -331,7 +415,7 @@ static int alloc_cluster_groups(unsigned
 	cpumask_copy(msk, node_cpumask);
 	for (n = 0; n < ncluster; n++) {
 		cpu = cpumask_first(msk);
-		cluster_mask = topology_cluster_cpumask(cpu);
+		cluster_mask = cluster_snapshot[cpu];
 		nc = cpumask_weight_and(cluster_mask, node_cpumask);
 		clusters[n] = cluster_mask;
 		cluster_groups[n].id = n;
@@ -347,6 +431,7 @@ static int alloc_cluster_groups(unsigned
 
  fail_cluster_groups:
 	kfree(clusters);
+	return -ENOMEM;
  no_cluster:
 	return 0;
 }
@@ -354,9 +439,9 @@ static int alloc_cluster_groups(unsigned
 /*
  * Try group CPUs evenly for cluster locality within a NUMA node.
  *
- * Return: true if success, false otherwise.
+ * Return: cluster count on success, 0 if inapplicable, or -ENOMEM on failure.
  */
-static bool __try_group_cluster_cpus(unsigned int ncpus,
+static int __try_group_cluster_cpus(unsigned int ncpus,
 				     unsigned int ngroups,
 				     struct cpumask *node_cpumask,
 				     struct cpumask *masks,
@@ -365,18 +450,17 @@ static bool __try_group_cluster_cpus(uns
 {
 	struct node_groups *cluster_groups;
 	const struct cpumask **clusters;
-	unsigned int ncluster;
-	bool ret = false;
+	int ncluster;
 	cpumask_var_t nmsk;
 	unsigned int i, nc;
 
 	if (!zalloc_cpumask_var(&nmsk, GFP_KERNEL))
-		goto fail_nmsk_alloc;
+		return -ENOMEM;
 
 	ncluster = alloc_cluster_groups(ncpus, ngroups, node_cpumask, nmsk,
 					&clusters, &cluster_groups);
 
-	if (ncluster == 0)
+	if (ncluster <= 0)
 		goto fail_no_clusters;
 
 	for (i = 0; i < ncluster; i++) {
@@ -392,13 +476,11 @@ static bool __try_group_cluster_cpus(uns
 		assign_cpus_to_groups(nc, nmsk, nv, masks, curgrp, last_grp);
 	}
 
-	ret = true;
 	kfree(cluster_groups);
 	kfree(clusters);
  fail_no_clusters:
 	free_cpumask_var(nmsk);
- fail_nmsk_alloc:
-	return ret;
+	return ncluster;
 }
 
 static int __group_cpus_evenly(unsigned int startgrp, unsigned int numgrps,
@@ -442,6 +524,7 @@ static int __group_cpus_evenly(unsigned
 	for (i = 0; i < nr_node_ids; i++) {
 		unsigned int ncpus;
 		struct node_groups *nv = &node_groups[i];
+		int ret;
 
 		if (nv->ngroups == UINT_MAX)
 			continue;
@@ -454,14 +537,16 @@ static int __group_cpus_evenly(unsigned
 
 		WARN_ON_ONCE(nv->ngroups > ncpus);
 
-		if (__try_group_cluster_cpus(ncpus, nv->ngroups, nmsk,
-					     masks, &curgrp, last_grp)) {
-			done += nv->ngroups;
-			continue;
+		ret = __try_group_cluster_cpus(ncpus, nv->ngroups, nmsk,
+					       masks, &curgrp, last_grp);
+		if (ret < 0) {
+			kfree(node_groups);
+			return ret;
 		}
 
-		assign_cpus_to_groups(ncpus, nmsk, nv, masks, &curgrp,
-				      last_grp);
+		if (!ret)
+			assign_cpus_to_groups(ncpus, nmsk, nv, masks, &curgrp,
+					      last_grp);
 		done += nv->ngroups;
 	}
 	kfree(node_groups);
@@ -496,6 +581,8 @@ struct cpumask *group_cpus_evenly(unsign
 	if (numgrps == 0)
 		return NULL;
 
+	capture_cluster_snapshot();
+
 	if (!zalloc_cpumask_var(&nmsk, GFP_KERNEL))
 		return NULL;
 
_

Patches currently in -mm which might be from Vishal.Badole@amd.com are

lib-group_cpus-snapshot-cluster-masks-to-keep-grouping-hotplug-invariant.patch

