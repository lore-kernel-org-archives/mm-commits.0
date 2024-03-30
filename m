Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3AB86FB9
	for <mm-commits@vger.kernel.org>; Sat, 30 Mar 2024 03:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711770023; cv=none; b=CYaa9J8yJO0TqzThGlAJTTzQ+iCLErXu1OArdIbt8U1pSxp8NB/VnyhFHgMNxGHCrNgFkOV0qMqAXV+X5pB0VBoaALUMjIYnecdl/h6pPAMNQ0O4WcvR4alLR5jz8dCFrAm/qM9tP9/RDoosb56U0Zk/qw24kwh80UdBv6ZLbYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711770023; c=relaxed/simple;
	bh=/N3CEcjq/ri4L+WCwAa7x4aW7a7E4HnYOpJuKKsdNDk=;
	h=Date:To:From:Subject:Message-Id; b=PJB3jhZlTiNEzPzm5vltJATwoCRIBfeaIYueIRsAy6qbSfR1kdD0K30g3Ex22/dVh18v7n88dfRoOASeL26vFUG30cySnwumuLhFQnugYRxxQKUGwiB+Ht2ehYYpH+zntbu4QJwCcwyzezf2dzprTynQVkwnwV2fvTBZwwIMhfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R3W6QoB3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R3W6QoB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D34C433F1;
	Sat, 30 Mar 2024 03:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711770022;
	bh=/N3CEcjq/ri4L+WCwAa7x4aW7a7E4HnYOpJuKKsdNDk=;
	h=Date:To:From:Subject:From;
	b=R3W6QoB3GX4ZvSyV1828V3YNnSEaue3WJ/+VUFXluILDJvWQdSKamyVjqzOe9X+Yz
	 kdGNXfndYTESpQ1X9y0AxFZb3LUDTRZ2LsFPG9YCIE/A+LhXST2e/1SOrM6YB1XCqV
	 XZRIWdCL3s1eGm0ZYCNagOdFXBaGwuVIZ+kHuKfI=
Date: Fri, 29 Mar 2024 20:40:21 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,vishal.l.verma@intel.com,tj@kernel.org,ravis.opensrc@micron.com,mhocko@suse.com,hao.xiang@bytedance.com,gourry.memverge@gmail.com,dave.jiang@intel.com,dan.j.williams@intel.com,apopple@nvidia.com,aneesh.kumar@linux.ibm.com,horenchuang@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memory-tier-dax-kmem-introduce-an-abstract-layer-for-finding-allocating-and-putting-memory-types.patch added to mm-unstable branch
Message-Id: <20240330034022.58D34C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memory tier: dax/kmem: introduce an abstract layer for finding, allocating, and putting memory types
has been added to the -mm mm-unstable branch.  Its filename is
     memory-tier-dax-kmem-introduce-an-abstract-layer-for-finding-allocating-and-putting-memory-types.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memory-tier-dax-kmem-introduce-an-abstract-layer-for-finding-allocating-and-putting-memory-types.patch

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
Subject: memory tier: dax/kmem: introduce an abstract layer for finding, allocating, and putting memory types
Date: Fri, 29 Mar 2024 05:33:52 +0000

Since different memory devices require finding, allocating, and putting
memory types, these common steps are abstracted in this patch, enhancing
the scalability and conciseness of the code.

Link: https://lkml.kernel.org/r/20240329053353.309557-2-horenchuang@bytedance.com
Signed-off-by: Ho-Ren (Jack) Chuang <horenchuang@bytedance.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Gregory Price <gourry.memverge@gmail.com>
Cc: Hao Xiang <hao.xiang@bytedance.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ravi Jonnalagadda <ravis.opensrc@micron.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/kmem.c           |   20 ++------------------
 include/linux/memory-tiers.h |   13 +++++++++++++
 mm/memory-tiers.c            |   32 ++++++++++++++++++++++++++++++++
 3 files changed, 47 insertions(+), 18 deletions(-)

--- a/drivers/dax/kmem.c~memory-tier-dax-kmem-introduce-an-abstract-layer-for-finding-allocating-and-putting-memory-types
+++ a/drivers/dax/kmem.c
@@ -55,21 +55,10 @@ static LIST_HEAD(kmem_memory_types);
 
 static struct memory_dev_type *kmem_find_alloc_memory_type(int adist)
 {
-	bool found = false;
 	struct memory_dev_type *mtype;
 
 	mutex_lock(&kmem_memory_type_lock);
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
+	mtype = mt_find_alloc_memory_type(adist, &kmem_memory_types);
 	mutex_unlock(&kmem_memory_type_lock);
 
 	return mtype;
@@ -77,13 +66,8 @@ static struct memory_dev_type *kmem_find
 
 static void kmem_put_memory_types(void)
 {
-	struct memory_dev_type *mtype, *mtn;
-
 	mutex_lock(&kmem_memory_type_lock);
-	list_for_each_entry_safe(mtype, mtn, &kmem_memory_types, list) {
-		list_del(&mtype->list);
-		put_memory_type(mtype);
-	}
+	mt_put_memory_types(&kmem_memory_types);
 	mutex_unlock(&kmem_memory_type_lock);
 }
 
--- a/include/linux/memory-tiers.h~memory-tier-dax-kmem-introduce-an-abstract-layer-for-finding-allocating-and-putting-memory-types
+++ a/include/linux/memory-tiers.h
@@ -48,6 +48,9 @@ int mt_calc_adistance(int node, int *adi
 int mt_set_default_dram_perf(int nid, struct access_coordinate *perf,
 			     const char *source);
 int mt_perf_to_adistance(struct access_coordinate *perf, int *adist);
+struct memory_dev_type *mt_find_alloc_memory_type(int adist,
+							struct list_head *memory_types);
+void mt_put_memory_types(struct list_head *memory_types);
 #ifdef CONFIG_MIGRATION
 int next_demotion_node(int node);
 void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
@@ -136,5 +139,15 @@ static inline int mt_perf_to_adistance(s
 {
 	return -EIO;
 }
+
+struct memory_dev_type *mt_find_alloc_memory_type(int adist, struct list_head *memory_types)
+{
+	return NULL;
+}
+
+void mt_put_memory_types(struct list_head *memory_types)
+{
+
+}
 #endif	/* CONFIG_NUMA */
 #endif  /* _LINUX_MEMORY_TIERS_H */
--- a/mm/memory-tiers.c~memory-tier-dax-kmem-introduce-an-abstract-layer-for-finding-allocating-and-putting-memory-types
+++ a/mm/memory-tiers.c
@@ -623,6 +623,38 @@ void clear_node_memory_type(int node, st
 }
 EXPORT_SYMBOL_GPL(clear_node_memory_type);
 
+struct memory_dev_type *mt_find_alloc_memory_type(int adist, struct list_head *memory_types)
+{
+	bool found = false;
+	struct memory_dev_type *mtype;
+
+	list_for_each_entry(mtype, memory_types, list) {
+		if (mtype->adistance == adist) {
+			found = true;
+			break;
+		}
+	}
+	if (!found) {
+		mtype = alloc_memory_type(adist);
+		if (!IS_ERR(mtype))
+			list_add(&mtype->list, memory_types);
+	}
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

memory-tier-dax-kmem-introduce-an-abstract-layer-for-finding-allocating-and-putting-memory-types.patch
memory-tier-create-cpuless-memory-tiers-after-obtaining-hmat-info.patch

