Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BD0F4E2
	for <mm-commits@vger.kernel.org>; Wed,  2 Apr 2025 03:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743564987; cv=none; b=JbJWmuhR90qag+y3QMgP8+6x+slZQkOWBZV8DIXsBa2vCSnVESKn3rhwhVQcMkOKPOvrNGX0s3+AmKKiMSaZa2crHrDS1m8yAvawiyLeY4w+VzXpmP2wCNd+nsbb+T0/u5BVSOiF0u38QtvQI7gs59f7pmW5dZySNd2gQmU2EUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743564987; c=relaxed/simple;
	bh=/MiuTTMAIVOO0iX5xtJYvwWOlL7rK7viZB04WQjDVi0=;
	h=Date:To:From:Subject:Message-Id; b=kxgAgR4xEvJ1EN8WxJSsdmSj4muLNDqz/q0qpfkaZJSW/iC9hQ322GbXQfEg+GTmRo85g7H6GQhVJXzOL2KwZ471yCHYEEaSadelqJXUIiZS+ilyOODAzqvv9xtJgpRZJWD6atVIn+fTwOkl5GGjvdJ1YKAPILn3looHqlsUHvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H2kwrsW2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H2kwrsW2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3106C4CEDD;
	Wed,  2 Apr 2025 03:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743564986;
	bh=/MiuTTMAIVOO0iX5xtJYvwWOlL7rK7viZB04WQjDVi0=;
	h=Date:To:From:Subject:From;
	b=H2kwrsW2bhIIGDt8lK23lP2l22y5hbBuasG45UFla2kEtLXwk0HgtkoPdoAcxF5dM
	 qfggyBPJWqiARSpyUCGdvWmrp9yOEySPAzGxFhB8rcK10zd1NP3MEgjmpKuyVZtxSg
	 cczjq1a6MPhLw5AB3PjsTWTiN+MqjEfjtOyWoEyI=
Date: Tue, 01 Apr 2025 20:36:25 -0700
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,ying.huang@linux.alibaba.com,joshua.hahnjy@gmail.com,Jonathan.Cameron@huawei.com,honggyu.kim@sk.com,gourry@gourry.net,david@redhat.com,dan.j.williams@intel.com,rakie.kim@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-fix-memory-leaks-in-weighted-interleave-sysfs.patch added to mm-new branch
Message-Id: <20250402033626.A3106C4CEDD@smtp.kernel.org>
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
Date: Wed, 2 Apr 2025 10:49:02 +0900

Patch series "Enhance sysfs handling for memory hotplug in weighted
interleave", v5.

The following patch series enhances the weighted interleave policy in the
memory management subsystem by improving sysfs handling, fixing memory
leaks, and introducing dynamic sysfs updates for memory hotplug support.

### Background
The weighted interleave policy distributes memory allocations across
multiple NUMA nodes based on their performance weight, thereby optimizing
memory bandwidth utilization.  The weight values are configured through
sysfs.

Previously, sysfs entries for weighted interleave were managed statically
at initialization. This led to several issues:
- Memory Leaks: Improper `kobject` deallocation caused memory leaks
  when initialization failed or when nodes were removed.
- Lack of Dynamic Updates: Sysfs attributes were created only during
  initialization, preventing nodes added at runtime from being recognized.
- Handling of Unusable Nodes: Sysfs entries were generated for all
  possible nodes (`N_POSSIBLE`), including memoryless or unavailable nodes,
  leading to sysfs entries for unusable nodes and potential
  misconfigurations.

### Patch Overview
1. [PATCH 1/3] Fix memory leaks in weighted interleave sysfs
   - Ensures proper cleanup of `kobject` allocations.
   - Replaces unnecessary `kfree()` calls with `kobject_put()`, preventing
     memory leaks and improving system stability.

2. [PATCH 2/3] Enable dynamic updates for weighted interleave sysfs
   - Restructures sysfs handling to allow runtime updates.
   - The sysfs attributes are now globally accessible, enabling external
     modules to manage interleave settings dynamically.

3. [PATCH 3/3] Support memory hotplug in weighted interleave
   - Modifies sysfs creation logic to restrict entries to nodes that are
     online and have memory, excluding unusable nodes.
   - Introduces a memory hotplug mechanism to dynamically add and remove
     sysfs attributes when nodes transition into or out of the `N_MEMORY` set.
   - Ensures that sysfs attributes are properly removed when nodes go offline,
     preventing stale or redundant entries from persisting.

These patches have been tested under CXL-based memory configurations,
including hotplug scenarios, to ensure proper behavior and stability.


This patch (of 3):

Memory leaks occurred when removing sysfs attributes for weighted
interleave.  Improper kobject deallocation led to unreleased memory when
initialization failed or when nodes were removed.

This patch resolves the issue by replacing unnecessary `kfree()` calls
with `kobject_put()`, ensuring proper cleanup and preventing memory leaks.

By correctly using `kobject_put()`, the release function now properly
deallocates memory without causing resource leaks, thereby improving
system stability.

Link: https://lkml.kernel.org/r/20250402014906.1086-1-rakie.kim@sk.com
Link: https://lkml.kernel.org/r/20250402014906.1086-2-rakie.kim@sk.com
Fixes: dce41f5ae253 ("mm/mempolicy: implement the sysfs-based weighted_interleave interface")
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

 mm/mempolicy.c |   61 +++++++++++++++++++++++------------------------
 1 file changed, 31 insertions(+), 30 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-fix-memory-leaks-in-weighted-interleave-sysfs
+++ a/mm/mempolicy.c
@@ -3479,7 +3479,9 @@ static void sysfs_wi_release(struct kobj
 
 	for (i = 0; i < nr_node_ids; i++)
 		sysfs_wi_node_release(node_attrs[i], wi_kobj);
-	kobject_put(wi_kobj);
+
+	kfree(node_attrs);
+	kfree(wi_kobj);
 }
 
 static const struct kobj_type wi_ktype = {
@@ -3525,15 +3527,22 @@ static int add_weighted_interleave_group
 	struct kobject *wi_kobj;
 	int nid, err;
 
-	wi_kobj = kzalloc(sizeof(struct kobject), GFP_KERNEL);
-	if (!wi_kobj)
+	node_attrs = kcalloc(nr_node_ids, sizeof(struct iw_node_attr *),
+			     GFP_KERNEL);
+	if (!node_attrs)
 		return -ENOMEM;
 
+	wi_kobj = kzalloc(sizeof(struct kobject), GFP_KERNEL);
+	if (!wi_kobj) {
+		err = -ENOMEM;
+		goto node_out;
+	}
+
 	err = kobject_init_and_add(wi_kobj, &wi_ktype, root_kobj,
 				   "weighted_interleave");
 	if (err) {
-		kfree(wi_kobj);
-		return err;
+		kobject_put(wi_kobj);
+		goto err_out;
 	}
 
 	for_each_node_state(nid, N_POSSIBLE) {
@@ -3543,9 +3552,17 @@ static int add_weighted_interleave_group
 			break;
 		}
 	}
-	if (err)
+	if (err) {
 		kobject_put(wi_kobj);
+		goto err_out;
+	}
+
 	return 0;
+
+node_out:
+	kfree(node_attrs);
+err_out:
+	return err;
 }
 
 static void mempolicy_kobj_release(struct kobject *kobj)
@@ -3559,7 +3576,6 @@ static void mempolicy_kobj_release(struc
 	mutex_unlock(&iw_table_lock);
 	synchronize_rcu();
 	kfree(old);
-	kfree(node_attrs);
 	kfree(kobj);
 }
 
@@ -3573,37 +3589,22 @@ static int __init mempolicy_sysfs_init(v
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
+		goto err_out;
 
 	err = add_weighted_interleave_group(mempolicy_kobj);
-	if (err) {
-		pr_err("mempolicy sysfs structure failed to initialize\n");
-		kobject_put(mempolicy_kobj);
-		return err;
-	}
+	if (err)
+		goto err_out;
+
+	return 0;
 
-	return err;
-node_out:
-	kfree(node_attrs);
-mempol_out:
-	kfree(mempolicy_kobj);
 err_out:
-	pr_err("failed to add mempolicy kobject to the system\n");
+	kobject_put(mempolicy_kobj);
 	return err;
 }
 
_

Patches currently in -mm which might be from rakie.kim@sk.com are

mm-mempolicy-fix-memory-leaks-in-weighted-interleave-sysfs.patch
mm-mempolicy-support-dynamic-sysfs-updates-for-weighted-interleave.patch
mm-mempolicy-support-memory-hotplug-in-weighted-interleave.patch

