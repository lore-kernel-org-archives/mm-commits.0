Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AEAC33F7
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 06:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747118744; cv=none; b=JDr0WUQlto6e1a4vxorTOuDboWT7c+1x4PTEWvVyNeCQ/R3/ppHUAzFm3dkvn4SZ/UKVV87EmGMNi7md0WtJ7x8944wS0TdkfWsxqER64kHQpZIgmSrK3UrtjwPKfcGGjMGbvMcC+QB3CTXeYdYlNrh72tPjUGPyoYETmW1n8vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747118744; c=relaxed/simple;
	bh=Y6tBBxdu5SeB8bbZSDH51sCZmWkb6m9QWkh8kuKn6qs=;
	h=Date:To:From:Subject:Message-Id; b=j3VUoGoBmcfsupFiLJIRoRBwTsSa8ch3nc8mCzXzM3KxNioz2fwNNKQuknQMlvVl2HYAmTImRYPqOo5+mjAidX7eQNjrYqtgqJ3dZMnLQhHQqGjXhy1ZPxSl+NZpiJmfFH6cCPylOtNbjIoyrD5rtBhfDZtFK/kfxdYt30YZG/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qRIUFAhG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qRIUFAhG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DAC6C4CEE4;
	Tue, 13 May 2025 06:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747118742;
	bh=Y6tBBxdu5SeB8bbZSDH51sCZmWkb6m9QWkh8kuKn6qs=;
	h=Date:To:From:Subject:From;
	b=qRIUFAhG1SFOsz+tSTVmyrLzC5PIVpzsoVGC+dLWB9l9KNTSv1nnJ+eMR6g/mLOHz
	 CkhMMcyKkEzWOzkwA69XwM1td8M5ooNuSCaXKcX22v1BF7mElrSMLxcMzYFaZO8n3l
	 Af+xaKLrz83ujkQAA1JJldCs/ZS6sMD0Vs/wkyng=
Date: Mon, 12 May 2025 23:45:41 -0700
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,ying.huang@linux.alibaba.com,osalvador@suse.de,lenb@kernel.org,Jonathan.Cameron@huawei.com,honggyu.kim@sk.com,harry.yoo@oracle.com,hannes@cmpxchg.org,gregkh@linuxfoundation.org,gourry@gourry.net,dave.jiang@intel.com,dan.j.williams@intel.com,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-mempolicy-weighted-interleave-auto-tuning-fix.patch removed from -mm tree
Message-Id: <20250513064542.4DAC6C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-mempolicy-weighted-interleave-auto-tuning-fix
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-weighted-interleave-auto-tuning-fix.patch

This patch was dropped because it was folded into mm-mempolicy-weighted-interleave-auto-tuning.patch

------------------------------------------------------
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: mm-mempolicy-weighted-interleave-auto-tuning-fix
Date: Sat, 10 May 2025 19:58:39 -0700

Some wordsmithing changes, some code simplification/cleanups, and make
sure that the code behavior matches that of the ABI I described.

Link: https://lkml.kernel.org/r/20250511025840.2410154-1-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Honggyu Kim <honggyu.kim@sk.com>
Tested-by: Honggyu Kim <honggyu.kim@sk.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Yunjeong Mun <yunjeong.mun@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave |    2 
 include/linux/mempolicy.h                                               |    9 --
 mm/mempolicy.c                                                          |   35 ++++++----
 3 files changed, 25 insertions(+), 21 deletions(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave~mm-mempolicy-weighted-interleave-auto-tuning-fix
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave
@@ -24,7 +24,7 @@ Description:	Weight configuration interf
 		empty string, ...) will return -EINVAL.
 
 		Changing the weight to a valid value will automatically
-		update the system to manual mode as well.
+		switch the system to manual mode as well.
 
 What:		/sys/kernel/mm/mempolicy/weighted_interleave/auto
 Date:		May 2025
--- a/include/linux/mempolicy.h~mm-mempolicy-weighted-interleave-auto-tuning-fix
+++ a/include/linux/mempolicy.h
@@ -58,15 +58,6 @@ struct mempolicy {
 };
 
 /*
- * A null weighted_interleave_state is interpted as having .mode = "auto",
- * and .iw_table is interpreted as an array of 1s with length nr_node_ids.
- */
-struct weighted_interleave_state {
-	bool mode_auto;
-	u8 iw_table[];
-};
-
-/*
  * Support for managing mempolicy data objects (clone, copy, destroy)
  * The default fast path of a NULL MPOL_DEFAULT policy is always inlined.
  */
--- a/mm/mempolicy.c~mm-mempolicy-weighted-interleave-auto-tuning-fix
+++ a/mm/mempolicy.c
@@ -148,6 +148,14 @@ static struct mempolicy preferred_node_p
  */
 static const int weightiness = 32;
 
+/*
+ * A null weighted_interleave_state is interpreted as having .mode="auto",
+ * and .iw_table is interpreted as an array of 1s with length nr_node_ids.
+ */
+struct weighted_interleave_state {
+	bool mode_auto;
+	u8 iw_table[];
+};
 static struct weighted_interleave_state __rcu *wi_state;
 static unsigned int *node_bw_table;
 
@@ -3561,9 +3569,8 @@ static ssize_t node_store(struct kobject
 	int i;
 
 	node_attr = container_of(attr, struct iw_node_attr, kobj_attr);
-	if (count == 0 || sysfs_streq(buf, ""))
-		weight = 0;
-	else if (kstrtou8(buf, 0, &weight) || weight == 0)
+	if (count == 0 || sysfs_streq(buf, "") ||
+	    kstrtou8(buf, 0, &weight) || weight == 0)
 		return -EINVAL;
 
 	new_wi_state = kzalloc(struct_size(new_wi_state, iw_table, nr_node_ids),
@@ -3630,9 +3637,15 @@ static ssize_t weighted_interleave_auto_
 	if (!input) {
 		old_wi_state = rcu_dereference_protected(wi_state,
 					lockdep_is_held(&wi_state_lock));
-		if (old_wi_state)
-			memcpy(new_wi_state->iw_table, old_wi_state->iw_table,
-					nr_node_ids * sizeof(u8));
+		if (!old_wi_state)
+			goto update_wi_state;
+		if (input == old_wi_state->mode_auto) {
+			mutex_unlock(&wi_state_lock);
+			return count;
+		}
+
+		memcpy(new_wi_state->iw_table, old_wi_state->iw_table,
+					       nr_node_ids * sizeof(u8));
 		goto update_wi_state;
 	}
 
@@ -3707,8 +3720,12 @@ out:
 	kfree(&wi_group->wi_kobj);
 }
 
+static struct kobj_attribute wi_auto_attr =
+	__ATTR(auto, 0664, weighted_interleave_auto_show,
+			   weighted_interleave_auto_store);
+
 static void wi_cleanup(void) {
-	sysfs_remove_file(&wi_group->wi_kobj, &wi_group->auto_kobj_attr.attr);
+	sysfs_remove_file(&wi_group->wi_kobj, &wi_auto_attr.attr);
 	sysfs_wi_node_delete_all();
 	wi_state_free();
 }
@@ -3798,10 +3815,6 @@ static int wi_node_notifier(struct notif
 	return NOTIFY_OK;
 }
 
-static struct kobj_attribute wi_auto_attr =
-	__ATTR(auto, 0664, weighted_interleave_auto_show,
-			   weighted_interleave_auto_store);
-
 static int __init add_weighted_interleave_group(struct kobject *mempolicy_kobj)
 {
 	int nid, err;
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are

mm-mempolicy-weighted-interleave-auto-tuning.patch
mm-mempolicy-weighted-interleave-auto-tuning-fix-2.patch

