Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCF5229B38;
	Wed, 16 Apr 2025 22:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744843602; cv=none; b=nWjRIQIWrUIg+4Us7xrj6U8C8Z3BvfE6aA2cbgAdWUFzpSSoBn/ljwvgSQYF1clofL2pT0TusqxH58U2+cXQ6PE81BnpZb3psdmKCzsmVWfvRgqreEYCgk8DADNX6oPbP3WOeDIfynO+VcNSHoPPXZxiWxVDnKoy3jJmUKpfkuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744843602; c=relaxed/simple;
	bh=WB6mcI3jVEFzI/xAzc/tVMORbnipzR4etpqawZpGjis=;
	h=Date:To:From:Subject:Message-Id; b=TMgowq6q043nHsBRUYCGApIBcmLKxQUxsfSENslIljF4uZdUV7J9F3jQWRqNtd3EoZKPZywVGnVKKllCBQRZCG20R++/r5Y5BkbvoIwto+10+rcH/u5toN40VBGjIqaAOKvveTf+KMVgxi1K6z55oCdNy3Jb3r5WnHfYgESLOMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Dzyl40rA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Dzyl40rA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218EAC4CEE2;
	Wed, 16 Apr 2025 22:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744843602;
	bh=WB6mcI3jVEFzI/xAzc/tVMORbnipzR4etpqawZpGjis=;
	h=Date:To:From:Subject:From;
	b=Dzyl40rAXU0f8VrVbew3VM5PQt2ISQOp8tbuaw/d+DXxm8olhpPqdIRS2xMIRGMkM
	 nMmeSGph+yX66KC47Gogq2V8uC4UBkj+G5w0lFjv4UZ4eJlAxsoxyobGcLIm9+YoQq
	 C8ZcFOh3e9xf1Ht1ZyQyJRyGI3nAaXeTuqlT2h+U=
Date: Wed, 16 Apr 2025 15:46:41 -0700
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,ying.huang@linux.alibaba.com,stable@vger.kernel.org,osalvador@suse.de,joshua.hahnjy@gmail.com,Jonathan.Cameron@huawei.com,honggyu.kim@sk.com,gourry@gourry.net,david@redhat.com,dan.j.williams@intel.com,rakie.kim@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-fix-memory-leaks-in-weighted-interleave-sysfs.patch added to mm-new branch
Message-Id: <20250416224642.218EAC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mempolicy: fix memory leaks in weighted interleave sysfs
has been added to the -mm mm-new branch.  Its filename is
     mm-mempolicy-fix-memory-leaks-in-weighted-interleave-sysfs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-fix-memory-leaks-in-weighted-interleave-sysfs.patch

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
Subject: mm/mempolicy: fix memory leaks in weighted interleave sysfs
Date: Wed, 16 Apr 2025 20:31:19 +0900

Patch series "Enhance sysfs handling for memory hotplug in weighted
interleave", v8.

The following patch series enhances the weighted interleave policy in the
memory management subsystem by improving sysfs handling, fixing memory
leaks, and introducing dynamic sysfs updates for memory hotplug support.


This patch (of 3):

Memory leaks occurred when removing sysfs attributes for weighted
interleave.  Improper kobject deallocation led to unreleased memory when
initialization failed or when nodes were removed.

This patch resolves the issue by replacing unnecessary `kfree()` calls
with proper `kobject_del()` and `kobject_put()` sequences, ensuring
correct teardown and preventing memory leaks.

By explicitly calling `kobject_del()` before `kobject_put()`, the release
function is now invoked safely, and internal sysfs state is correctly
cleaned up.  This guarantees that the memory associated with the kobject
is fully released and avoids resource leaks, thereby improving system
stability.

Additionally, sysfs_remove_file() is no longer called from the release
function to avoid accessing invalid sysfs state after kobject_del().  All
attribute removals are now done before kobject_del(), preventing WARN_ON()
in kernfs and ensuring safe and consistent cleanup of sysfs entries.

Link: https://lkml.kernel.org/r/20250416113123.629-1-rakie.kim@sk.com
Link: https://lkml.kernel.org/r/20250416113123.629-2-rakie.kim@sk.com
Fixes: dce41f5ae253 ("mm/mempolicy: implement the sysfs-based weighted_interleave interface")
Signed-off-by: Rakie Kim <rakie.kim@sk.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yunjeong Mun <yunjeong.mun@sk.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |  111 +++++++++++++++++++++++++----------------------
 1 file changed, 61 insertions(+), 50 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-fix-memory-leaks-in-weighted-interleave-sysfs
+++ a/mm/mempolicy.c
@@ -3463,8 +3463,8 @@ static ssize_t node_store(struct kobject
 
 static struct iw_node_attr **node_attrs;
 
-static void sysfs_wi_node_release(struct iw_node_attr *node_attr,
-				  struct kobject *parent)
+static void sysfs_wi_node_delete(struct iw_node_attr *node_attr,
+				 struct kobject *parent)
 {
 	if (!node_attr)
 		return;
@@ -3473,18 +3473,41 @@ static void sysfs_wi_node_release(struct
 	kfree(node_attr);
 }
 
-static void sysfs_wi_release(struct kobject *wi_kobj)
+static void sysfs_wi_node_delete_all(struct kobject *wi_kobj)
 {
-	int i;
+	int nid;
 
-	for (i = 0; i < nr_node_ids; i++)
-		sysfs_wi_node_release(node_attrs[i], wi_kobj);
-	kobject_put(wi_kobj);
+	for (nid = 0; nid < nr_node_ids; nid++)
+		sysfs_wi_node_delete(node_attrs[nid], wi_kobj);
+}
+
+static void iw_table_free(void)
+{
+	u8 *old;
+
+	mutex_lock(&iw_table_lock);
+	old = rcu_dereference_protected(iw_table,
+					lockdep_is_held(&iw_table_lock));
+	if (old) {
+		rcu_assign_pointer(iw_table, NULL);
+		mutex_unlock(&iw_table_lock);
+
+		synchronize_rcu();
+		kfree(old);
+	} else
+		mutex_unlock(&iw_table_lock);
+}
+
+static void wi_kobj_release(struct kobject *wi_kobj)
+{
+	iw_table_free();
+	kfree(node_attrs);
+	kfree(wi_kobj);
 }
 
 static const struct kobj_type wi_ktype = {
 	.sysfs_ops = &kobj_sysfs_ops,
-	.release = sysfs_wi_release,
+	.release = wi_kobj_release,
 };
 
 static int add_weight_node(int nid, struct kobject *wi_kobj)
@@ -3525,41 +3548,42 @@ static int add_weighted_interleave_group
 	struct kobject *wi_kobj;
 	int nid, err;
 
+	node_attrs = kcalloc(nr_node_ids, sizeof(struct iw_node_attr *),
+			     GFP_KERNEL);
+	if (!node_attrs)
+		return -ENOMEM;
+
 	wi_kobj = kzalloc(sizeof(struct kobject), GFP_KERNEL);
-	if (!wi_kobj)
+	if (!wi_kobj) {
+		kfree(node_attrs);
 		return -ENOMEM;
+	}
 
 	err = kobject_init_and_add(wi_kobj, &wi_ktype, root_kobj,
 				   "weighted_interleave");
-	if (err) {
-		kfree(wi_kobj);
-		return err;
-	}
+	if (err)
+		goto err_put_kobj;
 
 	for_each_node_state(nid, N_POSSIBLE) {
 		err = add_weight_node(nid, wi_kobj);
 		if (err) {
 			pr_err("failed to add sysfs [node%d]\n", nid);
-			break;
+			goto err_cleanup_kobj;
 		}
 	}
-	if (err)
-		kobject_put(wi_kobj);
+
 	return 0;
+
+err_cleanup_kobj:
+	sysfs_wi_node_delete_all(wi_kobj);
+	kobject_del(wi_kobj);
+err_put_kobj:
+	kobject_put(wi_kobj);
+	return err;
 }
 
 static void mempolicy_kobj_release(struct kobject *kobj)
 {
-	u8 *old;
-
-	mutex_lock(&iw_table_lock);
-	old = rcu_dereference_protected(iw_table,
-					lockdep_is_held(&iw_table_lock));
-	rcu_assign_pointer(iw_table, NULL);
-	mutex_unlock(&iw_table_lock);
-	synchronize_rcu();
-	kfree(old);
-	kfree(node_attrs);
 	kfree(kobj);
 }
 
@@ -3573,37 +3597,24 @@ static int __init mempolicy_sysfs_init(v
 	static struct kobject *mempolicy_kobj;
 
 	mempolicy_kobj = kzalloc(sizeof(*mempolicy_kobj), GFP_KERNEL);
-	if (!mempolicy_kobj) {
-		err = -ENOMEM;
-		goto err_out;
-	}
-
-	node_attrs = kcalloc(nr_node_ids, sizeof(struct iw_node_attr *),
-			     GFP_KERNEL);
-	if (!node_attrs) {
-		err = -ENOMEM;
-		goto mempol_out;
-	}
+	if (!mempolicy_kobj)
+		return -ENOMEM;
 
 	err = kobject_init_and_add(mempolicy_kobj, &mempolicy_ktype, mm_kobj,
 				   "mempolicy");
 	if (err)
-		goto node_out;
+		goto err_put_kobj;
 
 	err = add_weighted_interleave_group(mempolicy_kobj);
-	if (err) {
-		pr_err("mempolicy sysfs structure failed to initialize\n");
-		kobject_put(mempolicy_kobj);
-		return err;
-	}
+	if (err)
+		goto err_del_kobj;
 
-	return err;
-node_out:
-	kfree(node_attrs);
-mempol_out:
-	kfree(mempolicy_kobj);
-err_out:
-	pr_err("failed to add mempolicy kobject to the system\n");
+	return 0;
+
+err_del_kobj:
+	kobject_del(mempolicy_kobj);
+err_put_kobj:
+	kobject_put(mempolicy_kobj);
 	return err;
 }
 
_

Patches currently in -mm which might be from rakie.kim@sk.com are

mm-mempolicy-fix-memory-leaks-in-weighted-interleave-sysfs.patch
mm-mempolicy-prepare-weighted-interleave-sysfs-for-memory-hotplug.patch
mm-mempolicy-support-memory-hotplug-in-weighted-interleave.patch

