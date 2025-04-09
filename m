Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E24158DAC
	for <mm-commits@vger.kernel.org>; Wed,  9 Apr 2025 01:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744163029; cv=none; b=ASohFd7ltyc3rrtDqZ6Mo07mUPnSi+CMJuGcH48goUisdwPZ9Zdwf71q51rFate10olSA2GvTBgknvX3yor7yLj8usba/wdtTel4hxYbcqfkXOI8RFuohZuGTLgXsC9xKnMS+iAYqeJIYvmeIrV+NOl0UxJIDr6cZp7wJJ6AX1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744163029; c=relaxed/simple;
	bh=fbDFDWwMApO79Fyfpz8thZiDC/wyEai8Fmz55mHsyEI=;
	h=Date:To:From:Subject:Message-Id; b=OzUckKxZZt7KCvJmCf/UyDX1Gsvj8B4lIbos1ubNtLAK43kohHOXvj1/5XktSH6n0/LXRkKYPMJYEkqi1n4PEEMrKZeFOg0Rciflsm7nxhemer3OuuGXdHE5kFfxVKe1/8KxW7miLiYNUr0RuUFLcgEkJHxaDc6kVpQh5Wsom1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tl0TXxqb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tl0TXxqb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7712DC4CEE5;
	Wed,  9 Apr 2025 01:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744163028;
	bh=fbDFDWwMApO79Fyfpz8thZiDC/wyEai8Fmz55mHsyEI=;
	h=Date:To:From:Subject:From;
	b=tl0TXxqb/S8d7zJggDSuGUQUa4mwuhSqzWTd/UyVbPAuDgecI52q88tfv9MzJ8kqk
	 9jyJDA0fYka1TwfDt/H/109Shw1+9Ae6hTYZRAzRCUZPVatN6InZW9t9qZPGwl8cXG
	 CEwGU35H0cq2qdqvNwnCr1C3IE0VwNCgyWKpqBco=
Date: Tue, 08 Apr 2025 18:43:47 -0700
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,ying.huang@linux.alibaba.com,osalvador@suse.de,joshua.hahnjy@gmail.com,Jonathan.Cameron@huawei.com,honggyu.kim@sk.com,gourry@gourry.net,david@redhat.com,dan.j.williams@intel.com,rakie.kim@sk.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-fix-memory-leaks-in-weighted-interleave-sysfs.patch added to mm-new branch
Message-Id: <20250409014348.7712DC4CEE5@smtp.kernel.org>
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
Date: Tue, 8 Apr 2025 16:32:40 +0900

Patch series "Enhance sysfs handling for memory hotplug in weighted
interleave", v7.

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
- Memory Leaks: Improper `kobject` teardown caused memory leaks
  when initialization failed or when nodes were removed.
- Lack of Dynamic Updates: Sysfs attributes were created only during
  initialization, preventing nodes added at runtime from being recognized.
- Handling of Unusable Nodes: Sysfs entries were generated for all
  possible nodes (`N_POSSIBLE`), including memoryless or unavailable nodes,
  leading to sysfs entries for unusable nodes and potential
  misconfigurations.

### Patch Overview

1. [PATCH 1/3] mm/mempolicy: fix memory leaks in weighted interleave sysfs
   - Ensures proper cleanup of `kobject` allocations.
   - Adds `kobject_del()` before `kobject_put()` to clean up sysfs
     state correctly.
   - Prevents memory/resource leaks and improves teardown behavior.

2. [PATCH 2/3] mm/mempolicy: prepare weighted interleave sysfs for memory hotplug
   - Refactors static sysfs layout into a new `sysfs_wi_group` structure.
   - Makes per-node sysfs attributes accessible to external modules.
   - Lays groundwork for future hotplug support by enabling runtime
     modification.

3. [PATCH 3/3] mm/mempolicy: support memory hotplug in weighted interleave
   - Dynamically adds/removes sysfs entries when nodes are
     online/offline.
   - Limits sysfs creation to nodes with memory, avoiding unusable
     node entries.
   - Hooks into memory hotplug notifier for runtime updates.

These patches have been tested under CXL-based memory configurations,
including hotplug scenarios, to ensure proper behavior and stability.


This patch (of 7):

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

Link: https://lkml.kernel.org/r/20250408073243.488-1-rakie.kim@sk.com
Link: https://lkml.kernel.org/r/20250408073243.488-2-rakie.kim@sk.com
Fixes: dce41f5ae253 ("mm/mempolicy: implement the sysfs-based weighted_interleave interface")
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

 mm/mempolicy.c |   66 ++++++++++++++++++++++-------------------------
 1 file changed, 32 insertions(+), 34 deletions(-)

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
@@ -3525,27 +3527,37 @@ static int add_weighted_interleave_group
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
+			goto err_del_kobj;
 		}
 	}
-	if (err)
-		kobject_put(wi_kobj);
+
 	return 0;
+
+err_del_kobj:
+	kobject_del(wi_kobj);
+err_put_kobj:
+	kobject_put(wi_kobj);
+	return err;
 }
 
 static void mempolicy_kobj_release(struct kobject *kobj)
@@ -3559,7 +3571,6 @@ static void mempolicy_kobj_release(struc
 	mutex_unlock(&iw_table_lock);
 	synchronize_rcu();
 	kfree(old);
-	kfree(node_attrs);
 	kfree(kobj);
 }
 
@@ -3573,37 +3584,24 @@ static int __init mempolicy_sysfs_init(v
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

