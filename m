From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Fri, 05 Mar 2010 10:58:29 -0800
Message-ID: <201003051858.o25IwTrK021738@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755353Ab0CES6g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Mar 2010 13:58:36 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id o25IwYuR030160
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 5 Mar 2010 10:58:35 -0800
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

 drivers/gpu/vga/Kconfig          |    3 ---
 fs/nfsd/nfs4xdr.c                |    7 -------
 fs/notify/inotify/inotify_user.c |    4 ----
 kernel/audit_tree.c              |    4 ----
 4 files changed, 18 deletions(-)

diff -puN drivers/gpu/vga/Kconfig~linux-next-git-rejects drivers/gpu/vga/Kconfig
--- a/drivers/gpu/vga/Kconfig~linux-next-git-rejects
+++ a/drivers/gpu/vga/Kconfig
@@ -27,7 +27,4 @@ config VGA_SWITCHEROO
           X isn't running and delayed switching until the next logoff. This
 	  features is called hybrid graphics, ATI PowerXpress, and Nvidia
 	  HybridPower.
-<<<<<<< HEAD:drivers/gpu/vga/Kconfig
-=======
 
->>>>>>> FETCH_HEAD:drivers/gpu/vga/Kconfig
diff -puN fs/nfsd/nfs4xdr.c~linux-next-git-rejects fs/nfsd/nfs4xdr.c
--- a/fs/nfsd/nfs4xdr.c~linux-next-git-rejects
+++ a/fs/nfsd/nfs4xdr.c
@@ -2124,15 +2124,8 @@ out_acl:
 		    dentry == exp->ex_path.mnt->mnt_root) {
 			struct path path = exp->ex_path;
 			path_get(&path);
-<<<<<<< HEAD:fs/nfsd/nfs4xdr.c
-			while (follow_up(&path)) {
-				if (path.dentry != path.mnt->mnt_root)
-					break;
-			}
-=======
 			while (follow_up(&path))
 				;
->>>>>>> FETCH_HEAD:fs/nfsd/nfs4xdr.c
 			err = vfs_getattr(path.mnt, path.dentry, &stat);
 			path_put(&path);
 			if (err)
diff -puN fs/notify/inotify/inotify_user.c~linux-next-git-rejects fs/notify/inotify/inotify_user.c
--- a/fs/notify/inotify/inotify_user.c~linux-next-git-rejects
+++ a/fs/notify/inotify/inotify_user.c
@@ -836,11 +836,7 @@ out:
  */
 static int __init inotify_user_setup(void)
 {
-<<<<<<< HEAD:fs/notify/inotify/inotify_user.c
-	inotify_inode_mark_cachep = KMEM_CACHE(inotify_inode_mark_entry, SLAB_PANIC);
-=======
 	inotify_inode_mark_cachep = KMEM_CACHE(inotify_inode_mark, SLAB_PANIC);
->>>>>>> FETCH_HEAD:fs/notify/inotify/inotify_user.c
 	event_priv_cachep = KMEM_CACHE(inotify_event_private_data, SLAB_PANIC);
 
 	inotify_max_queued_events = 16384;
diff -puN kernel/audit_tree.c~linux-next-git-rejects kernel/audit_tree.c
--- a/kernel/audit_tree.c~linux-next-git-rejects
+++ a/kernel/audit_tree.c
@@ -600,12 +600,8 @@ void audit_trim_trees(void)
 
 		spin_lock(&hash_lock);
 		list_for_each_entry(node, &tree->chunks, list) {
-<<<<<<< HEAD:kernel/audit_tree.c
-			struct inode *inode = find_chunk(node)->watch.inode;
-=======
 			/* this could be NULL if the watch is dieing else where... */
 			struct inode *inode = find_chunk(node)->mark.i.inode;
->>>>>>> FETCH_HEAD:kernel/audit_tree.c
 			node->index |= 1U<<31;
 			if (iterate_mounts(compare_root, inode, root_mnt))
 				node->index &= ~(1U<<31);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-arm.patch
bitops-rename-for_each_bit-to-for_each_set_bit-net.patch
bitops-rename-for_each_bit-to-for_each_set_bit-mtd.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
3x59x-fix-pci-resource-management.patch
kernel-schedc-suppress-unused-var-warning.patch
usb-serial-ftdi-add-contec-vendor-and-product-id-fix.patch
drivers-watchdog-wdtc-wdt_ioctl-make-ident-non-static.patch
drivers-char-tty_bufferc-fix-min-warnings.patch
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
sdio-introduce-api-for-special-power-management-features-fix.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reldisp-ioctl-call-checkpatch-fixes.patch
gpio-pca953xc-add-interrupt-handling-capability.patch
gpio-pca953xc-add-interrupt-handling-capability-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
gpio-cs5535-gpio-fix-input-direction.patch
broadsheetfb-support-storing-waveform-fix.patch
drivers-char-memc-cleanups.patch
drivers-char-memc-cleanups-fix.patch
drivers-char-memc-cleanups-fix-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch
kmod-add-init-function-to-usermodehelper-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments-fix.patch
pps-linuxpps-clients-support-v3-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

