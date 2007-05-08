From: akpm@linux-foundation.org
Subject: + md-allow-reshape_position-for-md-arrays-to-be-set-via-sysfs.patch added to -mm tree
Date: Tue, 08 May 2007 16:09:13 -0700
Message-ID: <200705082309.l48N9DRv004353@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969455AbXEHXJS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 19:09:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: allow reshape_position for md arrays to be set via sysfs
has been added to the -mm tree.  Its filename is
     md-allow-reshape_position-for-md-arrays-to-be-set-via-sysfs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: allow reshape_position for md arrays to be set via sysfs
From: NeilBrown <neilb@suse.de>

"reshape_position" records how much progress has been made on a "reshape"
(adding drives, changing layout or chunksize).

When it is set, the number of drives, layout and chunksize can have
two possible values, an old an a new.

So allow these different values to be visible, and allow both old and new to
be set: Set the old ones first, then the reshape_position, then the new
values.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/md.txt |   72 +++++++++++++++++++++++++----------------
 drivers/md/md.c      |   70 +++++++++++++++++++++++++++++++++++----
 2 files changed, 107 insertions(+), 35 deletions(-)

diff -puN Documentation/md.txt~md-allow-reshape_position-for-md-arrays-to-be-set-via-sysfs Documentation/md.txt
--- a/Documentation/md.txt~md-allow-reshape_position-for-md-arrays-to-be-set-via-sysfs
+++ a/Documentation/md.txt
@@ -178,6 +178,21 @@ All md devices contain:
      The size should be at least PAGE_SIZE (4k) and should be a power
      of 2.  This can only be set while assembling an array
 
+  layout
+     The "layout" for the array for the particular level.  This is
+     simply a number that is interpretted differently by different
+     levels.  It can be written while assembling an array.
+
+  reshape_position
+     This is either "none" or a sector number within the devices of
+     the array where "reshape" is up to.  If this is set, the three
+     attributes mentioned above (raid_disks, chunk_size, layout) can
+     potentially have 2 values, an old and a new value.  If these
+     values differ, reading the attribute returns
+        new (old)
+     and writing will effect the 'new' value, leaving the 'old'
+     unchanged.
+
   component_size
      For arrays with data redundancy (i.e. not raid0, linear, faulty,
      multipath), all components must be the same size - or at least
@@ -193,11 +208,6 @@ All md devices contain:
      1.2 (newer format in varying locations) or "none" indicating that
      the kernel isn't managing metadata at all.
 
-  layout
-     The "layout" for the array for the particular level.  This is
-     simply a number that is interpretted differently by different
-     levels.  It can be written while assembling an array.
-
   resync_start
      The point at which resync should start.  If no resync is needed,
      this will be a very large number.  At array creation it will
@@ -259,29 +269,6 @@ All md devices contain:
          like active, but no writes have been seen for a while (safe_mode_delay).
 
 
-   sync_speed_min
-   sync_speed_max
-     This are similar to /proc/sys/dev/raid/speed_limit_{min,max}
-     however they only apply to the particular array.
-     If no value has been written to these, of if the word 'system'
-     is written, then the system-wide value is used.  If a value,
-     in kibibytes-per-second is written, then it is used.
-     When the files are read, they show the currently active value
-     followed by "(local)" or "(system)" depending on whether it is
-     a locally set or system-wide value.
-
-   sync_completed
-     This shows the number of sectors that have been completed of
-     whatever the current sync_action is, followed by the number of
-     sectors in total that could need to be processed.  The two
-     numbers are separated by a '/'  thus effectively showing one
-     value, a fraction of the process that is complete.
-
-   sync_speed
-     This shows the current actual speed, in K/sec, of the current
-     sync_action.  It is averaged over the last 30 seconds.
-
-
 As component devices are added to an md array, they appear in the 'md'
 directory as new directories named
       dev-XXX
@@ -412,6 +399,35 @@ also have
       Note that the numbers are 'bit' numbers, not 'block' numbers.
       They should be scaled by the bitmap_chunksize.
 
+   sync_speed_min
+   sync_speed_max
+     This are similar to /proc/sys/dev/raid/speed_limit_{min,max}
+     however they only apply to the particular array.
+     If no value has been written to these, of if the word 'system'
+     is written, then the system-wide value is used.  If a value,
+     in kibibytes-per-second is written, then it is used.
+     When the files are read, they show the currently active value
+     followed by "(local)" or "(system)" depending on whether it is
+     a locally set or system-wide value.
+
+   sync_completed
+     This shows the number of sectors that have been completed of
+     whatever the current sync_action is, followed by the number of
+     sectors in total that could need to be processed.  The two
+     numbers are separated by a '/'  thus effectively showing one
+     value, a fraction of the process that is complete.
+
+   sync_speed
+     This shows the current actual speed, in K/sec, of the current
+     sync_action.  It is averaged over the last 30 seconds.
+
+   suspend_lo
+   suspend_hi
+     The two values, given as numbers of sectors, indicate a range
+     within the array where IO will be blocked.  This is currently
+     only supported for raid4/5/6.
+
+
 Each active md device may also have attributes specific to the
 personality module that manages it.
 These are specific to the implementation of the module and could
diff -puN drivers/md/md.c~md-allow-reshape_position-for-md-arrays-to-be-set-via-sysfs drivers/md/md.c
--- a/drivers/md/md.c~md-allow-reshape_position-for-md-arrays-to-be-set-via-sysfs
+++ a/drivers/md/md.c
@@ -274,6 +274,7 @@ static mddev_t * mddev_find(dev_t unit)
 	atomic_set(&new->active, 1);
 	spin_lock_init(&new->write_lock);
 	init_waitqueue_head(&new->sb_wait);
+	new->reshape_position = MaxSector;
 
 	new->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!new->queue) {
@@ -2242,6 +2243,10 @@ static ssize_t
 layout_show(mddev_t *mddev, char *page)
 {
 	/* just a number, not meaningful for all levels */
+	if (mddev->reshape_position != MaxSector &&
+	    mddev->layout != mddev->new_layout)
+		return sprintf(page, "%d (%d)\n",
+			       mddev->new_layout, mddev->layout);
 	return sprintf(page, "%d\n", mddev->layout);
 }
 
@@ -2250,13 +2255,16 @@ layout_store(mddev_t *mddev, const char 
 {
 	char *e;
 	unsigned long n = simple_strtoul(buf, &e, 10);
-	if (mddev->pers)
-		return -EBUSY;
 
 	if (!*buf || (*e && *e != '\n'))
 		return -EINVAL;
 
-	mddev->layout = n;
+	if (mddev->pers)
+		return -EBUSY;
+	if (mddev->reshape_position != MaxSector)
+		mddev->new_layout = n;
+	else
+		mddev->layout = n;
 	return len;
 }
 static struct md_sysfs_entry md_layout =
@@ -2268,6 +2276,10 @@ raid_disks_show(mddev_t *mddev, char *pa
 {
 	if (mddev->raid_disks == 0)
 		return 0;
+	if (mddev->reshape_position != MaxSector &&
+	    mddev->delta_disks != 0)
+		return sprintf(page, "%d (%d)\n", mddev->raid_disks,
+			       mddev->raid_disks - mddev->delta_disks);
 	return sprintf(page, "%d\n", mddev->raid_disks);
 }
 
@@ -2285,7 +2297,11 @@ raid_disks_store(mddev_t *mddev, const c
 
 	if (mddev->pers)
 		rv = update_raid_disks(mddev, n);
-	else
+	else if (mddev->reshape_position != MaxSector) {
+		int olddisks = mddev->raid_disks - mddev->delta_disks;
+		mddev->delta_disks = n - olddisks;
+		mddev->raid_disks = n;
+	} else
 		mddev->raid_disks = n;
 	return rv ? rv : len;
 }
@@ -2295,6 +2311,10 @@ __ATTR(raid_disks, S_IRUGO|S_IWUSR, raid
 static ssize_t
 chunk_size_show(mddev_t *mddev, char *page)
 {
+	if (mddev->reshape_position != MaxSector &&
+	    mddev->chunk_size != mddev->new_chunk)
+		return sprintf(page, "%d (%d)\n", mddev->new_chunk,
+			       mddev->chunk_size);
 	return sprintf(page, "%d\n", mddev->chunk_size);
 }
 
@@ -2305,12 +2325,15 @@ chunk_size_store(mddev_t *mddev, const c
 	char *e;
 	unsigned long n = simple_strtoul(buf, &e, 10);
 
-	if (mddev->pers)
-		return -EBUSY;
 	if (!*buf || (*e && *e != '\n'))
 		return -EINVAL;
 
-	mddev->chunk_size = n;
+	if (mddev->pers)
+		return -EBUSY;
+	else if (mddev->reshape_position != MaxSector)
+		mddev->new_chunk = n;
+	else
+		mddev->chunk_size = n;
 	return len;
 }
 static struct md_sysfs_entry md_chunk_size =
@@ -2896,6 +2919,37 @@ suspend_hi_store(mddev_t *mddev, const c
 static struct md_sysfs_entry md_suspend_hi =
 __ATTR(suspend_hi, S_IRUGO|S_IWUSR, suspend_hi_show, suspend_hi_store);
 
+static ssize_t
+reshape_position_show(mddev_t *mddev, char *page)
+{
+	if (mddev->reshape_position != MaxSector)
+		return sprintf(page, "%llu\n",
+			       (unsigned long long)mddev->reshape_position);
+	strcpy(page, "none\n");
+	return 5;
+}
+
+static ssize_t
+reshape_position_store(mddev_t *mddev, const char *buf, size_t len)
+{
+	char *e;
+	unsigned long long new = simple_strtoull(buf, &e, 10);
+	if (mddev->pers)
+		return -EBUSY;
+	if (buf == e || (*e && *e != '\n'))
+		return -EINVAL;
+	mddev->reshape_position = new;
+	mddev->delta_disks = 0;
+	mddev->new_level = mddev->level;
+	mddev->new_layout = mddev->layout;
+	mddev->new_chunk = mddev->chunk_size;
+	return len;
+}
+
+static struct md_sysfs_entry md_reshape_position =
+__ATTR(reshape_position, S_IRUGO|S_IWUSR, reshape_position_show,
+       reshape_position_store);
+
 
 static struct attribute *md_default_attrs[] = {
 	&md_level.attr,
@@ -2908,6 +2962,7 @@ static struct attribute *md_default_attr
 	&md_new_device.attr,
 	&md_safe_delay.attr,
 	&md_array_state.attr,
+	&md_reshape_position.attr,
 	NULL,
 };
 
@@ -3446,6 +3501,7 @@ static int do_md_stop(mddev_t * mddev, i
 		mddev->size = 0;
 		mddev->raid_disks = 0;
 		mddev->recovery_cp = 0;
+		mddev->reshape_position = MaxSector;
 
 	} else if (mddev->pers)
 		printk(KERN_INFO "md: %s switched to read-only mode.\n",
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
git-md-accel.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
introduce-freezer-flags-rev-2.patch
the-nfsv2-nfsv3-server-does-not-handle-zero-length-write.patch
knfsd-rename-sk_defer_lock-to-sk_lock.patch
nfsd-nfs4state-remove-unnecessary-daemonize-call.patch
rpc-add-wrapper-for-svc_reserve-to-account-for-checksum.patch
rpc-add-wrapper-for-svc_reserve-to-account-for-checksum-fix.patch
sunrpc-fix-error-path-in-module_init.patch
knfsd-avoid-use-of-unitialised-variables-on-error-path-when-nfs-exports.patch
knfsd-rpc-fix-server-side-wrapping-of-krb5i-replies.patch
knfsd-fix-resource-leak-resulting-in-module-refcount-leak-for-rpcsec_gss_krb5ko.patch
knfsd-rpcgss-rpc_gss_proc_-destroy-request-will-get-a-bad-rpc.patch
knfsd-simplify-a-while-condition-in-svcsockc.patch
knfsd-trivial-makefile-cleanup.patch
knfsd-various-nfsd-xdr-cleanups.patch
knfsd-avoid-oops-if-buggy-userspace-performs-confusing-filehandle-dentry-mapping.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-cleanup-use-seq_release_private-where-appropriate.patch
md-move-test-for-whether-level-supports-bitmap-to-correct-place.patch
md-stop-using-csum_partial-for-checksum-calculation-in-md.patch
md-remove-the-slash-from-the-name-of-a-kmem_cache-used-by-raid5.patch
md-allow-reshape_position-for-md-arrays-to-be-set-via-sysfs.patch
md-improve-partition-detection-in-md-array.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
