From: akpm@linux-foundation.org
Subject: - md-support-external-metadata-for-md-arrays.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:29:47 -0800
Message-ID: <200802070029.m170TSIL007276@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38516 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764484AbYBGAne (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:43:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: support 'external' metadata for md arrays
has been removed from the -mm tree.  Its filename was
     md-support-external-metadata-for-md-arrays.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: support 'external' metadata for md arrays
From: NeilBrown <neilb@suse.de>

- Add a state flag 'external' to indicate that the metadata is managed
  externally (by user-space) so important changes need to be
  left of user-space to handle.
  Alternates are non-persistant ('none') where there is no stable metadata -
  after the  array is stopped there is no record of it's status - and
  internal which can be version 0.90 or version 1.x
  These are selected by writing to the 'metadata' attribute.

- move the updating of superblocks (sync_sbs) to after we have checked if
  there are any superblocks or not.

- New array state 'write_pending'.  This means that the metadata records
  the array as 'clean', but a write has been requested, so the metadata has
  to be updated to record a 'dirty' array before the write can continue.
  This change is reported to md by writing 'active' to the array_state
  attribute.

- tidy up marking of sb_dirty:
   - don't set sb_dirty when resync finishes as md_check_recovery
     calls md_update_sb when the sync thread finishes anyway.
   - Don't set sb_dirty in multipath_run as the array might not be dirty.
   - don't mark superblock dirty when switching to 'clean' if there
     is no internal superblock (if external, userspace can choose to
     update the superblock whenever it chooses to).

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c           |   77 +++++++++++++++++++++++++++---------
 include/linux/raid/md_k.h |    3 +
 2 files changed, 61 insertions(+), 19 deletions(-)

diff -puN drivers/md/md.c~md-support-external-metadata-for-md-arrays drivers/md/md.c
--- a/drivers/md/md.c~md-support-external-metadata-for-md-arrays
+++ a/drivers/md/md.c
@@ -778,7 +778,8 @@ static int super_90_validate(mddev_t *md
 		mddev->major_version = 0;
 		mddev->minor_version = sb->minor_version;
 		mddev->patch_version = sb->patch_version;
-		mddev->persistent = ! sb->not_persistent;
+		mddev->persistent = 1;
+		mddev->external = 0;
 		mddev->chunk_size = sb->chunk_size;
 		mddev->ctime = sb->ctime;
 		mddev->utime = sb->utime;
@@ -904,7 +905,7 @@ static void super_90_sync(mddev_t *mddev
 	sb->size  = mddev->size;
 	sb->raid_disks = mddev->raid_disks;
 	sb->md_minor = mddev->md_minor;
-	sb->not_persistent = !mddev->persistent;
+	sb->not_persistent = 0;
 	sb->utime = mddev->utime;
 	sb->state = 0;
 	sb->events_hi = (mddev->events>>32);
@@ -1158,6 +1159,7 @@ static int super_1_validate(mddev_t *mdd
 		mddev->major_version = 1;
 		mddev->patch_version = 0;
 		mddev->persistent = 1;
+		mddev->external = 0;
 		mddev->chunk_size = le32_to_cpu(sb->chunksize) << 9;
 		mddev->ctime = le64_to_cpu(sb->ctime) & ((1ULL << 32)-1);
 		mddev->utime = le64_to_cpu(sb->utime) & ((1ULL << 32)-1);
@@ -1696,18 +1698,20 @@ repeat:
 		MD_BUG();
 		mddev->events --;
 	}
-	sync_sbs(mddev, nospares);
 
 	/*
 	 * do not write anything to disk if using
 	 * nonpersistent superblocks
 	 */
 	if (!mddev->persistent) {
-		clear_bit(MD_CHANGE_PENDING, &mddev->flags);
+		if (!mddev->external)
+			clear_bit(MD_CHANGE_PENDING, &mddev->flags);
+
 		spin_unlock_irq(&mddev->write_lock);
 		wake_up(&mddev->sb_wait);
 		return;
 	}
+	sync_sbs(mddev, nospares);
 	spin_unlock_irq(&mddev->write_lock);
 
 	dprintk(KERN_INFO 
@@ -2425,6 +2429,8 @@ array_state_show(mddev_t *mddev, char *p
 		case 0:
 			if (mddev->in_sync)
 				st = clean;
+			else if (test_bit(MD_CHANGE_CLEAN, &mddev->flags))
+				st = write_pending;
 			else if (mddev->safemode)
 				st = active_idle;
 			else
@@ -2455,11 +2461,9 @@ array_state_store(mddev_t *mddev, const 
 		break;
 	case clear:
 		/* stopping an active array */
-		if (mddev->pers) {
-			if (atomic_read(&mddev->active) > 1)
-				return -EBUSY;
-			err = do_md_stop(mddev, 0);
-		}
+		if (atomic_read(&mddev->active) > 1)
+			return -EBUSY;
+		err = do_md_stop(mddev, 0);
 		break;
 	case inactive:
 		/* stopping an active array */
@@ -2467,7 +2471,8 @@ array_state_store(mddev_t *mddev, const 
 			if (atomic_read(&mddev->active) > 1)
 				return -EBUSY;
 			err = do_md_stop(mddev, 2);
-		}
+		} else
+			err = 0; /* already inactive */
 		break;
 	case suspended:
 		break; /* not supported yet */
@@ -2495,9 +2500,15 @@ array_state_store(mddev_t *mddev, const 
 			restart_array(mddev);
 			spin_lock_irq(&mddev->write_lock);
 			if (atomic_read(&mddev->writes_pending) == 0) {
-				mddev->in_sync = 1;
-				set_bit(MD_CHANGE_CLEAN, &mddev->flags);
-			}
+				if (mddev->in_sync == 0) {
+					mddev->in_sync = 1;
+					if (mddev->persistent)
+						set_bit(MD_CHANGE_CLEAN,
+							&mddev->flags);
+				}
+				err = 0;
+			} else
+				err = -EBUSY;
 			spin_unlock_irq(&mddev->write_lock);
 		} else {
 			mddev->ro = 0;
@@ -2508,7 +2519,8 @@ array_state_store(mddev_t *mddev, const 
 	case active:
 		if (mddev->pers) {
 			restart_array(mddev);
-			clear_bit(MD_CHANGE_CLEAN, &mddev->flags);
+			if (mddev->external)
+				clear_bit(MD_CHANGE_CLEAN, &mddev->flags);
 			wake_up(&mddev->sb_wait);
 			err = 0;
 		} else {
@@ -2659,7 +2671,9 @@ __ATTR(component_size, S_IRUGO|S_IWUSR, 
 
 
 /* Metdata version.
- * This is either 'none' for arrays with externally managed metadata,
+ * This is one of
+ *   'none' for arrays with no metadata (good luck...)
+ *   'external' for arrays with externally managed metadata,
  * or N.M for internally known formats
  */
 static ssize_t
@@ -2668,6 +2682,8 @@ metadata_show(mddev_t *mddev, char *page
 	if (mddev->persistent)
 		return sprintf(page, "%d.%d\n",
 			       mddev->major_version, mddev->minor_version);
+	else if (mddev->external)
+		return sprintf(page, "external:%s\n", mddev->metadata_type);
 	else
 		return sprintf(page, "none\n");
 }
@@ -2682,6 +2698,21 @@ metadata_store(mddev_t *mddev, const cha
 
 	if (cmd_match(buf, "none")) {
 		mddev->persistent = 0;
+		mddev->external = 0;
+		mddev->major_version = 0;
+		mddev->minor_version = 90;
+		return len;
+	}
+	if (strncmp(buf, "external:", 9) == 0) {
+		int namelen = len-9;
+		if (namelen >= sizeof(mddev->metadata_type))
+			namelen = sizeof(mddev->metadata_type)-1;
+		strncpy(mddev->metadata_type, buf+9, namelen);
+		mddev->metadata_type[namelen] = 0;
+		if (namelen && mddev->metadata_type[namelen-1] == '\n')
+			mddev->metadata_type[--namelen] = 0;
+		mddev->persistent = 0;
+		mddev->external = 1;
 		mddev->major_version = 0;
 		mddev->minor_version = 90;
 		return len;
@@ -2698,6 +2729,7 @@ metadata_store(mddev_t *mddev, const cha
 	mddev->major_version = major;
 	mddev->minor_version = minor;
 	mddev->persistent = 1;
+	mddev->external = 0;
 	return len;
 }
 
@@ -3524,6 +3556,7 @@ static int do_md_stop(mddev_t * mddev, i
 		mddev->raid_disks = 0;
 		mddev->recovery_cp = 0;
 		mddev->reshape_position = MaxSector;
+		mddev->external = 0;
 
 	} else if (mddev->pers)
 		printk(KERN_INFO "md: %s switched to read-only mode.\n",
@@ -4165,13 +4198,15 @@ static int set_array_info(mddev_t * mdde
 	else
 		mddev->recovery_cp = 0;
 	mddev->persistent    = ! info->not_persistent;
+	mddev->external	     = 0;
 
 	mddev->layout        = info->layout;
 	mddev->chunk_size    = info->chunk_size;
 
 	mddev->max_disks     = MD_SB_DISKS;
 
-	mddev->flags         = 0;
+	if (mddev->persistent)
+		mddev->flags         = 0;
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 
 	mddev->default_bitmap_offset = MD_SB_BYTES >> 9;
@@ -4982,7 +5017,10 @@ static int md_seq_show(struct seq_file *
 					   mddev->major_version,
 					   mddev->minor_version);
 			}
-		} else
+		} else if (mddev->external)
+			seq_printf(seq, " super external:%s",
+				   mddev->metadata_type);
+		else
 			seq_printf(seq, " super non-persistent");
 
 		if (mddev->pers) {
@@ -5589,7 +5627,7 @@ void md_check_recovery(mddev_t *mddev)
 	}
 
 	if ( ! (
-		mddev->flags ||
+		(mddev->flags && !mddev->external) ||
 		test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
 		test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
 		(mddev->safemode == 1) ||
@@ -5605,7 +5643,8 @@ void md_check_recovery(mddev_t *mddev)
 		if (mddev->safemode && !atomic_read(&mddev->writes_pending) &&
 		    !mddev->in_sync && mddev->recovery_cp == MaxSector) {
 			mddev->in_sync = 1;
-			set_bit(MD_CHANGE_CLEAN, &mddev->flags);
+			if (mddev->persistent)
+				set_bit(MD_CHANGE_CLEAN, &mddev->flags);
 		}
 		if (mddev->safemode == 1)
 			mddev->safemode = 0;
diff -puN include/linux/raid/md_k.h~md-support-external-metadata-for-md-arrays include/linux/raid/md_k.h
--- a/include/linux/raid/md_k.h~md-support-external-metadata-for-md-arrays
+++ a/include/linux/raid/md_k.h
@@ -130,6 +130,9 @@ struct mddev_s
 					minor_version,
 					patch_version;
 	int				persistent;
+	int 				external;	/* metadata is
+							 * managed externally */
+	char				metadata_type[17]; /* externally set*/
 	int				chunk_size;
 	time_t				ctime, utime;
 	int				level, layout;
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
one-less-parameter-to-__d_path.patch
d_path-kerneldoc-cleanup.patch
d_path-use-struct-path-in-struct-avc_audit_data.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
d_path-make-d_path-use-a-struct-path.patch
d_path-make-d_path-use-a-struct-path-fix.patch
