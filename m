Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28811A08CA
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011154; cv=none; b=bN60Gwj/Xb+zokeDBlK1wyfK2s1o6/4xSTWxxxxDDEi3tpR/43o0Gba7QfxrDbZrQZHr8MEXX3an4N3eHpem4b885ADEt5Wp3tQUYzGR+7CVvceOcgL/BnbtjbOBGdx7xho0Ytugl5rmDovHUzvmCdibjFndWKnow5JYXheDgRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011154; c=relaxed/simple;
	bh=TucQfhasyizC+sQqwUm8Fcqey5XlbJdWVKljyo+IDwc=;
	h=Date:To:From:Subject:Message-Id; b=tc4tWj2WmHRpxJdt8qUmgtypMoybMw6CG5fitdQeaBUJvB2kal6ZAHFrOMv06iFZC9JFUGl020/i6yy+e5eCq4B41sPEbk6nVolJThYlAY3KTSycegD0igZP+h5jNflfckvOQ9ocuayv543wsxzoF3e9LFcLMAE7iCu74BxFeZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CcX4M5mf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CcX4M5mf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C811CC4CEE4;
	Mon, 12 May 2025 00:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011153;
	bh=TucQfhasyizC+sQqwUm8Fcqey5XlbJdWVKljyo+IDwc=;
	h=Date:To:From:Subject:From;
	b=CcX4M5mf+FCUhN55elYp1XiBD+aYOxivyAgUuMEHadIMIFBplN9WuT5SdoE+MnzI1
	 Etdhf4a5ayatlbFQjIZVfmjoDg5jh31LsmJdr1XptU80c+8XOGd1AS3nFS+W4g+hNL
	 zw4aeEJqk1v5LDIykYiioZ7kZQaQUwx6ZwyDKqbA=
Date: Sun, 11 May 2025 17:52:33 -0700
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,ying.huang@linux.alibaba.com,osalvador@suse.de,joshua.hahnjy@gmail.com,Jonathan.Cameron@huawei.com,honggyu.kim@sk.com,gourry@gourry.net,david@redhat.com,dan.j.williams@intel.com,dan.carpenter@linaro.org,rakie.kim@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mempolicy-support-memory-hotplug-in-weighted-interleave.patch removed from -mm tree
Message-Id: <20250512005233.C811CC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mempolicy: support memory hotplug in weighted interleave
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-support-memory-hotplug-in-weighted-interleave.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rakie Kim <rakie.kim@sk.com>
Subject: mm/mempolicy: support memory hotplug in weighted interleave
Date: Thu, 17 Apr 2025 16:28:37 +0900

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

[dan.carpenter@linaro.org: fix error code in sysfs_wi_node_add()]
  Link: https://lkml.kernel.org/r/aBjL7Bwc0QBzgajK@stanley.mountain
Link: https://lkml.kernel.org/r/20250417072839.711-4-rakie.kim@sk.com
Co-developed-by: Honggyu Kim <honggyu.kim@sk.com>
Signed-off-by: Honggyu Kim <honggyu.kim@sk.com>
Co-developed-by: Yunjeong Mun <yunjeong.mun@sk.com>
Signed-off-by: Yunjeong Mun <yunjeong.mun@sk.com>
Signed-off-by: Rakie Kim <rakie.kim@sk.com>
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
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
 
@@ -3429,6 +3430,7 @@ struct iw_node_attr {
 
 struct sysfs_wi_group {
 	struct kobject wi_kobj;
+	struct mutex kobj_lock;
 	struct iw_node_attr *nattrs[];
 };
 
@@ -3478,13 +3480,24 @@ static ssize_t node_store(struct kobject
 
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
@@ -3526,35 +3539,77 @@ static const struct kobj_type wi_ktype =
 
 static int sysfs_wi_node_add(int nid)
 {
-	struct iw_node_attr *node_attr;
+	int ret;
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
+		ret = -EEXIST;
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
@@ -3565,20 +3620,26 @@ static int __init add_weighted_interleav
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


