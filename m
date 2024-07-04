Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5BE3B79F
	for <mm-commits@vger.kernel.org>; Thu,  4 Jul 2024 17:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720114513; cv=none; b=DfGejeEwKinH6DHYO3LWN5+TW5BfwNw3gnTatiq8YUNIWmqApW2eLP1sOkeAlzfZ2NItId/v4Bnk0by4pSDlCIujq7pFU52wAqZkD6Po8rosEGjGa/WkMgRZi0XlcDDfaXCG2RCTW5S7lFryVPQ+OtHDE6TBZAg0rCNJ7n+QzuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720114513; c=relaxed/simple;
	bh=TLj5OIA/uq2iHzbYZ8e2z3jscI0JoLzx2s3tLsoQfeU=;
	h=Date:To:From:Subject:Message-Id; b=Ua9r/sJYwOnXFKjhki/spA74p8wdzVkaNVq9UWv9DOABPT7bVLZ5hqUhzup0gi4joPT+FIVfUzn6MDDAoBCS+fLL/ZBY3FtXPebtZ3nSit706tDpOQ5LG/KxqQT9H480sd1VVXfcHS3zg+CLB1oe9CN0RHUCiVtugefQ8eG1baA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KDrwX4gi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KDrwX4gi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7F3C3277B;
	Thu,  4 Jul 2024 17:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720114513;
	bh=TLj5OIA/uq2iHzbYZ8e2z3jscI0JoLzx2s3tLsoQfeU=;
	h=Date:To:From:Subject:From;
	b=KDrwX4giH3quo4pnJaTlzKl15gWEUeiZb7z84hptVBv8NkteetmNtUp0yMPhPayY+
	 m7wj0+tybEo7SvjL1UfKnZcC8xpyKG/Ig+C9wo5Y2S27QA+Hz9+gOSsn/2UtdCHI+/
	 WWneVuvrLy89KrB0l4G31V8eHjCWbgw/stuEoZu8=
Date: Thu, 04 Jul 2024 10:35:12 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,tj@kernel.org,sj@kernel.org,ravis.opensrc@micron.com,rafael@kernel.org,mhocko@suse.com,lenb@kernel.org,Jonathan.Cameron@huawei.com,horenchuang@bytedance.com,gourry.memverge@gmail.com,dave.jiang@intel.com,dan.j.williams@intel.com,apopple@nvidia.com,aneesh.kumar@linux.ibm.com,horen.chuang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memory-tier-consolidate-the-initialization-of-memory-tiers.patch added to mm-unstable branch
Message-Id: <20240704173513.2B7F3C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memory tier: consolidate the initialization of memory tiers
has been added to the -mm mm-unstable branch.  Its filename is
     memory-tier-consolidate-the-initialization-of-memory-tiers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memory-tier-consolidate-the-initialization-of-memory-tiers.patch

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
From: "Ho-Ren (Jack) Chuang" <horen.chuang@linux.dev>
Subject: memory tier: consolidate the initialization of memory tiers
Date: Thu, 4 Jul 2024 07:26:44 +0000

The current memory tier initialization process is distributed across two
different functions, memory_tier_init() and memory_tier_late_init().  This
design is hard to maintain.  Thus, this patch is proposed to reduce the
possible code paths by consolidating different initialization patches into
one.

The earlier discussion with Jonathan and Ying is listed here:
https://lore.kernel.org/lkml/20240405150244.00004b49@Huawei.com/

If we want to put these two initializations together, they must be placed
together in the later function.  Because only at that time, the HMAT
information will be ready, adist between nodes can be calculated, and
memory tiering can be established based on the adist.  So we position the
initialization at memory_tier_init() to the memory_tier_late_init() call. 
Moreover, it's natural to keep memory_tier initialization in drivers at
device_initcall() level.

If we simply move the set_node_memory_tier() from memory_tier_init() to
late_initcall(), it will result in HMAT not registering the
mt_adistance_algorithm callback function, because set_node_memory_tier()
is not performed during the memory tiering initialization phase, leading
to a lack of correct default_dram information.

Therefore, we introduced a nodemask to pass the information of the default
DRAM nodes.  The reason for not choosing to reuse default_dram_type->nodes
is that it is not clean enough.  So in the end, we use a __initdata
variable, which is a variable that is released once initialization is
complete, including both CPU and memory nodes for HMAT to iterate through.

Link: https://lkml.kernel.org/r/20240704072646.437579-1-horen.chuang@linux.dev
Signed-off-by: Ho-Ren (Jack) Chuang <horenchuang@bytedance.com>
Suggested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Gregory Price <gourry.memverge@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Ravi Jonnalagadda <ravis.opensrc@micron.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/numa/hmat.c     |    5 ---
 include/linux/memory-tiers.h |    2 +
 mm/memory-tiers.c            |   54 ++++++++++++---------------------
 3 files changed, 24 insertions(+), 37 deletions(-)

--- a/drivers/acpi/numa/hmat.c~memory-tier-consolidate-the-initialization-of-memory-tiers
+++ a/drivers/acpi/numa/hmat.c
@@ -940,10 +940,7 @@ static int hmat_set_default_dram_perf(vo
 	struct memory_target *target;
 	struct access_coordinate *attrs;
 
-	if (!default_dram_type)
-		return -EIO;
-
-	for_each_node_mask(nid, default_dram_type->nodes) {
+	for_each_node_mask(nid, default_dram_nodes) {
 		pxm = node_to_pxm(nid);
 		target = find_mem_target(pxm);
 		if (!target)
--- a/include/linux/memory-tiers.h~memory-tier-consolidate-the-initialization-of-memory-tiers
+++ a/include/linux/memory-tiers.h
@@ -38,6 +38,7 @@ struct access_coordinate;
 #ifdef CONFIG_NUMA
 extern bool numa_demotion_enabled;
 extern struct memory_dev_type *default_dram_type;
+extern nodemask_t default_dram_nodes;
 struct memory_dev_type *alloc_memory_type(int adistance);
 void put_memory_type(struct memory_dev_type *memtype);
 void init_node_memory_type(int node, struct memory_dev_type *default_type);
@@ -76,6 +77,7 @@ static inline bool node_is_toptier(int n
 
 #define numa_demotion_enabled	false
 #define default_dram_type	NULL
+#define default_dram_nodes	NODE_MASK_NONE
 /*
  * CONFIG_NUMA implementation returns non NULL error.
  */
--- a/mm/memory-tiers.c~memory-tier-consolidate-the-initialization-of-memory-tiers
+++ a/mm/memory-tiers.c
@@ -43,6 +43,7 @@ static LIST_HEAD(memory_tiers);
 static LIST_HEAD(default_memory_types);
 static struct node_memory_type_map node_memory_types[MAX_NUMNODES];
 struct memory_dev_type *default_dram_type;
+nodemask_t default_dram_nodes __initdata = NODE_MASK_NONE;
 
 static const struct bus_type memory_tier_subsys = {
 	.name = "memory_tiering",
@@ -671,28 +672,35 @@ EXPORT_SYMBOL_GPL(mt_put_memory_types);
 
 /*
  * This is invoked via `late_initcall()` to initialize memory tiers for
- * CPU-less memory nodes after driver initialization, which is
- * expected to provide `adistance` algorithms.
+ * memory nodes, both with and without CPUs. After the initialization of
+ * firmware and devices, adistance algorithms are expected to be provided.
  */
 static int __init memory_tier_late_init(void)
 {
 	int nid;
+	struct memory_tier *memtier;
 
+	get_online_mems();
 	guard(mutex)(&memory_tier_lock);
+
+	/* Assign each uninitialized N_MEMORY node to a memory tier. */
 	for_each_node_state(nid, N_MEMORY) {
 		/*
-		 * Some device drivers may have initialized memory tiers
-		 * between `memory_tier_init()` and `memory_tier_late_init()`,
-		 * potentially bringing online memory nodes and
-		 * configuring memory tiers. Exclude them here.
+		 * Some device drivers may have initialized
+		 * memory tiers, potentially bringing memory nodes
+		 * online and configuring memory tiers.
+		 * Exclude them here.
 		 */
 		if (node_memory_types[nid].memtype)
 			continue;
 
-		set_node_memory_tier(nid);
+		memtier = set_node_memory_tier(nid);
+		if (IS_ERR(memtier))
+			continue;
 	}
 
 	establish_demotion_targets();
+	put_online_mems();
 
 	return 0;
 }
@@ -875,8 +883,7 @@ static int __meminit memtier_hotplug_cal
 
 static int __init memory_tier_init(void)
 {
-	int ret, node;
-	struct memory_tier *memtier;
+	int ret;
 
 	ret = subsys_virtual_register(&memory_tier_subsys, NULL);
 	if (ret)
@@ -887,7 +894,8 @@ static int __init memory_tier_init(void)
 				GFP_KERNEL);
 	WARN_ON(!node_demotion);
 #endif
-	mutex_lock(&memory_tier_lock);
+
+	guard(mutex)(&memory_tier_lock);
 	/*
 	 * For now we can have 4 faster memory tiers with smaller adistance
 	 * than default DRAM tier.
@@ -897,29 +905,9 @@ static int __init memory_tier_init(void)
 	if (IS_ERR(default_dram_type))
 		panic("%s() failed to allocate default DRAM tier\n", __func__);
 
-	/*
-	 * Look at all the existing N_MEMORY nodes and add them to
-	 * default memory tier or to a tier if we already have memory
-	 * types assigned.
-	 */
-	for_each_node_state(node, N_MEMORY) {
-		if (!node_state(node, N_CPU))
-			/*
-			 * Defer memory tier initialization on
-			 * CPUless numa nodes. These will be initialized
-			 * after firmware and devices are initialized.
-			 */
-			continue;
-
-		memtier = set_node_memory_tier(node);
-		if (IS_ERR(memtier))
-			/*
-			 * Continue with memtiers we are able to setup
-			 */
-			break;
-	}
-	establish_demotion_targets();
-	mutex_unlock(&memory_tier_lock);
+	/* Record nodes with memory and CPU to set default DRAM performance. */
+	nodes_and(default_dram_nodes, node_states[N_MEMORY],
+		  node_states[N_CPU]);
 
 	hotplug_memory_notifier(memtier_hotplug_callback, MEMTIER_HOTPLUG_PRI);
 	return 0;
_

Patches currently in -mm which might be from horen.chuang@linux.dev are

memory-tier-consolidate-the-initialization-of-memory-tiers.patch

