Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F112F4E2
	for <mm-commits@vger.kernel.org>; Wed,  2 Apr 2025 03:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743564989; cv=none; b=Tt7OOCz3DXjo9UZqa/nVtMx+5gD8IaHThRrn/B2EXqMYvluhlryVUs804bEIlIdYOk+FXCZofesYnks/GvoIVrOOG0A9skjLFnPwOk5RjCzF10AcqKHDmSV1BFVXluhGrB+mA3DFk5FAtyHrjGOEpV16jvA4O7fU7wNzN6CPnm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743564989; c=relaxed/simple;
	bh=xXacGE9/16JicZsQ1tRG3DcQrl70KqfIvuhO0oVpkhg=;
	h=Date:To:From:Subject:Message-Id; b=dJFlPehObzTeF6pVzcJvAfxF7W607ZwowV7NayzEcqW3mUq60feYcb+Bb7YOgs/hh+C/tyPSXjMpMjTJe1duE4VyTgummE5xT3ER/RNV/gqsrxHA/IJUrt6bS6kcqf1qwAh96HSmr3HEJ77jlKNIGDJo+jJtfmytLt7d9Iq3lac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yKmLJzOf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yKmLJzOf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BA2C4CEDD;
	Wed,  2 Apr 2025 03:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743564988;
	bh=xXacGE9/16JicZsQ1tRG3DcQrl70KqfIvuhO0oVpkhg=;
	h=Date:To:From:Subject:From;
	b=yKmLJzOf3BjWZ1dZFe8AQlH5YHwLVZBYlrlENHsIvHCFt9EUA6eM/JWOg89xs+aam
	 tXENQCUWDsmYD0O0lVpQDc0GjuKWKfTYod0cQWcu9H+VPfDPPsr9fiIyTidWS1T+3o
	 8Ukbd4RcKhwMkLNAn+w3kMqqXIbLrfkResJ5eg6I=
Date: Tue, 01 Apr 2025 20:36:28 -0700
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,ying.huang@linux.alibaba.com,joshua.hahnjy@gmail.com,Jonathan.Cameron@huawei.com,honggyu.kim@sk.com,gourry@gourry.net,david@redhat.com,dan.j.williams@intel.com,rakie.kim@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-support-dynamic-sysfs-updates-for-weighted-interleave.patch added to mm-new branch
Message-Id: <20250402033628.C0BA2C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mempolicy: support dynamic sysfs updates for weighted interleave
has been added to the -mm mm-new branch.  Its filename is
     mm-mempolicy-support-dynamic-sysfs-updates-for-weighted-interleave.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-support-dynamic-sysfs-updates-for-weighted-interleave.patch

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
Subject: mm/mempolicy: support dynamic sysfs updates for weighted interleave
Date: Wed, 2 Apr 2025 10:49:03 +0900

Previously, the weighted interleave sysfs structure was statically
managed, preventing dynamic updates when nodes were added or removed.

This patch restructures the weighted interleave sysfs to support dynamic
insertion and deletion.  The sysfs that was part of the
'weighted_interleave_group' is now globally accessible, allowing external
access to that sysfs.

With this change, sysfs management for weighted interleave is more
flexible, supporting hotplug events and runtime updates more effectively.

Link: https://lkml.kernel.org/r/20250402014906.1086-3-rakie.kim@sk.com
Reviewed-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Rakie Kim <rakie.kim@sk.com>
Signed-off-by: Honggyu Kim <honggyu.kim@sk.com>
Signed-off-by: Yunjeong Mun <yunjeong.mun@sk.com>
Cc: Dan Willaims <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   71 ++++++++++++++++++++---------------------------
 1 file changed, 31 insertions(+), 40 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-support-dynamic-sysfs-updates-for-weighted-interleave
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
+static void sysfs_wi_node_release(int nid)
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
+		sysfs_wi_node_release(nid);
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
@@ -3511,57 +3515,44 @@ static int add_weight_node(int nid, stru
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
+static int add_weighted_interleave_group(struct kobject *mempolicy_kobj)
 {
-	struct kobject *wi_kobj;
 	int nid, err;
 
-	node_attrs = kcalloc(nr_node_ids, sizeof(struct iw_node_attr *),
-			     GFP_KERNEL);
-	if (!node_attrs)
+	wi_group = kzalloc(sizeof(struct sysfs_wi_group) + 		\
+		       nr_node_ids * sizeof(struct iw_node_attr *),	\
+		       GFP_KERNEL);
+	if (!wi_group)
 		return -ENOMEM;
 
-	wi_kobj = kzalloc(sizeof(struct kobject), GFP_KERNEL);
-	if (!wi_kobj) {
-		err = -ENOMEM;
-		goto node_out;
-	}
-
-	err = kobject_init_and_add(wi_kobj, &wi_ktype, root_kobj,
+	err = kobject_init_and_add(&wi_group->wi_kobj, &wi_ktype, mempolicy_kobj,
 				   "weighted_interleave");
-	if (err) {
-		kobject_put(wi_kobj);
+	if (err)
 		goto err_out;
-	}
 
 	for_each_node_state(nid, N_POSSIBLE) {
-		err = add_weight_node(nid, wi_kobj);
+		err = sysfs_wi_node_add(nid);
 		if (err) {
 			pr_err("failed to add sysfs [node%d]\n", nid);
-			break;
+			goto err_out;
 		}
 	}
-	if (err) {
-		kobject_put(wi_kobj);
-		goto err_out;
-	}
 
 	return 0;
 
-node_out:
-	kfree(node_attrs);
 err_out:
+	kobject_put(&wi_group->wi_kobj);
 	return err;
 }
 
_

Patches currently in -mm which might be from rakie.kim@sk.com are

mm-mempolicy-fix-memory-leaks-in-weighted-interleave-sysfs.patch
mm-mempolicy-support-dynamic-sysfs-updates-for-weighted-interleave.patch
mm-mempolicy-support-memory-hotplug-in-weighted-interleave.patch

