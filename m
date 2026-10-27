Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793115449;
	b=NXoNjGs4B1cVTH+mVYMmnObnPGFv3iOLzrt8FiOeOsNgyK5xZWj5hMuLH5gMp8qnl9pS
	 p/rExb1cz5Ih3b7S2Cd3HoUhAKvSRAB+GUYH5IYcVogEabrIZL2uSHzbyQdb0EfxgU72A
	 SaLtyGXIU+A9Q+FyamRGTTZW2Ddd08tbClsRbuzsjm3gerPp6AuzdVoAnoryQ1bMyGSoy
	 Jvs2Z9X015B8o9w9SMPjvOUVYNChS2r8Gc4M1HybOkUxD9BnkjX+C6bNia4HO1HaVgCTs
	 C3xQH4qy8HPGVpCLsXShOPLGD9WA7au2FRUiopqpsQbimQQOldfx5JPZNMlZGZRVA0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793115449;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=vaAhT2JOYCr9kbrHlVAbzMWbcRUa5E2UWb6Rda9CcvE=;
	b=zH1WkBVDxuagEmA8rui1LDwDuSwLB7fXscs5KE5Qh+zPoIL/u1ZG52po8HwhwP36cqKf
	 7pdP7CEPk3LSuhSUFOEsBNGtkNMqD0rQp1GpfB3UYVJ4Yer9OZjKGOYPX/gg4YjKiaApN
	 csPpwCDiHP1Nrt4az5kZU4IY2nfBTzFEJCMnJmX4SoRLiJSXaQ2R2BcIFN5d1nxcgqQQ3
	 FRUWZV6+Zx4XzsT0Xad7A7RY9R79xYLqvOueYAzCmEcJgIVUgTPZ7EGCapm3onus3wUNo
	 BRIqB3T+o7clkby4XccyJTq5ykf0PjGY1ZZY0U/sUBAMYFfbKTmWSogngCDTaTn4Axw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=KSou9c9s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C63C606D926;
	Tue, 27 Oct 2026 15:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=KSou9c9s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3E71F01181;
	Tue, 27 Oct 2026 15:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793115448;
	bh=vaAhT2JOYCr9kbrHlVAbzMWbcRUa5E2UWb6Rda9CcvE=;
	h=Date:To:From:Subject;
	b=KSou9c9s+uiziP9MHhoOwQb48TgIRzFshU3X2MbRa0zcVNvSq6jxboCTr8A1fPbVs
	 F8ZtvFqUpPMIU+6WKlP3FY2BMElUDx99pzFmfkOIGAK9yvxo9KbiShpc/o1M1KkXSt
	 Fc8C/s+yjyqKhY92Wp/ALqsyjNAC9ujIZDtcGzAw=
Date: Tue, 27 Oct 2026 08:37:28 -0700
To: mm-commits@vger.kernel.org,wangyang.guo@intel.com,
	tim.c.chen@linux.intel.com,tianyou.li@intel.com,tglx@kernel.org,
	stable@vger.kernel.org,radu@rendec.net,dan.liang@intel.com,bp@alien8.de,
	Vishal.Badole@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] lib-group_cpus-snapshot-cluster-masks-to-keep-grouping-hotplug-invariant.patch removed from -mm tree
Message-Id: <20261027153728.AF3E71F01181@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: lib/group_cpus: snapshot cluster masks to keep grouping hotplug invariant
has been removed from the -mm tree.  Its filename was
     lib-group_cpus-snapshot-cluster-masks-to-keep-grouping-hotplug-invariant.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Vishal Badole <Vishal.Badole@amd.com>
Subject: lib/group_cpus: snapshot cluster masks to keep grouping hotplug invariant
Date: Wed, 26 Aug 2026 22:45:37 +0530

group_cpus_evenly() builds the managed-IRQ affinity spread used by
multi-queue devices such as NVMe.  That spread is meant to be a property
of the static CPU topology: it walks cpu_present_mask and then
cpu_possible_mask so every hardware queue owns a fixed set of CPUs,
including CPUs that are offline at the time.  A driver depends on that
partition staying stable across re-computation - the CPUs a queue is given
at probe must still describe the same queue after the device is later
reset and its affinity recomputed.

On an AMD system that stability breaks across an s2idle cycle.  With CPUs
3-11 offlined and only CPUs 0-2 left online, the machine is suspended to
s2idle and resumed.  The NVMe controller uses the simple-suspend quirk, so
resume fully re-initialises it and recomputes the affinity spread.  The
system then hangs for roughly two minutes and stays sluggish afterwards,
the controller only making progress through its command-timeout poll:

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
on resume while the non-boot CPUs are still offline, it no longer matches
the boot-time partition, and a queue is left with an affinity that does
not cover the CPU it is meant to serve once that CPU comes back online. 
The dependence is on the online mask, not on any AMD-specific behaviour,
so the same stall is reproducible on Intel platforms as well.

Make the cluster grouping depend on the complete cluster topology rather
than on whichever CPUs happen to be online.  Snapshot the cluster masks
once while every present CPU is online and reuse that view for every later
spread.  Every spread then groups from the same masks, so the partition
computed when the controller is reset matches the one computed at probe
and each queue's IRQ still covers the CPUs it serves.  If the snapshot was
never taken, the cluster path is skipped and the plain present/possible
spread is used.

Link: https://lore.kernel.org/20260826171537.4167367-1-Vishal.Badole@amd.com
Fixes: 89802ca36c96 ("lib/group_cpus: make group CPU cluster aware")
Signed-off-by: Vishal Badole <Vishal.Badole@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Wangyang Guo <wangyang.guo@intel.com>
Tested-by: Wangyang Guo <wangyang.guo@intel.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Radu Rendec <radu@rendec.net>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Tianyou Li <tianyou.li@intel.com>
Cc: Dan Liang <dan.liang@intel.com>
Cc: <stable@vger.kernel.org>
---

 lib/group_cpus.c |   87 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 85 insertions(+), 2 deletions(-)

--- a/lib/group_cpus.c~lib-group_cpus-snapshot-cluster-masks-to-keep-grouping-hotplug-invariant
+++ a/lib/group_cpus.c
@@ -6,6 +6,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/cpu.h>
+#include <linux/mutex.h>
 #include <linux/sort.h>
 #include <linux/group_cpus.h>
 
@@ -286,6 +287,77 @@ static void assign_cpus_to_groups(unsign
 	}
 }
 
+/*
+ * topology_cluster_cpumask() only lists the cluster siblings that are online,
+ * so group_cpus_evenly() would compute a different managed-IRQ partition when
+ * recomputed with CPUs offline (e.g. an NVMe reset across s2idle), steering a
+ * queue's IRQ away from the CPU it serves.
+ *
+ * Snapshot the cluster masks once, on the first spread seen with every
+ * present CPU online, and reuse it so the grouping stays stable. If no
+ * snapshot exists (partial boot via maxcpus=/nosmp, or allocation failure)
+ * the cluster path is skipped and the plain present/possible spread is
+ * used. Only the cluster path is stabilised; grp_spread_init_one()'s
+ * sibling mask is unchanged. The snapshot lives for the system lifetime
+ * and is not refreshed for CPUs hot-added after boot.
+ */
+static cpumask_var_t *cluster_snapshot;
+static bool cluster_snapshot_ready;
+static DEFINE_MUTEX(cluster_snapshot_lock);
+
+static void capture_cluster_snapshot(void)
+{
+	cpumask_var_t *snapshot;
+	unsigned int cpu;
+
+	/* Pairs with the smp_store_release() below. */
+	if (smp_load_acquire(&cluster_snapshot_ready))
+		return;
+
+	/* Only capture when all present CPUs are online. */
+	if (!data_race(cpumask_equal(cpu_present_mask, cpu_online_mask)))
+		return;
+
+	mutex_lock(&cluster_snapshot_lock);
+	if (cluster_snapshot_ready)
+		goto out;
+
+	snapshot = kcalloc(nr_cpu_ids, sizeof(*snapshot), GFP_KERNEL);
+	if (!snapshot)
+		goto out;
+
+	for_each_possible_cpu(cpu)
+		if (!zalloc_cpumask_var(&snapshot[cpu], GFP_KERNEL))
+			goto free_snapshot;
+
+	/* Trylock: a caller may hold a lock the hotplug writer needs. */
+	if (!cpus_read_trylock())
+		goto free_snapshot;
+
+	/* Recheck under the lock, which also pins the cluster masks. */
+	if (!data_race(cpumask_equal(cpu_present_mask, cpu_online_mask))) {
+		cpus_read_unlock();
+		goto free_snapshot;
+	}
+
+	for_each_possible_cpu(cpu)
+		cpumask_copy(snapshot[cpu], topology_cluster_cpumask(cpu));
+	cpus_read_unlock();
+
+	cluster_snapshot = snapshot;
+	/* Publish the filled snapshot before the ready flag. */
+	smp_store_release(&cluster_snapshot_ready, true);
+	goto out;
+
+free_snapshot:
+	/* Unallocated entries are NULL, which free_cpumask_var() ignores. */
+	for_each_possible_cpu(cpu)
+		free_cpumask_var(snapshot[cpu]);
+	kfree(snapshot);
+out:
+	mutex_unlock(&cluster_snapshot_lock);
+}
+
 static int alloc_cluster_groups(unsigned int ncpus,
 				unsigned int ngroups,
 				struct cpumask *node_cpumask,
@@ -299,6 +371,17 @@ static int alloc_cluster_groups(unsigned
 	const struct cpumask **clusters;
 	struct node_groups *cluster_groups;
 
+	/*
+	 * Capture on the first spread with every present CPU online (normally
+	 * the first device probe); later spreads reuse it. Sample the ready
+	 * flag once so both loops below use one consistent source.
+	 */
+	capture_cluster_snapshot();
+
+	/* Pairs with the smp_store_release() in capture_cluster_snapshot(). */
+	if (!smp_load_acquire(&cluster_snapshot_ready))
+		goto no_cluster;
+
 	cpumask_copy(msk, node_cpumask);
 
 	/* Probe how many clusters in this node. */
@@ -307,7 +390,7 @@ static int alloc_cluster_groups(unsigned
 		if (cpu >= nr_cpu_ids)
 			break;
 
-		cluster_mask = topology_cluster_cpumask(cpu);
+		cluster_mask = cluster_snapshot[cpu];
 		if (!cpumask_weight(cluster_mask))
 			goto no_cluster;
 		/* Clean out CPUs on the same cluster. */
@@ -331,7 +414,7 @@ static int alloc_cluster_groups(unsigned
 	cpumask_copy(msk, node_cpumask);
 	for (n = 0; n < ncluster; n++) {
 		cpu = cpumask_first(msk);
-		cluster_mask = topology_cluster_cpumask(cpu);
+		cluster_mask = cluster_snapshot[cpu];
 		nc = cpumask_weight_and(cluster_mask, node_cpumask);
 		clusters[n] = cluster_mask;
 		cluster_groups[n].id = n;
_

Patches currently in -mm which might be from Vishal.Badole@amd.com are


