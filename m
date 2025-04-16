Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537BF238C25
	for <mm-commits@vger.kernel.org>; Wed, 16 Apr 2025 22:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744843605; cv=none; b=kks8dheKJjrjazHYNqlR5MB3BazL6WfncLmr31wap0sOeixrYVWKGiaO0p6jGMKR4LY8JWwAzR/gwbcUlCRBvVkAUSsYOMjawaqSTETmLeRviuURJOC2lzOaasGRFhaUmjSnvDdrolP5u8RU0RtWArldhNeM4bdw3bLbafS97Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744843605; c=relaxed/simple;
	bh=UPfgm14d94NSYXrMZCSWblAu6VqLulkPTz3FWjq88b0=;
	h=Date:To:From:Subject:Message-Id; b=T8QrTyGOijfRm8qupoMtwhhDaAr7+cpENjovzd9jNyijcLFIH+EKzBprhYf2pkoxyyg+f0ZSYbmvoZD/ACk6woa0BiWy4uftdqqdK4DKh6aTdqsIN87qfS5RstvjRtOlL5OMUL/tN2r5CbP3XZ3xOPdcp/toe+c75q0uKrp64yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rmuH0iHQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rmuH0iHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4CAC4CEEC;
	Wed, 16 Apr 2025 22:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744843604;
	bh=UPfgm14d94NSYXrMZCSWblAu6VqLulkPTz3FWjq88b0=;
	h=Date:To:From:Subject:From;
	b=rmuH0iHQSz2eQP0T1Uuq45KqeeiyqTtDb24qF2/Vkfz9Cmz/BXeqFIzuijfGnZNfg
	 2gaQmFQo8alqfHcgu3JkvUZlYuLvBFH9g3t+85zkgdvxQ4LAXa6LFzGN+jnhYMTFXI
	 20K8MBVACelyIbO/dvRwL6Nom0vC+147GPkNRMDk=
Date: Wed, 16 Apr 2025 15:46:44 -0700
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,ying.huang@linux.alibaba.com,osalvador@suse.de,joshua.hahnjy@gmail.com,Jonathan.Cameron@huawei.com,honggyu.kim@sk.com,gourry@gourry.net,david@redhat.com,dan.j.williams@intel.com,rakie.kim@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-support-memory-hotplug-in-weighted-interleave.patch added to mm-new branch
Message-Id: <20250416224644.AD4CAC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mempolicy: support memory hotplug in weighted interleave
has been added to the -mm mm-new branch.  Its filename is
     mm-mempolicy-support-memory-hotplug-in-weighted-interleave.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-support-memory-hotplug-in-weighted-interleave.patch

This patch will later appear in the mm-new branch at
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
From: Rakie Kim <rakie.kim@sk.com>
Subject: mm/mempolicy: support memory hotplug in weighted interleave
Date: Wed, 16 Apr 2025 20:31:21 +0900

The weighted interleave policy distributes page allocations across
multiple NUMA nodes based on their performance weight, thereby improving
memory bandwidth utilization.  The weight values for each node are
configured through sysfs.

Previously, sysfs entries for configuring weighted interleave were created
for all possible nodes (N_POSSIBLE) at initialization, including nodes
that might not have memory.  However, not all nodes in N_POSSIBLE are
usable at runtime, as some may remain memoryless or offline.  This led to
sysfs entries being created for unusable nodes, causing potential
misconfiguration issues.

To address this issue, this patch modifies the sysfs creation logic to:
1) Limit sysfs entries to nodes that are online and have memory, avoiding
   the creation of sysfs entries for nodes that cannot be used.
2) Support memory hotplug by dynamically adding and removing sysfs entries
   based on whether a node transitions into or out of the N_MEMORY state.

Additionally, the patch ensures that sysfs attributes are properly managed
when nodes go offline, preventing stale or redundant entries from
persisting in the system.

By making these changes, the weighted interleave policy now manages its
sysfs entries more efficiently, ensuring that only relevant nodes are
considered for interleaving, and dynamically adapting to memory hotplug
events.

Link: https://lkml.kernel.org/r/20250416113123.629-4-rakie.kim@sk.com
Co-developed-by: Honggyu Kim <honggyu.kim@sk.com>
Signed-off-by: Honggyu Kim <honggyu.kim@sk.com>
Co-developed-by: Yunjeong Mun <yunjeong.mun@sk.com>
Signed-off-by: Yunjeong Mun <yunjeong.mun@sk.com>
Signed-off-by: Rakie Kim <rakie.kim@sk.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |  109 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 85 insertions(+), 24 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-support-memory-hotplug-in-weighted-interleave
+++ a/mm/mempolicy.c
@@ -113,6 +113,7 @@
 #include <asm/tlbflush.h>
 #include <asm/tlb.h>
 #include <linux/uaccess.h>
+#include <linux/memory.h>
 
 #include "internal.h"
 
@@ -3421,6 +3422,7 @@ struct iw_node_attr {
 
 struct sysfs_wi_group {
 	struct kobject wi_kobj;
+	struct mutex kobj_lock;
 	struct iw_node_attr *nattrs[];
 };
 
@@ -3470,13 +3472,24 @@ static ssize_t node_store(struct kobject
 
 static void sysfs_wi_node_delete(int nid)
 {
-	if (!wi_group->nattrs[nid])
+	struct iw_node_attr *attr;
+
+	if (nid < 0 || nid >= nr_node_ids)
+		return;
+
+	mutex_lock(&wi_group->kobj_lock);
+	attr = wi_group->nattrs[nid];
+	if (!attr) {
+		mutex_unlock(&wi_group->kobj_lock);
 		return;
+	}
+
+	wi_group->nattrs[nid] = NULL;
+	mutex_unlock(&wi_group->kobj_lock);
 
-	sysfs_remove_file(&wi_group->wi_kobj,
-			  &wi_group->nattrs[nid]->kobj_attr.attr);
-	kfree(wi_group->nattrs[nid]->kobj_attr.attr.name);
-	kfree(wi_group->nattrs[nid]);
+	sysfs_remove_file(&wi_group->wi_kobj, &attr->kobj_attr.attr);
+	kfree(attr->kobj_attr.attr.name);
+	kfree(attr);
 }
 
 static void sysfs_wi_node_delete_all(void)
@@ -3517,35 +3530,77 @@ static const struct kobj_type wi_ktype =
 
 static int sysfs_wi_node_add(int nid)
 {
-	struct iw_node_attr *node_attr;
+	int ret = 0;
 	char *name;
+	struct iw_node_attr *new_attr;
 
-	node_attr = kzalloc(sizeof(*node_attr), GFP_KERNEL);
-	if (!node_attr)
+	if (nid < 0 || nid >= nr_node_ids) {
+		pr_err("invalid node id: %d\n", nid);
+		return -EINVAL;
+	}
+
+	new_attr = kzalloc(sizeof(*new_attr), GFP_KERNEL);
+	if (!new_attr)
 		return -ENOMEM;
 
 	name = kasprintf(GFP_KERNEL, "node%d", nid);
 	if (!name) {
-		kfree(node_attr);
+		kfree(new_attr);
 		return -ENOMEM;
 	}
 
-	sysfs_attr_init(&node_attr->kobj_attr.attr);
-	node_attr->kobj_attr.attr.name = name;
-	node_attr->kobj_attr.attr.mode = 0644;
-	node_attr->kobj_attr.show = node_show;
-	node_attr->kobj_attr.store = node_store;
-	node_attr->nid = nid;
-
-	if (sysfs_create_file(&wi_group->wi_kobj, &node_attr->kobj_attr.attr)) {
-		kfree(node_attr->kobj_attr.attr.name);
-		kfree(node_attr);
-		pr_err("failed to add attribute to weighted_interleave\n");
-		return -ENOMEM;
+	sysfs_attr_init(&new_attr->kobj_attr.attr);
+	new_attr->kobj_attr.attr.name = name;
+	new_attr->kobj_attr.attr.mode = 0644;
+	new_attr->kobj_attr.show = node_show;
+	new_attr->kobj_attr.store = node_store;
+	new_attr->nid = nid;
+
+	mutex_lock(&wi_group->kobj_lock);
+	if (wi_group->nattrs[nid]) {
+		mutex_unlock(&wi_group->kobj_lock);
+		pr_info("node%d already exists\n", nid);
+		goto out;
 	}
 
-	wi_group->nattrs[nid] = node_attr;
+	ret = sysfs_create_file(&wi_group->wi_kobj, &new_attr->kobj_attr.attr);
+	if (ret) {
+		mutex_unlock(&wi_group->kobj_lock);
+		goto out;
+	}
+	wi_group->nattrs[nid] = new_attr;
+	mutex_unlock(&wi_group->kobj_lock);
 	return 0;
+
+out:
+	kfree(new_attr->kobj_attr.attr.name);
+	kfree(new_attr);
+	return ret;
+}
+
+static int wi_node_notifier(struct notifier_block *nb,
+			       unsigned long action, void *data)
+{
+	int err;
+	struct memory_notify *arg = data;
+	int nid = arg->status_change_nid;
+
+	if (nid < 0)
+		return NOTIFY_OK;
+
+	switch (action) {
+	case MEM_ONLINE:
+		err = sysfs_wi_node_add(nid);
+		if (err)
+			pr_err("failed to add sysfs for node%d during hotplug: %d\n",
+			       nid, err);
+		break;
+	case MEM_OFFLINE:
+		sysfs_wi_node_delete(nid);
+		break;
+	}
+
+	return NOTIFY_OK;
 }
 
 static int __init add_weighted_interleave_group(struct kobject *mempolicy_kobj)
@@ -3556,20 +3611,26 @@ static int __init add_weighted_interleav
 			   GFP_KERNEL);
 	if (!wi_group)
 		return -ENOMEM;
+	mutex_init(&wi_group->kobj_lock);
 
 	err = kobject_init_and_add(&wi_group->wi_kobj, &wi_ktype, mempolicy_kobj,
 				   "weighted_interleave");
 	if (err)
 		goto err_put_kobj;
 
-	for_each_node_state(nid, N_POSSIBLE) {
+	for_each_online_node(nid) {
+		if (!node_state(nid, N_MEMORY))
+			continue;
+
 		err = sysfs_wi_node_add(nid);
 		if (err) {
-			pr_err("failed to add sysfs [node%d]\n", nid);
+			pr_err("failed to add sysfs for node%d during init: %d\n",
+			       nid, err);
 			goto err_cleanup_kobj;
 		}
 	}
 
+	hotplug_memory_notifier(wi_node_notifier, DEFAULT_CALLBACK_PRI);
 	return 0;
 
 err_cleanup_kobj:
_

Patches currently in -mm which might be from rakie.kim@sk.com are

mm-mempolicy-fix-memory-leaks-in-weighted-interleave-sysfs.patch
mm-mempolicy-prepare-weighted-interleave-sysfs-for-memory-hotplug.patch
mm-mempolicy-support-memory-hotplug-in-weighted-interleave.patch

