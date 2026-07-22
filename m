Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3E6466B08;
	Wed, 22 Jul 2026 23:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784763843; cv=none; b=UiConh6y/x0HzUuIv3K6ny1XsHukpRizEkSXvSj7Mqka0ppDI28fQKuJzG4kI2sSUINLAuH+467E8ZZMC2qN3j55JL5ORIqKwGPB5czok5H2vTFnQ5A9D9zkw61FPuT7QUKPwQ18uZHeovkghl5zsncDXRp/A2QfkkaL6A+qLiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784763843; c=relaxed/simple;
	bh=zyxd3NKGGPPOjHA9wLElyMq3tYluKDK+8E9/hiapxac=;
	h=Date:To:From:Subject:Message-Id; b=DjYAgvsOzOC6uPClOE/tbkxFVEM6qecsDSuZOLB1y/CQud1lEh3gYjkyekhX8IUyjlJ7L70k9ZFFT+UeM6iNOZHZd/y5PGZohPAzQdvkYFP1RC6H7Q/cNK4HS4vIhbB3Ac+49JEXnY+AmucEDViuqEzYWOFHVkzh/PmNzsZ3yLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xkCuBZrS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xkCuBZrS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2EDB1F000E9;
	Wed, 22 Jul 2026 23:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784763842;
	bh=Inoyd87RM9KUCqEygWEU4/ow7Mwm3QueyrfSMAKe4ig=;
	h=Date:To:From:Subject;
	b=xkCuBZrSbUEvomBQkz7LU0wAshKE05ctq4mQlhdyafhVADa153OkHHG1cq2/jGdJY
	 9DZVwH92Mn3FRogsvQdxkfBAj8P2jtlp+t+1xItOhU0RbPsP9xA+QyG2AwjXgiMyxg
	 uXktTbbGv/EvSEgRbOlKnxGtHLgkIQHv6Si2QBpQ=
Date: Wed, 22 Jul 2026 16:44:01 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-cluster-avoid-lock-order-inversion-in-o2hb_region_pin-from-drop_item.patch added to mm-nonmm-unstable branch
Message-Id: <20260722234401.E2EDB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: cluster: avoid lock order inversion in o2hb_region_pin() from drop_item
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-cluster-avoid-lock-order-inversion-in-o2hb_region_pin-from-drop_item.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-cluster-avoid-lock-order-inversion-in-o2hb_region_pin-from-drop_item.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: cluster: avoid lock order inversion in o2hb_region_pin() from drop_item
Date: Wed, 22 Jul 2026 20:49:32 +0800

o2hb_heartbeat_group_drop_item() is called from configfs rmdir with the
parent directory's inode_lock held.  It calls o2hb_region_pin() ->
o2nm_depend_item() -> configfs_depend_item(), which acquires the configfs
root inode_lock.  This creates a parent -> root inode_lock nesting that
could deadlock against paths taking root -> parent (e.g.  subsystem
unregistration).

Fix this by using configfs_depend_item_unlocked() when o2hb_region_pin()
is called from a configfs callback context.  This variant skips the root
inode_lock when caller and target are in the same subsystem, which is safe
because VFS already holds a lock preventing unregistration.

Add o2nm_depend_item_unlocked() wrapper and a from_callback parameter to
o2hb_region_pin() to select the appropriate variant.

Link: https://lore.kernel.org/20260722124933.430554-3-joseph.qi@linux.alibaba.com
Fixes: 58a3158a5d17 ("ocfs2/cluster: Pin/unpin o2hb regions")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/cluster/heartbeat.c   |   17 ++++++++++-------
 fs/ocfs2/cluster/nodemanager.c |    6 ++++++
 fs/ocfs2/cluster/nodemanager.h |    1 +
 3 files changed, 17 insertions(+), 7 deletions(-)

--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-cluster-avoid-lock-order-inversion-in-o2hb_region_pin-from-drop_item
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -146,7 +146,7 @@ static unsigned int o2hb_dependent_users
  * In global heartbeat mode, we pin/unpin all o2hb regions. This solution
  * works for both file system and userdlm domains.
  */
-static int o2hb_region_pin(const char *region_uuid);
+static int o2hb_region_pin(const char *region_uuid, bool from_callback);
 static void o2hb_region_unpin(const char *region_uuid);
 
 /* Only sets a new threshold if there are no active regions.
@@ -2188,7 +2188,7 @@ static void o2hb_heartbeat_group_drop_it
 
 	if (bitmap_weight(o2hb_quorum_region_bitmap,
 			   O2NM_MAX_REGIONS) <= O2HB_PIN_CUT_OFF)
-		o2hb_region_pin(NULL);
+		o2hb_region_pin(NULL, true);
 
 unlock:
 	spin_unlock(&o2hb_live_lock);
@@ -2330,7 +2330,7 @@ EXPORT_SYMBOL_GPL(o2hb_setup_callback);
  * In local, we only pin the matching region. In global we pin all the active
  * regions.
  */
-static int o2hb_region_pin(const char *region_uuid)
+static int o2hb_region_pin(const char *region_uuid, bool from_callback)
 {
 	int ret = 0, found;
 	struct o2hb_region *reg, *pinned;
@@ -2385,7 +2385,10 @@ static int o2hb_region_pin(const char *r
 		spin_unlock(&o2hb_live_lock);
 
 		/* Ignore ENOENT only for local hb (userdlm domain) */
-		ret = o2nm_depend_item(&pinned->hr_item);
+		if (from_callback)
+			ret = o2nm_depend_item_unlocked(&pinned->hr_item);
+		else
+			ret = o2nm_depend_item(&pinned->hr_item);
 
 		spin_lock(&o2hb_live_lock);
 		if (!ret) {
@@ -2483,8 +2486,8 @@ static int o2hb_region_inc_user(const ch
 
 	/* local heartbeat */
 	if (!o2hb_global_heartbeat_active()) {
-	    ret = o2hb_region_pin(region_uuid);
-	    goto unlock;
+		ret = o2hb_region_pin(region_uuid, false);
+		goto unlock;
 	}
 
 	/*
@@ -2497,7 +2500,7 @@ static int o2hb_region_inc_user(const ch
 
 	if (bitmap_weight(o2hb_quorum_region_bitmap,
 			   O2NM_MAX_REGIONS) <= O2HB_PIN_CUT_OFF)
-		ret = o2hb_region_pin(NULL);
+		ret = o2hb_region_pin(NULL, false);
 
 unlock:
 	spin_unlock(&o2hb_live_lock);
--- a/fs/ocfs2/cluster/nodemanager.c~ocfs2-cluster-avoid-lock-order-inversion-in-o2hb_region_pin-from-drop_item
+++ a/fs/ocfs2/cluster/nodemanager.c
@@ -778,6 +778,12 @@ int o2nm_depend_item(struct config_item
 	return configfs_depend_item(&o2nm_cluster_group.cs_subsys, item);
 }
 
+int o2nm_depend_item_unlocked(struct config_item *item)
+{
+	return configfs_depend_item_unlocked(&o2nm_cluster_group.cs_subsys,
+					     item);
+}
+
 void o2nm_undepend_item(struct config_item *item)
 {
 	configfs_undepend_item(item);
--- a/fs/ocfs2/cluster/nodemanager.h~ocfs2-cluster-avoid-lock-order-inversion-in-o2hb_region_pin-from-drop_item
+++ a/fs/ocfs2/cluster/nodemanager.h
@@ -64,6 +64,7 @@ void o2nm_node_get(struct o2nm_node *nod
 void o2nm_node_put(struct o2nm_node *node);
 
 int o2nm_depend_item(struct config_item *item);
+int o2nm_depend_item_unlocked(struct config_item *item);
 void o2nm_undepend_item(struct config_item *item);
 int o2nm_depend_node(u8 node_num);
 void o2nm_undepend_node(u8 node_num);
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are

ocfs2-cluster-use-gfp_nofs-for-heartbeat-bio-allocation.patch
ocfs2-cluster-use-an-on-stack-bio-for-the-heartbeat-write.patch
ocfs2-cluster-dont-sleep-while-holding-o2hb_live_lock-in-o2hb_region_pin.patch
ocfs2-cluster-avoid-lock-order-inversion-in-o2hb_region_pin-from-drop_item.patch
ocfs2-cluster-fix-o2hb_dependent_users-leak-on-pin-failure.patch

