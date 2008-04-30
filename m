From: akpm@linux-foundation.org
Subject: - fs-fs-writeback-make-2-functions-static.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:39:26 -0700
Message-ID: <200804300539.m3U5dQgH028845@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753950AbYD3Fjo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:39:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     fs/fs-writeback.c: make 2 functions static
has been removed from the -mm tree.  Its filename was
     fs-fs-writeback-make-2-functions-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/fs-writeback.c: make 2 functions static
From: Adrian Bunk <bunk@kernel.org>

Make the following needlessly global functions static:

- writeback_acquire()
- writeback_release()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c           |   78 +++++++++++++++++-----------------
 include/linux/backing-dev.h |    2 
 2 files changed, 39 insertions(+), 41 deletions(-)

diff -puN fs/fs-writeback.c~fs-fs-writeback-make-2-functions-static fs/fs-writeback.c
--- a/fs/fs-writeback.c~fs-fs-writeback-make-2-functions-static
+++ a/fs/fs-writeback.c
@@ -25,6 +25,45 @@
 #include <linux/buffer_head.h>
 #include "internal.h"
 
+
+/**
+ * writeback_acquire - attempt to get exclusive writeback access to a device
+ * @bdi: the device's backing_dev_info structure
+ *
+ * It is a waste of resources to have more than one pdflush thread blocked on
+ * a single request queue.  Exclusion at the request_queue level is obtained
+ * via a flag in the request_queue's backing_dev_info.state.
+ *
+ * Non-request_queue-backed address_spaces will share default_backing_dev_info,
+ * unless they implement their own.  Which is somewhat inefficient, as this
+ * may prevent concurrent writeback against multiple devices.
+ */
+static int writeback_acquire(struct backing_dev_info *bdi)
+{
+	return !test_and_set_bit(BDI_pdflush, &bdi->state);
+}
+
+/**
+ * writeback_in_progress - determine whether there is writeback in progress
+ * @bdi: the device's backing_dev_info structure.
+ *
+ * Determine whether there is writeback in progress against a backing device.
+ */
+int writeback_in_progress(struct backing_dev_info *bdi)
+{
+	return test_bit(BDI_pdflush, &bdi->state);
+}
+
+/**
+ * writeback_release - relinquish exclusive writeback access against a device.
+ * @bdi: the device's backing_dev_info structure
+ */
+static void writeback_release(struct backing_dev_info *bdi)
+{
+	BUG_ON(!writeback_in_progress(bdi));
+	clear_bit(BDI_pdflush, &bdi->state);
+}
+
 /**
  *	__mark_inode_dirty -	internal function
  *	@inode: inode to mark
@@ -747,43 +786,4 @@ int generic_osync_inode(struct inode *in
 
 	return err;
 }
-
 EXPORT_SYMBOL(generic_osync_inode);
-
-/**
- * writeback_acquire - attempt to get exclusive writeback access to a device
- * @bdi: the device's backing_dev_info structure
- *
- * It is a waste of resources to have more than one pdflush thread blocked on
- * a single request queue.  Exclusion at the request_queue level is obtained
- * via a flag in the request_queue's backing_dev_info.state.
- *
- * Non-request_queue-backed address_spaces will share default_backing_dev_info,
- * unless they implement their own.  Which is somewhat inefficient, as this
- * may prevent concurrent writeback against multiple devices.
- */
-int writeback_acquire(struct backing_dev_info *bdi)
-{
-	return !test_and_set_bit(BDI_pdflush, &bdi->state);
-}
-
-/**
- * writeback_in_progress - determine whether there is writeback in progress
- * @bdi: the device's backing_dev_info structure.
- *
- * Determine whether there is writeback in progress against a backing device.
- */
-int writeback_in_progress(struct backing_dev_info *bdi)
-{
-	return test_bit(BDI_pdflush, &bdi->state);
-}
-
-/**
- * writeback_release - relinquish exclusive writeback access against a device.
- * @bdi: the device's backing_dev_info structure
- */
-void writeback_release(struct backing_dev_info *bdi)
-{
-	BUG_ON(!writeback_in_progress(bdi));
-	clear_bit(BDI_pdflush, &bdi->state);
-}
diff -puN include/linux/backing-dev.h~fs-fs-writeback-make-2-functions-static include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~fs-fs-writeback-make-2-functions-static
+++ a/include/linux/backing-dev.h
@@ -156,9 +156,7 @@ static inline unsigned long bdi_stat_err
 extern struct backing_dev_info default_backing_dev_info;
 void default_unplug_io_fn(struct backing_dev_info *bdi, struct page *page);
 
-int writeback_acquire(struct backing_dev_info *bdi);
 int writeback_in_progress(struct backing_dev_info *bdi);
-void writeback_release(struct backing_dev_info *bdi);
 
 static inline int bdi_congested(struct backing_dev_info *bdi, int bdi_bits)
 {
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
mm-filemapc-generic_write_checks-mustnt-be-inline.patch
fs-block_devc-i_bdev-mustnt-be-inline.patch
frv-fix-arch-frv-mm-unalignedo-build-error.patch
reiserfs-some-functions-mustnt-be-inline.patch
git-acpi.patch
git-x86.patch
arch-x86-video-fbdevc-add-module_license.patch
md-make-dm_dirty_log_initexit-static.patch
drm-make-drm_minors_cleanup-static.patch
git-m32r.patch
net-ipv4-ip_outputc-ip_send_check-mustnt-be-inline.patch
nfs-make-nfs4_drop_state_owner-static.patch
git-ocfs2.patch
show_schedstat-fix-memleak.patch
git-sh.patch
if-0-ses_match_host.patch
git-watchdog.patch
xen-drivers-xen-balloonc-make-a-function-static.patch
make-marker_debug-static.patch
reiser4.patch

