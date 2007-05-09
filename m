From: akpm@linux-foundation.org
Subject: - md-move-test-for-whether-level-supports-bitmap-to-correct-place.patch removed from -mm tree
Date: Wed, 09 May 2007 14:54:54 -0700
Message-ID: <200705092154.l49Lssu4003209@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752316AbXEIVzS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:55:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: move test for whether level supports bitmap to correct place
has been removed from the -mm tree.  Its filename was
     md-move-test-for-whether-level-supports-bitmap-to-correct-place.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: move test for whether level supports bitmap to correct place
From: NeilBrown <neilb@suse.de>

We need to check for internal-consistency of superblock in load_super. 
validate_super is for inter-device consistency.

With the test in the wrong place, a badly created array will confuse md rather
an produce sensible errors.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |   42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff -puN drivers/md/md.c~md-move-test-for-whether-level-supports-bitmap-to-correct-place drivers/md/md.c
--- a/drivers/md/md.c~md-move-test-for-whether-level-supports-bitmap-to-correct-place
+++ a/drivers/md/md.c
@@ -695,6 +695,17 @@ static int super_90_load(mdk_rdev_t *rde
 	rdev->data_offset = 0;
 	rdev->sb_size = MD_SB_BYTES;
 
+	if (sb->state & (1<<MD_SB_BITMAP_PRESENT)) {
+		if (sb->level != 1 && sb->level != 4
+		    && sb->level != 5 && sb->level != 6
+		    && sb->level != 10) {
+			/* FIXME use a better test */
+			printk(KERN_WARNING
+			       "md: bitmaps not supported for this level.\n");
+			goto abort;
+		}
+	}
+
 	if (sb->level == LEVEL_MULTIPATH)
 		rdev->desc_nr = -1;
 	else
@@ -793,16 +804,8 @@ static int super_90_validate(mddev_t *md
 		mddev->max_disks = MD_SB_DISKS;
 
 		if (sb->state & (1<<MD_SB_BITMAP_PRESENT) &&
-		    mddev->bitmap_file == NULL) {
-			if (mddev->level != 1 && mddev->level != 4
-			    && mddev->level != 5 && mddev->level != 6
-			    && mddev->level != 10) {
-				/* FIXME use a better test */
-				printk(KERN_WARNING "md: bitmaps not supported for this level.\n");
-				return -EINVAL;
-			}
+		    mddev->bitmap_file == NULL)
 			mddev->bitmap_offset = mddev->default_bitmap_offset;
-		}
 
 	} else if (mddev->pers == NULL) {
 		/* Insist on good event counter while assembling */
@@ -1059,6 +1062,18 @@ static int super_1_load(mdk_rdev_t *rdev
 		       bdevname(rdev->bdev,b));
 		return -EINVAL;
 	}
+	if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_BITMAP_OFFSET)) {
+		if (sb->level != cpu_to_le32(1) &&
+		    sb->level != cpu_to_le32(4) &&
+		    sb->level != cpu_to_le32(5) &&
+		    sb->level != cpu_to_le32(6) &&
+		    sb->level != cpu_to_le32(10)) {
+			printk(KERN_WARNING
+			       "md: bitmaps not supported for this level.\n");
+			return -EINVAL;
+		}
+	}
+
 	rdev->preferred_minor = 0xffff;
 	rdev->data_offset = le64_to_cpu(sb->data_offset);
 	atomic_set(&rdev->corrected_errors, le32_to_cpu(sb->cnt_corrected_read));
@@ -1142,14 +1157,9 @@ static int super_1_validate(mddev_t *mdd
 		mddev->max_disks =  (4096-256)/2;
 
 		if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_BITMAP_OFFSET) &&
-		    mddev->bitmap_file == NULL ) {
-			if (mddev->level != 1 && mddev->level != 5 && mddev->level != 6
-			    && mddev->level != 10) {
-				printk(KERN_WARNING "md: bitmaps not supported for this level.\n");
-				return -EINVAL;
-			}
+		    mddev->bitmap_file == NULL )
 			mddev->bitmap_offset = (__s32)le32_to_cpu(sb->bitmap_offset);
-		}
+
 		if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_RESHAPE_ACTIVE)) {
 			mddev->reshape_position = le64_to_cpu(sb->reshape_position);
 			mddev->delta_disks = le32_to_cpu(sb->delta_disks);
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
introduce-freezer-flags-rev-2.patch
git-md-accel.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
