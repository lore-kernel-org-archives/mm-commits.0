Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400322185BE
	for <mm-commits@vger.kernel.org>; Thu, 17 Apr 2025 22:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744929331; cv=none; b=tbRVcLIMYyTSHo0XzT3UzfbGqT02oyRZkqMIBlwFLo22DQuPdkcH2FYY5Y2txNFKUCn/0PCqGs2GCGxtX6jFVPjyFSqf5xZZbAp7NEkb/78b0eE3aeEC7aMQiX+3LL1gPEW2N7DqPY+klYsQheB4VQkEn3biF05JHHeG2z7O2ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744929331; c=relaxed/simple;
	bh=oidvNEZhxy07virnZI9MfcVEqLXHifsgfZ13JFistZU=;
	h=Date:To:From:Subject:Message-Id; b=b+/UMLccOaJGKVK760Z2tnxL79HBHLAapXvwMy4AxpzO+gNYlcBmSZe2z+1Kp/Hnk0LGTvCfoNzI/QGzxo6Bgfot5pFp71dOAMbmZSX4RRdjDjEEzp12RuDTZkxvBYjkHD1w5c9++88pL83vh9PwW58RTy3avEdeBrj5EgH/lsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aalwgaYk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aalwgaYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF631C4CEE4;
	Thu, 17 Apr 2025 22:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744929330;
	bh=oidvNEZhxy07virnZI9MfcVEqLXHifsgfZ13JFistZU=;
	h=Date:To:From:Subject:From;
	b=aalwgaYkPWH8TD/hqETxsRfCz9Lq1uGpwbLS5Cv6IZYEZDSByIKK5jjVyr5kn35Wo
	 +o/4Scs3xItM6/eldrsaWUIOXiu+Zl3ooiYYzGyKZDBn8xw1dEh12oehPgcAuPALyQ
	 9eC18l3x9BC/kjcwSaxvpdqlitkCCGK2k3GlHinU=
Date: Thu, 17 Apr 2025 15:35:29 -0700
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,ying.huang@linux.alibaba.com,osalvador@suse.de,joshua.hahnjy@gmail.com,Jonathan.Cameron@huawei.com,honggyu.kim@sk.com,gourry@gourry.net,david@redhat.com,dan.j.williams@intel.com,rakie.kim@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-prepare-weighted-interleave-sysfs-for-memory-hotplug.patch added to mm-new branch
Message-Id: <20250417223530.AF631C4CEE4@smtp.kernel.org>
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
Date: Thu, 17 Apr 2025 16:28:36 +0900

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

Link: https://lkml.kernel.org/r/20250417072839.711-3-rakie.kim@sk.com
Signed-off-by: Rakie Kim <rakie.kim@sk.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yunjeong Mun <yunjeong.mun@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   64 ++++++++++++++++++++++-------------------------
 1 file changed, 31 insertions(+), 33 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-prepare-weighted-interleave-sysfs-for-memory-hotplug
+++ a/mm/mempolicy.c
@@ -3427,6 +3427,13 @@ struct iw_node_attr {
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
@@ -3469,24 +3476,23 @@ static ssize_t node_store(struct kobject
 	return count;
 }
 
-static struct iw_node_attr **node_attrs;
-
-static void sysfs_wi_node_delete(struct iw_node_attr *node_attr,
-				 struct kobject *parent)
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
 
-static void sysfs_wi_node_delete_all(struct kobject *wi_kobj)
+static void sysfs_wi_node_delete_all(void)
 {
 	int nid;
 
 	for (nid = 0; nid < nr_node_ids; nid++)
-		sysfs_wi_node_delete(node_attrs[nid], wi_kobj);
+		sysfs_wi_node_delete(nid);
 }
 
 static void iw_table_free(void)
@@ -3503,15 +3509,14 @@ static void iw_table_free(void)
 	kfree(old);
 }
 
-static void wi_cleanup(struct kobject *wi_kobj) {
-	sysfs_wi_node_delete_all(wi_kobj);
+static void wi_cleanup(void) {
+	sysfs_wi_node_delete_all();
 	iw_table_free();
-	kfree(node_attrs);
 }
 
 static void wi_kobj_release(struct kobject *wi_kobj)
 {
-	kfree(wi_kobj);
+	kfree(wi_group);
 }
 
 static const struct kobj_type wi_ktype = {
@@ -3519,7 +3524,7 @@ static const struct kobj_type wi_ktype =
 	.release = wi_kobj_release,
 };
 
-static int add_weight_node(int nid, struct kobject *wi_kobj)
+static int sysfs_wi_node_add(int nid)
 {
 	struct iw_node_attr *node_attr;
 	char *name;
@@ -3541,40 +3546,33 @@ static int add_weight_node(int nid, stru
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
-		return -ENOMEM;
-
-	wi_kobj = kzalloc(sizeof(struct kobject), GFP_KERNEL);
-	if (!wi_kobj) {
-		kfree(node_attrs);
+	wi_group = kzalloc(struct_size(wi_group, nattrs, nr_node_ids),
+			   GFP_KERNEL);
+	if (!wi_group)
 		return -ENOMEM;
-	}
 
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
 			goto err_cleanup_kobj;
@@ -3584,10 +3582,10 @@ static int add_weighted_interleave_group
 	return 0;
 
 err_cleanup_kobj:
-	wi_cleanup(wi_kobj);
-	kobject_del(wi_kobj);
+	wi_cleanup();
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

