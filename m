Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FDE4137A7;
	Tue,  4 Aug 2026 04:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816351; cv=none; b=kZ/Li1nZjNoucMmelbQC6CiC8l68g05AdlInW74yc8vWLOJ8uM7DTj5e4gMbA8cEC981AyoAK4iplToV62GyLeCDSeileXFGvb9upr7pIHgjBAQNGAzj7Fht3Cck8abNQnAZVr5aCvgqA/1HXMY5Gi6mpaNr8Luh6U7U2a8Ffl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816351; c=relaxed/simple;
	bh=+8PIpmynxnNrjajuKujdV+AaekDrwt7Tg3CalCfRpvU=;
	h=Date:To:From:Subject:Message-Id; b=J4NGm8HUn6XpN3G2HV4tV8ju81jMB4oFJ2bBMb1ODcBeYJPfueueEx5WFQSNZ9It/cFFVvbp1t0//GdC6aaO2x88mDqvv9Yzqw+6zBxCbo+VtlxP+mhlJzsmjApi6HXgi/DItRCaSNv8YLrDB6pQWujtHsIJgmPVblcXG0cq3p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eAbJe9Bk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eAbJe9Bk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5771F00A3A;
	Tue,  4 Aug 2026 04:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816349;
	bh=MOV+eHUSuUpF7TP+VqowpZ7olrJSfO69QqIhLi9gTF0=;
	h=Date:To:From:Subject;
	b=eAbJe9BkjVSEsiUKryL3YusWHdTWwG7UD8KMKgw7xVd5vEMb84W0Y4WgTFX/PDSp6
	 D6yCUjrDE132OYGizy+4EMb+ksXNPpz6m82wo3+BuOjjR7BpZWpxYTiz6A/rg1dQiN
	 3IlSqOIJoEQn4M47Sapat/NWrd4BIqOUKVLLG+Jo=
Date: Mon, 03 Aug 2026 21:05:49 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,joseph.qi@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-cluster-dont-sleep-while-holding-o2hb_live_lock-in-o2hb_region_pin.patch removed from -mm tree
Message-Id: <20260804040549.CC5771F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: cluster: don't sleep while holding o2hb_live_lock in o2hb_region_pin()
has been removed from the -mm tree.  Its filename was
     ocfs2-cluster-dont-sleep-while-holding-o2hb_live_lock-in-o2hb_region_pin.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: ocfs2: cluster: don't sleep while holding o2hb_live_lock in o2hb_region_pin()
Date: Wed, 22 Jul 2026 20:49:31 +0800

Patch series "ocfs2: cluster: o2hb_region_pin() fixes", v2.

This series fixes three related issues in o2hb_region_pin(), all are from
the original implementation in commit: 58a3158a5d17 ("ocfs2/cluster:
Pin/unpin o2hb regions"):

1) It is called with o2hb_live_lock (a spinlock) held, but the
   underlying configfs_depend_item() sleeps (takes inode rwsem and
   pins the filesystem).  This triggers BUG under
   CONFIG_DEBUG_ATOMIC_SLEEP.

2) When called from the configfs drop_item callback, it creates a
   lock order inversion: parent inode_lock -> configfs root
   inode_lock, which can deadlock against subsystem unregistration
   paths taking root -> parent.

3) If pinning fails partway through o2hb_region_inc_user(), the
   o2hb_dependent_users counter is leaked and partially-pinned
   regions are never released, leaving heartbeat regions
   unprotected on subsequent mounts.

Patch 1 reworks o2hb_region_pin() to drop o2hb_live_lock across each
sleeping configfs_depend_item() call, using a config_item reference to
keep the region alive while unlocked.

Patch 2 adds a from_callback parameter to select
configfs_depend_item_unlocked() when called from configfs context,
avoiding the inode_lock nesting.

Patch 3 fixes the error path in o2hb_region_inc_user() to unpin and
decrement the counter on failure.


This patch (of 3):

o2hb_region_pin() is always called with the o2hb_live_lock spinlock held
(from o2hb_region_inc_user() and o2hb_heartbeat_group_drop_item()), but it
calls o2nm_depend_item() -> configfs_depend_item(), which sleeps: it pins
the configfs filesystem and takes the configfs root inode rwsem.  Under
CONFIG_DEBUG_ATOMIC_SLEEP this triggers:

  BUG: sleeping function called from invalid context at kernel/locking/rwsem.c
  in_atomic(): 1, ... name: mount.ocfs2
    down_write
    configfs_depend_item
    o2hb_region_pin
    o2hb_region_inc_user
    o2hb_register_callback
    dlm_register_domain_handlers
    ...
    ocfs2_dlm_init
    ocfs2_mount_volume
    ocfs2_fill_super

Rework o2hb_region_pin() to pin one region at a time with the lock dropped
across the sleeping call: under o2hb_live_lock find the next eligible
region and take a config_item reference to keep it alive, drop the lock,
call o2nm_depend_item(), then retake the lock and record the pin.  The
config_item_put() is done with the lock released as well, since
o2hb_region_release() also acquires o2hb_live_lock and can sleep.  The
region list may change while unlocked, so the scan restarts from the top
after each pin.  Local heartbeat still pins only the matching region;
global heartbeat pins all eligible regions.

The unpin path is unaffected: configfs_undepend_item() only takes a
spinlock and does not sleep.

Link: https://lore.kernel.org/20260722124933.430554-1-joseph.qi@linux.alibaba.com
Link: https://lore.kernel.org/20260722124933.430554-2-joseph.qi@linux.alibaba.com
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

 fs/ocfs2/cluster/heartbeat.c |  126 ++++++++++++++++++++++++++-------
 1 file changed, 101 insertions(+), 25 deletions(-)

--- a/fs/ocfs2/cluster/heartbeat.c~ocfs2-cluster-dont-sleep-while-holding-o2hb_live_lock-in-o2hb_region_pin
+++ a/fs/ocfs2/cluster/heartbeat.c
@@ -43,6 +43,14 @@ static DECLARE_RWSEM(o2hb_callback_sem);
  * whenever any of the threads sees activity from the node in its region.
  */
 static DEFINE_SPINLOCK(o2hb_live_lock);
+/*
+ * Serializes region pin/unpin dependency management (o2hb_dependent_users
+ * and the o2nm_depend_item()/o2nm_undepend_item() calls). o2hb_region_pin()
+ * has to drop o2hb_live_lock across the sleeping o2nm_depend_item(), so the
+ * spinlock alone can no longer keep pin and unpin mutually exclusive; this
+ * mutex, taken outside o2hb_live_lock, does.
+ */
+static DEFINE_MUTEX(o2hb_dependency_mutex);
 static struct list_head o2hb_live_slots[O2NM_MAX_NODES];
 static unsigned long o2hb_live_node_bitmap[BITS_TO_LONGS(O2NM_MAX_NODES)];
 static LIST_HEAD(o2hb_node_events);
@@ -2172,6 +2180,7 @@ static void o2hb_heartbeat_group_drop_it
 	 * If global heartbeat active and there are dependent users,
 	 * pin all regions if quorum region count <= CUT_OFF
 	 */
+	mutex_lock(&o2hb_dependency_mutex);
 	spin_lock(&o2hb_live_lock);
 
 	if (!o2hb_dependent_users)
@@ -2183,6 +2192,7 @@ static void o2hb_heartbeat_group_drop_it
 
 unlock:
 	spin_unlock(&o2hb_live_lock);
+	mutex_unlock(&o2hb_dependency_mutex);
 }
 
 static ssize_t o2hb_heartbeat_group_dead_threshold_show(struct config_item *item,
@@ -2322,46 +2332,108 @@ EXPORT_SYMBOL_GPL(o2hb_setup_callback);
  */
 static int o2hb_region_pin(const char *region_uuid)
 {
-	int ret = 0, found = 0;
-	struct o2hb_region *reg;
+	int ret = 0, found;
+	struct o2hb_region *reg, *pinned;
 	char *uuid;
 
 	assert_spin_locked(&o2hb_live_lock);
 
-	list_for_each_entry(reg, &o2hb_all_regions, hr_all_item) {
-		if (reg->hr_item_dropped)
-			continue;
+	do {
+		found = 0;
+		pinned = NULL;
 
-		uuid = config_item_name(&reg->hr_item);
+		list_for_each_entry(reg, &o2hb_all_regions, hr_all_item) {
+			if (reg->hr_item_dropped)
+				continue;
 
-		/* local heartbeat */
-		if (region_uuid) {
-			if (strcmp(region_uuid, uuid))
+			uuid = config_item_name(&reg->hr_item);
+
+			/* local heartbeat */
+			if (region_uuid) {
+				if (strcmp(region_uuid, uuid))
+					continue;
+				found = 1;
+			}
+
+			if (reg->hr_item_pinned || reg->hr_item_dropped) {
+				if (found)
+					break;
 				continue;
-			found = 1;
+			}
+
+			/*
+			 * Found a region that needs pinning. Take a reference
+			 * so it stays alive while we drop the lock below.
+			 */
+			pinned = reg;
+			config_item_get(&reg->hr_item);
+			break;
 		}
 
-		if (reg->hr_item_pinned || reg->hr_item_dropped)
-			goto skip_pin;
+		if (!pinned)
+			break;
+
+		uuid = config_item_name(&pinned->hr_item);
+
+		/*
+		 * o2nm_depend_item() -> configfs_depend_item() can sleep (it
+		 * takes the configfs root inode rwsem), so it must not run
+		 * under o2hb_live_lock. Drop the lock across it; @pinned is
+		 * kept alive by the reference taken above. The region list may
+		 * change while unlocked, so we rescan from the top afterwards.
+		 */
+		spin_unlock(&o2hb_live_lock);
 
 		/* Ignore ENOENT only for local hb (userdlm domain) */
-		ret = o2nm_depend_item(&reg->hr_item);
+		ret = o2nm_depend_item(&pinned->hr_item);
+
+		spin_lock(&o2hb_live_lock);
 		if (!ret) {
-			mlog(ML_CLUSTER, "Pin region %s\n", uuid);
-			reg->hr_item_pinned = 1;
-		} else {
-			if (ret == -ENOENT && found)
-				ret = 0;
-			else {
-				mlog(ML_ERROR, "Pin region %s fails with %d\n",
-				     uuid, ret);
+			/*
+			 * o2hb_live_lock was dropped across o2nm_depend_item().
+			 * o2hb_set_quorum_device() runs in the heartbeat thread
+			 * without o2hb_dependency_mutex, so for global heartbeat
+			 * it may have crossed O2HB_PIN_CUT_OFF and unpinned the
+			 * regions while we slept. If that happened this pin is
+			 * no longer wanted; undo it and stop rather than
+			 * resurrecting it on the rescan below.
+			 */
+			if (!region_uuid &&
+			    bitmap_weight(o2hb_quorum_region_bitmap,
+					  O2NM_MAX_REGIONS) > O2HB_PIN_CUT_OFF) {
+				o2nm_undepend_item(&pinned->hr_item);
+				spin_unlock(&o2hb_live_lock);
+				config_item_put(&pinned->hr_item);
+				spin_lock(&o2hb_live_lock);
 				break;
 			}
+			mlog(ML_CLUSTER, "Pin region %s\n", uuid);
+			pinned->hr_item_pinned = 1;
+		} else if (ret == -ENOENT && (found || !region_uuid)) {
+			/*
+			 * For local hb (found): ignore ENOENT from userdlm
+			 * domains as before.  For global hb (!region_uuid):
+			 * the region may have been detached from configfs
+			 * while the lock was dropped — skip it and continue
+			 * pinning the remaining regions.
+			 */
+			ret = 0;
+		} else {
+			mlog(ML_ERROR, "Pin region %s fails with %d\n",
+			     uuid, ret);
 		}
-skip_pin:
-		if (found)
-			break;
-	}
+
+		/*
+		 * config_item_put() may drop the last reference and run
+		 * o2hb_region_release(), which also grabs o2hb_live_lock and
+		 * can sleep, so it must happen with the lock released.
+		 */
+		spin_unlock(&o2hb_live_lock);
+		config_item_put(&pinned->hr_item);
+		spin_lock(&o2hb_live_lock);
+
+		/* local hb pins a single matching region */
+	} while (!ret && !region_uuid);
 
 	return ret;
 }
@@ -2406,6 +2478,7 @@ static int o2hb_region_inc_user(const ch
 {
 	int ret = 0;
 
+	mutex_lock(&o2hb_dependency_mutex);
 	spin_lock(&o2hb_live_lock);
 
 	/* local heartbeat */
@@ -2428,11 +2501,13 @@ static int o2hb_region_inc_user(const ch
 
 unlock:
 	spin_unlock(&o2hb_live_lock);
+	mutex_unlock(&o2hb_dependency_mutex);
 	return ret;
 }
 
 static void o2hb_region_dec_user(const char *region_uuid)
 {
+	mutex_lock(&o2hb_dependency_mutex);
 	spin_lock(&o2hb_live_lock);
 
 	/* local heartbeat */
@@ -2451,6 +2526,7 @@ static void o2hb_region_dec_user(const c
 
 unlock:
 	spin_unlock(&o2hb_live_lock);
+	mutex_unlock(&o2hb_dependency_mutex);
 }
 
 int o2hb_register_callback(const char *region_uuid,
_

Patches currently in -mm which might be from joseph.qi@linux.alibaba.com are


