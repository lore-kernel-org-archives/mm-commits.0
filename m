From: akpm@linux-foundation.org
Subject: - drivers-rtc-kconfig-dont-build-rtc-cmoso-on-sparc32.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:52:01 -0700
Message-ID: <200810012152.m91Lq1EC005991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37184 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753883AbYJAVwQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:52:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, davem@davemloft.net, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     drivers/rtc/Kconfig: don't build rtc-cmos.o on sparc32
has been removed from the -mm tree.  Its filename was
     drivers-rtc-kconfig-dont-build-rtc-cmoso-on-sparc32.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/rtc/Kconfig: don't build rtc-cmos.o on sparc32
From: Andrew Morton <akpm@linux-foundation.org>

Fix for linux-next's

: Author: David S. Miller <davem@davemloft.net>  2008-08-28 19:54:17
: Committer: David S. Miller <davem@davemloft.net>  2008-08-29 14:16:45
: Parent: 7f60459921bd24e86b21e07c42244c510b4f46b2 (Blackfin RTC Driver: BF561 not have on-chip RTC)
: Child:  cca4c231028405950a15f5a27d7326d18d909784 (rtc: Add TI BQ4802 RTC driver.)
: Branches: git-alsa-tiwai, linux-next
: Follows: v2.6.27-rc4
: Precedes: next-20080902
: 
:     rtc: Allow RTC_DRV_CMOS to be used on SPARC.


In file included from drivers/rtc/rtc-cmos.c:40:
include/asm-generic/rtc.h: In function 'rtc_is_updating':
include/asm-generic/rtc.h:40: error: 'rtc_port' undeclared (first use in this function)
include/asm-generic/rtc.h:40: error: (Each undeclared identifier is reported only once
include/asm-generic/rtc.h:40: error: for each function it appears in.)
include/asm-generic/rtc.h: In function 'get_rtc_time':
include/asm-generic/rtc.h:73: error: 'rtc_port' undeclared (first use in this function)
include/asm-generic/rtc.h: In function 'set_rtc_time':
include/asm-generic/rtc.h:160: error: 'rtc_port' undeclared (first use in this function)
drivers/rtc/rtc-cmos.c: In function 'cmos_read_alarm':
drivers/rtc/rtc-cmos.c:193: error: 'rtc_port' undeclared (first use in this function)
drivers/rtc/rtc-cmos.c: In function 'cmos_checkintr':
drivers/rtc/rtc-cmos.c:255: error: 'rtc_port' undeclared (first use in this function)
drivers/rtc/rtc-cmos.c: In function 'cmos_irq_enable':
drivers/rtc/rtc-cmos.c:272: error: 'rtc_port' undeclared (first use in this function)
drivers/rtc/rtc-cmos.c: In function 'cmos_irq_disable':
drivers/rtc/rtc-cmos.c:292: error: 'rtc_port' undeclared (first use in this function)
drivers/rtc/rtc-cmos.c: In function 'cmos_set_alarm':
drivers/rtc/rtc-cmos.c:337: error: 'rtc_port' undeclared (first use in this function)
drivers/rtc/rtc-cmos.c: In function 'cmos_irq_set_freq':
drivers/rtc/rtc-cmos.c:378: error: 'rtc_port' undeclared (first use in this function)
drivers/rtc/rtc-cmos.c: In function 'cmos_procfs':
drivers/rtc/rtc-cmos.c:455: error: 'rtc_port' undeclared (first use in this function)
drivers/rtc/rtc-cmos.c: In function 'cmos_nvram_read':
drivers/rtc/rtc-cmos.c:519: error: 'rtc_port' undeclared (first use in this function)
drivers/rtc/rtc-cmos.c: In function 'cmos_nvram_write':
drivers/rtc/rtc-cmos.c:551: error: 'rtc_port' undeclared (first use in this function)
drivers/rtc/rtc-cmos.c: In function 'cmos_interrupt':
drivers/rtc/rtc-cmos.c:588: error: 'rtc_port' undeclared (first use in this function)
drivers/rtc/rtc-cmos.c: In function 'cmos_do_probe':
drivers/rtc/rtc-cmos.c:722: error: 'rtc_port' undeclared (first use in this function)

Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Brownell <david-b@pacbell.net>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/Kconfig~drivers-rtc-kconfig-dont-build-rtc-cmoso-on-sparc32 drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~drivers-rtc-kconfig-dont-build-rtc-cmoso-on-sparc32
+++ a/drivers/rtc/Kconfig
@@ -329,7 +329,7 @@ comment "Platform RTC drivers"
 
 config RTC_DRV_CMOS
 	tristate "PC-style 'CMOS'"
-	depends on X86 || ALPHA || ARM || M32R || ATARI || PPC || MIPS || SPARC
+	depends on X86 || ALPHA || ARM || M32R || ATARI || PPC || MIPS || SPARC64
 	default y if X86
 	help
 	  Say "yes" here to get direct support for the real time clock
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

git-powerpc.patch
git-sparc.patch
git-x86.patch
git-xtensa.patch
git-ftrace.patch
git-pci.patch
git-hid.patch
git-v4l-dvb.patch
git-nfsd.patch
git-dlm.patch
git-async_tx.patch
git-net.patch
git-mtd.patch
git-sound.patch
git-sound-rejects.patch
git-input.patch
git-block.patch
git-battery.patch
git-mfd.patch
git-drm.patch
drivers-mfd-ucb1400_corec-needs-gpio.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
arch-x86-kernel-early_printkc-remove-unused-enable_debug_console.patch
drivers-media-video-tda9840c-unbreak.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
libata-blackfin-pata-driver-add-proper-pm-operation-into-atapi-driver.patch
misdn-misc-timerdev-fixes-fix.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
drivers-scsi-device_handler-scsi_dh_emcc-suppress-warning.patch
drivers-scsi-sdh-use-inlined-c-functions-not-macros.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
acpi-cope-with-pnpacpi-tables-missing-an-rtc-entry.patch
drivers-media-video-cafe_ccicc-needs-mmh.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-rewrite-vmap-layer-fix.patch
mm-rewrite-vmap-layer-fix-fix.patch
mm-rewrite-vmap-layer-fix-fix-fix.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
eeepc-laptop-use-standard-interfaces-fix-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix-fix.patch
make-taint-bit-reliable-v3-fix.patch
kernel-sysc-improve-code-generation.patch
compat-generic-compat-get-settimeofday-checkpatch-fixes.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms-cleanup.patch
drivers-hwmon-applesmcc-remove-unneeded-casts.patch
allow-recursion-in-binfmt_script-and-binfmt_misc-fix.patch
serial-make-uart_ports-ioport-unsigned-long-fix.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-2.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip-fix.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
ext2-avoid-printk-floods-in-the-face-of-directory-corruption-checkpatch-fixes.patch
ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
tty-fix-echo-tab-erase-and-locking-fix.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
w1-be-able-to-manually-add-and-remove-slaves-fix.patch
w1-new-driver-ds2431-chip-fix.patch
gru-driver-minor-updates-fix.patch
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

