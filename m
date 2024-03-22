Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF8267C53
	for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2024 20:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711137757; cv=none; b=dnKVl/cBDKqtafJl0z//gK7uJUiKtlcP7F0MgHYeHoN6qYhfF0Khg0Cro2fRJhh3uPVwkD+WxEOde0YdkmcPi8bo7t/R77ABCI6d1J2hfanY4Um8e2ui/iS1E4qnwVfAVzsqRCuCAgGM0yIT+9PGXwomL9vz5m7cz85BOSK9gSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711137757; c=relaxed/simple;
	bh=r2LSslVBkUT4FxS4gIZFGh3HVBXILNsDt1xXS5ohrlk=;
	h=Date:To:From:Subject:Message-Id; b=t/Zpw4O3F+TCCGNgoKUpXMW3xp2s6Q9sn0jsPzOzTv10RSiVHIZP2XfBH41GJJlx9kCiLrD5SPP8MwdRgJn4UiwWXIbUgS2WuWYtZMsRZtc6Ge28c/41danDhXpfl9toO6hVkCbT4ypQGGze6Rz8uUkIn/bSVFjMjpKjjyFmLSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kKD/Em6R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kKD/Em6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23AC3C433C7;
	Fri, 22 Mar 2024 20:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711137757;
	bh=r2LSslVBkUT4FxS4gIZFGh3HVBXILNsDt1xXS5ohrlk=;
	h=Date:To:From:Subject:From;
	b=kKD/Em6RzsAs5JZ9cjb/eek4aOtql/hIYNWQnRQt63nlPegzwdy6GCCUNAXGnTxq1
	 JtN1b5PNpQr2GhA/2KAmF+1mrkZLd/QXdjs0v9Ty3W47KSkj+x/PGCgc+/BvrgDbeO
	 Jr4pzGtP1JICokuz5s3/QbG3j1Q7n1DXjpmHjlEY=
Date: Fri, 22 Mar 2024 13:02:31 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,tj@kernel.org,ravis.opensrc@micron.com,rafael@kernel.org,mhocko@suse.com,lenb@kernel.org,jonathan.cameron@huawei.com,hao.xiang@bytedance.com,gourry.memverge@gmail.com,dave.jiang@intel.com,dan.j.williams@intel.com,apopple@nvidia.com,aneesh.kumar@linux.ibm.com,horenchuang@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memory-tier-acpi-hmat-create-cpuless-memory-tiers-after-obtaining-hmat-info.patch added to mm-unstable branch
Message-Id: <20240322200237.23AC3C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memory tier: acpi/hmat: create CPUless memory tiers after obtaining HMAT info
has been added to the -mm mm-unstable branch.  Its filename is
     memory-tier-acpi-hmat-create-cpuless-memory-tiers-after-obtaining-hmat-info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memory-tier-acpi-hmat-create-cpuless-memory-tiers-after-obtaining-hmat-info.patch

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
Subject: memory tier: acpi/hmat: create CPUless memory tiers after obtaining HMAT info
Date: Fri, 1 Mar 2024 08:22:45 +0000

The memory tiering component in the kernel is functionally useless for
CPUless memory/non-DRAM devices like CXL1.1 type3 memory because the nodes
are lumped together in the DRAM tier. 
https://lore.kernel.org/linux-mm/PH0PR08MB7955E9F08CCB64F23963B5C3A860A@PH0PR08MB7955.namprd08.prod.outlook.com/T/

This patchset automatically resolves the issues.  It delays the
initialization of memory tiers for CPUless NUMA nodes until they obtain
HMAT information at boot time, eliminating the need for user intervention.
If no HMAT specified, it falls back to using `default_dram_type`.

Example usecase:
We have CXL memory on the host, and we create VMs with a new system memory
device backed by host CXL memory. We inject CXL memory performance attributes
through QEMU, and the guest now sees memory nodes with performance attributes
in HMAT. With this change, we enable the guest kernel to construct
the correct memory tiering for the memory nodes.

* Introduce `mt_init_with_hmat()`

  We defer memory tier initialization for those CPUless NUMA nodes until
  acquiring HMAT info.  `mt_init_with_hmat()` is introduced to post-create
  CPUless memory tiers after obtaining HMAT info.  It iterates through
  each CPUless memory node, creating memory tiers if necessary.  Finally,
  it calculates demotion tables again at the end.

* Introduce `hmat_find_alloc_memory_type()` Find or allocate a memory
  type in the `hmat_memory_types` list.

* Make `set_node_memory_tier()` more generic This function can also be
  used for setting other memory types for a node.  To do so, a new
  argument is added to specify a memory type.

* Handle cases where there is no HMAT when creating memory tiers If no
  HMAT is specified, it falls back to using `default_dram_type`.

* Change adist calculation code to use another new lock, mt_perf_lock. 
  Iterating through CPUlist nodes requires holding the `memory_tier_lock`.
  However, `mt_calc_adistance()` will end up trying to acquire the same
  lock, leading to a potential deadlock.  Therefore, we propose
  introducing a standalone `mt_perf_lock` to protect `default_dram_perf`. 
  This approach not only avoids deadlock but also prevents holding a large
  lock simultaneously.

Link: https://lkml.kernel.org/r/20240301082248.3456086-2-horenchuang@bytedance.com
Signed-off-by: Ho-Ren (Jack) Chuang <horenchuang@bytedance.com>
Signed-off-by: Hao Xiang <hao.xiang@bytedance.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Gregory Price <gourry.memverge@gmail.com>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Ravi Jonnalagadda <ravis.opensrc@micron.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/numa/hmat.c     |    3 +
 include/linux/memory-tiers.h |    6 ++
 mm/memory-tiers.c            |   76 +++++++++++++++++++++++++++++----
 3 files changed, 77 insertions(+), 8 deletions(-)

--- a/drivers/acpi/numa/hmat.c~memory-tier-acpi-hmat-create-cpuless-memory-tiers-after-obtaining-hmat-info
+++ a/drivers/acpi/numa/hmat.c
@@ -1083,6 +1083,9 @@ static __init int hmat_init(void)
 	if (!hmat_set_default_dram_perf())
 		register_mt_adistance_algorithm(&hmat_adist_nb);
 
+	/* Post-create CPUless memory tiers after getting HMAT info */
+	mt_init_with_hmat();
+
 	return 0;
 out_put:
 	hmat_free_structures();
--- a/include/linux/memory-tiers.h~memory-tier-acpi-hmat-create-cpuless-memory-tiers-after-obtaining-hmat-info
+++ a/include/linux/memory-tiers.h
@@ -48,6 +48,7 @@ int mt_calc_adistance(int node, int *adi
 int mt_set_default_dram_perf(int nid, struct access_coordinate *perf,
 			     const char *source);
 int mt_perf_to_adistance(struct access_coordinate *perf, int *adist);
+void mt_init_with_hmat(void);
 #ifdef CONFIG_MIGRATION
 int next_demotion_node(int node);
 void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
@@ -136,5 +137,10 @@ static inline int mt_perf_to_adistance(s
 {
 	return -EIO;
 }
+
+static inline void mt_init_with_hmat(void)
+{
+
+}
 #endif	/* CONFIG_NUMA */
 #endif  /* _LINUX_MEMORY_TIERS_H */
--- a/mm/memory-tiers.c~memory-tier-acpi-hmat-create-cpuless-memory-tiers-after-obtaining-hmat-info
+++ a/mm/memory-tiers.c
@@ -35,7 +35,9 @@ struct node_memory_type_map {
 };
 
 static DEFINE_MUTEX(memory_tier_lock);
+static DEFINE_MUTEX(mt_perf_lock);
 static LIST_HEAD(memory_tiers);
+static LIST_HEAD(hmat_memory_types);
 static struct node_memory_type_map node_memory_types[MAX_NUMNODES];
 struct memory_dev_type *default_dram_type;
 
@@ -502,7 +504,7 @@ static inline void __init_node_memory_ty
 	}
 }
 
-static struct memory_tier *set_node_memory_tier(int node)
+static struct memory_tier *set_node_memory_tier(int node, struct memory_dev_type *new_memtype)
 {
 	struct memory_tier *memtier;
 	struct memory_dev_type *memtype;
@@ -514,7 +516,7 @@ static struct memory_tier *set_node_memo
 	if (!node_state(node, N_MEMORY))
 		return ERR_PTR(-EINVAL);
 
-	__init_node_memory_type(node, default_dram_type);
+	__init_node_memory_type(node, new_memtype);
 
 	memtype = node_memory_types[node].memtype;
 	node_set(node, memtype->nodes);
@@ -623,6 +625,56 @@ void clear_node_memory_type(int node, st
 }
 EXPORT_SYMBOL_GPL(clear_node_memory_type);
 
+static struct memory_dev_type *hmat_find_alloc_memory_type(int adist)
+{
+	bool found = false;
+	struct memory_dev_type *mtype;
+
+	list_for_each_entry(mtype, &hmat_memory_types, list) {
+		if (mtype->adistance == adist) {
+			found = true;
+			break;
+		}
+	}
+	if (!found) {
+		mtype = alloc_memory_type(adist);
+		if (!IS_ERR(mtype))
+			list_add(&mtype->list, &hmat_memory_types);
+	}
+	return mtype;
+}
+
+static void mt_create_with_hmat(int node)
+{
+	struct memory_dev_type *mtype = NULL;
+	int adist = MEMTIER_ADISTANCE_DRAM;
+
+	mt_calc_adistance(node, &adist);
+	if (adist != MEMTIER_ADISTANCE_DRAM) {
+		mtype = hmat_find_alloc_memory_type(adist);
+		if (IS_ERR(mtype))
+			pr_err("%s() failed to allocate a tier\n", __func__);
+	} else {
+		mtype = default_dram_type;
+	}
+
+	set_node_memory_tier(node, mtype);
+}
+
+void mt_init_with_hmat(void)
+{
+	int nid;
+
+	mutex_lock(&memory_tier_lock);
+	for_each_node_state(nid, N_MEMORY)
+		if (!node_state(nid, N_CPU))
+			mt_create_with_hmat(nid);
+
+	establish_demotion_targets();
+	mutex_unlock(&memory_tier_lock);
+}
+EXPORT_SYMBOL_GPL(mt_init_with_hmat);
+
 static void dump_hmem_attrs(struct access_coordinate *coord, const char *prefix)
 {
 	pr_info(
@@ -636,7 +688,7 @@ int mt_set_default_dram_perf(int nid, st
 {
 	int rc = 0;
 
-	mutex_lock(&memory_tier_lock);
+	mutex_lock(&mt_perf_lock);
 	if (default_dram_perf_error) {
 		rc = -EIO;
 		goto out;
@@ -684,7 +736,7 @@ int mt_set_default_dram_perf(int nid, st
 	}
 
 out:
-	mutex_unlock(&memory_tier_lock);
+	mutex_unlock(&mt_perf_lock);
 	return rc;
 }
 
@@ -700,7 +752,7 @@ int mt_perf_to_adistance(struct access_c
 	    perf->read_bandwidth + perf->write_bandwidth == 0)
 		return -EINVAL;
 
-	mutex_lock(&memory_tier_lock);
+	mutex_lock(&mt_perf_lock);
 	/*
 	 * The abstract distance of a memory node is in direct proportion to
 	 * its memory latency (read + write) and inversely proportional to its
@@ -713,7 +765,7 @@ int mt_perf_to_adistance(struct access_c
 		(default_dram_perf.read_latency + default_dram_perf.write_latency) *
 		(default_dram_perf.read_bandwidth + default_dram_perf.write_bandwidth) /
 		(perf->read_bandwidth + perf->write_bandwidth);
-	mutex_unlock(&memory_tier_lock);
+	mutex_unlock(&mt_perf_lock);
 
 	return 0;
 }
@@ -797,7 +849,7 @@ static int __meminit memtier_hotplug_cal
 		break;
 	case MEM_ONLINE:
 		mutex_lock(&memory_tier_lock);
-		memtier = set_node_memory_tier(arg->status_change_nid);
+		memtier = set_node_memory_tier(arg->status_change_nid, default_dram_type);
 		if (!IS_ERR(memtier))
 			establish_demotion_targets();
 		mutex_unlock(&memory_tier_lock);
@@ -836,7 +888,15 @@ static int __init memory_tier_init(void)
 	 * types assigned.
 	 */
 	for_each_node_state(node, N_MEMORY) {
-		memtier = set_node_memory_tier(node);
+		if (!node_state(node, N_CPU))
+			/*
+			 * Defer memory tier initialization on CPUless numa nodes.
+			 * These will be initialized when HMAT information is
+			 * available.
+			 */
+			continue;
+
+		memtier = set_node_memory_tier(node, default_dram_type);
 		if (IS_ERR(memtier))
 			/*
 			 * Continue with memtiers we are able to setup
_

Patches currently in -mm which might be from horenchuang@bytedance.com are

memory-tier-acpi-hmat-create-cpuless-memory-tiers-after-obtaining-hmat-info.patch

