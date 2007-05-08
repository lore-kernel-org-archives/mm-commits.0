From: akpm@linux-foundation.org
Subject: + md-move-test-for-whether-level-supports-bitmap-to-correct-place.patch added to -mm tree
Date: Tue, 08 May 2007 16:09:07 -0700
Message-ID: <200705082309.l48N97BL004343@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40268 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968588AbXEHXJM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 19:09:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md: move test for whether level supports bitmap to correct place
has been added to the -mm tree.  Its filename is
     md-move-test-for-whether-level-supports-bitmap-to-correct-place.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 26 insertions(+), 16 deletions(-)

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
