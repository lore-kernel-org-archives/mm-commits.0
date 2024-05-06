Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00145CB0
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714956983; cv=none; b=B6n2SAbY43+pIzJzclPTSaDbifonCCG7r936ssqhAuT9cWcR8VJeaunkPOEKddbjFiAjNkK3LNSR+uSQlSzLUsJxXliXkg57nFzcdYPBzb1+a1f770S+TQSSa/OjNTcX/RhuGPnKTxJugGscPuWth8y97kAtMZbVHa4MreF+qBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714956983; c=relaxed/simple;
	bh=5IzrI9wEDUvzYzMjCtgmDQbDeJ5ByEhuB1qxYoR2bOY=;
	h=Date:To:From:Subject:Message-Id; b=RdIAeSZU35c2AFeKSRc5xQuM/dJWmuGTVf54bZE6oe8XQ80gPlTDcZrwuhvOWF72UNOXJnEsYBSU4mvZQ/uIPKjnpp9c1UHmT3Ltpw45D8uJjR3BqWrnh/GR6h7tdoE3ZX7io3CODBK7+28rXmrdNxNoTEO+0Da5cxh1xIpIU0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CG3EedJr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CG3EedJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1D7C113CC;
	Mon,  6 May 2024 00:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714956983;
	bh=5IzrI9wEDUvzYzMjCtgmDQbDeJ5ByEhuB1qxYoR2bOY=;
	h=Date:To:From:Subject:From;
	b=CG3EedJrVQ4cWToB5/gtdeSq7scSHp+52FUJUw7JrQbQLXKAe1uLddPiVyocVxNzU
	 m6hPaXIeefKwCmn9vucqE4b5u3mAV3n2ZyY6rxaPcP3ic04R6pLxL+nIRYWIAqx8Sy
	 GuC2dGAXMiRqrnpYgj9XfOGo3EDpWPsfdgUYodcM=
Date: Sun, 05 May 2024 17:56:22 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,vishal.l.verma@intel.com,tj@kernel.org,sj@kernel.org,ravis.opensrc@micron.com,mhocko@suse.com,Jonathan.Cameron@huawie.com,Jonathan.Cameron@huawei.com,hao.xiang@bytedance.com,gourry.memverge@gmail.com,dave.jiang@intel.com,dan.j.williams@intel.com,apopple@nvidia.com,aneesh.kumar@linux.ibm.com,horenchuang@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memory-tier-dax-kmem-introduce-an-abstract-layer-for-finding-allocating-and-putting-memory-types.patch removed from -mm tree
Message-Id: <20240506005623.6A1D7C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memory tier: dax/kmem: introduce an abstract layer for finding, allocating, and putting memory types
has been removed from the -mm tree.  Its filename was
     memory-tier-dax-kmem-introduce-an-abstract-layer-for-finding-allocating-and-putting-memory-types.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com>
Subject: memory tier: dax/kmem: introduce an abstract layer for finding, allocating, and putting memory types
Date: Fri, 5 Apr 2024 00:07:05 +0000

Patch series "Improved Memory Tier Creation for CPUless NUMA Nodes", v11.

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

Since different memory devices require finding, allocating, and putting
memory types, these common steps are abstracted in this patch, enhancing
the scalability and conciseness of the code.

Link: https://lkml.kernel.org/r/20240405000707.2670063-1-horenchuang@bytedance.com
Link: https://lkml.kernel.org/r/20240405000707.2670063-2-horenchuang@bytedance.com
Signed-off-by: Ho-Ren (Jack) Chuang <horenchuang@bytedance.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawie.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Gregory Price <gourry.memverge@gmail.com>
Cc: Hao Xiang <hao.xiang@bytedance.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ravi Jonnalagadda <ravis.opensrc@micron.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/kmem.c           |   30 ++++--------------------------
 include/linux/memory-tiers.h |   13 +++++++++++++
 mm/memory-tiers.c            |   29 +++++++++++++++++++++++++++++
 3 files changed, 46 insertions(+), 26 deletions(-)

--- a/drivers/dax/kmem.c~memory-tier-dax-kmem-introduce-an-abstract-layer-for-finding-allocating-and-putting-memory-types
+++ a/drivers/dax/kmem.c
@@ -55,36 +55,14 @@ static LIST_HEAD(kmem_memory_types);
 
 static struct memory_dev_type *kmem_find_alloc_memory_type(int adist)
 {
-	bool found = false;
-	struct memory_dev_type *mtype;
-
-	mutex_lock(&kmem_memory_type_lock);
-	list_for_each_entry(mtype, &kmem_memory_types, list) {
-		if (mtype->adistance == adist) {
-			found = true;
-			break;
-		}
-	}
-	if (!found) {
-		mtype = alloc_memory_type(adist);
-		if (!IS_ERR(mtype))
-			list_add(&mtype->list, &kmem_memory_types);
-	}
-	mutex_unlock(&kmem_memory_type_lock);
-
-	return mtype;
+	guard(mutex)(&kmem_memory_type_lock);
+	return mt_find_alloc_memory_type(adist, &kmem_memory_types);
 }
 
 static void kmem_put_memory_types(void)
 {
-	struct memory_dev_type *mtype, *mtn;
-
-	mutex_lock(&kmem_memory_type_lock);
-	list_for_each_entry_safe(mtype, mtn, &kmem_memory_types, list) {
-		list_del(&mtype->list);
-		put_memory_type(mtype);
-	}
-	mutex_unlock(&kmem_memory_type_lock);
+	guard(mutex)(&kmem_memory_type_lock);
+	mt_put_memory_types(&kmem_memory_types);
 }
 
 static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
--- a/include/linux/memory-tiers.h~memory-tier-dax-kmem-introduce-an-abstract-layer-for-finding-allocating-and-putting-memory-types
+++ a/include/linux/memory-tiers.h
@@ -48,6 +48,9 @@ int mt_calc_adistance(int node, int *adi
 int mt_set_default_dram_perf(int nid, struct access_coordinate *perf,
 			     const char *source);
 int mt_perf_to_adistance(struct access_coordinate *perf, int *adist);
+struct memory_dev_type *mt_find_alloc_memory_type(int adist,
+						  struct list_head *memory_types);
+void mt_put_memory_types(struct list_head *memory_types);
 #ifdef CONFIG_MIGRATION
 int next_demotion_node(int node);
 void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
@@ -136,5 +139,15 @@ static inline int mt_perf_to_adistance(s
 {
 	return -EIO;
 }
+
+static inline struct memory_dev_type *mt_find_alloc_memory_type(int adist,
+								struct list_head *memory_types)
+{
+	return NULL;
+}
+
+static inline void mt_put_memory_types(struct list_head *memory_types)
+{
+}
 #endif	/* CONFIG_NUMA */
 #endif  /* _LINUX_MEMORY_TIERS_H */
--- a/mm/memory-tiers.c~memory-tier-dax-kmem-introduce-an-abstract-layer-for-finding-allocating-and-putting-memory-types
+++ a/mm/memory-tiers.c
@@ -623,6 +623,35 @@ void clear_node_memory_type(int node, st
 }
 EXPORT_SYMBOL_GPL(clear_node_memory_type);
 
+struct memory_dev_type *mt_find_alloc_memory_type(int adist, struct list_head *memory_types)
+{
+	struct memory_dev_type *mtype;
+
+	list_for_each_entry(mtype, memory_types, list)
+		if (mtype->adistance == adist)
+			return mtype;
+
+	mtype = alloc_memory_type(adist);
+	if (IS_ERR(mtype))
+		return mtype;
+
+	list_add(&mtype->list, memory_types);
+
+	return mtype;
+}
+EXPORT_SYMBOL_GPL(mt_find_alloc_memory_type);
+
+void mt_put_memory_types(struct list_head *memory_types)
+{
+	struct memory_dev_type *mtype, *mtn;
+
+	list_for_each_entry_safe(mtype, mtn, memory_types, list) {
+		list_del(&mtype->list);
+		put_memory_type(mtype);
+	}
+}
+EXPORT_SYMBOL_GPL(mt_put_memory_types);
+
 static void dump_hmem_attrs(struct access_coordinate *coord, const char *prefix)
 {
 	pr_info(
_

Patches currently in -mm which might be from horenchuang@bytedance.com are


