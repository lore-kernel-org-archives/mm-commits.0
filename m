From: akpm@linux-foundation.org
Subject: - drivers-scsi-sdh-use-inlined-c-functions-not-macros.patch removed from -mm tree
Date: Sat, 18 Oct 2008 15:33:18 -0700
Message-ID: <200810182233.m9IMXIgO022632@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750837AbYJRWd1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 18:33:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/sd.h: use inlined C functions, not macros
has been removed from the -mm tree.  Its filename was
     drivers-scsi-sdh-use-inlined-c-functions-not-macros.patch

This patch was dropped because something else got merged instead which broek it and I can't be bothered fixing it

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/scsi/sd.h: use inlined C functions, not macros
From: Andrew Morton <akpm@linux-foundation.org>

Fix this:

drivers/scsi/sd.c: In function `sd_done':
drivers/scsi/sd.c:1092: warning: statement with no effect

By switching to proper, typechecked C-language inlined stubs.  I really don't
know how to wean kernel developers off their macro addiction.


Also, consistently fill in the argument names in the
CONFIG_BLK_DEV_INTEGRITY=y declarations - it's good for readability.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sd.h |   34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff -puN drivers/scsi/sd.h~drivers-scsi-sdh-use-inlined-c-functions-not-macros drivers/scsi/sd.h
--- a/drivers/scsi/sd.h~drivers-scsi-sdh-use-inlined-c-functions-not-macros
+++ a/drivers/scsi/sd.h
@@ -99,17 +99,35 @@ struct sd_dif_tuple {
 
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
 
-extern void sd_dif_op(struct scsi_cmnd *, unsigned int, unsigned int);
-extern void sd_dif_config_host(struct scsi_disk *);
-extern int sd_dif_prepare(struct request *rq, sector_t, unsigned int);
-extern void sd_dif_complete(struct scsi_cmnd *, unsigned int);
+extern void sd_dif_op(struct scsi_cmnd *scmd, unsigned int dif,
+			unsigned int dix);
+extern void sd_dif_config_host(struct scsi_disk *sdkp);
+extern int sd_dif_prepare(struct request *rq, sector_t hw_sector,
+			unsigned int sector_sz);
+extern void sd_dif_complete(struct scsi_cmnd *scmd, unsigned int good_bytes);
 
 #else /* CONFIG_BLK_DEV_INTEGRITY */
 
-#define sd_dif_op(a, b, c)			do { } while (0)
-#define sd_dif_config_host(a)			do { } while (0)
-#define sd_dif_prepare(a, b, c)			(0)
-#define sd_dif_complete(a, b)			(0)
+static inline void sd_dif_op(struct scsi_cmnd *scmd, unsigned int dif,
+			unsigned int dix)
+{
+}
+
+static inline void sd_dif_config_host(struct scsi_disk *sdkp)
+{
+}
+
+static inline int sd_dif_prepare(struct request *rq, sector_t hw_sector,
+			unsigned int sector_sz)
+{
+	return 0;
+}
+
+static inline int sd_dif_complete(struct scsi_cmnd *scmd,
+				unsigned int good_bytes)
+{
+	return 0;
+}
 
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
linux-next-git-rejects.patch
revert-i7300_idle-driver-v155.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module-checkpatch-fixes.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
leds-driver-for-hp-harddisk-protection-led-fix.patch
drivers-rtc-rtc-ds1286c-is-borked.patch
drivers-rtc-rtc-m48t35c-is-borked-too.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
drivers-scsi-sdh-use-inlined-c-functions-not-macros.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check-fix.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check-fix-fix.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check-fix-fix-fix.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-vmallocc-revert-git-tip-change.patch
mm-rewrite-vmap-layer-fix.patch
mm-rewrite-vmap-layer-fix-fix.patch
mm-rewrite-vmap-layer-fix-fix-fix.patch
revert-mm-vmallocc-revert-git-tip-change.patch
memory_probe-fix-wrong-sysfs-file-attribute-fix.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms-cleanup.patch
drivers-hwmon-applesmcc-remove-unneeded-casts.patch
mfd-drivers-mfd-wm8350-corec-doesnt-work-on-x86.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch
x86-sysfs-kill-owner-field-from-attribute-fix.patch
x86-sysfs-kill-owner-field-from-attribute-fix-3.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

