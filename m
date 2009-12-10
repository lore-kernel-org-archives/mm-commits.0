From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 10 Dec 2009 12:20:38 -0800
Message-ID: <200912102020.nBAKKcId023361@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756488AbZLJUUe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Dec 2009 15:20:34 -0500
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id nBAKKcJG012411
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 10 Dec 2009 12:20:39 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |    3 ---
 drivers/media/common/tuners/max2165.c      |    4 ----
 drivers/media/dvb/firewire/firedtv-1394.c  |   11 -----------
 drivers/media/dvb/firewire/firedtv-avc.c   |    4 ----
 drivers/media/dvb/firewire/firedtv-fw.c    |    4 ----
 drivers/media/dvb/firewire/firedtv.h       |    4 ----
 include/linux/videodev2.h                  |    3 ---
 7 files changed, 33 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~linux-next-git-rejects Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~linux-next-git-rejects
+++ a/Documentation/feature-removal-schedule.txt
@@ -490,8 +490,6 @@ Why:	Obsoleted by the adt7475 driver.
 Who:	Jean Delvare <khali@linux-fr.org>
 
 ---------------------------
-<<<<<<< HEAD:Documentation/feature-removal-schedule.txt
-=======
 
 What:	Support for lcd_switch and display_get in asus-laptop driver
 When:	March 2010
@@ -512,4 +510,3 @@ Why:	These two features use non-standard
 Who:	Corentin Chary <corentin.chary@gmail.com>
 
 ----------------------------
->>>>>>> FETCH_HEAD:Documentation/feature-removal-schedule.txt
diff -puN drivers/media/common/tuners/max2165.c~linux-next-git-rejects drivers/media/common/tuners/max2165.c
--- a/drivers/media/common/tuners/max2165.c~linux-next-git-rejects
+++ a/drivers/media/common/tuners/max2165.c
@@ -193,11 +193,7 @@ static int max2165_set_rf(struct max2165
 {
 	u8 tf;
 	u8 tf_ntch;
-<<<<<<< HEAD:drivers/media/common/tuners/max2165.c
 	u32 t;
-=======
-	double t;
->>>>>>> FETCH_HEAD:drivers/media/common/tuners/max2165.c
 	u32 quotient, fraction;
 
 	/* Set PLL divider according to RF frequency */
diff -puN drivers/media/dvb/firewire/firedtv-1394.c~linux-next-git-rejects drivers/media/dvb/firewire/firedtv-1394.c
--- a/drivers/media/dvb/firewire/firedtv-1394.c~linux-next-git-rejects
+++ a/drivers/media/dvb/firewire/firedtv-1394.c
@@ -90,7 +90,6 @@ static inline struct node_entry *node_of
 	return container_of(fdtv->device, struct unit_directory, device)->ne;
 }
 
-<<<<<<< HEAD:drivers/media/dvb/firewire/firedtv-1394.c
 static int node_lock(struct firedtv *fdtv, u64 addr, __be32 data[])
 {
 	int ret;
@@ -98,16 +97,6 @@ static int node_lock(struct firedtv *fdt
 	ret = hpsb_node_lock(node_of(fdtv), addr, EXTCODE_COMPARE_SWAP,
 		(__force quadlet_t *)&data[1], (__force quadlet_t)data[0]);
 	data[0] = data[1];
-=======
-static int node_lock(struct firedtv *fdtv, u64 addr, void *data)
-{
-	quadlet_t *d = data;
-	int ret;
-
-	ret = hpsb_node_lock(node_of(fdtv), addr,
-			     EXTCODE_COMPARE_SWAP, &d[1], d[0]);
-	d[0] = d[1];
->>>>>>> FETCH_HEAD:drivers/media/dvb/firewire/firedtv-1394.c
 
 	return ret;
 }
diff -puN drivers/media/dvb/firewire/firedtv-avc.c~linux-next-git-rejects drivers/media/dvb/firewire/firedtv-avc.c
--- a/drivers/media/dvb/firewire/firedtv-avc.c~linux-next-git-rejects
+++ a/drivers/media/dvb/firewire/firedtv-avc.c
@@ -1295,11 +1295,7 @@ static int cmp_lock(struct firedtv *fdtv
 	/* data[] is stack-allocated and should not be DMA-mapped. */
 	memcpy(fdtv->avc_data, data, 8);
 
-<<<<<<< HEAD:drivers/media/dvb/firewire/firedtv-avc.c
-	ret = fdtv->backend->lock(fdtv, addr, data);
-=======
 	ret = fdtv->backend->lock(fdtv, addr, fdtv->avc_data);
->>>>>>> FETCH_HEAD:drivers/media/dvb/firewire/firedtv-avc.c
 	if (ret < 0)
 		dev_err(fdtv->device, "CMP: lock I/O error\n");
 	else
diff -puN drivers/media/dvb/firewire/firedtv-fw.c~linux-next-git-rejects drivers/media/dvb/firewire/firedtv-fw.c
--- a/drivers/media/dvb/firewire/firedtv-fw.c~linux-next-git-rejects
+++ a/drivers/media/dvb/firewire/firedtv-fw.c
@@ -41,11 +41,7 @@ static int node_req(struct firedtv *fdtv
 	return rcode != RCODE_COMPLETE ? -EIO : 0;
 }
 
-<<<<<<< HEAD:drivers/media/dvb/firewire/firedtv-fw.c
 static int node_lock(struct firedtv *fdtv, u64 addr, __be32 data[])
-=======
-static int node_lock(struct firedtv *fdtv, u64 addr, void *data)
->>>>>>> FETCH_HEAD:drivers/media/dvb/firewire/firedtv-fw.c
 {
 	return node_req(fdtv, addr, data, 8, TCODE_LOCK_COMPARE_SWAP);
 }
diff -puN drivers/media/dvb/firewire/firedtv.h~linux-next-git-rejects drivers/media/dvb/firewire/firedtv.h
--- a/drivers/media/dvb/firewire/firedtv.h~linux-next-git-rejects
+++ a/drivers/media/dvb/firewire/firedtv.h
@@ -73,11 +73,7 @@ struct input_dev;
 struct firedtv;
 
 struct firedtv_backend {
-<<<<<<< HEAD:drivers/media/dvb/firewire/firedtv.h
 	int (*lock)(struct firedtv *fdtv, u64 addr, __be32 data[]);
-=======
-	int (*lock)(struct firedtv *fdtv, u64 addr, void *data);
->>>>>>> FETCH_HEAD:drivers/media/dvb/firewire/firedtv.h
 	int (*read)(struct firedtv *fdtv, u64 addr, void *data);
 	int (*write)(struct firedtv *fdtv, u64 addr, void *data, size_t len);
 	int (*start_iso)(struct firedtv *fdtv);
diff -puN include/linux/videodev2.h~linux-next-git-rejects include/linux/videodev2.h
--- a/include/linux/videodev2.h~linux-next-git-rejects
+++ a/include/linux/videodev2.h
@@ -361,10 +361,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_PJPG     v4l2_fourcc('P', 'J', 'P', 'G') /* Pixart 73xx JPEG */
 #define V4L2_PIX_FMT_OV511    v4l2_fourcc('O', '5', '1', '1') /* ov511 JPEG */
 #define V4L2_PIX_FMT_OV518    v4l2_fourcc('O', '5', '1', '8') /* ov518 JPEG */
-<<<<<<< HEAD:include/linux/videodev2.h
-=======
 #define V4L2_PIX_FMT_TM6000   v4l2_fourcc('T', 'M', '6', '0') /* tm5600/tm60x0 */
->>>>>>> FETCH_HEAD:include/linux/videodev2.h
 #define V4L2_PIX_FMT_STV0680  v4l2_fourcc('S', '6', '8', '0') /* stv0680 bayer */
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
acpi-remove-nid_inval.patch
drivers-acpi-acpi_padc-squish-warning.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices.patch
cmpc_acpi-add-support-for-classmate-pc-acpi-devices-checkpatch-fixes.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
drivers-leds-leds-ss4200c-fix-return-statement.patch
net-sctp-socketc-fix-warning.patch
net-ipv4-tcpc-fix-warning.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix2.patch
3x59x-fix-pci-resource-management.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
atmel_serial-add-poll_get_char-and-poll_put_char-uart_ops.patch
scsi-add-hpsa-driver-for-hp-smart-array-controllers.patch
aoe-switch-to-the-new-bio_flush_dcache_pages-interface.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
fs-improve-remountro-vs-buffercache-coherency.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix.patch
dev-mem-cleanup-unxlate_dev_mem_ptr-calls-fix-fix.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process-fix.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes.patch
mm-mlocking-in-try_to_unmap_one-fix-fix.patch
mm-memory_hotplug-make-offline_pages-static.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore-cleanup.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore-build-fix.patch
mm-hugetlb-add-hugepage-support-to-pagemap-build-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm-cleanup.patch
floppy-add-an-extra-bound-check-on-ioctl-arguments-fix.patch
drivers-misc-add-driver-for-texas-instruments-dac7512-update.patch
rwsem-fix-rwsem_is_locked-bugs-fix.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-checkpatch-fixes.patch
kernelh-add-printk_ratelimited-and-pr_level_rl-rename.patch
errh-add-helper-function-to-simplify-pointer-error-checking-fix.patch
drivers-scsi-sym53c8xx_2-sym_gluec-rename-skip_spaces-to-sym_skip_spaces.patch
lib-introduce-strim-checkpatch-fixes.patch
msm_sdccc-add-missing-include-fix-compilation-checkpatch-fixes.patch
blackfin-sd-host-controller-driver-fix.patch
blackfin-sd-host-controller-driver-fix-fix.patch
blackfin-sd-host-controller-driver-fix-fix-fix.patch
crc32-minor-optimizations-and-cleanup-checkpatch-fixes.patch
hwmon-w83627ehf-updates-checkpatch-fixes.patch
lis3-update-documentation-to-match-latest-changes-fix.patch
spi-controller-driver-for-designware-spi-core-fix.patch
spidev-use-declare_bitmap-instead-of-declaring-the-array-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2.patch
mb862xxfb-add-acceleration-support-for-coral-p-coral-pa-imageblt-copyarea-fillrect-fix2-fix-3.patch
ext2-avoid-warn-messages-when-failing-to-write-to-the-superblock-checkpatch-fixes.patch
memcg-coalesce-charging-via-percpu-storage-fix.patch
memcg-code-cleanrm-unused-variable-in-mem_cgroup_resize_limit-cleanup.patch
ipc-remove-unreachable-code-in-semc-fix.patch
char-cyclades-fix-compiler-warning.patch
drivers-edac-amd64_edacc-fix-use-uninitialised-bug.patch
fs-cache-avoid-maybe-used-uninitialised-warning-on-variable.patch
aio-dont-zero-out-the-pages-array-inside-struct-dio-fix.patch
direct-io-cleanup-blockdev_direct_io-locking-checkpatch-fixes.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
drivers-media-video-cx23885-needs-kfifo-updates.patch
kfifo-move-struct-kfifo-in-place-fix.patch
zlib-optimize-inffast-when-copying-direct-from-output-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes.patch
lib-add-support-for-lzo-compressed-kernels-checkpatch-fixes-cleanup.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

