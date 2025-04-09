Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BE482899
	for <mm-commits@vger.kernel.org>; Wed,  9 Apr 2025 01:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744163032; cv=none; b=DjE/OOUFvJYnoA+2PEIQ9QrdCJBdigS/MtDoHk17/JEPWVt4t8EA8fscZjjO9pHuZksS+tX8J7kJC0nyslRcVuKVAGFz/9lWYl/8NbSphGVJQ1RVkjAHQJz/mZCa2DPIfUHm8JiGjjcdQmgnFlGjFH0bio2HAirq23FTVzO06bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744163032; c=relaxed/simple;
	bh=XTF6SqOxeZd7dA/k66WdEMHy/4zyBoakGeeZO0GVMCk=;
	h=Date:To:From:Subject:Message-Id; b=qMmuiLZnRn+FNhdrO67OwK2BzlehCWxC1u99mv8m2DTYR4Xqpz7v/WQVzvXUu6CTT/kxS8uxXvfiby8HOgbkRWM5GUFdG6uFQEIElJMrLDDLxUUcXuvmTdy81p7cH0ham23KtQdL3QKA0M0sVudSi/jumIUwggnu8XnO3HujJcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ndQ0EKv9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ndQ0EKv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898AFC4CEE5;
	Wed,  9 Apr 2025 01:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744163030;
	bh=XTF6SqOxeZd7dA/k66WdEMHy/4zyBoakGeeZO0GVMCk=;
	h=Date:To:From:Subject:From;
	b=ndQ0EKv9DSI7WVAi9nntuC/t6ty1GnXaqzQRO0ZQeebdoAik1ofU99x/J4HEuNVVz
	 pYbPKYK7oD5nn9SU/wpuY011q3bkOSy/UTH2X0xJQJTjvPbrOGfSKj0RykoUYek+Bd
	 i9xfgI8ORiY6XrPuytW8bfBmy3cZ5Wkd7xHIjywM=
Date: Tue, 08 Apr 2025 18:43:50 -0700
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,ying.huang@linux.alibaba.com,osalvador@suse.de,joshua.hahnjy@gmail.com,Jonathan.Cameron@huawei.com,honggyu.kim@sk.com,gourry@gourry.net,david@redhat.com,dan.j.williams@intel.com,rakie.kim@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-prepare-weighted-interleave-sysfs-for-memory-hotplug.patch added to mm-new branch
Message-Id: <20250409014350.898AFC4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mempolicy: prepare weighted interleave sysfs for memory hotplug
has been added to the -mm mm-new branch.  Its filename is
     mm-mempolicy-prepare-weighted-interleave-sysfs-for-memory-hotplug.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-prepare-weighted-interleave-sysfs-for-memory-hotplug.patch

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
Subject: mm/mempolicy: prepare weighted interleave sysfs for memory hotplug
Date: Tue, 8 Apr 2025 16:32:41 +0900

Previously, the weighted interleave sysfs structure was statically managed
during initialization.  This prevented new nodes from being recognized
when memory hotplug events occurred, limiting the ability to update or
extend sysfs entries dynamically at runtime.

To address this, this patch refactors the sysfs infrastructure and
encapsulates it within a new structure, `sysfs_wi_group`, which holds both
the kobject and an array of node attribute pointers.

By allocating this group structure globally, the per-node sysfs attributes
can be managed beyond initialization time, enabling external modules to
insert or remove node entries in response to events such as memory hotplug
or node online/offline transitions.

Instead of allocating all per-node sysfs attributes at once, the
initialization path now uses the existing sysfs_wi_node_add() and
sysfs_wi_node_delete() helpers.  This refactoring makes it possible to
modularly manage per-node sysfs entries and ensures the infrastructure is
ready for runtime extension.

Link: https://lkml.kernel.org/r/20250408073243.488-3-rakie.kim@sk.com
Signed-off-by: Rakie Kim <rakie.kim@sk.com>
Signed-off-by: Honggyu Kim <honggyu.kim@sk.com>
Signed-off-by: Yunjeong Mun <yunjeong.mun@sk.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   61 ++++++++++++++++++++++-------------------------
 1 file changed, 29 insertions(+), 32 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-prepare-weighted-interleave-sysfs-for-memory-hotplug
+++ a/mm/mempolicy.c
@@ -3419,6 +3419,13 @@ struct iw_node_attr {
 	int nid;
 };
 
+struct sysfs_wi_group {
+	struct kobject wi_kobj;
+	struct iw_node_attr *nattrs[];
+};
+
+static struct sysfs_wi_group *wi_group;
+
 static ssize_t node_show(struct kobject *kobj, struct kobj_attribute *attr,
 			 char *buf)
 {
@@ -3461,27 +3468,24 @@ static ssize_t node_store(struct kobject
 	return count;
 }
 
-static struct iw_node_attr **node_attrs;
-
-static void sysfs_wi_node_release(struct iw_node_attr *node_attr,
-				  struct kobject *parent)
+static void sysfs_wi_node_delete(int nid)
 {
-	if (!node_attr)
+	if (!wi_group->nattrs[nid])
 		return;
-	sysfs_remove_file(parent, &node_attr->kobj_attr.attr);
-	kfree(node_attr->kobj_attr.attr.name);
-	kfree(node_attr);
+
+	sysfs_remove_file(&wi_group->wi_kobj,
+			  &wi_group->nattrs[nid]->kobj_attr.attr);
+	kfree(wi_group->nattrs[nid]->kobj_attr.attr.name);
+	kfree(wi_group->nattrs[nid]);
 }
 
 static void sysfs_wi_release(struct kobject *wi_kobj)
 {
-	int i;
-
-	for (i = 0; i < nr_node_ids; i++)
-		sysfs_wi_node_release(node_attrs[i], wi_kobj);
+	int nid;
 
-	kfree(node_attrs);
-	kfree(wi_kobj);
+	for (nid = 0; nid < nr_node_ids; nid++)
+		sysfs_wi_node_delete(nid);
+	kfree(wi_group);
 }
 
 static const struct kobj_type wi_ktype = {
@@ -3489,7 +3493,7 @@ static const struct kobj_type wi_ktype =
 	.release = sysfs_wi_release,
 };
 
-static int add_weight_node(int nid, struct kobject *wi_kobj)
+static int sysfs_wi_node_add(int nid)
 {
 	struct iw_node_attr *node_attr;
 	char *name;
@@ -3511,40 +3515,33 @@ static int add_weight_node(int nid, stru
 	node_attr->kobj_attr.store = node_store;
 	node_attr->nid = nid;
 
-	if (sysfs_create_file(wi_kobj, &node_attr->kobj_attr.attr)) {
+	if (sysfs_create_file(&wi_group->wi_kobj, &node_attr->kobj_attr.attr)) {
 		kfree(node_attr->kobj_attr.attr.name);
 		kfree(node_attr);
 		pr_err("failed to add attribute to weighted_interleave\n");
 		return -ENOMEM;
 	}
 
-	node_attrs[nid] = node_attr;
+	wi_group->nattrs[nid] = node_attr;
 	return 0;
 }
 
-static int add_weighted_interleave_group(struct kobject *root_kobj)
+static int __init add_weighted_interleave_group(struct kobject *mempolicy_kobj)
 {
-	struct kobject *wi_kobj;
 	int nid, err;
 
-	node_attrs = kcalloc(nr_node_ids, sizeof(struct iw_node_attr *),
-			     GFP_KERNEL);
-	if (!node_attrs)
+	wi_group = kzalloc(struct_size(wi_group, nattrs, nr_node_ids),
+			   GFP_KERNEL);
+	if (!wi_group)
 		return -ENOMEM;
 
-	wi_kobj = kzalloc(sizeof(struct kobject), GFP_KERNEL);
-	if (!wi_kobj) {
-		kfree(node_attrs);
-		return -ENOMEM;
-	}
-
-	err = kobject_init_and_add(wi_kobj, &wi_ktype, root_kobj,
+	err = kobject_init_and_add(&wi_group->wi_kobj, &wi_ktype, mempolicy_kobj,
 				   "weighted_interleave");
 	if (err)
 		goto err_put_kobj;
 
 	for_each_node_state(nid, N_POSSIBLE) {
-		err = add_weight_node(nid, wi_kobj);
+		err = sysfs_wi_node_add(nid);
 		if (err) {
 			pr_err("failed to add sysfs [node%d]\n", nid);
 			goto err_del_kobj;
@@ -3554,9 +3551,9 @@ static int add_weighted_interleave_group
 	return 0;
 
 err_del_kobj:
-	kobject_del(wi_kobj);
+	kobject_del(&wi_group->wi_kobj);
 err_put_kobj:
-	kobject_put(wi_kobj);
+	kobject_put(&wi_group->wi_kobj);
 	return err;
 }
 
_

Patches currently in -mm which might be from rakie.kim@sk.com are

mm-mempolicy-fix-memory-leaks-in-weighted-interleave-sysfs.patch
mm-mempolicy-prepare-weighted-interleave-sysfs-for-memory-hotplug.patch
mm-mempolicy-support-memory-hotplug-in-weighted-interleave.patch

