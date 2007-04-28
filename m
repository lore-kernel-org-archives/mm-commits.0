From: akpm@linux-foundation.org
Subject: - git-alsa-fixup.patch removed from -mm tree
Date: Sat, 28 Apr 2007 02:41:34 -0700
Message-ID: <200704280941.l3S9fYIC019031@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60543 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753650AbXD1Jlh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 05:41:37 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l3S9fZQl009175
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Sat, 28 Apr 2007 02:41:36 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     git-alsa-fixup
has been removed from the -mm tree.  Its filename was
     git-alsa-fixup.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-alsa-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/pci/hda/hda_intel.c      |    5 -----
 sound/pci/hda/patch_sigmatel.c |   25 -------------------------
 sound/soc/Kconfig              |    6 ------
 3 files changed, 36 deletions(-)

diff -puN sound/pci/hda/patch_sigmatel.c~git-alsa-fixup sound/pci/hda/patch_sigmatel.c
--- a/sound/pci/hda/patch_sigmatel.c~git-alsa-fixup
+++ a/sound/pci/hda/patch_sigmatel.c
@@ -530,17 +530,7 @@ static unsigned int macbook_pro_v1_pin_c
 	0x02a19320, 0x400000fb
 };
 
-<<<<<<< HEAD/sound/pci/hda/patch_sigmatel.c
-static unsigned int macbook_pro_v1_pin_configs[10] = {
-	0x0321e230, 0x03a1e020, 0x9017e110, 0x01014010,
-	0x01a19021, 0x0381e021, 0x1345e240, 0x13c5e22e,
-	0x02a19320, 0x400000fb
-};
-
 static unsigned int macbook_pro_v2_pin_configs[10] = {
-=======
-static unsigned int macbook_pro_v2_pin_configs[10] = {
->>>>>>> /sound/pci/hda/patch_sigmatel.c
 	0x0221401f, 0x90a70120, 0x01813024, 0x01014010,
 	0x400000fd, 0x01016011, 0x1345e240, 0x13c5e22e,
 	0x400000fc, 0x400000fb,
@@ -550,17 +540,10 @@ static unsigned int *stac922x_brd_tbl[ST
 	[STAC_D945_REF] = ref922x_pin_configs,
 	[STAC_D945GTP3] = d945gtp3_pin_configs,
 	[STAC_D945GTP5] = d945gtp5_pin_configs,
-<<<<<<< HEAD/sound/pci/hda/patch_sigmatel.c
-	[STAC_MACMINI] = d945gtp5_pin_configs,
-	[STAC_MACBOOK] = macbook_pin_configs,
-	[STAC_MACBOOK_PRO_V1] = macbook_pro_v1_pin_configs,
-	[STAC_MACBOOK_PRO_V2] = macbook_pro_v2_pin_configs,
-=======
 	[STAC_MACMINI] = macbook_pro_v1_pin_configs,
 	[STAC_MACBOOK] = macbook_pro_v1_pin_configs,
 	[STAC_MACBOOK_PRO_V1] = macbook_pro_v1_pin_configs,
 	[STAC_MACBOOK_PRO_V2] = macbook_pro_v2_pin_configs,
->>>>>>> /sound/pci/hda/patch_sigmatel.c
 };
 
 static const char *stac922x_models[STAC_922X_MODELS] = {
@@ -1928,13 +1911,6 @@ static int patch_stac922x(struct hda_cod
 		 */
 		printk(KERN_INFO "hda_codec: STAC922x, Apple subsys_id=%x\n", codec->subsystem_id);
 		switch (codec->subsystem_id) {
-<<<<<<< HEAD/sound/pci/hda/patch_sigmatel.c
-		case 0x106b0200: /* MacBook Pro first generation */
-			spec->board_config = STAC_MACBOOK_PRO_V1;
-			break;
-		case 0x106b1e00: /* MacBook Pro second generation */
-			spec->board_config = STAC_MACBOOK_PRO_V2;
-=======
 		case 0x106b0a00: /* MacBook First generatoin */
 			spec->board_config = STAC_MACBOOK;
 			break;
@@ -1943,7 +1919,6 @@ static int patch_stac922x(struct hda_cod
 			break;
 		case 0x106b1e00: /* MacBook Pro second generation */
 			spec->board_config = STAC_MACBOOK_PRO_V2;
->>>>>>> /sound/pci/hda/patch_sigmatel.c
 			break;
 		}
 	}
diff -puN sound/soc/Kconfig~git-alsa-fixup sound/soc/Kconfig
--- a/sound/soc/Kconfig~git-alsa-fixup
+++ a/sound/soc/Kconfig
@@ -9,15 +9,9 @@ config SND_SOC_AC97_BUS
 	bool
 
 config SND_SOC
-<<<<<<< HEAD/sound/soc/Kconfig
-	tristate "SoC audio support"
-	depends on SND
-	select SND_PCM
-=======
 	tristate "ALSA for SoC audio support"
 	depends on SND
 	select SND_PCM
->>>>>>> /sound/soc/Kconfig
 	---help---
 
 	  If you want ASoC support, you should say Y here and also to the
diff -puN sound/pci/hda/hda_intel.c~git-alsa-fixup sound/pci/hda/hda_intel.c
--- a/sound/pci/hda/hda_intel.c~git-alsa-fixup
+++ a/sound/pci/hda/hda_intel.c
@@ -991,13 +991,8 @@ static int __devinit azx_codec_create(st
 	if ((err = snd_hda_bus_new(chip->card, &bus_temp, &chip->bus)) < 0)
 		return err;
 
-<<<<<<< HEAD/sound/pci/hda/hda_intel.c
-	codecs = 0;
-	for (c = 0; c < azx_max_codecs[chip->driver_type]; c++) {
-=======
 	codecs = audio_codecs = 0;
 	for (c = 0; c < AZX_MAX_CODECS; c++) {
->>>>>>> /sound/pci/hda/hda_intel.c
 		if ((chip->codec_mask & (1 << c)) & probe_mask) {
 			struct hda_codec *codec;
 			err = snd_hda_codec_new(chip->bus, c, &codec);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
extend-print_symbol-capability.patch
add-kvasprintf.patch
add-kvasprintf-fix.patch
slab-introduce-krealloc.patch
git-acpi.patch
git-alsa.patch
git-alsa-fixup.patch
git-agpgart.patch
git-agp-build-fix.patch
git-cpufreq-borkage-fix.patch
git-powerpc.patch
ppc4xx_sgdma-needs-dma_mappingh.patch
ida-implement-idr-based-id-allocator-fix.patch
revert-gregkh-driver-remove-struct-subsystem-as-it-is-no-longer-needed.patch
fix-gregkh-driver-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
even-even-more-fix-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
define-platform-wakeup-hook-use-in-pci_enable_wake.patch
dev_dbg-check-dev_dbg-arguments.patch
sysfs-binc-printk-fix.patch
git-drm.patch
git-dvb.patch
git-dvb-vs-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
fix-jdelvare-i2c-i2c-del-driver-returns-void-on-powerpc.patch
git-gfs2-nmw.patch
gfs2-printk-warning-fixes.patch
git-ieee1394.patch
sbp2-include-fixes.patch
fw-device-printk-fix.patch
ieee1394-iso-needs-schedh.patch
git-input.patch
git-input-fixup.patch
git-jfs.patch
git-kvm.patch
git-libata-all.patch
ata-printk-warning-fixes.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-build-fix.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-mtd-build-fix.patch
git-ubi-fixup.patch
revert-gitpowerpc-ehea-changes.patch
git-netdev-all.patch
reapply-gitpowerpc-ehea-changes.patch
git-netdev-all-export-ieee80211_debug_level.patch
vioc-warning-fix.patch
vioc-cast-warning-fix.patch
ne-add-platform_driver-fix.patch
ne-mips-use-platform_driver-for-ne-on-rbtx49xx-fix.patch
git-e1000.patch
git-e1000-fixup-2.patch
git-net-fixup.patch
git-net-vs-git-netdev-all.patch
sctp-fix-sctp_getsockopt_local_addrs_old-to-use-local-storage.patch
git-net-fix-yamc.patch
irda_device_dongle_init-fix-kzallocgfp_kernel-in-spinlock.patch
rfcomm_worker-fix-wakeup-race.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio.patch
git-ocfs2.patch
git-parisc.patch
git-r8169.patch
rm9000-serial-driver.patch
fix-gregkh-pci-pci-remove-the-broken-pci_multithread_probe-option.patch
git-pciseg.patch
git-s390-fixup.patch
git-s390-vs-gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
s390-net-lcs-convert-to-the-kthread-api.patch
git-scsi-misc.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-block-fixup.patch
git-unionfs.patch
git-wireless.patch
fix-x86_64-mm-nmi-watchdog-ops.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
x86_64-unexport-cpu_llc_id.patch
xfs-clean-up-shrinker-games.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
smaps-add-clear_refs-file-to-clear-reference.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
mm-move-common-segment-checks-to-separate-helper-function-v7.patch
slab-mark-set_up_list3s-__init.patch
slub-core.patch
slub-enable-tracking-of-full-slabs-fix.patch
slub-add-ability-to-list-alloc--free-callers-per-slab-tidy.patch
slub-user-documentation-fix.patch
mm-optimize-kill_bdev-fix.patch
lazy-freeing-of-memory-through-madv_free-fix.patch
lazy-freeing-of-memory-through-madv_free-sparc-fix.patch
lazy-freeing-of-memory-through-madv_free-vs-mm-madvise-avoid-exclusive-mmap_sem.patch
driver_bfin_serial_core-update.patch
srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-fix-fix.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
rtc-add-rtc-rs5c313-driver-is-busted.patch
enlarge-console-name.patch
move-die-notifier-handling-to-common-code-fixes-2.patch
move-die-notifier-handling-to-common-code-fix-vmalloc_sync_all.patch
fix-sscanf-%n-match-at-end-of-input-string-tidy.patch
parport-dev-driver-model-support-powerpc-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch-fix-tidy.patch
add-support-for-deferrable-timers-respun-tidy.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
move-timekeeping-code-to-timekeepingc-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog-fix.patch
fix-kevents-childs-priority-greediness-fix.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount-fix.patch
enhance-initcall_debug-measure-latency-fix.patch
expose-range-checking-functions-from-arch-specific-update-fix.patch
pad-irq_desc-to-internode-cacheline-size-fix.patch
dtlk-fix-error-checks-in-module_init-fix.patch
document-spin_lock_unlocked-rw_lock_unlocked-deprecation-fix.patch
upper-32-bits.patch
driver-for-the-maxim-ds1wm-a-1-wire-bus-master-asic-core-kconfig-update.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
kthread-dont-depend-on-work-queues-take-2-fix.patch
fix-kthread_create-vs-freezer-theoretical-race-dont-be-obnoxious.patch
speedup-divides-by-cpu_power-in-scheduler.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-consolidate-sched_clock-drift-adjustments-fix.patch
utimensat-implementation-fix.patch
revert-rtc-add-rtc_merge_alarm.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout-fix.patch
kprobes-the-on-off-knob-thru-debugfs-updated-fix.patch
kprobes-the-on-off-knob-thru-debugfs-updated-fix-fix-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
linux-kernel-markers-i386-optimization-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix.patch
signal-timer-event-fds-v9-signalfd-core-fix-fix.patch
signal-timer-event-fds-v9-timerfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix.patch
signal-timer-event-fds-v9-eventfd-core-fix-fix.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls.patch
x86-serial-convert-legacy-com-ports-to-platform-devices-fix.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
fs-convert-core-functions-to-zero_user_page-fix-2.patch
ntfs-use-zero_user_page-fix.patch
reiser4-slab-allocators-remove-slab_debug_initial-flag.patch
fbdev-hecuba-framebuffer-driver.patch
vt-add-color-support-to-the-underline-and-italic-attributes-fix.patch
sm501fb-printk-warning-fixes.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
w1-build-fix.patch
