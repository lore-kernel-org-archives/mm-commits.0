From: akpm@linux-foundation.org
Subject: [folded] jfs-free-sbi-memory-in-error-path-fix.patch removed from -mm tree
Date: Mon, 12 Apr 2010 16:42:50 -0700
Message-ID: <201004122342.o3CNgosN000948@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754322Ab0DLXm7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Apr 2010 19:42:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jblunck@suse.de, shaggy@austin.ibm.com, mm-commits@vger.kernel.org


The patch titled
     jfs-free-sbi-memory-in-error-path-fix
has been removed from the -mm tree.  Its filename was
     jfs-free-sbi-memory-in-error-path-fix.patch

This patch was dropped because it was folded into jfs-free-sbi-memory-in-error-path.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jfs-free-sbi-memory-in-error-path-fix
From: Andrew Morton <akpm@linux-foundation.org>

[akpm@linux-foundation.org: avoid multiple returns so it doesn't happen again]
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Cc: Jan Blunck <jblunck@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jfs/super.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN fs/jfs/super.c~jfs-free-sbi-memory-in-error-path-fix fs/jfs/super.c
--- a/fs/jfs/super.c~jfs-free-sbi-memory-in-error-path-fix
+++ a/fs/jfs/super.c
@@ -446,10 +446,8 @@ static int jfs_fill_super(struct super_b
 	/* initialize the mount flag and determine the default error handler */
 	flag = JFS_ERR_REMOUNT_RO;
 
-	if (!parse_options((char *) data, sb, &newLVSize, &flag)) {
-		kfree(sbi);
-		return -EINVAL;
-	}
+	if (!parse_options((char *) data, sb, &newLVSize, &flag))
+		goto out_kfree;
 	sbi->flag = flag;
 
 #ifdef CONFIG_JFS_POSIX_ACL
@@ -458,8 +456,7 @@ static int jfs_fill_super(struct super_b
 
 	if (newLVSize) {
 		printk(KERN_ERR "resize option for remount only\n");
-		kfree(sbi);
-		return -EINVAL;
+		goto out_kfree;
 	}
 
 	/*
@@ -479,7 +476,7 @@ static int jfs_fill_super(struct super_b
 	inode = new_inode(sb);
 	if (inode == NULL) {
 		ret = -ENOMEM;
-		goto out_kfree;
+		goto out_unload;
 	}
 	inode->i_ino = 0;
 	inode->i_nlink = 1;
@@ -551,9 +548,10 @@ out_mount_failed:
 	make_bad_inode(sbi->direct_inode);
 	iput(sbi->direct_inode);
 	sbi->direct_inode = NULL;
-out_kfree:
+out_unload:
 	if (sbi->nls_tab)
 		unload_nls(sbi->nls_tab);
+out_kfree:
 	kfree(sbi);
 	return ret;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-crypto-aesni-intel_asms-still-busted.patch
include-linux-fsh-complete-hexification-of-fmode_-constants.patch
drivers-video-efifbc-framebuffer-for-nvidia-9400m-in-macbook-pro-51-fix.patch
intel-agpc-fix-crash-when-accessing-nonexistent-gtt-entries-in-i915-checkpatch-fixes.patch
iio-iio_get_new_idr_val-return-negative-value-on-failure-fix.patch
drivers-acpi-use-kasprintf-fix.patch
acpi_pad-processor_aggregator-name-too-long-fix.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cifs-provide-user-with-a-hint-when-name-resolution-fails-fix.patch
jfs-free-sbi-memory-in-error-path.patch
jfs-free-sbi-memory-in-error-path-fix.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix-fix2.patch
led-driver-for-the-soekris-net5501-board-checkpatch-fixes.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
gpio-add-support-for-janz-vmod-ttl-digital-io-module-fix.patch
ipc-mqueuec-let-message-queue-timeout-use-hrtimers-checkpatch-fixes.patch
3x59x-fix-pci-resource-management.patch
backlight-add-s6e63m0-amoled-lcd-panel-driver-checkpatch-fixes.patch
serial-timbuart-make-sure-last-byte-is-sent-when-port-is-closed-fix.patch
kernel-irq-managec-add-raise_threaded_irq-fix.patch
max3100-to_max3100_port-small-style-fixes-fix.patch
mm-compaction-direct-compact-when-a-high-order-allocation-fails-reject-fix.patch
mm-compaction-do-not-display-compaction-related-stats-when-config_compaction-reject-fix.patch
frv-extend-gdbstub-to-support-more-features-of-gdb-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
firmware-loader-use-statically-initialized-data-attribute-fix.patch
firmware-loader-use-statically-initialized-data-attribute-fix-fix.patch
davinci-mmc-updates-to-suspend-resume-implementation-checkpatch-fixes.patch
checkpatch-add-check-for-too-short-kconfig-descriptions-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
hwmon-add-ti-ads7871-a-d-converter-driver-checkpatch-fixes.patch
rtc-mxc-remove-unnecessary-clock-source-for-rtc-subsystem.patch
gpiolib-make-names-array-and-its-values-const-fix.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch
memcg-move-charge-of-file-pages-fix.patch
proc-turn-signal_struct-count-into-int-nr_threads-checkpatch-fixes.patch
fault-injection-add-cpu-notifier-error-injection-module-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn-checkpatch-fixes.patch
x86_32-use-asm-generic-scatterlisth.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

