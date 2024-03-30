Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2E07482
	for <mm-commits@vger.kernel.org>; Sat, 30 Mar 2024 03:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711770025; cv=none; b=jFfb151tnKWfWthz3SL1s2KlCKzokyS77v2otYol/QoGedtBZiMp4aKq7/phoV/td26T3Eyfo1ajTIM++8WJOmn5WM2dxzZSIkbnpi/J81KXZ4QEkoP6XaMNW89/xULKjTLYc8WZeONIwC/hcERVfjaGYHzXrVoB4OW6gi5qNqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711770025; c=relaxed/simple;
	bh=bHOz81/6CtQZrCoeobl9b2pF2Lhmw0eyS2RUYBV8+9M=;
	h=Date:To:From:Subject:Message-Id; b=p4ShUzsIu+0O1hY9S+DvCtEDSkO4VmA73ij53+1iDa/VZTz6lJGGxsL7pbX9uYUpoCRbFoxOTLrq4Z3196KcN/y42eIRIhy0qrIE+QVRGq/4QUcTwTJ2Ewd39gqnuK+okdHMuGxx0e4UBbRtToFQ2y7dtUFpuJBLZ1be/TnoHX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JZR3ztIF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JZR3ztIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C54DC433F1;
	Sat, 30 Mar 2024 03:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711770025;
	bh=bHOz81/6CtQZrCoeobl9b2pF2Lhmw0eyS2RUYBV8+9M=;
	h=Date:To:From:Subject:From;
	b=JZR3ztIFr44GLYyhKuRHX0vbATs7pzQLOIig7wdZXYenJWH+jUsHvUd4o6N4B6TMB
	 kC4sKtrGFl8i09wVqLt4QAjFb/zyT547B92xuJKKKy6f10mEQvfsr+VwCm6nYGyUxk
	 YZqKGyHcWCL/dN7SsF6faG/yWV6JcbKnEQBoDaFE=
Date: Fri, 29 Mar 2024 20:40:24 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,vishal.l.verma@intel.com,tj@kernel.org,ravis.opensrc@micron.com,mhocko@suse.com,hao.xiang@bytedance.com,gourry.memverge@gmail.com,dave.jiang@intel.com,dan.j.williams@intel.com,apopple@nvidia.com,aneesh.kumar@linux.ibm.com,horenchuang@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memory-tier-create-cpuless-memory-tiers-after-obtaining-hmat-info.patch added to mm-unstable branch
Message-Id: <20240330034025.1C54DC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memory tier: create CPUless memory tiers after obtaining HMAT info
has been added to the -mm mm-unstable branch.  Its filename is
     memory-tier-create-cpuless-memory-tiers-after-obtaining-hmat-info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memory-tier-create-cpuless-memory-tiers-after-obtaining-hmat-info.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com>
Subject: memory tier: create CPUless memory tiers after obtaining HMAT info
Date: Fri, 29 Mar 2024 05:33:53 +0000

Patch series "Improved Memory Tier Creation for CPUless NUMA Nodes", v9.

When a memory device, such as CXL1.1 type3 memory, is emulated as normal
memory (E820_TYPE_RAM), the memory device is indistinguishable from normal
DRAM in terms of memory tiering with the current implementation.  The
current memory tiering assigns all detected normal memory nodes to the
same DRAM tier.  This results in normal memory devices with different
attributions being unable to be assigned to the correct memory tier,
leading to the inability to migrate pages between different types of
memory. 
https://lore.kernel.org/linux-mm/PH0PR08MB7955E9F08CCB64F23963B5C3A860A@PH0PR08MB7955.namprd08.prod.outlook.com/T/

This patchset automatically resolves the issues.  It delays the
initialization of memory tiers for CPUless NUMA nodes until they obtain
HMAT information and after all devices are initialized at boot time,
eliminating the need for user intervention.  If no HMAT is specified, it
falls back to using `default_dram_type`.

Example usecase:
We have CXL memory on the host, and we create VMs with a new system memory
device backed by host CXL memory.  We inject CXL memory performance
attributes through QEMU, and the guest now sees memory nodes with
performance attributes in HMAT.  With this change, we enable the guest
kernel to construct the correct memory tiering for the memory nodes.


This patch (of 2):

The current implementation treats emulated memory devices, such as CXL1.1
type3 memory, as normal DRAM when they are emulated as normal memory
(E820_TYPE_RAM).  However, these emulated devices have different
characteristics than traditional DRAM, making it important to distinguish
them.  Thus, we modify the tiered memory initialization process to
introduce a delay specifically for CPUless NUMA nodes.  This delay ensures
that the memory tier initialization for these nodes is deferred until HMAT
information is obtained during the boot process.  Finally, demotion tables
are recalculated at the end.

* late_initcall(memory_tier_late_init);

  Some device drivers may have initialized memory tiers between
  `memory_tier_init()` and `memory_tier_late_init()`, potentially bringing
  online memory nodes and configuring memory tiers.  They should be
  excluded in the late init.

* Handle cases where there is no HMAT when creating memory tiers There
  is a scenario where a CPUless node does not provide HMAT information. 
  If no HMAT is specified, it falls back to using the default DRAM tier.

* Introduce another new lock `default_dram_perf_lock` for adist
  calculation In the current implementation, iterating through CPUlist
  nodes requires holding the `memory_tier_lock`.  However,
  `mt_calc_adistance()` will end up trying to acquire the same lock,
  leading to a potential deadlock.  Therefore, we propose introducing a
  standalone `default_dram_perf_lock` to protect `default_dram_perf_*`. 
  This approach not only avoids deadlock but also prevents holding a large
  lock simultaneously.

* Upgrade `set_node_memory_tier` to support additional cases, including
  default DRAM, late CPUless, and hot-plugged initializations.  To cover
  hot-plugged memory nodes, `mt_calc_adistance()` and
  `mt_find_alloc_memory_type()` are moved into `set_node_memory_tier()` to
  handle cases where memtype is not initialized and where HMAT information
  is available.

* Introduce `default_memory_types` for those memory types that are not
  initialized by device drivers.  Because late initialized memory and
  default DRAM memory need to be managed, a default memory type is created
  for storing all memory types that are not initialized by device drivers
  and as a fallback.

Link: https://lkml.kernel.org/r/20240329053353.309557-1-horenchuang@bytedance.com
Link: https://lkml.kernel.org/r/20240329053353.309557-3-horenchuang@bytedance.com
Signed-off-by: Ho-Ren (Jack) Chuang <horenchuang@bytedance.com>
Signed-off-by: Hao Xiang <hao.xiang@bytedance.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Gregory Price <gourry.memverge@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ravi Jonnalagadda <ravis.opensrc@micron.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-tiers.c |   93 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 77 insertions(+), 16 deletions(-)

--- a/mm/memory-tiers.c~memory-tier-create-cpuless-memory-tiers-after-obtaining-hmat-info
+++ a/mm/memory-tiers.c
@@ -36,6 +36,11 @@ struct node_memory_type_map {
 
 static DEFINE_MUTEX(memory_tier_lock);
 static LIST_HEAD(memory_tiers);
+/*
+ * The list is used to store all memory types that are not created
+ * by a device driver.
+ */
+static LIST_HEAD(default_memory_types);
 static struct node_memory_type_map node_memory_types[MAX_NUMNODES];
 struct memory_dev_type *default_dram_type;
 
@@ -108,6 +113,8 @@ static struct demotion_nodes *node_demot
 
 static BLOCKING_NOTIFIER_HEAD(mt_adistance_algorithms);
 
+/* The lock is used to protect `default_dram_perf*` info and nid. */
+static DEFINE_MUTEX(default_dram_perf_lock);
 static bool default_dram_perf_error;
 static struct access_coordinate default_dram_perf;
 static int default_dram_perf_ref_nid = NUMA_NO_NODE;
@@ -505,7 +512,8 @@ static inline void __init_node_memory_ty
 static struct memory_tier *set_node_memory_tier(int node)
 {
 	struct memory_tier *memtier;
-	struct memory_dev_type *memtype;
+	struct memory_dev_type *mtype = default_dram_type;
+	int adist = MEMTIER_ADISTANCE_DRAM;
 	pg_data_t *pgdat = NODE_DATA(node);
 
 
@@ -514,11 +522,20 @@ static struct memory_tier *set_node_memo
 	if (!node_state(node, N_MEMORY))
 		return ERR_PTR(-EINVAL);
 
-	__init_node_memory_type(node, default_dram_type);
+	mt_calc_adistance(node, &adist);
+	if (node_memory_types[node].memtype == NULL) {
+		mtype = mt_find_alloc_memory_type(adist, &default_memory_types);
+		if (IS_ERR(mtype)) {
+			mtype = default_dram_type;
+			pr_info("Failed to allocate a memory type. Fall back.\n");
+		}
+	}
+
+	__init_node_memory_type(node, mtype);
 
-	memtype = node_memory_types[node].memtype;
-	node_set(node, memtype->nodes);
-	memtier = find_create_memory_tier(memtype);
+	mtype = node_memory_types[node].memtype;
+	node_set(node, mtype->nodes);
+	memtier = find_create_memory_tier(mtype);
 	if (!IS_ERR(memtier))
 		rcu_assign_pointer(pgdat->memtier, memtier);
 	return memtier;
@@ -655,6 +672,33 @@ void mt_put_memory_types(struct list_hea
 }
 EXPORT_SYMBOL_GPL(mt_put_memory_types);
 
+/*
+ * This is invoked via `late_initcall()` to initialize memory tiers for
+ * CPU-less memory nodes after driver initialization, which is
+ * expected to provide `adistance` algorithms.
+ */
+static int __init memory_tier_late_init(void)
+{
+	int nid;
+
+	mutex_lock(&memory_tier_lock);
+	for_each_node_state(nid, N_MEMORY)
+		if (node_memory_types[nid].memtype == NULL)
+			/*
+			 * Some device drivers may have initialized memory tiers
+			 * between `memory_tier_init()` and `memory_tier_late_init()`,
+			 * potentially bringing online memory nodes and
+			 * configuring memory tiers. Exclude them here.
+			 */
+			set_node_memory_tier(nid);
+
+	establish_demotion_targets();
+	mutex_unlock(&memory_tier_lock);
+
+	return 0;
+}
+late_initcall(memory_tier_late_init);
+
 static void dump_hmem_attrs(struct access_coordinate *coord, const char *prefix)
 {
 	pr_info(
@@ -668,7 +712,7 @@ int mt_set_default_dram_perf(int nid, st
 {
 	int rc = 0;
 
-	mutex_lock(&memory_tier_lock);
+	mutex_lock(&default_dram_perf_lock);
 	if (default_dram_perf_error) {
 		rc = -EIO;
 		goto out;
@@ -716,23 +760,30 @@ int mt_set_default_dram_perf(int nid, st
 	}
 
 out:
-	mutex_unlock(&memory_tier_lock);
+	mutex_unlock(&default_dram_perf_lock);
 	return rc;
 }
 
 int mt_perf_to_adistance(struct access_coordinate *perf, int *adist)
 {
-	if (default_dram_perf_error)
-		return -EIO;
+	int rc = 0;
 
-	if (default_dram_perf_ref_nid == NUMA_NO_NODE)
-		return -ENOENT;
+	mutex_lock(&default_dram_perf_lock);
+	if (default_dram_perf_error) {
+		rc = -EIO;
+		goto out;
+	}
 
 	if (perf->read_latency + perf->write_latency == 0 ||
-	    perf->read_bandwidth + perf->write_bandwidth == 0)
-		return -EINVAL;
+	    perf->read_bandwidth + perf->write_bandwidth == 0) {
+		rc = -EINVAL;
+		goto out;
+	}
 
-	mutex_lock(&memory_tier_lock);
+	if (default_dram_perf_ref_nid == NUMA_NO_NODE) {
+		rc = -ENOENT;
+		goto out;
+	}
 	/*
 	 * The abstract distance of a memory node is in direct proportion to
 	 * its memory latency (read + write) and inversely proportional to its
@@ -745,8 +796,9 @@ int mt_perf_to_adistance(struct access_c
 		(default_dram_perf.read_latency + default_dram_perf.write_latency) *
 		(default_dram_perf.read_bandwidth + default_dram_perf.write_bandwidth) /
 		(perf->read_bandwidth + perf->write_bandwidth);
-	mutex_unlock(&memory_tier_lock);
 
+out:
+	mutex_unlock(&default_dram_perf_lock);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mt_perf_to_adistance);
@@ -858,7 +910,8 @@ static int __init memory_tier_init(void)
 	 * For now we can have 4 faster memory tiers with smaller adistance
 	 * than default DRAM tier.
 	 */
-	default_dram_type = alloc_memory_type(MEMTIER_ADISTANCE_DRAM);
+	default_dram_type = mt_find_alloc_memory_type(MEMTIER_ADISTANCE_DRAM,
+									&default_memory_types);
 	if (IS_ERR(default_dram_type))
 		panic("%s() failed to allocate default DRAM tier\n", __func__);
 
@@ -868,6 +921,14 @@ static int __init memory_tier_init(void)
 	 * types assigned.
 	 */
 	for_each_node_state(node, N_MEMORY) {
+		if (!node_state(node, N_CPU))
+			/*
+			 * Defer memory tier initialization on CPUless numa nodes.
+			 * These will be initialized after firmware and devices are
+			 * initialized.
+			 */
+			continue;
+
 		memtier = set_node_memory_tier(node);
 		if (IS_ERR(memtier))
 			/*
_

Patches currently in -mm which might be from horenchuang@bytedance.com are

memory-tier-dax-kmem-introduce-an-abstract-layer-for-finding-allocating-and-putting-memory-types.patch
memory-tier-create-cpuless-memory-tiers-after-obtaining-hmat-info.patch

