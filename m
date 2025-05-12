Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FAB224FA
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 03:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747020354; cv=none; b=NMBc67QTrGNjLqnz3Z7qudkMV2AmlbG+8gr0PtzHnnwCbTEKJAXc+Jo3qulT468shKpAsuCzufIuGi8bFDzTgKCJFLsNuDz+KTZL8je05hAcRyzwdDGlC74DIwh9e8IKJWv9GP8oGf50KAUwol7ojGN/h4GPaDGQ4kkIb5LY8Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747020354; c=relaxed/simple;
	bh=fPXSxRm9BpnD7FcaJT4PNpO89wz+L0lfqPukjYTur2M=;
	h=Date:To:From:Subject:Message-Id; b=OgK4ej/DI/XiTLYbMRdWG+a1LbEec1DDqmiIbiI7bz1R+5clhxD4eRV7+BW9zDM7pCT5cEESyJowXhso8LW953Sf9AyZqJ/18DoohVuLJy3jf7xlnnjcziWBdjpx4RFSZ8/I2gqAiI5GLfDru6ROeMhBDetQfoXnAuEhNgYAsTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Crvqm+yi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Crvqm+yi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F388AC4CEE4;
	Mon, 12 May 2025 03:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747020354;
	bh=fPXSxRm9BpnD7FcaJT4PNpO89wz+L0lfqPukjYTur2M=;
	h=Date:To:From:Subject:From;
	b=Crvqm+yi2lKgGLiiuxpxzxGbg3jgw/mQao8BMPSPJo+2T1gZ6inVtCpsUvbvt/qvX
	 Q23vgY8Dajq7iW77iqz39SWpAl5agbk36BZxHg23sd+yuQymAj7jlrm3pZOgs8cV/M
	 STJBeMwMslBDNbwQaTsr+Eg+4FA98Ihsz1NuxCVo=
Date: Sun, 11 May 2025 20:25:53 -0700
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,ying.huang@linux.alibaba.com,osalvador@suse.de,lenb@kernel.org,Jonathan.Cameron@huawei.com,honggyu.kim@sk.com,harry.yoo@oracle.com,hannes@cmpxchg.org,gregkh@linuxfoundation.org,gourry@gourry.net,dave.jiang@intel.com,dan.j.williams@intel.com,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-weighted-interleave-auto-tuning-fix.patch added to mm-unstable branch
Message-Id: <20250512032553.F388AC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-mempolicy-weighted-interleave-auto-tuning-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-weighted-interleave-auto-tuning-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-weighted-interleave-auto-tuning-fix.patch

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
mm-mempolicy-weighted-interleave-auto-tuning-fix.patch

