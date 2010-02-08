From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Mon, 08 Feb 2010 11:49:43 -0800
Message-ID: <201002081949.o18JnhQ8031260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751131Ab0BHTuO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2010 14:50:14 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id o18JnhfM007460
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 8 Feb 2010 11:49:45 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/glock.c    |   28 ----------------------------
 fs/gfs2/lock_dlm.c |    4 ----
 fs/gfs2/super.c    |    3 ---
 3 files changed, 35 deletions(-)

diff -puN fs/gfs2/glock.c~linux-next-git-rejects fs/gfs2/glock.c
--- a/fs/gfs2/glock.c~linux-next-git-rejects
+++ a/fs/gfs2/glock.c
@@ -1510,36 +1510,8 @@ void gfs2_gl_hash_clear(struct gfs2_sbd 
 {
 	unsigned int x;
 
-<<<<<<< HEAD:fs/gfs2/glock.c
-	t = jiffies;
-
-	for (;;) {
-		cont = 0;
-		for (x = 0; x < GFS2_GL_HASH_SIZE; x++) {
-			if (examine_bucket(clear_glock, sdp, x))
-				cont = 1;
-		}
-
-		if (!cont)
-			break;
-
-		if (time_after_eq(jiffies,
-				  t + gfs2_tune_get(sdp, gt_stall_secs) * HZ)) {
-			fs_warn(sdp, "Unmount seems to be stalled. "
-				     "Dumping lock state...\n");
-			gfs2_dump_lockstate(sdp);
-			t = jiffies;
-		}
-
-		down_write(&gfs2_umount_flush_sem);
-		invalidate_inodes(sdp->sd_vfs);
-		up_write(&gfs2_umount_flush_sem);
-		msleep(10);
-	}
-=======
 	for (x = 0; x < GFS2_GL_HASH_SIZE; x++)
 		examine_bucket(clear_glock, sdp, x);
->>>>>>> FETCH_HEAD:fs/gfs2/glock.c
 	flush_workqueue(glock_workqueue);
 	wait_event(sdp->sd_glock_wait, atomic_read(&sdp->sd_glock_disposal) == 0);
 	gfs2_dump_lockstate(sdp);
diff -puN fs/gfs2/lock_dlm.c~linux-next-git-rejects fs/gfs2/lock_dlm.c
--- a/fs/gfs2/lock_dlm.c~linux-next-git-rejects
+++ a/fs/gfs2/lock_dlm.c
@@ -30,14 +30,10 @@ static void gdlm_ast(void *arg)
 
 	switch (gl->gl_lksb.sb_status) {
 	case -DLM_EUNLOCK: /* Unlocked, so glock can be freed */
-<<<<<<< HEAD:fs/gfs2/lock_dlm.c
-		kmem_cache_free(gfs2_glock_cachep, gl);
-=======
 		if (gl->gl_ops->go_flags & GLOF_ASPACE)
 			kmem_cache_free(gfs2_glock_aspace_cachep, gl);
 		else
 			kmem_cache_free(gfs2_glock_cachep, gl);
->>>>>>> FETCH_HEAD:fs/gfs2/lock_dlm.c
 		if (atomic_dec_and_test(&sdp->sd_glock_disposal))
 			wake_up(&sdp->sd_glock_wait);
 		return;
diff -puN fs/gfs2/super.c~linux-next-git-rejects fs/gfs2/super.c
--- a/fs/gfs2/super.c~linux-next-git-rejects
+++ a/fs/gfs2/super.c
@@ -21,10 +21,7 @@
 #include <linux/gfs2_ondisk.h>
 #include <linux/crc32.h>
 #include <linux/time.h>
-<<<<<<< HEAD:fs/gfs2/super.c
-=======
 #include <linux/writeback.h>
->>>>>>> FETCH_HEAD:fs/gfs2/super.c
 #include <linux/wait.h>
 
 #include "gfs2.h"
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-fix.patch
bitops-rename-for_each_bit-to-for_each_set_bit-fix-fix-2.patch
pci-update-pci_set_vga_state-to-call-arch-functions.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region-fix.patch
kernel-schedc-suppress-unused-var-warning.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
add-generic-sys_ipc-wrapper-fix.patch
lib-more-scalable-list_sort-fix.patch
fs-compat_ioctlc-suppress-two-warnings.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
gpio-pca953xc-add-interrupt-handling-capability-fix.patch
broadsheetfb-support-storing-waveform-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch
kmod-add-init-function-to-usermodehelper-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

